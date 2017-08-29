//
//  TypeChecker.swift
//  DPTypeChecker
//
//  Created by Jan Wittler on 08.06.17.
//  Copyright © 2017 Jan Wittler. All rights reserved.
//

import Foundation

private struct FunctionSignature {
    let id: Id
    let argumentTypes: [Type]
    let returnType: Type
    let isExposed: Bool
}

private var environment = Environment()

func typeCheck(_ program: Program) throws {
    environment = Environment()
    switch program {
    case let .defs(defs):
        try populateEnvironment(defs)
        try defs.forEach { try checkDef($0) }
    }
}

private func populateEnvironment(_ defs: [Def]) throws {
    //collect at first all typedefs, otherwise function signatures may not be validated
    for case let .typedef(ident, lType, rType) in defs {
        try environment.addSumType(name: ident, types: (lType, rType))
    }
    try defs.flatMap { def -> (Id, [Arg], Type)? in
        //get all functions
        switch def {
        case let .fun(id, args, returnType, _):
            return (id, args, returnType)
        case let .funExposed(id, args, returnType, _):
            return (id, args, returnType)
             case .typedef:
            return nil
        }
    }.forEach {
        try environment.addFunction(id: $0, arguments: $1.map { $0.type }, returnType: $2)
    }
}

/**
 Type-checks the given definition under the current environment. Throws an error if the type-check failed.
 - parameters:
   - def: The definition to type-check.
 - throws: Throws an instance of `TypeCheckerError` if the type-check failed.
 */
private func checkDef(_ def: Def) throws {
    switch def {
    case let .fun(id, args, returnType, stms):
        try checkFunction(id: id, args: args, returnType: returnType, stms: stms, isExposed: false)
        case let .funExposed(id, args, returnType, stms):
        //exposed functions must return an opp type since they are handed to the opponent
        guard returnType.isOPPType(inEnvironment: environment) else {
            throw TypeCheckerError.exposedFunctionDoesNotReturnOPPType(function: id, returnType: returnType)
        }
        try checkFunction(id: id, args: args, returnType: returnType, stms: stms, isExposed: true)
    case .typedef:
        break //handled in `populateEnvironment`
    }
}

/**
 Type-checks the given function under the current environment. Throws an error if the type-check failed.
 - parameters:
   - id: The id of the function.
   - args: The arguments of the function.
   - returnType: The return type of the function.
   - stms: The statements of the function's body.
   - isExposed: Indicates whether the function is an exposed function. Exposed functions are required to return an opponent type.
 - throws: Throws an instance of `TypeCheckerError` if the type-check failed.
 */
private func checkFunction(id: Id, args: [Arg], returnType: Type, stms: [Stm], isExposed: Bool) throws {
    guard containsReturnStatement(stms) else {
        throw TypeCheckerError.missingReturn(function: id)
    }
    environment.pushContext()
    try addArgsToCurrentContext(args)
    let signature = FunctionSignature(id: id, argumentTypes: args.map({ $0.type }), returnType: returnType, isExposed: isExposed)
    try checkStms(stms, functionSignature: signature)
}

/**
 A convenience method to add all arguments of a function to the current context.
 - parameters:
   - args: The arguments of the function to add.
 - throws: Throws an instance of `TypeCheckerError` if any argument's type is not valid or a variable with the argument's name already exists in the current context.
 */
private func addArgsToCurrentContext(_ args: [Arg]) throws {
    try args.forEach { arg in
        switch arg {
        case let .decl(id, type):
            try environment.addToCurrentContext(id, type: type)
        }
    }
}

/**
 Verifies that a function reaches a `return`-statement in every possible execution flow of the function's body.
 - parameters:
   - stms: The statements of the function's body.
 - returns: Returns `true` if a `return`-statement is reached in any case, otherwise `false`.
 */
private func containsReturnStatement(_ stms: [Stm]) -> Bool {
    return stms.reduce(false, { result, stm -> Bool in
        let isReturn: Bool
        switch stm {
        case .return:
            isReturn = true
        case let .ifElse(_, ifStms, `else`):
            isReturn = containsReturnStatement(ifStms) && (`else`.stms == nil ? true : containsReturnStatement(`else`.stms!))
        default:
            isReturn = false
        }
        return result || isReturn
    })
}

/**
 Type-checks the given statements under the current environment. Throws an error if the type-check failed.
 - parameters:
   - stms: The statements to type-check.
   - functionSignature: The signature of the function to which the given statements belong.
 - throws: Throws an instance of `TypeCheckerError` if the type-check failed.
 */
private func checkStms(_ stms: [Stm], functionSignature: FunctionSignature) throws {
    try stms.forEach { try checkStm($0, functionSignature: functionSignature) }
}

