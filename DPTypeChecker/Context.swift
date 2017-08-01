//
//  Context.swift
//  DPTypeChecker
//
//  Created by Jan Wittler on 01.08.17.
//  Copyright © 2017 Jan Wittler. All rights reserved.
//

import Foundation

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
