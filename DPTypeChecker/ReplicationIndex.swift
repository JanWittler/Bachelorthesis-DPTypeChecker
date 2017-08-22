//
//  ReplicationIndex.swift
//  DPTypeChecker
//
//  Created by Jan Wittler on 16.08.17.
//  Copyright © 2017 Jan Wittler. All rights reserved.
//

import Foundation

/**
 A wrapper for the Swift type `Decimal` that represents numbers in base-10 format and allows specifying the rounding mode when imprecisions are met. The wrapper is required to prevent from accidentally performing any arithmetic operation without specifying the rounding mode. Controlling the rounding behavior is required to prevent from security breaches due to wrong rounding.
 */
public struct ReplicationIndex {
    /// The available rounding modes which are a subset of `Decimal.RoundingMode`.
    enum RoundingMode {
        /// Round up on imprecision.
        case up
        /// Round up on imprecision.
        case down
        
        /// The rounding mode that should be used whenever dealing with usage counts.
        static var forUsageCount: RoundingMode = .up
        /// The rounding mode that should be used whenever construction a type's replication index.
        static var forTypeConstruction: RoundingMode = .down
        
        /// A convenience accessor for the `NSDecimalNumberBehaviors` that should be used for any computations with the current rounding mode. Note that the behavior by default raises an error on overflow, underflow or division by zero.
        fileprivate func decimalBehavior() -> NSDecimalNumberBehaviors {
            let roundingMode: Decimal.RoundingMode
            switch self {
            case .up:
                roundingMode = .up
            case .down:
                roundingMode = .down
            }
            return NSDecimalNumberHandler(roundingMode: roundingMode, scale: Int16(NSDecimalNoScale), raiseOnExactness: false, raiseOnOverflow: true, raiseOnUnderflow: true, raiseOnDivideByZero: true)
        }
    }
    
    // `NSDecimalNumber` is used internally instead of Swift type `Decimal` to have easier handling with the arithmetic operations.
    fileprivate var value: NSDecimalNumber
    
    /**
     Creates an instance initialized to the specified `Decimal` value.
     - parameters:
       - value: The value to store.
     */
    init(_ value: Decimal) {
        self.value = value as NSDecimalNumber
    }
    
    /**
     Creates an instance initialized to the specified `Double` value.
     - parameters:
       - value: The value to store.
     */
    init(_ value: Double) {
        self.value = NSDecimalNumber(value: value)
    }
    
    /**
     Creates an instance initialized to the specified integer value.
     - parameters:
       - value: The value to store.
     */
    init(_ value: Int) {
        self.value = NSDecimalNumber(value: value)
    }
    
    /// The `ReplicationIndex` instance that represents the value _infinity_.
    static var infinity: ReplicationIndex {
        /// using Double.infinity does not work, it gives an `NSDecimalNumber` with `isInfinite = false`.
        return ReplicationIndex(Decimal.nan)
    }
    
    /**
     Adds `other` to the receiver and returns the sum, a newly created `ReplicationIndex` instance. `roundingMode` specifies the handling of rounding. Raises an error on value overflow or underflow.
     - parameters:
       - other: The value to add.
       - roundingMode: Specifies the handling of rounding.
     - returns: A newly created `ReplicationIndex` instance that stores the sum of the two instances.
     */
    func adding(_ other: ReplicationIndex, withRoundingMode roundingMode: ReplicationIndex.RoundingMode) -> ReplicationIndex {
        if self == .infinity || other == .infinity {
            return .infinity
        }
        let result = value.adding(other.value, withBehavior: roundingMode.decimalBehavior())
        return ReplicationIndex(result as Decimal)
    }
    
