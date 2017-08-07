//
//  TypeEqualityTests.swift
//  DPTypeChecker
//
//  Created by Jan Wittler on 07.08.17.
//  Copyright © 2017 Jan Wittler. All rights reserved.
//

import XCTest

class TypeEqualityTests: XCTestCase {
    func testReplicationCountInequality() {
        let coreType = CoreType.cTBase(.unit)
        let t1 = Type.tType(coreType, .infinity)
        let t2 = Type.tTypeExponential(coreType)
        let t3 = Type.tType(coreType, 14)
        let t4 = Type.tTypeConvenienceInt(coreType, 14)
        
        //self-comparison must be tested, since equality is calculated based on value, not on value's memory address
        XCTAssertTrue(t1 == t1)
        XCTAssertTrue(t1 == t2)
        XCTAssertTrue(t1 != t3)
        XCTAssertTrue(t1 != t4)
        
        XCTAssertTrue(t2 != t3)
        XCTAssertTrue(t2 != t4)
        
        XCTAssertTrue(t3 == t4)
    }
    
    func testBasicTypeEquality() {
        let intType1 = Type.tType(.cTBase(.int), 4)
        let intType2 = Type.tTypeConvenienceInt(.cTBase(.int), 4)
        
        XCTAssertTrue(intType1 == intType1)
        XCTAssertTrue(intType1 == intType2)
        XCTAssertTrue(intType2 == intType1)
        
        let doubleType1 = Type.tTypeExponential(.cTBase(.float))
        let doubleType2 = Type.tType(.cTBase(.float), .infinity)
        
        XCTAssertTrue(doubleType1 == doubleType2)
        
        XCTAssertFalse(intType1 == doubleType1)
        XCTAssertFalse(doubleType2 == intType2)
    }
    
    func testComposedTypeEquality() {
        let t1 = Type.tType(.cTBase(.unit), 1)
        let t2 = Type.tTypeExponential(.cTBase(.int))
        
        let pair1 = Type.tType(.cTMulPair(t1, t2), 3)
        let pair2 = Type.tType(.cTMulPair(t2, t1), 3)
        let pair3 = Type.tType(.cTMulPair(t1, t2), 1)
        
        XCTAssertTrue(pair1 == pair1)
        XCTAssertTrue(pair1 != pair2)
        XCTAssertFalse(pair1 == pair3)
        XCTAssertFalse(pair1 == t1)
        XCTAssertFalse(pair1 == t2)
        
        let sum1 = Type.tType(.cTSum(t1, t2), 3)
        let sum2 = Type.tType(.cTSum(t2, t1), 3)
        let sum3 = Type.tType(.cTSum(t1, t2), 1)
        
        XCTAssertTrue(sum1 == sum1)
        XCTAssertTrue(sum1 != sum2)
        XCTAssertFalse(sum1 == sum3)
        
        XCTAssertFalse(pair1 == sum1)
        XCTAssertFalse(sum1 == t1)
        XCTAssertFalse(sum1 == t2)
        
        let list1 = Type.tType(.cTList(t1), 3)
        let list2 = Type.tType(.cTList(t2), 3)
        let list3 = Type.tType(.cTList(t1), 1)
        
        XCTAssertTrue(list1 == list1)
        XCTAssertTrue(list1 != list2)
        XCTAssertTrue(list1 != list3)
        
        XCTAssertTrue(list1 != t1)
        XCTAssertTrue(list1 != pair1)
        XCTAssertTrue(list1 != sum1)
    }
    
    func testGenericTypeEquality() {
        let ident = Ident("Test")
        let g1 = Type.tTypeExponential(.cTBase(.int))
        let g2 = Type.tTypeExponential(.cTBase(.unit))
        
        let t1 = Type.tTypeExponential(.cTNamed(ident, .genericsNone))
        let t2 = Type.tTypeExponential(.cTNamed(ident, .genericsType(g1)))
        let t3 = Type.tTypeExponential(.cTNamed(ident, .genericsType(g2)))
        
        XCTAssertTrue(t1 == t1)
        XCTAssertTrue(t2 == t2)
        
        XCTAssertFalse(t1 == t2)
        XCTAssertFalse(t1 == t3)
        XCTAssertFalse(t2 == t3)
        
        XCTAssertFalse(t2 == g1)
        XCTAssertFalse(t3 == g2)
    }
    
    func testFunctionTypeEquality() {
        let arg1 = Type.tTypeExponential(.cTBase(.int))
        let arg2 = Type.tTypeExponential(.cTMulPair(arg1, arg1))
        
        let function1 = Type.tTypeExponential(.cTFunction([arg1, arg2], arg1))
        let function2 = Type.tTypeExponential(.cTFunction([.tTypeExponential(.cTMulPair(arg1, arg2))], arg1))
        let function3 = Type.tTypeExponential(.cTFunction([arg2], arg1))
        let function4 = Type.tTypeExponential(.cTFunction([], arg1))
        let function5 = Type.tTypeExponential(.cTFunction([function1, function2, function3], function4))
        
        XCTAssertTrue(function1 == function1)
        XCTAssertTrue(function2 == function2)
        XCTAssertTrue(function3 == function3)
        XCTAssertTrue(function4 == function4)
        XCTAssertTrue(function5 == function5)
        
        XCTAssertFalse(function1 == function2)
        XCTAssertFalse(function1 == function3)
        XCTAssertFalse(function1 == function4)
        XCTAssertFalse(function1 == function5)
        
        XCTAssertFalse(function2 == function3)
        XCTAssertFalse(function2 == function4)
        XCTAssertFalse(function2 == function5)
        
        XCTAssertFalse(function3 == function4)
        XCTAssertFalse(function3 == function5)
        
        XCTAssertFalse(function4 == function5)
    }
}
