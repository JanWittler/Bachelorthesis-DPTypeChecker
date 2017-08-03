//
//  DPTypeCheckerTests.swift
//  DPTypeCheckerTests
//
//  Created by Jan Wittler on 13.06.17.
//  Copyright © 2017 Jan Wittler. All rights reserved.
//

import XCTest

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
    
//MARK: helper methods
    
    private func testFiles(_ files: [String]) {
        files.forEach { testFile($0) }
    }
    
    private func testFile(_ file: String) {
        guard let path = path(forResource: file, ofType: nil) else {
            XCTFail("file for \(file) not found")
            return
        }
        guard let tree = parseFile(at: path) else {
            XCTFail("failed to parse \(file)")
            return
        }
        XCTAssertNoThrow(try typeCheck(tree), "type check of \(file) failed")
    }
    
    private func path(forResource resource: String?, ofType type: String?) -> String? {
        return Bundle(for: type(of: self)).path(forResource: resource, ofType: type)
    }
}
