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
        }
    }
    
    var internalType: InternalType {
        switch self {
        case let .tType(iType, _):
            return iType
        case let .tTypeConvenienceInt(iType, _):
            return iType
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
        default: return false
        }
    }
}

//MARK: Type printing

extension Type: CustomStringConvertible {
    var description: String {
        return "Type(\(internalDescription))"
    }
    
    fileprivate var internalDescription: String {
        let countString = replicationCount.remainder(dividingBy: 1) == 0 ? String(format: "%.0f", replicationCount) : "\(replicationCount)"
        return "\(internalType)!\(countString)"
    }
}

extension InternalType: CustomStringConvertible {
    var description: String {
        switch self {
        case let .iTBase(bType):
            return bType.description
        case let .iTMulPair(t1, t2):
            return "(\(t1.internalDescription), \(t2.internalDescription))"
        }
    }
}

extension BaseType: CustomStringConvertible {
    var description: String {
        switch self {
        case .int:
            return "Int"
        }
    }
}
