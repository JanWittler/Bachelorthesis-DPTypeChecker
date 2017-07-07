//
//  TypeChecker.swift
//  DPTypeChecker
//
//  Created by Jan Wittler on 08.06.17.
//  Copyright © 2017 Jan Wittler. All rights reserved.
//

import Foundation

private let addNoiseId = Id("add_noise")

public enum TypeCheckerError: Error {
    case nameAlreadyInUse(id: String, as: String)
    case functionNotFound(Id)
    case exposedFunctionDoesNotReturnOPPType(function: Id, returnType: Type)
    case typeNotFound(Ident)
    case variableAlreadyExists(Id)
    case variableNotFound(Id)
    case invalidVariableAccess(Id)
    case assignmentFailed(stm: Stm, actual: Type, expected: Type)
    case missingReturn(function: Id)
    case invalidReturnType(actual: Type, expected: Type)
    case splitFailed(stm: Stm, actual: Type)
    case caseApplicationFailed(case: Case, actual: Type)
    case mismatchingTypesForSumType(exp: Exp, actual: Type, expected: Type)
    case tooManyArgumentsToFunction(exp: Exp, actualCount: Int, expectedCount: Int)
    case mismatchingTypeForFunctionArgument(exp: Exp, index: Int, actual: Type, expected: Type)
    case noOperatorOverloadFound(exp: Exp, types: [Type])
    case assertionFailed(String)
    case addNoiseFailed(message: String)
    case other(String)
}

internal struct Environment {
    private enum GlobalElement {
        case addNoise
        case function(args: [Type], returnType: Type)
        case typedef(type: Type)
    }
    
    struct Delta {
        private(set) var changes: [Id : Double] = [:]
        
        mutating func updateUsageCount(for id: Id, delta: Double) {
            precondition(delta > 0, "the given delta must be greater than zero")
            let value = changes[id] ?? 0
            changes[id] = value + delta
            
        }
        
        mutating func scale(by factor: Double) {
            precondition(factor >= 1, "scaling to lower count invalid")
            changes = changes.reduce([Id : Double]()) {
                var dict = $0
                let (key, value) = $1
                dict[key] = value * factor
                return dict
            }
        }
        
        func merge(with other: Delta) -> Delta {
            var new = Delta()
            new.changes = changes
            other.changes.forEach {
                new.updateUsageCount(for: $0, delta: $1)
            }
            return new
        }
    }
    
    //the `add_noise` function is present in every environment
    private var globals: [String : GlobalElement] = [
        addNoiseId.value : .addNoise
    ]
    
    private mutating func addGlobal(_ global: GlobalElement, forId id: String) throws {
        try checkIdNotGlobalUsed(id)
        globals[id] = global
    }
    
    private func checkIdNotGlobalUsed(_ id: String) throws {
        guard let global = globals[id] else {
            return
        }
        let usageType: String
        switch global {
        case .addNoise:
            usageType = "function"
        case .function:
            usageType = "function"
        case .typedef:
            usageType = "type"
        }
        throw TypeCheckerError.nameAlreadyInUse(id: id, as: usageType)
    }
    
    var contexts : [Context] = []
    private var currentContext: Context! {
        get {
            return contexts.last
        }
        set {
            contexts.removeLast()
            contexts.append(newValue)
        }
    }
    
    mutating func pushContext() {
        contexts.append(Context())
    }
    
    mutating func popContext() {
        contexts.removeLast()
    }
    
    mutating func addFunction(id: Id, arguments: [Type], returnType: Type) throws {
        let function = GlobalElement.function(args: arguments, returnType: returnType)
        try addGlobal(function, forId: id.value)
    }
    
    mutating func addSumType(name id: Ident, types: (Type, Type)) throws {
        let sumType = Type.tTypeExponential(.cTSum(types.0, types.1))
        try addGlobal(.typedef(type: sumType), forId: id.value)
    }
    
    mutating func addToCurrentContext(_ id: Id, type: Type) throws {
        try checkIdNotGlobalUsed(id.value)
        return try currentContext.add(id, type: type)
    }
    
