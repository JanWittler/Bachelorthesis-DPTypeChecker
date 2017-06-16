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
        let files = ["Typing.dpp"]
        testFiles(files)
    }
    
    func testPair() {
        let files = ["Pair_0.dpp", "Pair_1.dpp"]
        testFiles(files)
    }
    
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
    
    func testSplit() {
        let files = ["Split_0.dpp", "Split_1.dpp"]
        testFiles(files)
    }
    
    private func path(forResource resource: String?, ofType type: String?) -> String? {
        return Bundle(for: type(of: self)).path(forResource: resource, ofType: type)
    }
}
