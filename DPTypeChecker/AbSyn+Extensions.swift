//
//  AbSyn+Extensions.swift
//  DPTypeChecker
//
//  Created by Jan Wittler on 08.06.17.
//  Copyright © 2017 Jan Wittler. All rights reserved.
//

import Foundation

//MARK: custom accessors

extension Type {
    var replicationCount: Double {
        switch self {
        case let .tType(_, rCount):
            return rCount
        case let .tTypeConvenienceInt(_ ,rCount):
            return Double(rCount)
        case .tTypeExponential(_):
            return Double.infinity
        case .tTypeUnknown:
            return 0
        }
    }
    
    var coreType: CoreType {
        let coreType: CoreType
        switch self {
        case let .tType(cType, _):
            coreType = cType
        case let .tTypeConvenienceInt(cType, _):
            coreType = cType
        case let .tTypeExponential(cType):
            coreType = cType
        case .tTypeUnknown:
            return .cTUnknown
        }
        return coreType
    }
}

extension IdMaybeTyped {
    var id: Id {
        switch self {
        case let .idNotTyped(id):
            return id
        case let.idTyped(id, _):
            return id
        }
    }
    
    var type: Type? {
        switch self {
        case .idNotTyped:
            return nil
        case let .idTyped(_, type):
            return type
        }
    }
}

extension Arg {
    var id: Id {
        switch self {
        case let .aDecl(id, _):
            return id
        }
    }
    
    var type: Type {
        switch self {
        case let .aDecl(_, type):
            return type
        }
    }
}

extension Else {
    var stms: [Stm]? {
        switch self {
        case .elseNone:
            return nil
        case let .elseStms(stms):
            return stms
        }
    }
}

extension Generics {
    var annotatedType: Type? {
        switch self {
        case .genericsNone:
            return nil
        case let .genericsType(type):
            return type
        }
    }
}

extension Case {
    /**
     Returns the unwrapped type from the given type based on the case value.
     - parameters:
       - type: The type to unwrap. The core type of this type must be a sum type, otherwise an error is thrown.
       - environment: The environment in which the type was created. Required to enable unwrapping of named types.
     - returns: The unwrapped type based on the case value.
     - throws: Throws a `TypeCheckerError.caseApplicationFailed` error if the given type cannot be unwrapped because its core type is not a sum type.
     */
    func unwrappedType(from type: Type, inEnvironment environment: Environment) throws -> Type {
        guard case let .cTSum(lType, rType) = type.coreType else {
            if case let .cTNamed(id, generics) = type.coreType {
                do {
                    var type = Type.tType(try environment.typeDefinitionOfCoreType(with: id), type.replicationCount)
                    if let annotatedType = generics.annotatedType {
                        type = type.replaceAllGenericTypes(with: annotatedType)
                    }
                    return try unwrappedType(from: type, inEnvironment: environment)
                }
                //don't throw type not found exception but rather case application failed exception
                catch {}
            }
            throw TypeCheckerError.caseApplicationFailed(case: self, actual: type)
        }
        
        switch self {
        case .inl:
            return lType
        case .inr:
            return rType
        }
    }
}

//MARK:- subtyping

extension Type {
    /**
     Checks whether `self` is a subtype of the given type. A type is a subtype of another if the replication count is less or equal to the other replication count, the core types match and their respective types are subtypes of their matching counterpart too. A type is always subtype of itself.
     - parameters:
       - other: The supertype to check for.
     - returns: `true` if `self` is a subtype of `other`, otherwise `false`.
     */
    func isSubtype(of other: Type) -> Bool {
        //if the own count is larger than the compared count, we can alwas return `false`, no matter of the internal types
        guard replicationCount <= other.replicationCount else {
            return false
        }
        switch (self.coreType, other.coreType) {
        case (let .cTBase(bType1), let .cTBase(bType2)):
            return bType1 == bType2
        case (let .cTMulPair(pair1), let .cTMulPair(pair2)):
            return pair1.0.isSubtype(of: pair2.0) && pair1.1.isSubtype(of: pair2.1)
        case (let .cTSum(sum1), let .cTSum(sum2)):
            return sum1.0.isSubtype(of: sum2.0) && sum1.1.isSubtype(of: sum2.1)
        case (let .cTList(elem1), let .cTList(elem2)):
            return elem1.isSubtype(of: elem2)
        case (let .cTFunction(a1, r1), let .cTFunction(a2, r2)):
            //arguments have inversed subtype requirements
            return r1.isSubtype(of: r2) && a1.count == a2.count && zip(a1, a2).reduce(true) { $0 && $1.1.isSubtype(of: $1.0) }
        case (.cTUnknown, .cTUnknown):
            return true
        case (let .cTNamed(id1, generics1), let .cTNamed(id2, generics2)) where id1 == id2:
            if let aType1 = generics1.annotatedType {
                if let aType2 = generics2.annotatedType {
                    return aType1.isSubtype(of: aType2)
                }
            }
            else if generics2.annotatedType == nil {
                return true
            }
            return false
        default:
            return false
        }
    }
    
