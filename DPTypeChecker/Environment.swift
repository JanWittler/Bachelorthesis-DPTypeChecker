//
//  Environment.swift
//  DPTypeChecker
//
//  Created by Jan Wittler on 01.08.17.
//  Copyright © 2017 Jan Wittler. All rights reserved.
//

import Foundation

public let addNoiseId        = Id("add_noise")

public let boolTypeIdent     = Ident("Bool")
public let optionalTypeIdent = Ident("Optional")
public let readTypeIdent     = Ident("Read")
public let writeTypeIdent    = Ident("Write")

/**
 An `Environment`-instance reflects the current state of the type checking process. It stores all global definitions for functions and type definitions and manages `Context`-objects.
 */
internal struct Environment {    
    /// Global elements that can get managed by the environment.
    private enum GlobalElement {
        /// The `add_noise` element which is present in every environment.
        case addNoise
        /// A function element with its arguments types and return type.
        case function(args: [Type], returnType: Type)
        /// A  type defintion element with its associated core type and information if type contains generics.
        case typedef(coreType: CoreType, containsGenerics: Bool)
    }
    
//MARK:-
    
    /**
     A `Delta` stores Ids and their respective usage counts. It is used to keep track of variable accesses during type checking expressions which enables scaling to be only applied to the correct subset of variables rather than to the entire environment.
     */
    struct Delta {
        var isEmpty: Bool { return changes.isEmpty }
        private(set) var changes: [Id : ReplicationIndex] = [:]
        
        /**
         Updates the usage count for the given id by the given delta. If there was no entry for the id, the new usage count is equal to `delta`, otherwise the new usage count is the sum of the old usage count and `delta`.
         - parameters:
         - id: The id to update the usage count for.
         - delta: The change of the usage count. This value must be greater than `0`.
         */
        mutating func updateUsageCount(for id: Id, delta: ReplicationIndex) {
            precondition(delta > 0, "the given delta must be greater than zero")
            let value = changes[id] ?? 0
            changes[id] = value.adding(delta, withRoundingMode: .forUsageCount)
        }
        
        /**
         Scales all usage counts of the current delta by the given factor. The resulting usage counts for each id are the previous usage counts times the given factor.
         - parameters:
         - factor: The factor to scale by. This value must be greater or equal than `1`.
         */
        mutating func scale(by factor: ReplicationIndex) {
            precondition(factor >= 1, "scaling to lower usage count invalid")
            changes = changes.reduce([Id : ReplicationIndex]()) {
                var dict = $0
                let (key, value) = $1
                dict[key] = value.multiplying(by: factor, withRoundingMode: .forUsageCount)
                return dict
            }
        }
        
        /**
         Merges the given delta with the current one. If both deltas contain a usage count for some id, the result contains the sum of both usage counts for that id. All other usage counts are carried over without modification.
         - parameters:
           - other: The delta to merge with.
         - returns: A new `Delta`-instance containing the merged usage counts of both deltas.
         */
        func merge(with other: Delta) -> Delta {
            var new = Delta()
            new.changes = changes
            other.changes.forEach {
                new.updateUsageCount(for: $0, delta: $1)
            }
            return new
        }
    }
    
//MARK:-
    
    /**
     Represents the context of a scope in the type checking process. It stores variables with their respective type and a usage count. The usage count reflects how often the variable was accessed and must not be greater than the replication index of the variable's type.
     */
    private struct Context {
        /// The variables stored by the context, together with their type and usage count.
        private var values : [Id : (Type, ReplicationIndex)] = [:]
        
        /**
         Adds a variable with the give type and a usage count of `0` to the context.
         - parameters:
         - id: The id of the variable. This must not be already present in the context, otherwise an error is thrown.
         - type: The type of the variable. The type's replication index must be greater or equal than `0`.
         - throws: Throws a `TypeCheckerError.variableAlreadyExists` error if the variable already exists in the context. Throws a `TypeCheckerError.other` error if the type`s replication index is less than `0`.
         */
        mutating func add(_ id: Id, type: Type) throws {
            guard !values.keys.contains(id) else {
                throw TypeCheckerError.variableAlreadyExists(id)
            }
            guard type.replicationIndex >= 0 else {
                throw TypeCheckerError.other("variable `\(id.value)` must be initialized with a nonnegative replication index")
            }
            values[id] = (type, 0)
        }
        
