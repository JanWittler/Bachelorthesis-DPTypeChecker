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
    case conditionFailed(stm: Stm, actual: Type)
    case functionApplicationFailed(exp: Exp, argsActual: [Type], argsExpected: [Type])
    case assertionFailed(String)
    case addNoiseFailed(message: String)
    case other(String)
}

private struct Environment {
    private enum GlobalElement {
        case addNoise
        case function(args: [Type], returnType: Type)
        case typedef(type: Type)
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
    
    mutating func updateUsageCount(for id: Id, delta: Double) throws {
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
    
    mutating func scale(by factor: Double) throws {
        precondition(factor >= 1, "scaling to lower count invalid")
        
        for i in 0..<contexts.count {
            var context = contexts[i]
            try context.scale(by: factor)
            contexts[i] = context
        }
    }
}

private struct Context {
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

private var environment = Environment()

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
        default:
            isReturn = false
        }
        return result || isReturn
    })
}

private func checkStm(_ stm: Stm, expectedReturnType: Type) throws {
    switch stm {
    case let .sInit(idMaybeTyped, exp):
        let expType = try inferType(exp)
        let varType = idMaybeTyped.type ?? expType
        try checkIfIdMaybeTyped(idMaybeTyped, matchesType: expType, inStm: stm)
        if let type = idMaybeTyped.type {
            let differingFactor = type.replicationCount / expType.replicationCount
            //TODO: there is no real need to scale everything
            // but rather only those parts that are affected by the assignment
            try environment.scale(by: differingFactor)
        }
        try environment.addToCurrentContext(idMaybeTyped.id, type: varType)
        
    case let .sSplit(idMaybeTyped1, idMaybeTyped2, exp):
        let expType = try inferType(exp)
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
        try environment.scale(by: maxFactor)
        //since both variables are scaled by `maxFactor` it would be wrong to use the annotated types, rather we need to compute the scaled type from the inferred type
        //note: if the `maxFactor` is equal to the factor of the component, the scaled type will match the annotated type
        //TODO: there is no real need to scale everything
        // but rather only those parts that are affected by the assignment
        try environment.addToCurrentContext(id1, type: .tType(type1.coreType, type1.replicationCount * maxFactor))
        try environment.addToCurrentContext(id2, type: .tType(type2.coreType, type2.replicationCount * maxFactor))
        
    case let .sCase(cond, ifStms, elseStms):
        environment.pushContext()
        
        let condType = try inferType(cond.exp)
        guard case let .cTSum(lType, rType) = condType.coreType else {
            throw TypeCheckerError.conditionFailed(stm: stm, actual: condType)
        }
        var unwrappedType: Type
        switch cond {
        case .ifCaseLeft:
            unwrappedType = lType
        case .ifCaseRight:
            unwrappedType = rType
        }
        try checkIfIdMaybeTyped(cond.idMaybeTyped, matchesType: unwrappedType, inStm: stm)
        if let type = cond.idMaybeTyped.type {
            let differingFactor = type.replicationCount / unwrappedType.replicationCount
            //TODO: there is no real need to scale everything
            // but rather only those parts that are affected by the assignment
            try environment.scale(by: differingFactor)
            unwrappedType = type
        }
        try environment.addToCurrentContext(cond.idMaybeTyped.id, type: unwrappedType)
        
        try ifStms.forEach { try checkStm($0, expectedReturnType: expectedReturnType) }
        environment.popContext()
        
        environment.pushContext()
        try elseStms.forEach { try checkStm($0, expectedReturnType: expectedReturnType) }
        environment.popContext()
        
    case let .sReturn(exp):
        let expType = try inferType(exp)
        guard expType.isSubtype(of: expectedReturnType) else {
            throw TypeCheckerError.invalidReturnType(actual: expType, expected: expectedReturnType)
        }
        //if the expression is exponential and the return type is a subtype of it, it must be exponential too, so no need to scale
        if expType.replicationCount < Double.infinity {
            let differingFactor = expectedReturnType.replicationCount / expType.replicationCount
            //TODO: there is no real need to scale everything
            // but rather only those parts that are affected by the assignment
            try environment.scale(by: differingFactor)
        }
        
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

private func inferType(_ exp: Exp) throws -> Type {
    switch exp {
    case .eInt:
        return .tType(.cTBase(.int), 1)
    case .eUnit:
        return .tType(.cTBase(.unit), 1)
    case let .eId(id):
        let type = try environment.lookup(id)
        let returnType = Type.tType(type.coreType, 1)
        try environment.updateUsageCount(for: id, delta: 1)
        return returnType
    case let .ePair(e1, e2):
        let type1 = try inferType(e1)
        let type2 = try inferType(e2)
        return .tType(.cTMulPair(type1, type2), 1)
    case let .eApp(id, exps):
        guard id != addNoiseId else {
            return try handleAddNoise(exps)
        }
        let (args, returnType) = try environment.lookupFunction(id)
        let expTypes = try exps.map { try inferType($0) }
        //TODO: if expTypes[i].isSubtype(type[i]) -> scale by differing factor but this requires scaling to work only on the values that are involved
        guard args == expTypes else {
            throw TypeCheckerError.functionApplicationFailed(exp: exp, argsActual: expTypes, argsExpected: args)
        }
        return returnType
    case let .eTyped(_, type):
        //TODO: for now this is accepted to get types where inferencing does not work yet but should be removed as soon as possible
        return type
    }
}

private func handleAddNoise(_ exps: [Exp]) throws -> Type {
    guard exps.count == 1 else {
        throw TypeCheckerError.addNoiseFailed(message: "the add_noise construct requires exactly one argument but was provided \(exps.count)\nnamely \(exps)")
    }
    let exp = exps.first!
    let expType = try inferType(exp)
    let allowedBaseTypes: [BaseType] = [.int]
    guard case let .cTBase(baseType) = expType.coreType, allowedBaseTypes.contains(baseType) else {
        throw TypeCheckerError.addNoiseFailed(message: "invalid type for adding noise to\ntype: \(expType)\nin expression: \(exp)")
    }
    guard expType.replicationCount < Double.infinity else {
        throw TypeCheckerError.addNoiseFailed(message: "adding noise to an exponential type would result in an unusable result and is therefore forbidden")
    }
    return .tTypeExponential(expType.coreType)
}

private func checkAssertion(_ assertion: Assertion) throws {
    switch assertion {
    case let .aTypeEqual(id, type):
        let idType = try environment.lookup(id)
        let usageCount = try environment.lookupUsageCount(id)
        let updatedType = Type.tType(idType.coreType, idType.replicationCount - usageCount)
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
        case let .conditionFailed(stm: stm, actual: actual):
            return "condition must have an expression of sum type" + "\n" +
            "statement: " + stm.show() + "\n" +
            "actual: \(actual)"
        case let .functionApplicationFailed(exp: exp, argsActual: actual, argsExpected: expected):
            return "invalid arguments to function in expression" + "\n" +
            "expression: " + exp.show() + "\n" +
                "expected: (\(expected.reduce("", {$0 + ($0.isEmpty ? "" : ", ") + $1.description })))\n" +
            "actual: (\(actual.reduce("", {$0 + ($0.isEmpty ? "" : ", ") + $1.description })))"
        case let .assertionFailed(message):
            return message
        case let.addNoiseFailed(message: message):
            return message
        case let .other(message):
            return message
        }
    }
}