    /**
     Returns the scaling factor that is required to match the current type with the given type. The returned factor is never less than `1`. If the two types do not match, `nil` is returned.
     - Note: Unknown types contained in `self` are treated as if they would match their counterpart in `requiredType`. Thus after applying the scaling, `self` should not be used furthermore but rather the `requiredType` variable.
     - parameters:
       - requiredType: The type that `self` should be scaled up to match.
     - returns: Returns the scaling factor to apply to match `self` with `requiredType`. The minimal returned value is `1`. Returns `nil` if the two types do not match.
     */
    func scalingFactorToConvertToType(_ requiredType: Type) -> Double? {
        if requiredType.isSubtype(of: self) {
            return 1
        }
        else if coreType == requiredType.coreType {
            return max(1, requiredType.replicationCount / replicationCount)
        }
        //check if `self` contains an unknown type which can be converted to match `requiredType`
        else if canBeConverted(to: requiredType) {
            return Type.tType(requiredType.coreType, replicationCount).scalingFactorToConvertToType(requiredType)
        }
        return nil
    }
}

//MARK:- generic types

extension Type {
    /**
     Checks whether the current type can be converted to the given type using scaling and by replacing unknown types with their corresponding types in the required type.
     - parameters:
       - requiredType: The type to try to convert to.
     - returns: Returns `true` if the current type can be converted to the given type, otherwise `false`.
     */
    fileprivate func canBeConverted(to requiredType: Type) -> Bool {
        //use recursion on an internal closure to be able to do not check replication count only in first recursion. This is allowed because topmost replication count can be adjusted using scaling
        var internalCanBeConverted: ((Type, Type, Bool) -> Bool)!
        internalCanBeConverted = {
            //if own type is unknown it can become any type
            if $0 == .tTypeUnknown {
                return true
            }
            
            //either first stage where replication count can be ignored or `type`'s replication count is greater than `requiredType`'s replication count thus it can be subtyped to `requiredType`
            guard $2 || $0.replicationCount >= $1.replicationCount else {
                return false
            }
            
            switch ($0.coreType, $1.coreType) {
            case (let .cTBase(bType1), let .cTBase(bType2)):
                return bType1 == bType2
            case (let .cTMulPair(pair1), let .cTMulPair(pair2)):
                return internalCanBeConverted(pair1.0, pair2.0, false) && internalCanBeConverted(pair1.1, pair2.1, false)
            case (let .cTSum(sum1), let .cTSum(sum2)):
                return internalCanBeConverted(sum1.0, sum2.0, false) && internalCanBeConverted(sum1.1, sum2.1, false)
            case (let .cTList(elem1), let .cTList(elem2)):
                return internalCanBeConverted(elem1, elem2, false)
            case (let .cTNamed(id1, generics1), let .cTNamed(id2, generics2)) where id1 == id2:
                //either both with or without annotated type
                if let aType1 = generics1.annotatedType {
                    if let aType2 = generics2.annotatedType {
                        return internalCanBeConverted(aType1, aType2, false)
                    }
                }
                else if generics2.annotatedType == nil {
                    return true
                }
                return false
            case (.cTFunction, .cTFunction):
                //since functions cannot have unknown generic constraints, we can simply use the subtype method
                return $1.isSubtype(of: $0)
            //case .cTUnknown already handled by comparison to unknown type before
            default:
                return $1.isSubtype(of: $0)
            }
        }
        
        return internalCanBeConverted(self, requiredType, true)
    }
    