        /**
         Increments the usage count of the given variable by `delta`. If the resulting usage count exceeds its allowed count, an error is thrown.
         - parameters:
         - id: The id of the variable whose usage count should be incremented.
         - delta: The change to the usage count. This value must be greater than `0`.
         - throws: Throws a `TypeCheckerError.variableNotFound` error if the variable is not present in the context. Throws a `TypeCheckerError.invalidVariableAccess` error if the usage count of the variable exceeds its allowed count, which is the replication index of the variables type.
         */
        mutating func updateUsageCount(for id: Id, delta: ReplicationIndex) throws {
            precondition(delta >= 0, "the usage count can't be reduced")
            
            guard let (type, count) = values[id] else {
                throw TypeCheckerError.variableNotFound(id)
            }
            let newCount = count.adding(delta, withRoundingMode: .forUsageCount)
            guard type.replicationIndex >= newCount else {
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
                if type == .unknown {
                    throw TypeCheckerError.accessToVariableWithUnknownType(id)
                }
                return type
            }
            throw TypeCheckerError.variableNotFound(id)
        }
        
        /**
         Looks up the usage count of the variable with the given id in the context. The usage count is the number of times the variable was accessed yet and must not be greater than the replication index of the variable's type.
         - parameters:
           - id: The id of the variable to search for.
         - returns: The usage count of the variable.
         - throws: Throws a `TypeCheckerError.variableNotFound` error if the variable is not found in the context.
         */
        func lookupUsageCount(_ id: Id) throws -> ReplicationIndex {
            if let type = values[id] {
                return type.1
            }
            throw TypeCheckerError.variableNotFound(id)
        }
    }

//MARK:- Environment implementation
    
