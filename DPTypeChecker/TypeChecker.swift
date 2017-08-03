//
//  TypeChecker.swift
//  DPTypeChecker
//
//  Created by Jan Wittler on 08.06.17.
//  Copyright © 2017 Jan Wittler. All rights reserved.
//

import Foundation

internal var environment = Environment()

func typeCheck(_ program: Program) throws {
    environment = Environment()
    switch program {
    case let .pDefs(defs):
        try populateEnvironment(defs)
        try defs.forEach { try checkDef($0) }
    }
}

private func populateEnvironment(_ defs: [Def]) throws {
    try defs.forEach { def in
        switch def {
        case let .dFun(id, args, returnType, _):
            try environment.addFunction(id: id, arguments: args.map({ $0.type }), returnType: returnType)
       case let .dFunExposed(id, args, returnType, _):
            try environment.addFunction(id: id, arguments: args.map({ $0.type }), returnType: returnType)
        case let .dTypedef(ident, lType, rType):
            try environment.addSumType(name: ident, types: (lType, rType))
        }
    }
}

private func checkDef(_ def: Def) throws {
    switch def {
    case let .dFun(id, args, returnType, stms):
        guard containsReturnStatement(stms) else {
            throw TypeCheckerError.missingReturn(function: id)
        }
        environment.pushContext()
        try addArgsToCurrentContext(args)
        try stms.forEach { try checkStm($0, expectedReturnType: returnType) }
        environment.popContext()
    case let .dFunExposed(id, args, returnType, stms):
        //exposed functions must return an opp type since they are handed to the opponent
        guard returnType.isOPPType else {
            throw TypeCheckerError.exposedFunctionDoesNotReturnOPPType(function: id, returnType: returnType)
        }
        try checkDef(.dFun(id, args, returnType, stms))
    case .dTypedef:
        break //handled in `populateEnvironment`
    }
}

private func addArgsToCurrentContext(_ args: [Arg]) throws {
    try args.forEach { arg in
        switch arg {
        case let .aDecl(id, type):
            try environment.addToCurrentContext(id, type: type)
        }
    }
}

private func containsReturnStatement(_ stms: [Stm]) -> Bool {
    return stms.reduce(false, { result, stm -> Bool in
        let isReturn: Bool
        switch stm {
        case .sReturn:
            isReturn = true
        case let .sCase(_, _, _, ifStms, elseStms):
            isReturn = containsReturnStatement(ifStms) && containsReturnStatement(elseStms)
        default:
            isReturn = false
        }
        return result || isReturn
    })
}

private func checkStm(_ stm: Stm, expectedReturnType: Type) throws {
    switch stm {
    case let .sInit(idMaybeTyped, exp):
        var (expType, envDelta) = try inferType(exp)
        if let type = idMaybeTyped.type {
            try makeType(&expType, matchRequiredType: type, withDelta: &envDelta, errorForFailure: .assignmentFailed(stm: stm, actual: expType, expected: type))
        }
        try environment.applyDelta(envDelta)
        try environment.addToCurrentContext(idMaybeTyped.id, type: expType)
        
    case let .sSplit(idMaybeTyped1, idMaybeTyped2, exp):
        var (expType, envDelta) = try inferType(exp)
        guard case var .cTMulPair(type1, type2) = expType.coreType else {
            throw TypeCheckerError.splitFailed(stm: stm, actual: expType)
        }
        
        let factor1: Double
        let factor2: Double
        let fixedTypesAndFactors = try [(type1, idMaybeTyped1), (type2, idMaybeTyped2)].map { (type, idMaybeTyped) -> (Type, Double) in
            if let requiredType = idMaybeTyped.type {
                let factor = factorToMakeType(type, matchType: requiredType)
                let resultType = Type.tType(requiredType.coreType, type.replicationCount)
                var dummyDelta = Environment.Delta()
                var typeCopy = type
                try makeType(&typeCopy, matchRequiredType: requiredType, withDelta: &dummyDelta, errorForFailure: .assignmentFailed(stm: stm, actual: type, expected: requiredType))
                return (resultType, factor)
            }
            return (type, 1)
        }
        (type1, factor1) = fixedTypesAndFactors[0]
        (type2, factor2) = fixedTypesAndFactors[1]
        let maxFactor = max(factor1, factor2)
        envDelta.scale(by: maxFactor)
        //since both variables are scaled by `maxFactor` it would be wrong to use the annotated types, rather we need to compute the scaled type from the inferred type
        //note: if the `maxFactor` is equal to the factor of the component, the scaled type will match the annotated type
        try environment.applyDelta(envDelta)
        let id1 = idMaybeTyped1.id
        let id2 = idMaybeTyped2.id
        try environment.addToCurrentContext(id1, type: .tType(type1.coreType, type1.replicationCount * maxFactor))
        try environment.addToCurrentContext(id2, type: .tType(type2.coreType, type2.replicationCount * maxFactor))
        
    case let .sCase(idMaybeTyped, sumCase, exp, ifStms, elseStms):
        //TODO: case handling must be corrected
        // case handling is wrong since both if and else blocks may access variables outside the topmost context
        // but if they do, the other contexts contain changes of both the if and else block, which may result in wrong usage count for following statements
        // correct would be to branch and evaluate the if branch and all subsequent calls and after that the else branch with all subsequent calls and with the same environment as the if branch started with 
        environment.pushContext()
        
        var (condType, envDelta) = try inferType(exp)
        var unwrappedType = try sumCase.unwrappedType(from: condType)
        if let requiredType = idMaybeTyped.type {
            try makeType(&unwrappedType, matchRequiredType: requiredType, withDelta: &envDelta, errorForFailure: .assignmentFailed(stm: stm, actual: unwrappedType, expected: requiredType))
        }
        try environment.applyDelta(envDelta)
        try environment.addToCurrentContext(idMaybeTyped.id, type: unwrappedType)
        
        try ifStms.forEach { try checkStm($0, expectedReturnType: expectedReturnType) }
        environment.popContext()
        
        environment.pushContext()
        try elseStms.forEach { try checkStm($0, expectedReturnType: expectedReturnType) }
        environment.popContext()
        
    case let .sReturn(exp):
        var (expType, envDelta) = try inferType(exp)
        try makeType(&expType, matchRequiredType: expectedReturnType, withDelta: &envDelta, errorForFailure: .invalidReturnType(actual: expType, expected: expectedReturnType))
        try environment.applyDelta(envDelta)
        
    case let .sAssert(assertion):
        try checkAssertion(assertion)
    }
}

