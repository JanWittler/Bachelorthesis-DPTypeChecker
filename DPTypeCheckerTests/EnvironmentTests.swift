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
        var delta = Environment.Delta()
        var expectedResult: [Id : Double] = [:]
        XCTAssertEqual(delta.changes, expectedResult)
        
        delta.updateUsageCount(for: Id("x"), delta: 1)
        expectedResult[Id("x")] = 1
        XCTAssertEqual(delta.changes, expectedResult)
        
        delta.updateUsageCount(for: Id("y"), delta: 2)
        expectedResult[Id("y")] = 2
        delta.updateUsageCount(for: Id("x"), delta: 3)
        expectedResult[Id("x")]! += 3
        XCTAssertEqual(delta.changes, expectedResult)
    }
    
    func testDeltaScaling() {
        var delta = Environment.Delta()
        delta.updateUsageCount(for: Id("x"), delta: 1)
        delta.updateUsageCount(for: Id("y"), delta: 5.3)
        delta.scale(by: 8)
        
        let expectedResult: [Id : Double] = [Id("x") : 1 * 8, Id("y") : 5.3 * 8]
        XCTAssertEqual(delta.changes, expectedResult)
    }
    
    func testDeltaMerging() {
        var delta1 = Environment.Delta()
        delta1.updateUsageCount(for: Id("x"), delta: 1)
        
        var delta2 = Environment.Delta()
        delta2.updateUsageCount(for: Id("x"), delta: 2)
        delta2.updateUsageCount(for: Id("y"), delta: 1)
        
        let merged = delta1.merge(with: delta2)
        let expectedResult: [Id : Double] = [Id("x") : 1 + 2, Id("y") : 1]
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
}
