//
//  DPTypeCheckerTests.swift
//  DPTypeCheckerTests
//
//  Created by Jan Wittler on 13.06.17.
//  Copyright © 2017 Jan Wittler. All rights reserved.
//

import XCTest

class DPTypeCheckerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testBasicTyping() {
        /*
         let x: Int!1 = 10
         let y = 20
         assertType(x, Int!1)
         assertType(y, Int!inf)
        */
        let explicitType = Type.tType(.iTBase(.int), 1)
        let explicitTypeAssignStatement = Stm.sInitExplicitType(Id("x"), explicitType, .eInt(10))
        let implicitTypeAssignStatement = Stm.sInit(Id("y"), .eInt(20))
        let explicitTypeAssert = Assertion.aTypeEqual(Id("x"), explicitType)
        let implicitTypeAssert = Assertion.aTypeEqual(Id("y"), .tType(.iTBase(.int), Double.infinity))
        let program = Program.pDefs([explicitTypeAssignStatement,
                                     implicitTypeAssignStatement,
                                     Stm.sAssert(explicitTypeAssert),
                                     Stm.sAssert(implicitTypeAssert)])
        
        XCTAssertNoThrow(try typeCheck(program), "type check for basic typing failed")
    }
    
    func testExample4() {
        guard let path = path(forResource: "Example4", ofType: "dpp") else {
            XCTFail("file for example 4 not found")
            return
        }
        guard let example4 = parseFile(at: path) else {
            XCTFail("failed to parse example 4")
            return
        }
        XCTAssertNoThrow(try typeCheck(example4), "type check of example 4 failed")
    }
    
    func path(forResource resource: String?, ofType type: String?) -> String? {
        return Bundle(for: type(of: self)).path(forResource: resource, ofType: type)
    }
}
