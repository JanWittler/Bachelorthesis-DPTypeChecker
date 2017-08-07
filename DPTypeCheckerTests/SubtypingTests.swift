//
//  SubtypingTests.swift
//  DPTypeChecker
//
//  Created by Jan Wittler on 07.08.17.
//  Copyright © 2017 Jan Wittler. All rights reserved.
//

import XCTest

class SubtypingTests: XCTestCase {
    func testSubtypeReplicationCount() {
        let coreType = CoreType.cTBase(.int)
        let subtype = Type.tType(coreType, 1.8)
        let supertype = Type.tTypeConvenienceInt(coreType, 5)
        let supersupertype = Type.tTypeExponential(coreType)
        
        XCTAssertTrue(subtype.isSubtype(of: subtype))
        XCTAssertTrue(subtype.isSubtype(of: supertype))
        XCTAssertTrue(subtype.isSubtype(of: supersupertype))
        
        XCTAssertFalse(supertype.isSubtype(of: subtype))
        XCTAssertTrue(supertype.isSubtype(of: supertype))
        XCTAssertTrue(supertype.isSubtype(of: supersupertype))
        
        XCTAssertFalse(supersupertype.isSubtype(of: subtype))
        XCTAssertFalse(supersupertype.isSubtype(of: supertype))
        XCTAssertTrue(supersupertype.isSubtype(of: supersupertype))
    }
    
    func testBasicSubtypes() {
        let subType = Type.tType(.cTBase(.int), 1)
        let superType = Type.tType(.cTBase(.int), 1.5)
        
        let pair1 = Type.tType(.cTMulPair(subType, superType), 1)
        let pair2 = Type.tType(.cTMulPair(superType, superType), 2)
        XCTAssertTrue(pair1.isSubtype(of: pair1))
        XCTAssertTrue(pair1.isSubtype(of: pair2))
        XCTAssertFalse(pair2.isSubtype(of: pair1))
        
        let sum1 = Type.tType(.cTSum(subType, superType), 1)
        let sum2 = Type.tType(.cTSum(superType, superType), 2)
        XCTAssertTrue(sum1.isSubtype(of: sum1))
        XCTAssertTrue(sum1.isSubtype(of: sum2))
        XCTAssertFalse(sum2.isSubtype(of: sum1))
        
        let list1 = Type.tType(.cTList(subType), 1)
        let list2 = Type.tType(.cTList(superType), 2)
        XCTAssertTrue(list1.isSubtype(of: list1))
        XCTAssertTrue(list1.isSubtype(of: list2))
        XCTAssertTrue(list1.isSubtype(of: list1))
        
        XCTAssertFalse(pair1.isSubtype(of: sum1))
        XCTAssertFalse(pair1.isSubtype(of: list1))
        XCTAssertFalse(sum1.isSubtype(of: pair1))
        XCTAssertFalse(sum1.isSubtype(of: list1))
        XCTAssertFalse(list1.isSubtype(of: pair1))
        XCTAssertFalse(list1.isSubtype(of: sum1))
    }
    
    func testGenericTypesSubtyping() {
        let subType = Type.tType(.cTBase(.int), 1)
        let superType = Type.tType(.cTBase(.int), 1.5)
        let ident = Ident("Test")
        
        let named1 = Type.tType(.cTNamed(ident, .genericsNone), 1)
        let named2 = Type.tType(.cTNamed(ident, .genericsType(subType)), 1)
        let named3 = Type.tType(.cTNamed(ident, .genericsType(superType)), 2)
        
        XCTAssertTrue(named1.isSubtype(of: named1))
        XCTAssertFalse(named1.isSubtype(of: named2))
        XCTAssertFalse(named1.isSubtype(of: named3))
        
        XCTAssertFalse(named2.isSubtype(of: named1))
        XCTAssertTrue(named2.isSubtype(of: named2))
        XCTAssertTrue(named2.isSubtype(of: named3))
        XCTAssertFalse(named2.isSubtype(of: superType))
        XCTAssertFalse(subType.isSubtype(of: named2))
        
        XCTAssertFalse(named3.isSubtype(of: named1))
        XCTAssertFalse(named3.isSubtype(of: named2))
        XCTAssertTrue(named2.isSubtype(of: named3))
    }
    
    func testFunctionSubtyping() {
        let sub1 = Type.tType(.cTBase(.int), 1)
        let sub2 = Type.tType(.cTMulPair(sub1, sub1), 4)
        
        let super1 = Type.tType(.cTBase(.int), 10)
        let super2 = Type.tType(.cTMulPair(super1, super1), 5)
        
        let f1 = Type.tTypeExponential(.cTFunction([sub1, sub2], sub1))
        let f2 = Type.tTypeExponential(.cTFunction([sub1, sub2], super1))
        let f3 = Type.tTypeExponential(.cTFunction([super1, super2], sub1))
        let f4 = Type.tTypeExponential(.cTFunction([super1, super2], super1))
        
        //functions have inversed subtyping requirements for their arguments
        XCTAssertTrue(f1.isSubtype(of: f1))
        XCTAssertTrue(f1.isSubtype(of: f2))
        XCTAssertFalse(f1.isSubtype(of: f3))
        XCTAssertFalse(f1.isSubtype(of: f4))
        
        XCTAssertFalse(f2.isSubtype(of: f1))
        XCTAssertTrue(f2.isSubtype(of: f2))
        XCTAssertFalse(f2.isSubtype(of: f3))
        XCTAssertFalse(f2.isSubtype(of: f4))
        
        XCTAssertTrue(f3.isSubtype(of: f1))
        XCTAssertTrue(f3.isSubtype(of: f2))
        XCTAssertTrue(f3.isSubtype(of: f3))
        XCTAssertTrue(f3.isSubtype(of: f4))
        
        XCTAssertFalse(f4.isSubtype(of: f1))
        XCTAssertTrue(f4.isSubtype(of: f2))
        XCTAssertFalse(f4.isSubtype(of: f3))
        XCTAssertTrue(f4.isSubtype(of: f4))
    }
}