private func inferType(_ exp: Exp) throws -> (Type, Environment.Delta) {
    switch exp {
    case .eInt:
        return (.tType(.cTBase(.int), 1), Environment.Delta())
    case .eFloat:
        return (.tType(.cTBase(.float), 1), Environment.Delta())
    case .eUnit:
        return (.tType(.cTBase(.unit), 1), Environment.Delta())
    case .eTrue:
        fallthrough
    case .eFalse:
        return (.tType(try environment.lookupCoreType(boolTypeIdent), 1), Environment.Delta())
    case let .eId(id):
        let type = try environment.lookup(id)
        let returnType = Type.tType(type.coreType, 1)
        var delta = Environment.Delta()
        delta.updateUsageCount(for: id, delta: 1)
        return (returnType, delta)
    case let .ePair(e1, e2):
        let (type1, delta1) = try inferType(e1)
        let (type2, delta2) = try inferType(e2)
        let returnType = Type.tType(.cTMulPair(type1, type2), 1)
        let delta = delta1.merge(with: delta2)
        return (returnType, delta)
    case let .eSum(typeId, sumCase, exp):
        let type = Type.tType(try environment.lookupCoreType(typeId), 1)
        var (expType, delta) = try inferType(exp)
        let requiredType = try sumCase.unwrappedType(from: type)
        try makeType(&expType, matchRequiredType: requiredType, withDelta: &delta, errorForFailure: .mismatchingTypesForSumType(exp: exp, actual: expType, expected: requiredType))
        return (.tType(type.coreType, 1), delta)
    case let .eApp(id, exps):
        guard id != addNoiseId else {
            return (try handleAddNoise(exps), Environment.Delta())
        }
        
        let args: [Type], returnType: Type
        var delta = Environment.Delta()
        
        do {
            (args, returnType) = try environment.lookupFunction(id)
        }
        //if there was not function with the id, check if there is a variable with the id which has a function type
        catch let functionError {
            do {
                let idType = try environment.lookup(id)
                guard case let .cTFunction(aType, rType) = idType.coreType else {
                    throw functionError
                }
                delta.updateUsageCount(for: id, delta: 1)
                args = aType
                returnType = rType
            }
            //catch errors to throw the original function lookup error instead of the variable lookup one
            catch {
                throw functionError
            }
        }
        
        guard exps.count <= args.count else {
            throw TypeCheckerError.tooManyArgumentsToFunction(exp: exp, actualCount: exps.count, expectedCount: args.count)
        }
        
        let expTypesAndDeltas = try exps.map { try inferType($0) }
        for i in 0..<expTypesAndDeltas.count {
            var (argType, argDelta) = expTypesAndDeltas[i]
            let requiredType = args[i]
            try makeType(&argType, matchRequiredType: requiredType, withDelta: &argDelta, errorForFailure: .mismatchingTypeForFunctionArgument(exp: exp, index: i, actual: argType, expected: requiredType))
            delta = delta.merge(with: argDelta)
        }
        
        if (exps.count == args.count) {
            return (returnType, delta)
        }
        else { //allow for currying
            let missingArgs = args.dropFirst(exps.count)
            let functionType = CoreType.cTFunction(Array(missingArgs), returnType)
            let returnType = Type.tType(functionType, 1)
            return (returnType, delta)
        }
    case let .eNegative(e1):
        let (type, delta) = try inferType(e1)
        let allowedCoreTypes: [CoreType] = [
            .cTBase(.int),
            .cTBase(.float)
        ]
        if allowedCoreTypes.contains(type.coreType) {
            return (type, delta)
        }
        throw TypeCheckerError.noOperatorOverloadFound(exp: exp, types: [type])
    case let .eTimes(e1, e2):
        return try handleMultiplication(e1, e2, originalExpression: exp)
    case let .ePlus(e1, e2):
        return try handleAdditionOrSubtraction(e1, e2, originalExpression: exp)
    case let .eMinus(e1, e2):
        return try handleAdditionOrSubtraction(e1, e2, originalExpression: exp)
    case let .eLt(e1, e2):
        return try handleComparison(e1, e2, originalExpression: exp)
    case let .eGt(e1, e2):
        return try handleComparison(e1, e2, originalExpression: exp)
    case let .eLtEq(e1, e2):
        return try handleComparison(e1, e2, originalExpression: exp)
    case let .eGtEq(e1, e2):
        return try handleComparison(e1, e2, originalExpression: exp)
    case let .eEq(e1, e2):
        return try handleComparison(e1, e2, originalExpression: exp)
    case let .eNeq(e1, e2):
        return try handleComparison(e1, e2, originalExpression: exp)
    case let .eTyped(exp, type):
        //TODO: for now this is accepted to get types where inferencing does not work yet but should be removed as soon as possible
        do {
            let (inferredType, delta) = try inferType(exp)
            if inferredType == type {
                return (type, delta)
            }
            else {
                print("inferred type \(inferredType) for expression: " + exp.show() + "\nbut expression was annotated with type: \(type)")
            }
        }
        catch let error as TypeCheckerError {
            print("was not able to infer type for expression: " + exp.show() + "\ninferring failed with error: \(error)\nwill continue with annotated type: \(type)")
        }
        return (type, Environment.Delta())
    }
}

