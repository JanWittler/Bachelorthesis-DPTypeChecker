//
//  OPPTypeTests.swift
//  DPTypeChecker
//
//  Created by Jan Wittler on 07.08.17.
//  Copyright © 2017 Jan Wittler. All rights reserved.
//

import XCTest

class OPPTypeTests: XCTestCase {
    func testReplicationCountOPPType() {
        let coreType = CoreType.cTBase(.int)
        let environment = Environment()
        let t1 = Type.tType(coreType, 1)
        let t2 = Type.tType(coreType, 1000)
        let t3 = Type.tType(coreType, .infinity)
        let t4 = Type.tTypeExponential(coreType)
        let t5 = Type.tTypeUnknown
        
        XCTAssertFalse(t1.isOPPType(inEnvironment: environment))
        XCTAssertFalse(t2.isOPPType(inEnvironment: environment))
        XCTAssertTrue(t3.isOPPType(inEnvironment: environment))
        XCTAssertTrue(t4.isOPPType(inEnvironment: environment))
        XCTAssertFalse(t5.isOPPType(inEnvironment: environment))
    }
    
    func testBasicOPPTypes() {
        let environment = Environment()
        let int = Type.tTypeExponential(.cTBase(.int))
        let double = Type.tTypeExponential(.cTBase(.float))
        let unit = Type.tTypeExponential(.cTBase(.unit))
        let notOPP = Type.tType(.cTBase(.int), 12345)
        
        XCTAssertTrue(int.isOPPType(inEnvironment: environment))
        XCTAssertTrue(double.isOPPType(inEnvironment: environment))
        XCTAssertTrue(unit.isOPPType(inEnvironment: environment))
        XCTAssertFalse(notOPP.isOPPType(inEnvironment: environment))
        
        let pair = Type.tTypeExponential(.cTMulPair(int, double))
        let notOPPPair1 = Type.tTypeExponential(.cTMulPair(int, notOPP))
        let notOPPPair2 = Type.tTypeExponential(.cTMulPair(notOPP, double))
        XCTAssertTrue(pair.isOPPType(inEnvironment: environment))
        XCTAssertFalse(notOPPPair1.isOPPType(inEnvironment: environment))
        XCTAssertFalse(notOPPPair2.isOPPType(inEnvironment: environment))
        
        let sum = Type.tTypeExponential(.cTSum(pair, double))
        let notOPPSum1 = Type.tTypeExponential(.cTSum(pair, notOPP))
        let notOPPSum2 = Type.tTypeExponential(.cTSum(notOPP, double))
        XCTAssertTrue(sum.isOPPType(inEnvironment: environment))
        XCTAssertFalse(notOPPSum1.isOPPType(inEnvironment: environment))
        XCTAssertFalse(notOPPSum2.isOPPType(inEnvironment: environment))
        
        let list = Type.tTypeExponential(.cTList(sum))
        let notOPPList = Type.tTypeExponential(.cTList(notOPP))
        XCTAssertTrue(list.isOPPType(inEnvironment: environment))
        XCTAssertFalse(notOPPList.isOPPType(inEnvironment: environment))
        
        let function = Type.tTypeExponential(.cTFunction([pair, sum, list, int, double], unit))
        let notOPPFunction1 = Type.tTypeExponential(.cTFunction([pair, sum, list, int, double, notOPP], unit))
        let notOPPFunction2 = Type.tTypeExponential(.cTFunction([], notOPP))
        XCTAssertTrue(function.isOPPType(inEnvironment: environment))
        XCTAssertFalse(notOPPFunction1.isOPPType(inEnvironment: environment))
        XCTAssertFalse(notOPPFunction2.isOPPType(inEnvironment: environment))
    }
    
    func testNamedOPPTypes() {
        let OPPType = Type.tTypeExponential(.cTBase(.int))
        let NotOPPType = Type.tType(.cTBase(.int), 98765)
        
        var environment = Environment()
        let OPPIdent = Ident("OPP")
        let notOPPIdent = Ident("Not_OPP_1")
        let genericIdent = Ident("Generic")
        try! environment.addSumType(name: OPPIdent, types: (OPPType, OPPType))
        try! environment.addSumType(name: notOPPIdent, types: (OPPType, NotOPPType))
        try! environment.addSumType(name: genericIdent, types: (.tTypeUnknown, OPPType))
        
        let named = Type.tTypeExponential(.cTNamed(OPPIdent, .genericsNone))
        let notOPPNamed = Type.tTypeExponential(.cTNamed(notOPPIdent, .genericsNone))
        XCTAssertTrue(named.isOPPType(inEnvironment: environment))
        XCTAssertFalse(notOPPNamed.isOPPType(inEnvironment: environment))
        
        let generic = Type.tTypeExponential(.cTNamed(genericIdent, .genericsType(OPPType)))
        let notResolvedGeneric = Type.tTypeExponential(.cTNamed(genericIdent, .genericsNone))
        let unknownResolvedGeneric = Type.tTypeExponential(.cTNamed(genericIdent, .genericsType(.tTypeUnknown)))
        XCTAssertTrue(generic.isOPPType(inEnvironment: environment))
        XCTAssertFalse(notResolvedGeneric.isOPPType(inEnvironment: environment))
        XCTAssertFalse(unknownResolvedGeneric.isOPPType(inEnvironment: environment))
    }
}