/**
 Type-checks the given statement under the current environment. Throws an error if the type-check failed.
 - parameters:
   - stm: The statement to type-check.
   - functionSignature: The signature of the function to which the given statement belongs.
 - throws: Throws an instance of `TypeCheckerError` if the type-check failed.
 */
private func checkStm(_ stm: Stm, functionSignature: FunctionSignature) throws {
    switch stm {
    case let .init(idMaybeTyped, exp):
        var (expType, envDelta) = try inferType(exp, requiresOPPType: false)
        if let requiredType = idMaybeTyped.type {
            try makeType(&expType, matchRequiredType: requiredType, withDelta: &envDelta, errorForFailure: .assignmentFailed(stm: stm, actual: expType, expected: requiredType))
        }
        try environment.applyDelta(envDelta)
        try environment.addToCurrentContext(idMaybeTyped.id, type: expType)
        
    case let .split(idMaybeTyped1, idMaybeTyped2, exp):
        var (expType, envDelta) = try inferType(exp, requiresOPPType: false)
        guard case var .mulPair(type1, type2) = expType.coreType else {
            throw TypeCheckerError.splitFailed(stm: stm, actual: expType)
        }
        
        //resolve generic types to their annotated types, if any, and get scaling factor for each pair element
        let fixedTypesAndFactors = try [(type1, idMaybeTyped1), (type2, idMaybeTyped2)].map { (type, idMaybeTyped) -> (Type, ReplicationIndex) in
            if let requiredType = idMaybeTyped.type {
                //use the core type of the required type to resolve generic types but keep the old replication index since this may get recomputed when variable is added to the environment
                let resultType = Type.default(requiredType.coreType, type.replicationIndex)
                guard let factor = try type.scalingFactorToConvertToType(requiredType, inEnvironment: environment) else {
                    throw TypeCheckerError.assignmentFailed(stm: stm, actual: type, expected: requiredType)
                }
                return (resultType, factor)
            }
            return (type, 1)
        }
        
        type1 = fixedTypesAndFactors[0].0
        type2 = fixedTypesAndFactors[1].0
        let maxFactor = fixedTypesAndFactors.map { $0.1 }.max()!
        envDelta.scale(by: maxFactor)
        try environment.applyDelta(envDelta)
        
        let id1 = idMaybeTyped1.id
        let id2 = idMaybeTyped2.id
        try environment.addToCurrentContext(id1, type: idMaybeTyped1.type ?? .default(type1.coreType, type1.replicationIndex.multiplying(by: maxFactor, withRoundingMode: .forTypeConstruction)))
        try environment.addToCurrentContext(id2, type: idMaybeTyped2.type ?? .default(type2.coreType, type2.replicationIndex.multiplying(by: maxFactor, withRoundingMode: .forTypeConstruction)))
        
    case let .ifElse(condition, ifStms, `else`):
        var elseEnvironment: Environment?
        if let elseStms = `else`.stms {
            let environmentCopy = environment
            
            //since `handleIfCondition` may scale the delta which is not needed for else, just get the expression from the condition and type-check it without scaling
            let exp: Exp
            switch condition {
            case let .bool(e):
                exp = e
            case let .case(_, _, e):
                exp = e
            case let .unfold(_, _, e):
                exp = e
            }
            let (_, delta) = try inferType(exp, requiresOPPType: false)
            environment.pushContext()
            try environment.applyDelta(delta)
            try checkStms(elseStms, functionSignature: functionSignature)
            environment.popContext()
            elseEnvironment = environment
            //restore the environment that existed before typechecking the else branch to typecheck the if branch with the old environment
            environment = environmentCopy
        }
        
        environment.pushContext()
        try handleIfCondition(condition, inStatement: stm)
        try checkStms(ifStms, functionSignature: functionSignature)
        environment.popContext()
        
        if let elseEnvironment = elseEnvironment {
            //adjust the environment to have the higher usage counts of both branches
            environment.adjustToTakeHigherUsageCounts(from: elseEnvironment)
        }
        
    case let .switch(exp, cases):
        let originalEnvironment = environment
        var createdEnvironments = [Environment]()
        let (type, delta) = try inferType(exp, requiresOPPType: false)
        //cases may be used only once, otherwise language is not deterministic
        var usedCases = [Case]()
        try cases.forEach {
            guard !usedCases.contains($0.case) else {
                throw TypeCheckerError.invalidSwitch(stm: stm, message: "duplicate usage of '\($0.case.show())'")
            }
            usedCases.append($0.case)

            var deltaCopy = delta
            var unwrappedType = try $0.case.unwrappedType(from: type, inEnvironment: environment)
            if let requiredType = $0.idMaybeTyped.type {
                try makeType(&unwrappedType, matchRequiredType: requiredType, withDelta: &deltaCopy, errorForFailure: .assignmentFailed(stm: stm, actual: unwrappedType, expected: requiredType))
            }
            environment.pushContext()
            try environment.applyDelta(deltaCopy)
            try environment.addToCurrentContext($0.idMaybeTyped.id, type: unwrappedType)
            try checkStms($0.stms, functionSignature: functionSignature)
            environment.popContext()
            
            createdEnvironments.append(environment)
            //reset to original environment for next case
            environment = originalEnvironment
        }
        //adjust the environment to have the higher usage counts from any of the created environments
        createdEnvironments.forEach { environment.adjustToTakeHigherUsageCounts(from: $0) }
        
    case let .return(exp):
        var (expType, envDelta) = try inferType(exp, requiresOPPType: functionSignature.isExposed)
        try makeType(&expType, matchRequiredType: functionSignature.returnType, withDelta: &envDelta, errorForFailure: .invalidReturnType(function: functionSignature.id, actual: expType, expected: functionSignature.returnType))
        try environment.applyDelta(envDelta)
        
    case let .assert(assertion):
        try checkAssertion(assertion)
    }
}