    func lookup(_ id: Id) throws -> Type {
        //check topmost context first
        for context in contexts.reversed() {
            do {
                return try context.lookup(id)
            }
            catch TypeCheckerError.variableNotFound(_) {
                //error intended to occur, continue searching in next context
            }
        }
        throw TypeCheckerError.variableNotFound(id)
    }
    
    func lookupFunction(_ id: Id) throws -> ([Type], Type) {
        guard let global = globals[id.value], case let .function(args, returnType) = global else {
            throw TypeCheckerError.functionNotFound(id)
        }
        return (args, returnType)
    }
    
    func lookupType(_ id: Ident) throws -> Type {
        guard let global = globals[id.value], case let .typedef(type) = global else {
            throw TypeCheckerError.typeNotFound(id)
        }
        return type
    }
    
    func lookupUsageCount(_ id: Id) throws -> Double {
        //check topmost context first
        for context in contexts.reversed() {
            do {
                return try context.lookupUsageCount(id)
            }
            catch TypeCheckerError.variableNotFound(_) {
                //error intended to occur, continue searching in next context
            }
        }
        throw TypeCheckerError.variableNotFound(id)
    }
    
    mutating func applyDelta(_ delta: Delta) throws {
        try delta.changes.forEach {
            try updateUsageCount(for: $0, delta: $1)
        }
    }
    
    private mutating func updateUsageCount(for id: Id, delta: Double) throws {
        var index = contexts.count - 1
        while index >= 0 {
            do {
                var context = contexts[index]
                try context.updateUsageCount(for: id, delta: delta)
                contexts[index] = context
                return
            }
            catch TypeCheckerError.variableNotFound(_) {
                    //error intended to occur, continue searching in next context
            }
            index -= 1
        }
        throw TypeCheckerError.variableNotFound(id)
    }
}

internal struct Context {
    private var values : [Id : (Type, Double)] = [:]
    
    mutating func add(_ id: Id, type: Type) throws {
        guard !values.keys.contains(id) else {
            throw TypeCheckerError.variableAlreadyExists(id)
        }
        guard type.replicationCount >= 0 else {
            throw TypeCheckerError.other("variable `\(id.value)` must be initialized with a nonnegative replication count")
        }
        values[id] = (type, 0)
    }
    
    mutating func updateUsageCount(for id: Id, delta: Double) throws {
        precondition(delta >= 0, "the usage count can't be reduced")
        
        guard let (type, count) = values[id] else {
            throw TypeCheckerError.variableNotFound(id)
        }
        let newCount = count + delta
        guard type.replicationCount >= newCount else {
            throw TypeCheckerError.invalidVariableAccess(id)
        }
        values[id] = (type, newCount)
    }
    
    func lookup(_ id: Id) throws -> Type {
        if let type = values[id] {
            return type.0
        }
        throw TypeCheckerError.variableNotFound(id)
    }
    
    func lookupUsageCount(_ id: Id) throws -> Double {
        if let type = values[id] {
            return type.1
        }
        throw TypeCheckerError.variableNotFound(id)
    }
    