private func makeType(_ type: inout Type, matchRequiredType requiredType: Type, withDelta delta: inout Environment.Delta, errorForFailure: TypeCheckerError) throws {
    if !requiredType.isSubtype(of: type) {
        //if possible, scale expression up to match required type
        if type.coreType == requiredType.coreType {
            let differingFactor = factorToMakeType(type, matchType: requiredType)
            delta.scale(by: differingFactor)
        }
        else {
            throw errorForFailure
        }
    }
    type = requiredType
}

private func factorToMakeType(_ type1: Type, matchType type2: Type) -> Double {
    return max(1, type2.replicationCount / type1.replicationCount)
}

private func handleAddNoise(_ exps: [Exp]) throws -> Type {
    guard exps.count == 1 else {
        throw TypeCheckerError.addNoiseFailed(message: "the add_noise construct requires exactly one argument but was provided \(exps.count)\nnamely \(exps)")
    }
    let exp = exps.first!
    let (expType, delta) = try inferType(exp)
    //apply delta directly, because it must not be scaled after `add_noise` was applied
    try environment.applyDelta(delta)
    let allowedBaseTypes: [BaseType] = [.int]
    guard case let .cTBase(baseType) = expType.coreType, allowedBaseTypes.contains(baseType) else {
        throw TypeCheckerError.addNoiseFailed(message: "invalid type for adding noise to\ntype: \(expType)\nin expression: \(exp)")
    }
    guard expType.replicationCount < Double.infinity else {
        throw TypeCheckerError.addNoiseFailed(message: "adding noise to an exponential type would result in an unusable result and is therefore forbidden")
    }
    return .tTypeExponential(expType.coreType)
}

private func handleAdditionOrSubtraction(_ e1: Exp, _ e2: Exp, originalExpression exp: Exp) throws -> (Type, Environment.Delta) {
    let (type1, delta1) = try inferType(e1)
    let (type2, delta2) = try inferType(e2)
    let allowedCoreTypes: [CoreType] = [
        .cTBase(.int),
        .cTBase(.float)
    ] //replication count is always 1
    if allowedCoreTypes.contains(type1.coreType) && type1.coreType == type2.coreType {
        //instead of subtyping to replication count 1, rather subtype only so far that type1 and type2 match
        let lowerReplicationCount = min(type1.replicationCount, type2.replicationCount)
        let resultType = Type.tType(type1.coreType, lowerReplicationCount)
        return (resultType, delta1.merge(with: delta2))
    }
    throw TypeCheckerError.noOperatorOverloadFound(exp: exp, types: [type1, type2])
}