/**
 Infers the type of the given expression. If an opponent type is required, elements of composed types are tried to be scaled to exponential types. Returns the type of the expression and an environment delta that indicates the changes that must occur to the environment in order to successfully type-check the given expression.
 - parameters:
   - exp: The expression to infer the type of.
   - requiresOPPType: Indicates whether an opponent type is required as the result of the type inference. This is the case in the return statement of an exposed function.
 - returns: Returns the type of the expression and an environment delta that indicates the changes to the environment when type-checking the given expression.
 - throws: Throws an instance of `TypeCheckerError` if the type inference failed.
 */
private func inferType(_ exp: Exp, requiresOPPType: Bool) throws -> (Type, Environment.Delta) {
    switch exp {
    case .int:
        return (.default(.base(.int), 1), Environment.Delta())
    case .double:
        return (.default(.base(.double), 1), Environment.Delta())
    case .unit:
        return (.default(.base(.unit), 1), Environment.Delta())
    case .true:
        fallthrough
    case .false:
        return (.default(try environment.coreTypeForId(boolTypeIdent), 1), Environment.Delta())
    case let .option(e1):
        var (type, delta) = try inferType(e1, requiresOPPType: requiresOPPType)
        if requiresOPPType {
            try makeType(&type, matchRequiredType: .exponential(type.coreType), withDelta: &delta, errorForFailure: .failedToConvertTypeToOPPType(exp: exp, type: type))
        }
        let resultType = Type.default(try environment.coreTypeForId(optionalTypeIdent), 1).replaceAllGenericTypes(with: type)
        return (resultType, delta)
    case .nothing:
        return (.default(try environment.coreTypeForId(optionalTypeIdent), 1), Environment.Delta())
    case let .id(id):
        do {
            let type = try environment.lookup(id)
            let returnType = Type.default(type.coreType, 1)
            var delta = Environment.Delta()
            delta.updateUsageCount(for: id, delta: 1)
            return (returnType, delta)
        }
        // if it is not a variable, maybe it is a function called without argument thus the function type is preserved
        // if it is not a function, return the original variable not found error
        catch let TypeCheckerError.variableNotFound(errorId) {
            do {
                let (args, returnType) = try environment.lookupFunction(id)
                let function = Type.exponential(.function(args, returnType))
                return (function, Environment.Delta())
            }
            catch {
                throw TypeCheckerError.variableNotFound(errorId)
            }
        }
        
    case let .pair(e1, e2):
        var (type1, delta1) = try inferType(e1, requiresOPPType: requiresOPPType)
        var (type2, delta2) = try inferType(e2, requiresOPPType: requiresOPPType)
        if requiresOPPType {
            try makeType(&type1, matchRequiredType: .exponential(type1.coreType), withDelta: &delta1, errorForFailure: .failedToConvertTypeToOPPType(exp: exp, type: type1))
            try makeType(&type2, matchRequiredType: .exponential(type2.coreType), withDelta: &delta2, errorForFailure: .failedToConvertTypeToOPPType(exp: exp, type: type2))
        }
        let returnType = Type.default(.mulPair(type1, type2), 1)
        let delta = delta1.merge(with: delta2)
        return (returnType, delta)
    case let .sum(typeId, sumCase, exp):
        var (expType, delta) = try inferType(exp, requiresOPPType: requiresOPPType)
        //check if expression's type matches type from type definition and if required scale correctly
        let typeDefinition = Type.default(try environment.typeDefinitionOfCoreType(with: typeId), 1)
        let requiredType = try sumCase.unwrappedType(from: typeDefinition, inEnvironment: environment)
        try makeType(&expType, matchRequiredType: requiredType, withDelta: &delta, errorForFailure: .mismatchingTypesForSumType(exp: exp, actual: expType, expected: requiredType))
        
        //don't return the type definition types but rather the named core type
        let sumType = try environment.coreTypeForId(typeId)
        return (.default(sumType, 1), delta)
    case let .list(exps):
        let typesAndDeltas = try exps.map { try inferType($0, requiresOPPType: requiresOPPType) }
        let types = typesAndDeltas.map { $0.0 }
        var delta = typesAndDeltas.reduce(Environment.Delta()) { $0.merge(with: $1.1) }
        if var elementType = types.first {
            try types.forEach {
                //subtype all elements to the type with the least replication index
                if $0.isSubtype(of: elementType) {
                    elementType = $0
                }
                else if !elementType.isSubtype(of: $0) {
                   throw TypeCheckerError.listWithHeterogenousElementsNotSupported(exp: exp, types: types)
                }
            }
            if requiresOPPType {
                elementType = .exponential(elementType.coreType)
                delta = try typesAndDeltas.reduce(Environment.Delta()) {
                    var type = $1.0
                    var delta = $1.1
                    try makeType(&type, matchRequiredType: elementType, withDelta: &delta, errorForFailure: .failedToConvertTypeToOPPType(exp: exp, type: type))
                    return $0.merge(with: delta)
                }
            }
            return (.default(.list(elementType), 1), delta)
        }
        else {
            return (.default(.list(.unknown), 1), Environment.Delta())
        }
    case let .ref(type):
        try type.validate(inEnvironment: environment)
        let readCoreType = try environment.coreTypeForId(readTypeIdent).replaceAllGenericTypes(with: type)
        let writeCoreType = try environment.coreTypeForId(writeTypeIdent).replaceAllGenericTypes(with: type)
        let readType = Type.exponential(readCoreType)
        let writeType = Type.exponential(writeCoreType)
        return (.default(.mulPair(readType, writeType), 1), Environment.Delta())
    case let .app(id, exps):
        let args: [Type], returnType: Type
        var delta = Environment.Delta()
        
        do {
            (args, returnType) = try environment.lookupFunction(id)
        }
        //if there was no function with the id, check if there is a variable with the id which has a function type
        catch let functionError {
            do {
                let idType = try environment.lookup(id)
                delta.updateUsageCount(for: id, delta: 1)
                switch idType.coreType {
                case let .function(aTypes, rType):
                    args = aTypes
                    returnType = rType
                //named type may be a function type
                case let .named(id, generics):
                    guard case let .function(aTypes, rType) = try environment.typeDefinitionOfCoreType(with: id) else {
                        throw functionError
                    }
                    if let annotatedType = generics.annotatedType {
                        args = aTypes.map { $0.replaceAllGenericTypes(with: annotatedType) }
                        returnType = rType.replaceAllGenericTypes(with: annotatedType)
                    }
                    else {
                        args = aTypes
                        returnType = rType
                    }
                default:
                    throw functionError
                }
            }
            //catch errors to throw the original function lookup error instead of the variable lookup one
            catch {
                throw functionError
            }
        }
        
        guard exps.count <= args.count else {
            throw TypeCheckerError.tooManyArgumentsToFunction(exp: exp, actualCount: exps.count, expectedCount: args.count)
        }
        
        let expTypesAndDeltas = try exps.map { try inferType($0, requiresOPPType: requiresOPPType) }
        for i in 0..<expTypesAndDeltas.count {
            var (argType, argDelta) = expTypesAndDeltas[i]
            let requiredType = args[i]
            try makeType(&argType, matchRequiredType: requiredType, withDelta: &argDelta, errorForFailure: .mismatchingTypeForFunctionArgument(exp: exp, index: i, actual: argType, expected: requiredType))
            delta = delta.merge(with: argDelta)
        }
        
        if (exps.count == args.count) {
            return (returnType, delta)
        }
        else { //allow partial function application
            let missingArgs = args.dropFirst(exps.count)
            let functionType = CoreType.function(Array(missingArgs), returnType)
            let returnType = Type.default(functionType, 1)
            return (returnType, delta)
        }
    case let .noising(e1):
        return (try handleAddNoise(e1), Environment.Delta())
    case let .negative(e1):
        let (type, delta) = try inferType(e1, requiresOPPType: requiresOPPType)
        let allowedCoreTypes: [CoreType] = [
            .base(.int),
            .base(.double)
        ]
        if allowedCoreTypes.contains(type.coreType) {
            return (type, delta)
        }
        throw TypeCheckerError.noOperatorOverloadFound(exp: exp, types: [type])
    case let .not(e1):
        let (type, delta) = try inferType(e1, requiresOPPType: requiresOPPType)
        let allowedCoreTypes: [CoreType] = [
            try environment.coreTypeForId(boolTypeIdent)
        ]
        if allowedCoreTypes.contains(type.coreType) {
            return (type, delta)
        }
        throw TypeCheckerError.noOperatorOverloadFound(exp: exp, types: [type])
    case let .times(e1, e2):
        return try handleMultiplicationOrDivision(e1, e2, originalExpression: exp, requiresOPPType: requiresOPPType)
    case let .div(e1, e2):
        return try handleMultiplicationOrDivision(e1, e2, originalExpression: exp, requiresOPPType: requiresOPPType)
    case let .plus(e1, e2):
        return try handleAdditionOrSubtraction(e1, e2, originalExpression: exp, requiresOPPType: requiresOPPType)
    case let .minus(e1, e2):
        return try handleAdditionOrSubtraction(e1, e2, originalExpression: exp, requiresOPPType: requiresOPPType)
    case let .lt(e1, e2):
        return try handleComparison(e1, e2, originalExpression: exp, requiresOPPType: requiresOPPType)
    case let .gt(e1, e2):
        return try handleComparison(e1, e2, originalExpression: exp, requiresOPPType: requiresOPPType)
    case let .ltEq(e1, e2):
        return try handleComparison(e1, e2, originalExpression: exp, requiresOPPType: requiresOPPType)
    case let .gtEq(e1, e2):
        return try handleComparison(e1, e2, originalExpression: exp, requiresOPPType: requiresOPPType)
    case let .eq(e1, e2):
        return try handleComparison(e1, e2, originalExpression: exp, requiresOPPType: requiresOPPType)
    case let .neq(e1, e2):
        return try handleComparison(e1, e2, originalExpression: exp, requiresOPPType: requiresOPPType)
    }
}