    /**
     Subtracts `other` from the receiver and returns the difference, a newly created `ReplicationIndex` instance. `roundingMode` specifies the handling of rounding. Raises an error on value overflow or underflow.
     - parameters:
     - other: The value to subtract.
     - roundingMode: Specifies the handling of rounding.
     - returns: A newly created `ReplicationIndex` instance that stores the difference of the two instances.
     */
    func subtracting(_ other: ReplicationIndex, withRoundingMode roundingMode: ReplicationIndex.RoundingMode) -> ReplicationIndex {
        if self == .infinity && other != .infinity {
            return .infinity
        }
        let result = value.subtracting(other.value, withBehavior: roundingMode.decimalBehavior())
        return ReplicationIndex(result as Decimal)
    }
    
    /**
     Multiplies the receiver by `other` and returns the product, a newly created `ReplicationIndex` instance. `roundingMode` specifies the handling of rounding. Raises an error on value overflow or underflow.
     - parameters:
     - other: The value to multiply by.
     - roundingMode: Specifies the handling of rounding.
     - returns: A newly created `ReplicationIndex` instance that stores the product of the two instances.
     */
    func multiplying(by other: ReplicationIndex, withRoundingMode roundingMode: ReplicationIndex.RoundingMode) -> ReplicationIndex {
        if (self == .infinity && other != 0) || (other == .infinity && other != 0) {
            return .infinity
        }
        let result = value.multiplying(by: other.value, withBehavior: roundingMode.decimalBehavior())
        return ReplicationIndex(result as Decimal)
    }
    
    /**
     Divides the received by `other` and returns the quotient, a newly created `ReplicationIndex` instance. `roundingMode` specifies the handling of rounding. Raises an error on value overflow, underflow or a division by zero.
     - parameters:
     - other: The value to divide by.
     - roundingMode: Specifies the handling of rounding.
     - returns: A newly created `ReplicationIndex` instance that stores the quotient of the two instances.
     */
    func dividing(by other: ReplicationIndex, withRoundingMode roundingMode: ReplicationIndex.RoundingMode) -> ReplicationIndex {
        if self == .infinity && other > 0 {
            return .infinity
        }
        let result = value.dividing(by: other.value, withBehavior: roundingMode.decimalBehavior())
        return ReplicationIndex(result as Decimal)
    }
    
    static prefix func -(_ x: ReplicationIndex) -> ReplicationIndex {
        var copy = x.value as Decimal
        copy.negate()
        return ReplicationIndex(copy)
    }
    
    /// Returns whether the receiver stores a finite value.
    var isFinite: Bool {
        return self != .infinity
    }
    
    /// Returns whether the receiver stores an infinite value.
    var isInfinite: Bool {
        return self == .infinity
    }
}

func abs(_ x: ReplicationIndex) -> ReplicationIndex {
    return (x.value as Decimal).sign == .plus ? x : -x
}

extension ReplicationIndex: ExpressibleByIntegerLiteral {
    public typealias IntegerLiteralType = Decimal.IntegerLiteralType
    
    public init(integerLiteral: IntegerLiteralType) {
        self.value = NSDecimalNumber(integerLiteral: integerLiteral)
    }
}

extension ReplicationIndex: ExpressibleByFloatLiteral {
    public typealias FloatLiteralType = Decimal.FloatLiteralType
    
    public init(floatLiteral: FloatLiteralType) {
        self.value = NSDecimalNumber(floatLiteral: floatLiteral)
    }
}

extension ReplicationIndex: Equatable {
    public static func ==(lhs: ReplicationIndex, rhs: ReplicationIndex) -> Bool {
        return lhs.value.compare(rhs.value) == .orderedSame
    }
}

extension ReplicationIndex: Comparable {
    public static func <(lhs: ReplicationIndex, rhs: ReplicationIndex) -> Bool {
        return lhs != .infinity && (rhs == .infinity ||  lhs.value.compare(rhs.value) == .orderedAscending)
    }
}

extension ReplicationIndex: Hashable {
    public var hashValue: Int { return value.hashValue }
}

extension ReplicationIndex: CustomStringConvertible {
    public var description: String { return self == .infinity ? "inf" : value.description }
}