private func handleMultiplication(_ e1: Exp, _ e2: Exp, originalExpression exp: Exp) throws -> (Type, Environment.Delta) {
    var (type1, delta1) = try inferType(e1)
    var (type2, delta2) = try inferType(e2)
    
    let allowedCoreTypes: [CoreType] = [
        .cTBase(.int),
        .cTBase(.float)
    ]
    guard allowedCoreTypes.contains(type1.coreType) && type1.coreType == type2.coreType else {
        throw TypeCheckerError.noOperatorOverloadFound(exp: exp, types: [type1, type2])
    }
    
    let mulWithConst: ((Type, Environment.Delta, Double) -> (Type, Environment.Delta)) = {
        var delta = $1
        //take the absolute value to handle negative numbers correctly
        //scaling to numbers less than 1 is forbidden thus assure that factor is at least 1
        delta.scale(by: max(1, abs($2)))
        return ($0, delta)
    }
    //check if it is a multiplication with a constant value
    if delta1.isEmpty, let value = constantValueFromExpression(e1) {
        return mulWithConst(type2, delta2, value)
    }
    else if delta2.isEmpty, let value = constantValueFromExpression(e2) {
        return mulWithConst(type1, delta1, value)
    }
    else {
        //check if both types are exponential or can be scaled up to that
        do {
            var environmentCopy = environment
            if type1.replicationCount < .infinity {
                delta1.scale(by: .infinity)
                try environmentCopy.applyDelta(delta1)
            }
            if type2.replicationCount < .infinity {
                delta2.scale(by: .infinity)
                try environmentCopy.applyDelta(delta2)
            }
            return (.tTypeExponential(type1.coreType), delta1.merge(with: delta2))
        }
        catch {
            //catch scaling error to throw more descriptive arithmetic error instead
            throw TypeCheckerError.arithmeticError(message: "multiplication must be performed with at least one constant or only exponential types." + "\n" + "expression: \(exp.show())")
        }
    }
}

private func handleComparison(_ e1: Exp, _ e2: Exp, originalExpression exp: Exp) throws -> (Type, Environment.Delta) {
    var (type1, delta1) = try inferType(e1)
    var (type2, delta2) = try inferType(e2)
    var allowedCoreTypes: [CoreType] = [
        .cTBase(.int),
        .cTBase(.float),
    ] //since comparison yields bool type which can magnify distance of input by infinity, input to comparison must have exponential type
    
    //booleans can not be ordered, thus only allow them for `==` and `!=`
    if case .eEq = exp {
        allowedCoreTypes.append(.cTTypedef(boolTypeIdent))
    }
    else if case .eNeq = exp {
        allowedCoreTypes.append(.cTTypedef(boolTypeIdent))
    }
    
    if allowedCoreTypes.contains(type1.coreType) && type1.coreType == type2.coreType {
        do {
            var environmentCopy = environment
            if type1.replicationCount != .infinity {
                delta1.scale(by: .infinity)
                try environmentCopy.applyDelta(delta1)
            }
            if type2.replicationCount != .infinity {
                delta2.scale(by: .infinity)
                try environmentCopy.applyDelta(delta2)
            }
            return (.tTypeExponential(.cTTypedef(boolTypeIdent)), delta1.merge(with:delta2))
        }
        catch {
            //catch scaling error to throw more descriptive arithmetic error instead
            throw TypeCheckerError.arithmeticError(message: "input of comparison operators must both have an exponential type\nexpression: \(exp.show())")
        }
    }
    throw TypeCheckerError.noOperatorOverloadFound(exp: exp, types: [type1, type2])
}

private func constantValueFromExpression(_ exp: Exp) -> Double? {
    switch exp {
    case let .eFloat(value):
        return value
    case let .eInt(value):
        return Double(value)
    case let .eNegative(e):
        if let value = constantValueFromExpression(e) {
            return -value
        }
    default:
        break
    }
    return nil
}

private func checkAssertion(_ assertion: Assertion) throws {
    switch assertion {
    case let .aTypeEqual(id, type):
        let idType = try environment.lookup(id)
        let usageCount = try environment.lookupUsageCount(id)
        let updatedType: Type
        if idType.replicationCount == Double.infinity {
            //exponential types will always be exponentials, independent of usage count
            updatedType = idType
        }
        else {
            updatedType = Type.tType(idType.coreType, idType.replicationCount - usageCount)
        }
        guard updatedType == type else {
            let errorMessage = "variable `\(id.value)` does not match type\n" +
                "expected: \(type)\n" +
                "actual: \(updatedType)"
            throw TypeCheckerError.assertionFailed(errorMessage)
        }
    }
}
