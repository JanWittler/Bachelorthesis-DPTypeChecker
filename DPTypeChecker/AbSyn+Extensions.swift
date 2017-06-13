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
        case .tTypeInf(_):
            return Double.infinity
        }
    }
    
    var internalType: InternalType {
        switch self {
        case let .tType(iType, _):
            return iType
        case let .tTypeConvenienceInt(iType, _):
            return iType
        case let .tTypeInf(iType):
            return iType
        }
    }
}

//MARK: subtyping

extension Type {
    func isSubtype(of other: Type) -> Bool {
        //if the own count is larger than the compared count, we can alwas return `false`, no matter of the internal types
        guard replicationCount <= other.replicationCount else {
            return false
        }
        switch (self.internalType, other.internalType) {
        case (let .iTBase(bType1), let .iTBase(bType2)):
            return bType1 == bType2
        case (let .iTMulPair(pair1), let .iTMulPair(pair2)):
            return pair1.0.isSubtype(of:pair2.0) && pair1.1.isSubtype(of:pair2.1)
        default:
            return false
        }
    }
}

//MARK: equatable extensions

extension Type: Equatable {
    public static func ==(lhs: Type, rhs: Type) -> Bool {
        return lhs.replicationCount == rhs.replicationCount && lhs.internalType == rhs.internalType
    }
}

extension InternalType: Equatable {
    public static func ==(lhs: InternalType, rhs: InternalType) -> Bool {
        switch (lhs, rhs) {
        case (let .iTBase(bType1), let .iTBase(bType2)) where bType1 == bType2:
            return true
        case (let .iTMulPair(pair1), let .iTMulPair(pair2)) where pair1 == pair2:
            return true
        default:
            return false
        }
    }
}

//MARK: Type printing

extension Type: CustomStringConvertible {
    public var description: String {
        return "Type(\(internalDescription))"
    }
    
    fileprivate var internalDescription: String {
        let countString = replicationCount.remainder(dividingBy: 1) == 0 ? String(format: "%.0f", replicationCount) : "\(replicationCount)"
        return "\(internalType)!\(countString)"
    }
}

extension InternalType: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .iTBase(bType):
            return bType.description
        case let .iTMulPair(t1, t2):
            return "(\(t1.internalDescription), \(t2.internalDescription))"
        }
    }
}

extension BaseType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .int:
            return "Int"
        }
    }
}
