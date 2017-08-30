//
//  DPTypeCheckerTests.swift
//  DPTypeCheckerTests
//
//  Created by Jan Wittler on 13.06.17.
//  Copyright © 2017 Jan Wittler. All rights reserved.
//

import XCTest

/**
 A class to test all integration tests. A test is suceeded if the file was successfully parsed and type-checked.
 - important: Due to some ocassional occuring bridging errors from C anonymous enums to Swift integer values, it may happen that a test fails at the stage of bridging the abstract syntax to Swift, even though it may pass in another run. If this behavior remains, it may help to clean the build folder using `Cmd + Alt + Shift + K` and run the tests again.
 */
class DPTypeCheckerTests: XCTestCase {
    func testCoreTypes() {
        let files = ["CoreTypes.dpp"]
        testFiles(files)
    }
    
    func testPair() {
        let files = ["Pair_0.dpp", "Pair_1.dpp"]
        testFiles(files)
    }
    
    func testSplit() {
        let files = ["Split_0.dpp", "Split_1.dpp"]
        testFiles(files)
    }
    
    func testSum() {
        let files = ["Sum_0.dpp", "Sum_1.dpp"]
        testFiles(files)
    }
    
    func testFunctionApplication() {
        let files = ["FuncApply_0.dpp", "FuncApply_1.dpp"]
        testFiles(files)
    }
    
    func testAddNoise() {
        let files = ["AddNoise_0.dpp"]
        testFiles(files)
    }
    
    func testOperators() {
        let files = ["Operators_0.dpp", "Operators_1.dpp", "Operators_2.dpp"]
        testFiles(files)
    }
    
    func testList() {
        let files = ["List_0.dpp", "List_1.dpp"]
        testFiles(files)
    }
    
    func testOptional() {
        let files = ["Optional_0.dpp"]
        testFiles(files)
    }
    
    func testRef() {
        let files = ["Ref_0.dpp"]
        testFiles(files)
    }
    
    func testExample1() {
        let files = ["Example1.dpp", "Example1+Assertions.dpp"]
        testFiles(files)
    }
    
    func testExample2() {
        testFile("Example2.dpp", isValid: false)
        testFile("Example2_Malicious.dpp")
    }
    
//MARK: helper methods
    
    private func testFiles(_ files: [String]) {
        files.forEach { testFile($0) }
    }
    
    private func testFile(_ file: String, isValid: Bool = true) {
        guard let path = path(forResource: file, ofType: nil) else {
            XCTFail("file for \(file) not found")
            return
        }
        guard let tree = parseFile(at: path) else {
            XCTFail("failed to parse \(file)")
            return
        }
        if isValid {
            XCTAssertNoThrow(try typeCheck(tree), "type check of \(file) failed")
        }
        else {
            XCTAssertThrowsError(try typeCheck(tree), "type check of \(file) succeeded but file is invalid")
        }
    }
    
    private func path(forResource resource: String?, ofType type: String?) -> String? {
        return Bundle(for: type(of: self)).path(forResource: resource, ofType: type)
    }
}