/**
 A helper method to correctly scale an inferred type to a required (annotated) type. Since unknown types contained in `type` are treated as if they would match their counterpart in the required type, `type` is changed during the method execution to match `requiredType` to avoid wrong types in further execution. Throws an error if the required type is invalid. Throws `errorForFailure` if the given type cannot be scaled to match the required type.
 - parameters:
   - type: The type that should be scaled to match the required type.
   - requiredType: The type that `type` should match.
   - delta: The delta associated with the given type. It is scaled up if this is necessary to make `type` match `requiredType`.
   - errorForFailure: An error that should be thrown in case the two types do not match.
 - throws: Throws an error if the required type is invalid. Throws `errorForFailure` if the given type cannot be scaled to match the required type.
 */
private func makeType(_ type: inout Type, matchRequiredType requiredType: Type, withDelta delta: inout Environment.Delta, errorForFailure: TypeCheckerError) throws {
    if let factor = try type.scalingFactorToConvertToType(requiredType, inEnvironment: environment) {
        delta.scale(by: factor)
    }
    else {
        throw errorForFailure
    }
    type = requiredType
}

/**
 Type-checks the given `if`-condition under the current environment. Throws an error if the type-check failed.
 - parameters:
   - condition: The `if`-condition to type-check.
   - stm: The stm from which the condition originated.
 - throws: Throws an instance of `TypeCheckerError` if the type-check failed.
 */