    /**
     Returns a copy of the current type where all generic types are replaced by the given type. If the current type does not contain any generic type, a copy of the current type itself is returned.
     - parameters:
       - type: The type to replace generic types with.
     - returns: Returns a type where all generic types are replaced by the given type. If the type does not contain any generic type, a copy of the type itself is returned.
    */
    func replaceAllGenericTypes(with type: Type) -> Type {
        let newCoreType: CoreType
        switch self.coreType {
        case .cTBase:
            newCoreType = coreType
        case let .cTMulPair(type1, type2):
            newCoreType = .cTMulPair(type1.replaceAllGenericTypes(with: type), type2.replaceAllGenericTypes(with: type))
        case let .cTSum(type1, type2):
            newCoreType = .cTSum(type1.replaceAllGenericTypes(with: type), type2.replaceAllGenericTypes(with: type))
        case let .cTList(elemType):
            newCoreType = .cTList(elemType.replaceAllGenericTypes(with: type))
        case let .cTFunction(argTypes, returnType):
            newCoreType = .cTFunction(argTypes.map { $0.replaceAllGenericTypes(with: type) }, returnType.replaceAllGenericTypes(with: type))
        case let .cTNamed(id, generics):
            if let annotatedType = generics.annotatedType {
                newCoreType = .cTNamed(id, .genericsType(annotatedType.replaceAllGenericTypes(with: type)))
            }
            else {
                newCoreType = coreType
            }
        case .cTUnknown:
            return type
        }
        return .tType(newCoreType,replicationCount)
    }
    
    /**
     Checks if a type signature is valid in the given environment, e.g. checks that generic type annotations are present only for generic types.
     - parameters:
       - environment: The environment under which to validate the type.
     - throws: Throws a `TypeCheckerError.invalidType` error if the current type is invalid in the given environment.
     */
    func validate(inEnvironment environment: Environment) throws {
        switch self.coreType {
        case .cTBase:
            break
        case let .cTMulPair(t1, t2):
            try t1.validate(inEnvironment: environment)
            try t2.validate(inEnvironment: environment)
        case let .cTSum(t1, t2):
            try t1.validate(inEnvironment: environment)
            try t2.validate(inEnvironment: environment)
        case let .cTList(elem):
            try elem.validate(inEnvironment: environment)
        case let .cTFunction(argTypes, returnType):
            try argTypes.forEach { try $0.validate(inEnvironment: environment) }
            try returnType.validate(inEnvironment: environment)
        case .cTUnknown:
            break
        case let .cTNamed(id, generics):
            let coreType = try environment.coreTypeForId(id)
            if case let .cTNamed(_, actualGenerics) = coreType {
                if actualGenerics.annotatedType == nil && generics.annotatedType != nil {
                    throw TypeCheckerError.invalidType(id: id, message: "type annotations for non-generic type not allowed")
                }
                else if actualGenerics.annotatedType != nil && generics.annotatedType == nil {
                    throw TypeCheckerError.invalidType(id: id, message: "missing type annotations for generic type")
                }
            }
            else if generics.annotatedType != nil {
                throw TypeCheckerError.invalidType(id: id, message: "type annotations for non-generic type not allowed")
            }
        }
    }
}

extension CoreType {
    /**
     Returns a copy of the current core type where all generic types are replaced by the given type. If the current core type does not contain any generic type, a copy of the current core type itself is returned.
     - parameters:
     - type: The type to replace generic types with.
     - returns: Returns a core type where all generic types are replaced by the given type. If the core type does not contain any generic type, a copy of the core type itself is returned.
     */
    func replaceAllGenericTypes(with type: Type) -> CoreType {
        return Type.tTypeExponential(self).replaceAllGenericTypes(with: type).coreType
    }
}

//MARK:- opponent type

extension Type {
    /**
     Indicates if the type instance is an opponent type in the given environment. An opponent type is a type where all replication counts have value infinity.
     - parameters:
       - environment: The environment in which the type resides. Required to enable checking of named types.
     - returns: Returns `true` if the type is an opponent type in the given environment, otherwise `false`.
     */
    func isOPPType(inEnvironment environment: Environment) -> Bool {
        return replicationCount == Double.infinity && coreType.isOPPType(inEnvironment: environment)
    }
}

