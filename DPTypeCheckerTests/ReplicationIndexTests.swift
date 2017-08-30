//
//  ReplicationIndexTests.swift
//  DPTypeChecker
//
//  Created by Jan Wittler on 16.08.17.
//  Copyright © 2017 Jan Wittler. All rights reserved.
//

import XCTest

/**
 A class to test the behavior of the `ReplicationIndex` structure on arithmetic operations.
 */
class ReplicationIndexTests: XCTestCase {
    let a: ReplicationIndex = 10
    let b: ReplicationIndex = 5
    
    func testAddition() {
        XCTAssertEqual(a.adding(b, withRoundingMode: .down), 15)
        XCTAssertEqual(a.adding(.infinity, withRoundingMode: .down), .infinity)
        XCTAssertEqual(ReplicationIndex.infinity.adding(b, withRoundingMode: .down), .infinity)
        XCTAssertEqual(ReplicationIndex.infinity.adding(.infinity, withRoundingMode: .down), .infinity)
    }
    
    func testSubtraction() {
        XCTAssertEqual(a.subtracting(b, withRoundingMode: .up), 5)
        XCTAssertEqual(ReplicationIndex.infinity.subtracting(a, withRoundingMode: .down), .infinity)
        //c - inf would give negative infinity but this is not defined as it is not required
        //inf - inf not defined
    }
    
    func testMultiplication() {
        XCTAssertEqual(a.multiplying(by: b, withRoundingMode: .down), 50)
        XCTAssertEqual(a.multiplying(by: .infinity, withRoundingMode: .down), .infinity)
        XCTAssertEqual(ReplicationIndex.infinity.multiplying(by: b, withRoundingMode: .down), .infinity)
        XCTAssertEqual(ReplicationIndex.infinity.multiplying(by: .infinity, withRoundingMode: .down), .infinity)
    }
    
    func testDivision() {
        XCTAssertEqual(a.dividing(by: b, withRoundingMode: .up), 2)
        XCTAssertEqual(ReplicationIndex.infinity.dividing(by: a, withRoundingMode: .down), .infinity)
        //c / inf not defined
        //inf / inf not defined
    }
    
    func testEquality() {
        XCTAssertTrue(a == a)
        XCTAssertFalse(a == b)
        XCTAssertTrue(ReplicationIndex.infinity == .infinity)
        XCTAssertFalse(ReplicationIndex.infinity == a)
        XCTAssertFalse(b == ReplicationIndex.infinity)
    }
    
    func testComparison() {
        XCTAssertTrue(a > b)
        XCTAssertFalse(b >= a)
        XCTAssertTrue(a < .infinity)
        XCTAssertTrue(.infinity >= b)
        
        XCTAssertTrue(ReplicationIndex.infinity >= .infinity)
        XCTAssertTrue(ReplicationIndex.infinity <= .infinity)
        XCTAssertFalse(ReplicationIndex.infinity > .infinity)
        XCTAssertFalse(ReplicationIndex.infinity < .infinity)
    }
    
    func testOthers() {
        // negation
        let negA = -a
        let negB = -b
        XCTAssertEqual(negA, -10)
        XCTAssertEqual(negB, -5)
        
        //absolute value
        XCTAssertEqual(abs(negA), a)
        XCTAssertEqual(abs(negB), -negB)
    }
}
