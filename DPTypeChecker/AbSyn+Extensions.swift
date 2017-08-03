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
        if case let .cTTypedef(id) = coreType {
            do {
                return try environment.lookupCoreType(id)
            }
            catch {}
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
        case .idNotTyped(_):
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

extension Case {
    /**
     Returns the unwrapped type from the given type based on the case value.
     - parameters:
       - type: The type to unwrap. The core type of this type must be a sum type, otherwise an error is thrown.
     - returns: The unwrapped type based on the case value.
     - throws: Throws a `TypeCheckerError.caseApplicationFailed` error if the given type cannot be unwrapped because its core type is not a sum type.
     */
    func unwrappedType(from type: Type) throws -> Type {
        //no need to handle .cTTypedef explicit, since it is handled in `Type.coreType` getter
        guard case let .cTSum(lType, rType) = type.coreType else {
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
        //case .cTTypedef ommitted since it is handled implicit by `Type.coreType` accessor
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
    
    /**
     Checks whether the current type can be converted to the given type using scaling and by replacing unknown types with their corresponding types in the required type.
     - parameters:
       - requiredType: The type to try to convert to.
     - returns: Returns `true` if the current type can be converted to the given type, otherwise `false`.
     */
    private func canBeConverted(to requiredType: Type) -> Bool {
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
            //case .cTFunction ommitted since functions cannot have unknown types
            //case .cTTypedef ommitted since it is handled implicit by `Type.coreType` accessor
            //unknown core type already handled by unknown type
            default:
                return $1.isSubtype(of: $0)
            }
        }

        return internalCanBeConverted(self, requiredType, true)
    }
}

//MARK:- opponent type

extension Type {
    /**
     Indicates if the type instance is an opponent type. An opponent type is a type where all replication counts have value infinity.
     */
    var isOPPType: Bool {
        return replicationCount == Double.infinity && coreType.isOPPType
    }
}

private extension CoreType {
    /**
     Indicates if the core type instance is an opponent type, assuming its belonging type has a replication count of infinity. All base types are opponent types by design, composed core types are opponent types if their contained types are opponent types.
    */
    var isOPPType: Bool {
        switch self {
        case .cTBase(_):
            return true
        case let .cTMulPair(type1, type2):
            return type1.isOPPType && type2.isOPPType
        case let .cTSum(lType, rType):
            return lType.isOPPType && rType.isOPPType
        case let .cTList(type):
            return type.isOPPType
        case let .cTFunction(argTypes, returnType):
            return argTypes.reduce(true) { $0 && $1.isOPPType } && returnType.isOPPType
        case let .cTTypedef(id):
            do {
                let coreType = try environment.lookupCoreType(id)
                return coreType.isOPPType
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
        case (let .cTTypedef(id1), _):
            do {
                let coreType = try environment.lookupCoreType(id1)
                return coreType == rhs
            }
            catch {
                //computed getters cannot throw, thus we must return a default value
                if case let .cTTypedef(id2) = rhs {
                    return id1 == id2
                }
                return false
            }
        case (_, .cTTypedef):
            //switch argument order to get handling of cTTypedef for first argument
            return rhs == lhs
        case (.cTUnknown, .cTUnknown):
            return true
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
        case let .cTTypedef(id):
            do {
                let type = try environment.lookupCoreType(id)
                return type.description
            }
            catch {
                //computed getters cannot throw, thus we must return a default value
                return "\(id.value)"
            }
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