private extension CoreType {
    /**
     Indicates if the core type instance is an opponent type, assuming its belonging type has a replication count of infinity. All base types are opponent types by design, composed core types are opponent types if their contained types are opponent types.
     - parameters:
       - environment: The environment in which the core type resides. Required to enable checking of named types.
     - returns: Returns `true` if the core type is an opponent type in the given environment, otherwise `false`.
    */
    func isOPPType(inEnvironment environment: Environment) -> Bool {
        switch self {
        case .cTBase:
            return true
        case let .cTMulPair(type1, type2):
            return type1.isOPPType(inEnvironment: environment) && type2.isOPPType(inEnvironment: environment)
        case let .cTSum(lType, rType):
            return lType.isOPPType(inEnvironment: environment) && rType.isOPPType(inEnvironment: environment)
        case let .cTList(type):
            return type.isOPPType(inEnvironment: environment)
        case let .cTFunction(argTypes, returnType):
            return argTypes.reduce(true) { $0 && $1.isOPPType(inEnvironment: environment) } && returnType.isOPPType(inEnvironment: environment)
        case let .cTNamed(id, generics):
            do {
                let coreType = try environment.typeDefinitionOfCoreType(with: id)
                return coreType.isOPPType(inEnvironment: environment) && (generics.annotatedType?.isOPPType(inEnvironment: environment) ?? true)
            }
            catch {
                //computed getters cannot throw, thus we must return a default value
                return false
            }
        case .cTUnknown:
            return false
        }
    }
}

//MARK:- type comparison

extension Type: Equatable {
    public static func ==(lhs: Type, rhs: Type) -> Bool {
        return lhs.replicationCount == rhs.replicationCount && lhs.coreType == rhs.coreType
    }
}

extension CoreType: Equatable {
    public static func ==(lhs: CoreType, rhs: CoreType) -> Bool {
        switch (lhs, rhs) {
        case (let .cTBase(bType1), let .cTBase(bType2)) where bType1 == bType2:
            return true
        case (let .cTMulPair(pair1), let .cTMulPair(pair2)) where pair1 == pair2:
            return true
        case (let .cTSum(sum1), let .cTSum(sum2)) where sum1 == sum2:
            return true
        case (let .cTList(elem1), let .cTList(elem2)) where elem1 == elem2:
            return true
        case (let .cTFunction(a1, r1), let cTFunction(a2, r2)):
            return r1 == r2 && a1.count == a2.count && zip(a1, a2).reduce(true) { $0 && $1.0 == $1.1 }
        case (let .cTNamed(id1, generics1), let .cTNamed(id2, generics2)):
            return id1 == id2 && generics1 == generics2
        case (.cTUnknown, .cTUnknown):
            return true
        default:
            return false
        }
    }
}

extension Generics: Equatable {
    public static func ==(lhs: Generics, rhs: Generics) -> Bool {
        switch (lhs, rhs) {
        case (.genericsNone, .genericsNone):
            return true
        case (let .genericsType(t1), let .genericsType(t2)):
            return t1 == t2
        default:
            return false
        }
    }
}

//MARK:- type printing

extension Type: CustomStringConvertible {
    public var description: String {
        return "Type(\(internalDescription))"
    }
    
    fileprivate var internalDescription: String {
        let countString = replicationCount.remainder(dividingBy: 1) == 0 ? String(format: "%.0f", replicationCount) : "\(replicationCount)"
        return "\(coreType)!\(countString)"
    }
}

extension CoreType: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .cTBase(bType):
            return bType.description
        case let .cTMulPair(t1, t2):
            return "(\(t1.internalDescription) ⊗ \(t2.internalDescription))"
        case let .cTSum(lType, rType):
            return "(\(lType.internalDescription) + \(rType.internalDescription))"
        case let .cTList(type):
            return "[\(type.internalDescription)]"
        case let .cTFunction(argTypes, returnType):
            let args = argTypes.map { $0.internalDescription }.joined(separator: ", ")
            return "((\(args)) -> \(returnType.internalDescription))"
        case let .cTNamed(id, generic):
            if let type = generic.annotatedType {
                return "\(id.value)<\(type.internalDescription)>"
            }
            return "\(id.value)"
        case .cTUnknown:
            return "Unknown"
        }
    }
}

extension BaseType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .int:
            return "Int"
        case .float:
            return "Float"
        case .unit:
            return "Unit"
        }
    }
}