    mutating func scale(by factor: Double) throws {
        for (id, (_, count)) in values {
            //since we apply a delta we need to substract the current count to get the correct value
            try updateUsageCount(for: id, delta: count * (factor - 1))
        }
    }
}

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
        var varType = expType
        if let type = idMaybeTyped.type {
            try makeType(expType, matchRequiredType: type, withDelta: &envDelta, errorForFailure: .assignmentFailed(stm: stm, actual: expType, expected: type))
            varType = type
        }
        try environment.applyDelta(envDelta)
        try environment.addToCurrentContext(idMaybeTyped.id, type: varType)
        
    case let .sSplit(idMaybeTyped1, idMaybeTyped2, exp):
        var (expType, envDelta) = try inferType(exp)
        guard case let .cTMulPair(type1, type2) = expType.coreType else {
            throw TypeCheckerError.splitFailed(stm: stm, actual: expType)
        }
        try checkIfIdMaybeTyped(idMaybeTyped1, matchesType: type1, inStm: stm)
        try checkIfIdMaybeTyped(idMaybeTyped2, matchesType: type2, inStm: stm)
        let id1 = idMaybeTyped1.id
        let id2 = idMaybeTyped2.id
        var factor1: Double = 1
        var factor2: Double = 1
        if let type = idMaybeTyped1.type {
            factor1 = type.replicationCount / type1.replicationCount
        }
        if let type = idMaybeTyped2.type {
            factor2 = type.replicationCount / type2.replicationCount
        }
        let maxFactor = max(factor1, factor2)
        envDelta.scale(by: maxFactor)
        //since both variables are scaled by `maxFactor` it would be wrong to use the annotated types, rather we need to compute the scaled type from the inferred type
        //note: if the `maxFactor` is equal to the factor of the component, the scaled type will match the annotated type
        try environment.applyDelta(envDelta)
        try environment.addToCurrentContext(id1, type: .tType(type1.coreType, type1.replicationCount * maxFactor))
        try environment.addToCurrentContext(id2, type: .tType(type2.coreType, type2.replicationCount * maxFactor))
        
    case let .sCase(idMaybeTyped, sumCase, exp, ifStms, elseStms):
        //TODO: case handling must be corrected
        // case handling is wrong since both if and else blocks may access variables outside the topmost context
        // but if they do, the other contexts are contain changes of both the if and else block, which may result in wrong usage count for following statements
        // correct would be to branch and evaluate the if branch and all subsequent calls and after that the else branch with all subsequent calls and with the same environment as the if branch started with 
        environment.pushContext()
        
        var (condType, envDelta) = try inferType(exp)
        var unwrappedType = try sumCase.unwrappedType(from: condType, environment: environment)
        try checkIfIdMaybeTyped(idMaybeTyped, matchesType: unwrappedType, inStm: stm)
        if let type = idMaybeTyped.type {
            try makeType(condType, matchRequiredType: type, withDelta: &envDelta, errorForFailure: .assignmentFailed(stm: stm, actual: condType, expected: type))
            unwrappedType = type
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
        try makeType(expType, matchRequiredType: expectedReturnType, withDelta: &envDelta, errorForFailure: .invalidReturnType(actual: expType, expected: expectedReturnType))
        try environment.applyDelta(envDelta)
        
    case let .sAssert(assertion):
        try checkAssertion(assertion)
    }
}

