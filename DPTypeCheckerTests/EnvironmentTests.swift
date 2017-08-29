//
//  EnvironmentTests.swift
//  DPTypeChecker
//
//  Created by Jan Wittler on 04.07.17.
//  Copyright © 2017 Jan Wittler. All rights reserved.
//

import XCTest

class EnvironmentTests: XCTestCase {
    func testDeltaEmpty() {
        var delta = Environment.Delta()
        XCTAssertEqual(delta.isEmpty, true)
        
        delta.updateUsageCount(for: Id("x"), delta: 1)
        XCTAssertEqual(delta.isEmpty, false)
    }
    
    func testDeltaUsageCount() {
        let x = Id("x")
        let y = Id("y")
        
        var delta = Environment.Delta()
        var expectedResult: [Id : ReplicationIndex] = [:]
        XCTAssertEqual(delta.changes, expectedResult)
        
        delta.updateUsageCount(for: x, delta: 1)
        expectedResult[x] = 1
        XCTAssertEqual(delta.changes, expectedResult)
        
        delta.updateUsageCount(for: y, delta: 2)
        expectedResult[y] = 2
        delta.updateUsageCount(for: x, delta: 3)
        expectedResult[x] = expectedResult[x]?.adding(3, withRoundingMode: .forUsageCount)
        XCTAssertEqual(delta.changes, expectedResult)
    }
    
    func testDeltaScaling() {
        var delta = Environment.Delta()
        delta.updateUsageCount(for: Id("x"), delta: 1)
        delta.updateUsageCount(for: Id("y"), delta: 5.3)
        delta.scale(by: 8)
        
        let expectedResult: [Id : ReplicationIndex] = [Id("x") : 8, Id("y") : ReplicationIndex(5.3).multiplying(by: 8, withRoundingMode: .forUsageCount)]
        XCTAssertEqual(delta.changes, expectedResult)
    }
    
    func testDeltaMerging() {
        var delta1 = Environment.Delta()
        delta1.updateUsageCount(for: Id("x"), delta: 1)
        
        var delta2 = Environment.Delta()
        delta2.updateUsageCount(for: Id("x"), delta: 2)
        delta2.updateUsageCount(for: Id("y"), delta: 1)
        
        let merged = delta1.merge(with: delta2)
        let expectedResult: [Id : ReplicationIndex] = [Id("x") : 3, Id("y") : 1]
        XCTAssertEqual(merged.changes, expectedResult)
    }
    
    func testApplyDelta() {
        var delta = Environment.Delta()
        delta.updateUsageCount(for: Id("x"), delta: 1)
        
        var environment = Environment()
        environment.pushContext()
        XCTAssertNoThrow(try environment.addToCurrentContext(Id("x"), type: .default(.base(.unit), 1)))
        
        environment.pushContext()
        XCTAssertNoThrow(try environment.addToCurrentContext(Id("x"), type: .default(.base(.unit), 2)))
        XCTAssertNoThrow(try environment.applyDelta(delta))
        XCTAssertNoThrow(try environment.applyDelta(delta))
        //increasing the usage count three times by 1 breaks the allowed access limit
        XCTAssertThrowsError(try environment.applyDelta(delta))
        
        environment.popContext()
        //if multiple variables with same name exist, the delta should only be applied to the one in the topmost stack
        //thus after poping we should be able to access `x` in the other context
        XCTAssertNoThrow(try environment.applyDelta(delta))
    }
    
    func testUsageCountAdjustments() {
        let type = Type.default(.base(.int), 100)
        var environment1 = Environment()
        environment1.pushContext()
        try! environment1.addToCurrentContext(Id("x"), type: type)
        environment1.pushContext()
        try! environment1.addToCurrentContext(Id("y"), type: type)
        environment1.pushContext()
        try! environment1.addToCurrentContext(Id("z"), type: type)
        
        var environment2 = environment1
        var environment3 = environment2
        
        var delta1 = Environment.Delta()
        delta1.updateUsageCount(for: Id("x"), delta: 1)
        delta1.updateUsageCount(for: Id("y"), delta: 5)
        delta1.updateUsageCount(for: Id("z"), delta: 10)
        try! environment1.applyDelta(delta1)
        
        var delta2 = Environment.Delta()
        delta2.updateUsageCount(for: Id("x"), delta: 4)
        delta2.updateUsageCount(for: Id("y"), delta: 3)
        delta2.updateUsageCount(for: Id("z"), delta: 12)
        try! environment2.applyDelta(delta2)
        
        var delta3 = Environment.Delta()
        delta3.updateUsageCount(for: Id("x"), delta: 4)
        delta3.updateUsageCount(for: Id("y"), delta: 2)
        delta3.updateUsageCount(for: Id("z"), delta: 12)
        try! environment3.applyDelta(delta3)
        
        environment1.adjustToTakeHigherUsageCounts(from: environment2)
        environment1.adjustToTakeHigherUsageCounts(from: environment3)
        
        environment2.adjustToTakeHigherUsageCounts(from: environment3)
        
        XCTAssertEqual(try! environment1.lookupUsageCount(Id("x")), 4)
        XCTAssertEqual(try! environment1.lookupUsageCount(Id("y")), 5)
        XCTAssertEqual(try! environment1.lookupUsageCount(Id("z")), 12)
        
        XCTAssertEqual(try! environment2.lookupUsageCount(Id("x")), 4)
        XCTAssertEqual(try! environment2.lookupUsageCount(Id("y")), 3)
        XCTAssertEqual(try! environment2.lookupUsageCount(Id("z")), 12)
        
        XCTAssertEqual(try! environment3.lookupUsageCount(Id("x")), 4)
        XCTAssertEqual(try! environment3.lookupUsageCount(Id("y")), 2)
        XCTAssertEqual(try! environment3.lookupUsageCount(Id("z")), 12)
    }
}