private func handleIfCondition(_ condition: IfCond, inStatement stm: Stm) throws {
    switch condition {
    case let .bool(exp):
        let (type, delta) = try inferType(exp, requiresOPPType: false)
        guard try type.coreType == environment.coreTypeForId(boolTypeIdent) else {
            throw TypeCheckerError.invalidIfCondition(stm: stm, message: "an if condition must be of `Bool` type but was \(type)")
        }
        try environment.applyDelta(delta)
    case let .case(idMaybeTyped, sumCase, exp):
        var (condType, envDelta) = try inferType(exp, requiresOPPType: false)
        var unwrappedType = try sumCase.unwrappedType(from: condType, inEnvironment: environment)
        if let requiredType = idMaybeTyped.type {
            try makeType(&unwrappedType, matchRequiredType: requiredType, withDelta: &envDelta, errorForFailure: .assignmentFailed(stm: stm, actual: unwrappedType, expected: requiredType))
        }
        try environment.applyDelta(envDelta)
        try environment.addToCurrentContext(idMaybeTyped.id, type: unwrappedType)
    case let .unfold(headIdMaybeTyped, tailIdMaybeTyped, exp):
        var (listType, delta) = try inferType(exp, requiresOPPType: false)
        guard case var .list(elemType) = listType.coreType else {
            throw TypeCheckerError.invalidIfCondition(stm: stm, message: "conditional unfold must be applied to list type\nactual: \(listType)")
        }
        
        //fix unknown types and get scaling factor for each pair element
        let fixedTypesAndFactors = try [(elemType, headIdMaybeTyped), (listType, tailIdMaybeTyped)].map { (type, idMaybeTyped) -> (Type, ReplicationIndex) in
            if let requiredType = idMaybeTyped.type {
                //use the core type of the required type to solve for `unknown` types but keep the old replication index since this gets recomputed when variable is added to environment
                let resultType = Type.default(requiredType.coreType, type.replicationIndex)
                guard let factor = try type.scalingFactorToConvertToType(requiredType, inEnvironment: environment) else {
                    throw TypeCheckerError.assignmentFailed(stm: stm, actual: type, expected: requiredType)
                }
                return (resultType, factor)
            }
            return (type, 1)
        }
        
        elemType = fixedTypesAndFactors[0].0
        listType = fixedTypesAndFactors[1].0
        let maxFactor = fixedTypesAndFactors.map { $0.1 }.max()!
        delta.scale(by: maxFactor)
        try environment.applyDelta(delta)
        
        let head = headIdMaybeTyped.id
        let tail = tailIdMaybeTyped.id
        try environment.addToCurrentContext(head, type: headIdMaybeTyped.type ?? .default(elemType.coreType, elemType.replicationIndex.multiplying(by: maxFactor, withRoundingMode: .forTypeConstruction)))
        try environment.addToCurrentContext(tail, type: tailIdMaybeTyped.type ?? .default(listType.coreType, listType.replicationIndex.multiplying(by: maxFactor, withRoundingMode: .forTypeConstruction)))
    }
}

