//
//  TypeChecker.swift
//  DPTypeChecker
//
//  Created by Jan Wittler on 08.06.17.
//  Copyright © 2017 Jan Wittler. All rights reserved.
//

import Foundation

enum TypeCheckerError: Error {
    case variableAlreadyExists(Id)
    case variableNotFound(Id)
    case invalidVariableAccess(Id)
    case assignmentFailed(stm: Stm, actual: Type, expected: Type)
    case missingReturn(function: Id)
    case invalidReturnType(actual: Type, expected: Type)
    case splitFailed(stm: Stm, actual: Type)
    case assertionFailed(String)
    case other(String)
}

private struct Environment {
    //there is always the global context
    var contexts : [Context] = []
    var currentContext: Context! {
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
    
    subscript(_ id: Id) -> Type? {
        return values[id]?.0
    }
    
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
        try defs.forEach { try checkDef($0) }
    }
}

private func checkDef(_ def: Def) throws {
    switch def {
    case let .dFun(id, args, returnType, stms):
        environment.pushContext()
        guard containsReturnStatement(stms) else {
            throw TypeCheckerError.missingReturn(function: id)
        }
        try addArgsToEnvironment(args)
        try stms.forEach { try checkStm($0, expectedReturnType: returnType) }
        environment.popContext()
    }
}

private func addArgsToEnvironment(_ args: [Arg]) throws {
    try args.forEach { arg in
        switch arg {
        case let .aDecl(id, type):
            try environment.currentContext.add(id, type: type)
        }
    }
}

private func containsReturnStatement(_ stms: [Stm]) -> Bool {
    return stms.reduce(false, { result, stm -> Bool in
        let isReturn: Bool
        switch stm {
        case .sReturn(_):
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
        if let type = idMaybeTyped.type {
            guard expType.isSubtype(of: type) else {
                throw TypeCheckerError.assignmentFailed(stm: stm, actual: expType, expected: type)
            }
            let differingFactor = type.replicationCount / expType.replicationCount
            //TODO: there is no real need to scale everything
            // but rather only those parts that are affected by the assignment
            try environment.scale(by: differingFactor)
        }
        try environment.currentContext.add(idMaybeTyped.id, type: varType)
    case let .sSplit(idMaybeTyped1, idMaybeTyped2, exp):
        let expType = try inferType(exp)
        guard case let .cTMulPair(type1, type2) = expType.coreType else {
            throw TypeCheckerError.splitFailed(stm: stm, actual: expType)
        }
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
        try environment.currentContext.add(id1, type: .tType(type1.coreType, type1.replicationCount * maxFactor))
        try environment.currentContext.add(id2, type: .tType(type2.coreType, type2.replicationCount * maxFactor))
    case let .sReturn(exp):
        let expType = try inferType(exp)
        guard expType.isSubtype(of: expectedReturnType) else {
            throw TypeCheckerError.invalidReturnType(actual: expType, expected: expectedReturnType)
        }
        let differingFactor = expectedReturnType.replicationCount / expType.replicationCount
        //TODO: there is no real need to scale everything
        // but rather only those parts that are affected by the assignment
        try environment.scale(by: differingFactor)
    case let .sAssert(assertion):
        try checkAssertion(assertion)
    }
}

private func inferType(_ exp: Exp) throws -> Type {
    switch exp {
    case .eInt(_):
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
    case let .eTyped(_, type):
        //TODO: for now this is accepted to get types where inferencing does not work yet but should be removed as soon as possible
        return type
    }
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
    var description: String {
        switch self {
        case let .variableAlreadyExists(id):
            return "variable `\(id.value)` already exists in context"
        case let .variableNotFound(id):
            return "variable `\(id.value)` not found in context"
        case let .invalidVariableAccess(id):
            return "access to variable `\(id.value)` led to replication count less than zero"
        case let .assignmentFailed(stm, actual, expected):
            return "assignment failed in statement" + "\n" +
            "expression: " + stm.show() + "\n" +
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
            "expression: " + stm.show() + "\n" +
            "expected: pair type\n" +
            "actual: \(actual)"
        case let .assertionFailed(message):
            return message
        case let .other(message):
            return message
        }
    }
}