    /// The global elements stored by this environment
    private var globals: [String : GlobalElement] = [
        //the `add_noise` function is present in every environment
        addNoiseId.value : .addNoise,
        //Bool = Unit!inf + Unit!inf
        boolTypeIdent.value : .typedef(coreType: .sum(.exponential(.base(.unit)), .exponential(.base(.unit))), containsGenerics: false),
        //Optional<τ> = Unit!inf + τ
        optionalTypeIdent.value : .typedef(coreType: .sum(.exponential(.base(.unit)), .unknown), containsGenerics: true),
        //Read<τ> = () -> Optional<τ>!1
        readTypeIdent.value : .typedef(coreType: .function([], .default(.named(optionalTypeIdent, .type(.unknown)), 1)), containsGenerics: true),
        //Write<τ> = τ -> Unit!inf
        writeTypeIdent.value : .typedef(coreType: .function([.unknown], .exponential(.base(.unit))), containsGenerics: true)
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
    
    /// The `Context`-objects managed by this environment.
    private var contexts : [Context] = []
    /// The current context of the environment, which is the topmost context in the `contexts` stack.
    private var currentContext: Context! {
        get {
            return contexts.last
        }
        set {
            contexts.removeLast()
            contexts.append(newValue)
        }
    }
    
    /// Pushes a new context onto the `contexts` stack.
    mutating func pushContext() {
        contexts.append(Context())
    }
    
    /// Removes the topmost context from the `contexts` stack.
    mutating func popContext() {
        contexts.removeLast()
    }
    
    /**
     Adds a function with the given argument types and the given return type to the environment's global elements.
     - parameters:
       - id: The id of the function. This must be unique among other functions and type definitions.
       - arguments: The argument types of the function.
       - returnType: The return type of the function.
     - throws: Throws a `TypeCheckerError.nameAlreadyInUse` error if the given id is already in use. Throws a `TypeCheckerError.invalidType` error if any given type is invalid.
     */
    mutating func addFunction(id: Id, arguments: [Type], returnType: Type) throws {
        try (arguments + [returnType]).forEach { try $0.validate(inEnvironment: self) }
        
        let function = GlobalElement.function(args: arguments, returnType: returnType)
        try addGlobal(function, forId: id.value)
    }
    
    /**
     Adds a type definition for a sum type to the environment's global elements.
     - parameters:
       - id: The id of the type. This must be unique among other type definitions and functions.
       - types: The two types from which the sum type is constructed.
     - throws: Throws a `TypeCheckerError.nameAlreadyInUse` error if the given id is already in use. Throws a `TypeCheckerError.invalidType` error if any given type is invalid.
     */
    mutating func addSumType(name id: Ident, types: (Type, Type)) throws {
        try [types.0, types.1].forEach { try $0.validate(inEnvironment: self) }
        
        let sumType = CoreType.sum(types.0, types.1)
        try addGlobal(.typedef(coreType: sumType, containsGenerics: false), forId: id.value)
    }
    
    /**
     Adds a variable with given id and type to the current context.
     - parameters:
       - id: The id of the type. The id must not be used for any global element or any variable in the current context yet.
       - type: The type of the variable.
     - throws: Throws a `TypeCheckerError.nameAlreadyInUse` error if the given id is already in use for a global element. Throws a `TypeCheckerError.variableAlreadyExists` error if the given id is already present in the current context.
     */
    mutating func addToCurrentContext(_ id: Id, type: Type) throws {
        try type.validate(inEnvironment: self)
        try checkIdNotGlobalUsed(id.value)
        return try currentContext.add(id, type: type)
    }
    
    /**
     Looks up the type of the variable with the given id in the `contexts` stack, starting with the topmost one. If there are multiple contexts containing a variable with the given id, the type stored in the topmost context, which contains the variable, is returned.
     - parameters:
       - id: The id of the variable to search for.
     - returns: The type of the variable.
     - throws: Throws a `TypeCheckerError.variableNotFound` error if the variable is not found in any context.
     */
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
    
    /**
     Looks up the argument types and return type of the function with the given id.
     - parameters:
       - id: The id of the function to search for.
     - returns: Returns the argument types and return type of the function.
     - throws: Throws a `TypeCheckerError.functionNotFound` error if the function could not be found.
     */
    func lookupFunction(_ id: Id) throws -> ([Type], Type) {
        guard let global = globals[id.value], case let .function(args, returnType) = global else {
            throw TypeCheckerError.functionNotFound(id)
        }
        return (args, returnType)
    }
    
    /**
     Looks up the core type of the type definition with the given id.
     - parameters:
       - id: The id of the type definition to search for.
     - returns: Returns the core type of the type definition. Does not return a `Type`-instance because type definitions are not bound to any usage count constraints.
     - throws: Throws a `TypeCheckerError.typeNotFound` error if the type definition could not be found.
     */
    func typeDefinitionOfCoreType(with id: Ident) throws -> CoreType {
        guard let global = globals[id.value], case let .typedef(coreType, _) = global else {
            throw TypeCheckerError.typeNotFound(id)
        }
        return coreType
    }
    
    /**
     Returns the core type associated with the given id. This can be used for types defined using `typedef` keyword or for predefined but not base types like `Bool` or `Optional<?>`.
     - parameters:
       - id: The id of the core type to search for.
     - returns: Returns the core type associated with the given id. Does not return a `Type`-instance because global defined types are not bound to any usage count constraints.
     - throws: Throws a `TypeCheckerError.typeNotFound` error if there was not type associated with the given id.
     */
    func coreTypeForId(_ id: Ident) throws -> CoreType {
        guard let global = globals[id.value], case let .typedef(_, containsGenerics) = global else {
            throw TypeCheckerError.typeNotFound(id)
        }
        return .named(id, containsGenerics ? .type(.unknown) : .none)
    }
    
    /**
     Looks up the usage count of the variable with the given id in the `contexts` stack, starting with the topmost one. The usage count is the number of times the variable was accessed yet and must not be greater than the replication index of the variable's type. If there are multiple contexts containing a variable with the given id, the usage count stored in the topmost context, which contains the variable, is returned.
     - parameters:
       - id: The id of the variable to search for.
     - returns: The usage count of the variable.
     - throws: Throws a `TypeCheckerError.variableNotFound` error if the variable is not found in any context.
     */
    internal func lookupUsageCount(_ id: Id) throws -> ReplicationIndex {
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
    
    /**
     Applies the given delta to the environment. Every change in the `Delta`-instance is applied to the environment by updating the usage count of the variable in the topmost context which contains that variable.
     - parameters:
       - delta: The delta to apply.
     - throws: Throws a `TypeCheckerError.variableNotFound` error if a variable in the `Delta`-instance could not be found in the environment's contexts. Throws a `TypeCheckerError.invalidVariableAccess` if the usage count for some variable after applying the delta is greater than the variable's type replication index.
     */
    mutating func applyDelta(_ delta: Delta) throws {
        try delta.changes.forEach {
            try updateUsageCount(for: $0, delta: $1)
        }
    }
    
    private mutating func updateUsageCount(for id: Id, delta: ReplicationIndex) throws {
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