/**
 Performs the validation of an `add_noise` function call. Throws an error if the type-check of the function argument failed or if the function argument has a non-numeric type. Returns the type of the `add_noise` function execution. Does not return an environment delta since adding noise hides any private data thus the delta of the argument is applied directly to the environment to prevent it from incorrectly scaling in further executions.
 - parameters: 
   -exp: The expression of the function argument.
 - returns: Returns the type of the `add_noise` function execution.
 - throws: Throws an instance of `TypeCheckerError` if type-checking the argument failed or the argument has an invalid type.
 */
private func handleAddNoise(_ exp: Exp) throws -> Type {
    let (expType, delta) = try inferType(exp, requiresOPPType: false)
    //apply delta directly, because it must not be scaled after `add_noise` was applied
    try environment.applyDelta(delta)
    let allowedBaseTypes: [BaseType] = [.int, .double]
    guard case let .base(baseType) = expType.coreType, allowedBaseTypes.contains(baseType) else {
        throw TypeCheckerError.addNoiseFailed(message: "invalid type for adding noise to\ntype: \(expType)\nin expression: \(exp)")
    }
    
    //it is not required to check the replication index of the noised type or of the function arguments because the amount of noise to add depends on the replication indexes of the arguments of the exposed functions called by the opponent that led to the execution of `add_noise`.
    return .exponential(expType.coreType)
}

/**
 Extracted parts of the `inferType` method for better readability. Type-checks an addition or subtraction under the current environment. If an opponent type is required, elements of composed types are tried to be scaled to exponential types. Returns the type of the expression and an environment delta that indicates the changes that must occur to the environment in order to successfully type-check the given expression.
 - parameters:
   - e1: The first operand.
   - e2: The second operand.
   - exp: The original expression.
   - requiresOPPType: Indicates whether an opponent type is required as the result of the type inference. This is the case in the return statement of an exposed function.
 - returns: Returns the type of the expression and an environment delta that indicates the changes to the environment when type-checking the given expression.
 - throws: Throws an instance of `TypeCheckerError` if the type inference failed.
 */
private func handleAdditionOrSubtraction(_ e1: Exp, _ e2: Exp, originalExpression exp: Exp, requiresOPPType: Bool) throws -> (Type, Environment.Delta) {
    let (type1, delta1) = try inferType(e1, requiresOPPType: requiresOPPType)
    let (type2, delta2) = try inferType(e2, requiresOPPType: requiresOPPType)
    let delta = delta1.merge(with: delta2)
    //instead of subtyping to replication index 1, rather subtype only so far that type1 and type2 match
    let lowerReplicationIndex = min(type1.replicationIndex, type2.replicationIndex)
    
    let allowedCoreTypes: [CoreType] = [
        .base(.int),
        .base(.double)
    ] //replication index is always 1
    if allowedCoreTypes.contains(type1.coreType) && type1.coreType == type2.coreType {
        let resultType = Type.default(type1.coreType, lowerReplicationIndex)
        return (resultType, delta)
    }
    
    //allow list addition
    if case .plus = exp, case let .list(elem1) = type1.coreType, case let .list(elem2) = type2.coreType {
        //take the element type that matches both lists, i.e. subtype one to match the other if possible
        //do not implicitly type generic lists to the type of the other list, as the generic list could be used later again and then typed to another element type which gives an inconsistency
        if elem1.isSubtype(of: elem2) {
            return (.default(.list(elem1), lowerReplicationIndex), delta)
        }
        else if elem2.isSubtype(of: elem1) {
            return (.default(.list(elem2), lowerReplicationIndex), delta)
        }
    }
    throw TypeCheckerError.noOperatorOverloadFound(exp: exp, types: [type1, type2])
}