private func checkIfIdMaybeTyped(_ idMaybeTyped: IdMaybeTyped, matchesType type: Type, inStm stm: Stm) throws {
    if let expectedType = idMaybeTyped.type {
        guard type.isSubtype(of: expectedType) else {
            throw TypeCheckerError.assignmentFailed(stm: stm, actual: type, expected: expectedType)
        }
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
        let type = try environment.lookupType(typeId)
        var (expType, delta) = try inferType(exp)
        let requiredType = try sumCase.unwrappedType(from: type, environment: environment)
        try makeType(expType, matchRequiredType: requiredType, withDelta: &delta, errorForFailure: .mismatchingTypesForSumType(exp: exp, actual: expType, expected: requiredType))
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
            try makeType(argType, matchRequiredType: requiredType, withDelta: &argDelta, errorForFailure: .mismatchingTypeForFunctionArgument(exp: exp, index: i, actual: argType, expected: requiredType))
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
    case let .ePlus(e1, e2):
        return try handleEPlusOrEMinus(e1, e2, originalExpression: exp)
    case let .eMinus(e1, e2):
        return try handleEPlusOrEMinus(e1, e2, originalExpression: exp)
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

private func makeType(_ type: Type, matchRequiredType requiredType: Type, withDelta delta: inout Environment.Delta, errorForFailure: TypeCheckerError) throws {
    if !requiredType.isSubtype(of: type) {
        //if possible, scale expression up to match required type
        if type.coreType == requiredType.coreType {
            let differingFactor = requiredType.replicationCount / type.replicationCount
            delta.scale(by: differingFactor)
        }
        else {
            throw errorForFailure
        }
    }
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

private func handleEPlusOrEMinus(_ e1: Exp, _ e2: Exp, originalExpression exp: Exp) throws -> (Type, Environment.Delta) {
    let (type1, delta1) = try inferType(e1)
    let (type2, delta2) = try inferType(e2)
    let allowedTypes: [Type] = [
        .tType(.cTBase(.int), 1),
        .tType(.cTBase(.float), 1)
    ]
    for allowedType in allowedTypes {
        if allowedType.coreType == type1.coreType && allowedType.coreType == type2.coreType {
            //instead of subtyping to replication count 1, rather subtype only so far that type1 and type2 match
            let lowerReplicationCount = min(type1.replicationCount, type2.replicationCount)
            let resultType = Type.tType(allowedType.coreType, lowerReplicationCount)
            return (resultType, delta1.merge(with:delta2))
        }
    }
    throw TypeCheckerError.noOperatorOverloadFound(exp: exp, types: [type1, type2])
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

//MARK: TypeCheckerError printing

extension TypeCheckerError: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .nameAlreadyInUse(id: id, as: usageType):
            return "unable to use Id `\(id)` because it is already used for a \(usageType)"
        case let .functionNotFound(id):
            return "function `\(id.value)` not found"
        case let .exposedFunctionDoesNotReturnOPPType(function: id, returnType: type):
            return "exposed functions must always return an OPP type\n" +
            "function: \(id)" +
            "actual: \(type)"
        case let .typeNotFound(id):
            return "type `\(id.value)` not found"
        case let .variableAlreadyExists(id):
            return "variable `\(id.value)` already exists in context"
        case let .variableNotFound(id):
            return "variable `\(id.value)` not found in context"
        case let .invalidVariableAccess(id):
            return "access to variable `\(id.value)` led to replication count less than zero"
        case let .assignmentFailed(stm, actual, expected):
            return "assignment failed in statement" + "\n" +
            "statement: " + stm.show() + "\n" +
            "expected: \(expected)\n" +
            "actual: \(actual)"
        case let .missingReturn(function: id):
            return "missing return statement in function `\(id.value)`"
        case let .invalidReturnType(actual: actual, expected: expected):
            return "invalid return type in function\n" +
            "expected: \(expected)\n" +
            "actual: \(actual)\n"
        case let .splitFailed(stm, actual):
            return "assignment failed in statement" + "\n" +
            "statement: " + stm.show() + "\n" +
            "expected: pair type\n" +
            "actual: \(actual)"
        case let .caseApplicationFailed(case: `case`, actual: actual):
            return "failed to apply " + `case`.show() + " on expression of type \(actual)"
        case let .mismatchingTypesForSumType(exp: exp, actual: actual, expected: expected):
            return "mismatching types when trying to construct sum type" + "\n" +
            "expression: " + exp.show() + "\n" +
            "expected: \(expected)\n" +
            "actual: \(actual)"
        case let .tooManyArgumentsToFunction(exp: exp, actualCount: actual, expectedCount: expected):
            return "too many arguments to function" + "\n" +
            "expression: " + exp.show() + "\n" +
            "expected: \(expected)\n" +
            "actual: \(actual)"
        case let .mismatchingTypeForFunctionArgument(exp: exp, index: index, actual: actual, expected: expected):
            return "argument at index \(index) has mismatching type in function application" + "\n" +
            "expression: " + exp.show() + "\n" +
            "expected: \(expected)\n" +
            "actual: \(actual)"
        case let .noOperatorOverloadFound(exp: exp, types: types):
            return "no operator overload found that matches found types" + "\n" +
            "expression: " + exp.show() + "\n" +
                "types: " + types.map { $0.description }.joined(separator: ", ")
        case let .assertionFailed(message):
            return message
        case let.addNoiseFailed(message: message):
            return message
        case let .other(message):
            return message
        }
    }
}
