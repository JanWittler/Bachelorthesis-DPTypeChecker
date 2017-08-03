//
//  Context.swift
//  DPTypeChecker
//
//  Created by Jan Wittler on 01.08.17.
//  Copyright © 2017 Jan Wittler. All rights reserved.
//

import Foundation

/**
 Represents the context of a scope in the type checking process. It stores variables with their respective type and a usage count. The usage count reflects how often the variable was accessed and must not be greater than the replication count of the variable's type.
 */
internal struct Context {
    /// The variables stored by the context, together with their type and usage count.
    private var values : [Id : (Type, Double)] = [:]
    
    /**
     Adds a variable with the give type and a usage count of `0` to the context.
     - parameters:
       - id: The id of the variable. This must not be already present in the context, otherwise an error is thrown.
       - type: The type of the variable. The type's replication count must be greater or equal than `0`.
     - throws: Throws a `TypeCheckerError.variableAlreadyExists` error if the variable already exists in the context. Throws a `TypeCheckerError.other` error if the type`s replication count is less than `0`.
     */
    mutating func add(_ id: Id, type: Type) throws {
        guard !values.keys.contains(id) else {
            throw TypeCheckerError.variableAlreadyExists(id)
        }
        guard type.replicationCount >= 0 else {
            throw TypeCheckerError.other("variable `\(id.value)` must be initialized with a nonnegative replication count")
        }
        values[id] = (type, 0)
    }
    
    /**
     Increments the usage count of the given variable by `delta`. If the resulting usage count exceeds its allowed count, an error is thrown.
     - parameters:
       - id: The id of the variable whose usage count should be incremented.
       - delta: The change to the usage count. This value must be greater than `0`.
     - throws: Throws a `TypeCheckerError.variableNotFound` error if the variable is not present in the context. Throws a `TypeCheckerError.invalidVariableAccess` error if the usage count of the variable exceeds its allowed count, which is the replication count of the variables type.
     */
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
    
    /**
     Looks up the type of the variable with the given id in the context.
     - parameters:
       - id: The id of the variable to search for.
     - returns: The type of the variable.
     - throws: Throws a `TypeCheckerError.variableNotFound` error if the variable is not found in the context.
     */
    func lookup(_ id: Id) throws -> Type {
        if let type = values[id]?.0 {
            if type == .tTypeUnknown {
                throw TypeCheckerError.accessToVariableWithUnknownType(id)
            }
            return type
        }
        throw TypeCheckerError.variableNotFound(id)
    }
    
    /**
     Looks up the usage count of the variable with the given id in the context. The usage count is the number of times the variable was accessed yet and must not be greater than the replication count of the variable's type.
     - parameters:
       - id: The id of the variable to search for.
     - returns: The usage count of the variable.
     - throws: Throws a `TypeCheckerError.variableNotFound` error if the variable is not found in the context.
     */
    func lookupUsageCount(_ id: Id) throws -> Double {
        if let type = values[id] {
            return type.1
        }
        throw TypeCheckerError.variableNotFound(id)
    }
}