/**
 Extracted parts of the `inferType` method for better readability. Type-checks a multiplication or division under the current environment. If an opponent type is required, elements of composed types are tried to be scaled to exponential types. Returns the type of the expression and an environment delta that indicates the changes that must occur to the environment in order to successfully type-check the given expression.
 - parameters:
   - e1: The first operand.
   - e2: The second operand.
   - exp: The original expression.
   - requiresOPPType: Indicates whether an opponent type is required as the result of the type inference. This is the case in the return statement of an exposed function.
 - returns: Returns the type of the expression and an environment delta that indicates the changes to the environment when type-checking the given expression.
 - throws: Throws an instance of `TypeCheckerError` if the type inference failed.
 */
private func handleMultiplicationOrDivision(_ e1: Exp, _ e2: Exp, originalExpression exp: Exp, requiresOPPType: Bool) throws -> (Type, Environment.Delta) {
    var (type1, delta1) = try inferType(e1, requiresOPPType: requiresOPPType)
    var (type2, delta2) = try inferType(e2, requiresOPPType: requiresOPPType)
    
    let allowedCoreTypes: [CoreType] = [
        .base(.int),
        .base(.double)
    ]
    guard allowedCoreTypes.contains(type1.coreType) && type1.coreType == type2.coreType else {
        throw TypeCheckerError.noOperatorOverloadFound(exp: exp, types: [type1, type2])
    }
    
    let mulWithConst: ((Type, Environment.Delta, ReplicationIndex) -> (Type, Environment.Delta)) = {
        var delta = $1
        //take the absolute value to handle negative numbers correctly
        //scaling to numbers less than 1 is forbidden thus assure that factor is at least 1
        delta.scale(by: max(1, abs($2)))
        return ($0, delta)
    }
    
    //check if it is a multiplication with a constant value
    if case .times = exp {
        if delta1.isEmpty, let value = constantValueFromExpression(e1, roundingMode: .forUsageCount) {
            return mulWithConst(type2, delta2, value)
        }
        else if delta2.isEmpty, let value = constantValueFromExpression(e2, roundingMode: .forUsageCount) {
            return mulWithConst(type1, delta1, value)
        }
    }
    //check if it is a division by a constant value; division by non-exponential non-constant type is not supported
    if case .div = exp {
        if delta2.isEmpty, let value = constantValueFromExpression(e2, roundingMode: .forUsageCount) {
            return mulWithConst(type1, delta1, ReplicationIndex(1).dividing(by: value, withRoundingMode: .up))
        }
    }
        
    //check if both types are exponential or can be scaled up to that
    do {
        var environmentCopy = environment
        if !type1.isExponential {
            delta1.scale(by: .infinity)
            try environmentCopy.applyDelta(delta1)
        }
        if !type2.isExponential {
            delta2.scale(by: .infinity)
            try environmentCopy.applyDelta(delta2)
        }
        return (.exponential(type1.coreType), delta1.merge(with: delta2))
    }
    catch {
        //catch scaling error to throw more descriptive arithmetic error instead
        let errorMessage: String
        if case .div = exp {
            errorMessage = "division must be performed with either a constant value as the divisor or only exponential types."
        }
        else {
            errorMessage = "multiplication must be performed with at least one constant value or only exponential types."
        }
        throw TypeCheckerError.arithmeticError(message: errorMessage + "\n" + "expression: \(exp.show())")
    }
}

/**
 Extracted parts of the `inferType` method for better readability. Type-checks a comparison (`<, <=, >, >=, ==, !=`) under the current environment. If an opponent type is required, elements of composed types are tried to be scaled to exponential types. Returns the type of the expression and an environment delta that indicates the changes that must occur to the environment in order to successfully type-check the given expression.
 - parameters:
   - e1: The first operand.
   - e2: The second operand.
   - exp: The original expression.
   - requiresOPPType: Indicates whether an opponent type is required as the result of the type inference. This is the case in the return statement of an exposed function.
 - returns: Returns the type of the expression and an environment delta that indicates the changes to the environment when type-checking the given expression.
 - throws: Throws an instance of `TypeCheckerError` if the type inference failed.
 */
