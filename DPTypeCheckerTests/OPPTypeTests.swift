//
//  OPPTypeTests.swift
//  DPTypeChecker
//
//  Created by Jan Wittler on 07.08.17.
//  Copyright © 2017 Jan Wittler. All rights reserved.
//

import XCTest

class OPPTypeTests: XCTestCase {
    func testReplicationIndexOPPType() {
        let coreType = CoreType.base(.int)
        let environment = Environment()
        let t1 = Type.default(coreType, 1)
        let t2 = Type.default(coreType, 1000)
        let t3 = Type.default(coreType, .infinity)
        let t4 = Type.exponential(coreType)
        let t5 = Type.unknown
        
        XCTAssertFalse(t1.isOPPType(inEnvironment: environment))
        XCTAssertFalse(t2.isOPPType(inEnvironment: environment))
        XCTAssertTrue(t3.isOPPType(inEnvironment: environment))
        XCTAssertTrue(t4.isOPPType(inEnvironment: environment))
        XCTAssertFalse(t5.isOPPType(inEnvironment: environment))
    }
    
    func testBasicOPPTypes() {
        let environment = Environment()
        let int = Type.exponential(.base(.int))
        let double = Type.exponential(.base(.double))
        let unit = Type.exponential(.base(.unit))
        let notOPP = Type.default(.base(.int), 12345)
        
        XCTAssertTrue(int.isOPPType(inEnvironment: environment))
        XCTAssertTrue(double.isOPPType(inEnvironment: environment))
        XCTAssertTrue(unit.isOPPType(inEnvironment: environment))
        XCTAssertFalse(notOPP.isOPPType(inEnvironment: environment))
        
        let pair = Type.exponential(.mulPair(int, double))
        let notOPPPair1 = Type.exponential(.mulPair(int, notOPP))
        let notOPPPair2 = Type.exponential(.mulPair(notOPP, double))
        XCTAssertTrue(pair.isOPPType(inEnvironment: environment))
        XCTAssertFalse(notOPPPair1.isOPPType(inEnvironment: environment))
        XCTAssertFalse(notOPPPair2.isOPPType(inEnvironment: environment))
        
        let sum = Type.exponential(.sum(pair, double))
        let notOPPSum1 = Type.exponential(.sum(pair, notOPP))
        let notOPPSum2 = Type.exponential(.sum(notOPP, double))
        XCTAssertTrue(sum.isOPPType(inEnvironment: environment))
        XCTAssertFalse(notOPPSum1.isOPPType(inEnvironment: environment))
        XCTAssertFalse(notOPPSum2.isOPPType(inEnvironment: environment))
        
        let list = Type.exponential(.list(sum))
        let notOPPList = Type.exponential(.list(notOPP))
        XCTAssertTrue(list.isOPPType(inEnvironment: environment))
        XCTAssertFalse(notOPPList.isOPPType(inEnvironment: environment))
        
        let function = Type.exponential(.function([pair, sum, list, int, double], unit))
        let notOPPFunction1 = Type.exponential(.function([pair, sum, list, int, double, notOPP], unit))
        let notOPPFunction2 = Type.exponential(.function([], notOPP))
        XCTAssertTrue(function.isOPPType(inEnvironment: environment))
        XCTAssertFalse(notOPPFunction1.isOPPType(inEnvironment: environment))
        XCTAssertFalse(notOPPFunction2.isOPPType(inEnvironment: environment))
    }
    
    func testNamedOPPTypes() {
        let OPPType = Type.exponential(.base(.int))
        let NotOPPType = Type.default(.base(.int), 98765)
        
        var environment = Environment()
        let OPPIdent = Ident("OPP")
        let notOPPIdent = Ident("Not_OPP_1")
        let genericIdent = Ident("Generic")
        try! environment.addSumType(name: OPPIdent, types: (OPPType, OPPType))
        try! environment.addSumType(name: notOPPIdent, types: (OPPType, NotOPPType))
        try! environment.addSumType(name: genericIdent, types: (.unknown, OPPType))
        
        let named = Type.exponential(.named(OPPIdent, .none))
        let notOPPNamed = Type.exponential(.named(notOPPIdent, .none))
        XCTAssertTrue(named.isOPPType(inEnvironment: environment))
        XCTAssertFalse(notOPPNamed.isOPPType(inEnvironment: environment))
        
        let generic = Type.exponential(.named(genericIdent, .type(OPPType)))
        let notResolvedGeneric = Type.exponential(.named(genericIdent, .none))
        let unknownResolvedGeneric = Type.exponential(.named(genericIdent, .type(.unknown)))
        XCTAssertTrue(generic.isOPPType(inEnvironment: environment))
        XCTAssertFalse(notResolvedGeneric.isOPPType(inEnvironment: environment))
        XCTAssertFalse(unknownResolvedGeneric.isOPPType(inEnvironment: environment))
    }
}