private func handleComparison(_ e1: Exp, _ e2: Exp, originalExpression exp: Exp, requiresOPPType: Bool) throws -> (Type, Environment.Delta) {
    var (type1, delta1) = try inferType(e1, requiresOPPType: requiresOPPType)
    var (type2, delta2) = try inferType(e2, requiresOPPType: requiresOPPType)
    var allowedCoreTypes: [CoreType] = [
        .base(.int),
        .base(.double),
    ] //since comparison yields bool type which can magnify distance of input by infinity, input to comparison must have exponential type
    
    //booleans can not be ordered, thus only allow them for `==` and `!=`
    if case .eq = exp {
        allowedCoreTypes.append(try environment.coreTypeForId(boolTypeIdent))
    }
    else if case .neq = exp {
        allowedCoreTypes.append(try environment.coreTypeForId(boolTypeIdent))
    }
    
    if allowedCoreTypes.contains(type1.coreType) && type1.coreType == type2.coreType {
        do {
            var environmentCopy = environment
            if !type1.isExponential {
                delta1.scale(by: .infinity)
                try environmentCopy.applyDelta(delta1)
            }
            if !type2.isExponential {
                delta2.scale(by: .infinity)
                try environmentCopy.applyDelta(delta2)
            }
            return (.exponential(try environment.coreTypeForId(boolTypeIdent)), delta1.merge(with: delta2))
        }
        catch {
            //catch scaling error to throw more descriptive arithmetic error instead
            throw TypeCheckerError.arithmeticError(message: "input of comparison operators must both have an exponential type\nexpression: \(exp.show())")
        }
    }
    throw TypeCheckerError.noOperatorOverloadFound(exp: exp, types: [type1, type2])
}

/**
 Infers the constant value of the given expression if possible. Returns a `ReplicationIndex` instance storing the inferred value or `nil` if inference was not possible. Supports inference of basic constants and operations on basic constants. Uses the given rounding mode for cases where the result of some operation cannot be represented exactly by `ReplicationIndex`.
 - parameters:
   - exp: The expression to infer the value from.
   - roundingMode: The rounding mode to use.
 - returns: Returns an instance of `ReplicationIndex` storing the inferred value or `nil` if inference failed.
 */
private func constantValueFromExpression(_ exp: Exp, roundingMode: ReplicationIndex.RoundingMode) -> ReplicationIndex? {
    switch exp {
    case let .double(value):
        return ReplicationIndex(value)
    case let .int(value):
        return ReplicationIndex(value)
    case let .negative(e):
        if let value = constantValueFromExpression(e, roundingMode: roundingMode) {
            return -value
        }
    case let .times(e1, e2):
        if let value1 = constantValueFromExpression(e1, roundingMode: roundingMode), let value2 = constantValueFromExpression(e2, roundingMode: roundingMode) {
            return value1.multiplying(by: value2, withRoundingMode: roundingMode)
        }
    case let .div(e1, e2):
        if let value1 = constantValueFromExpression(e1, roundingMode: roundingMode), let value2 = constantValueFromExpression(e2, roundingMode: roundingMode), value2 != 0 {
            return value1.dividing(by: value2, withRoundingMode: roundingMode)
        }
    case let .plus(e1, e2):
        if let value1 = constantValueFromExpression(e1, roundingMode: roundingMode), let value2 = constantValueFromExpression(e2, roundingMode: roundingMode) {
            return value1.adding(value2, withRoundingMode: roundingMode)
        }
    case let .minus(e1, e2):
        if let value1 = constantValueFromExpression(e1, roundingMode: roundingMode), let value2 = constantValueFromExpression(e2, roundingMode: roundingMode) {
            return value1.adding(value2, withRoundingMode: roundingMode)
        }
    default:
        break
    }
    return nil
}

/**
 Validates the given assertion under the current environment. Throws an error if the assertion is not hold.
 - note: Validating an assertion does not change the current environment.
 - parameters:
   - assertion: The assertion to validate.
 - throws: Throws an instance of `TypeCheckerError` if the assertion failed to validate.
 */
private func checkAssertion(_ assertion: Assertion) throws {
    //assertions are only for validation during debugging, not for any modification, thus restore the previous environment after checking the assertion
    let previousEnvironment = environment
    switch assertion {
    case let .typeEqual(id, type):
        try type.validate(inEnvironment: environment)
        let idType = try environment.lookup(id)
        let usageCount = try environment.lookupUsageCount(id)
        let updatedType: Type
        if idType.isExponential {
            //exponential types will always be exponentials, independent of usage count
            updatedType = idType
        }
        else {
            updatedType = Type.default(idType.coreType, idType.replicationIndex.subtracting(usageCount, withRoundingMode: .forTypeConstruction))
        }
        guard updatedType == type else {
            let errorMessage = "variable `\(id.value)` does not match type\n" +
                "expected: \(type)\n" +
                "actual: \(updatedType)"
            throw TypeCheckerError.assertionFailed(errorMessage)
        }
    }
    
    environment = previousEnvironment
}
