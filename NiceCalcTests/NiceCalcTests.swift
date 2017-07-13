//
//  NiceCalcTests.swift
//  NiceCalcTests
//
//  Created by Yaroslav Luchyt on 7/13/17.
//  Copyright © 2017 Yaroslav Luchyt. All rights reserved.
//

import XCTest
@testable import NiceCalc

class NiceCalcTests: XCTestCase {
    
    let input = InputAdapter.shared
    let output = OutputAdapter.shared
    
    var result: String?
    
    override func setUp() {
        super.setUp()
        
        output.resultDisplay = { [weak self] res in
            self?.result = res
        }
    }
    
    override func tearDown() {
        
        super.tearDown()
    }
    
    func testNumbers() {
        input.enterUtility(.clear)
        input.enterNum(5)
        input.enterNum(9)
        
        XCTAssertNotNil(result, "Result cant be nil")
        XCTAssert(result == "59", "Result must be 59")
    }
    
    func test6BigNumbers() {
        input.enterUtility(.clear)
        input.enterNum(123456)
        
        XCTAssertNotNil(result, "Result cant be nil")
        XCTAssert(result == "123456", "Result must be 123456, but \(result!) is presented")
    }
    
    func test9BigNumbers() {
        input.enterUtility(.clear)
        input.enterNum(123456789)
        
        XCTAssertNotNil(result, "Result cant be nil")
        XCTAssert(result == "123456789", "Result must be 123456789, but \(result!) is presented")
    }
    
    func testSimlePlus() {
        input.enterUtility(.clear)
        input.enterNum(25)
        input.enterUtility(.pls)
        input.enterNum(21)
        input.enterUtility(.equal)
        
        XCTAssertNotNil(result, "Result cant be nil")
        XCTAssert(result == "46", "Result must be 46, but \(result!) is presented")
    }
    
    func testDoublePlus() {
        input.enterUtility(.clear)
        input.enterNum(25)
        input.enterUtility(.pls)
        input.enterUtility(.pls)
        input.enterNum(21)
        input.enterUtility(.equal)
        
        XCTAssertNotNil(result, "Result cant be nil")
        XCTAssert(result == "46", "Result must be 46, but \(result!) is presented")
    }
    
    func testMinus() {
        input.enterUtility(.clear)
        input.enterNum(2)
        input.enterUtility(.mns)
        input.enterNum(3)
        input.enterUtility(.equal)
        
        XCTAssertNotNil(result, "Result cant be nil")
        XCTAssert(result == "-1", "Result must be -1, but \(result!) is presented")
    }
    
    func testDoubleOperation() {
        input.enterUtility(.clear)
        input.enterNum(2)
        input.enterUtility(.mul)
        input.enterUtility(.mul)
        input.enterNum(3)
        input.enterUtility(.equal)
        
        XCTAssertNotNil(result, "Result cant be nil")
        XCTAssert(result == "6", "Result must be 6, but \(result!) is presented")
    }
    
    func testDivByZeroOperation() {
        input.enterUtility(.clear)
        input.enterNum(2)
        input.enterUtility(.div)
        input.enterNum(0)
        input.enterUtility(.equal)
        
        XCTAssertNotNil(result, "Result cant be nil")
        XCTAssert(result == "inf", "Result must be inf, but \(result!) is presented")
    }
    
    func testSequenceOfOperations() {
        input.enterUtility(.clear)
        input.enterNum(2)
        input.enterUtility(.pls)
        input.enterNum(6)
        input.enterUtility(.mul)
        input.enterNum(8)
        input.enterUtility(.div)
        input.enterNum(2)
        input.enterUtility(.mns)
        input.enterNum(1)
        input.enterUtility(.equal)
        
        XCTAssertNotNil(result, "Result cant be nil")
        XCTAssert(result == "25", "Result must be 25, but \(result!) is presented")
    }
    
    func testPi() {
        input.enterUtility(.clear)
        input.enterUtility(.pi)
        input.enterUtility(.equal)
        
        XCTAssertNotNil(result, "Result cant be nil")
        XCTAssert(result == "3.1415926536", "Result must be 3.1415926536, but \(result!) is presented")
    }
    
    func testSin() {
        input.enterUtility(.clear)
        input.enterUtility(.sin)
        input.enterUtility(.leftBracket)
        input.enterUtility(.pi)
        input.enterUtility(.div)
        input.enterNum(2)
        input.enterUtility(.rightBracket)
        input.enterUtility(.equal)
        
        XCTAssertNotNil(result, "Result cant be nil")
        XCTAssert(result == "1", "Result must be 1, but \(result!) is presented")
    }
    
    func testCos() {
        input.enterUtility(.clear)
        input.enterUtility(.cos)
        input.enterNum(0)
        input.enterUtility(.equal)
        
        XCTAssertNotNil(result, "Result cant be nil")
        XCTAssert(result == "1", "Result must be 1, but \(result!) is presented")
    }
    
    func testSinAndCosSequence() {
        input.enterUtility(.clear)
        input.enterUtility(.sin)
        input.enterUtility(.leftBracket)
        input.enterUtility(.pi)
        input.enterUtility(.mul)
        input.enterUtility(.cos)
        input.enterNum(0)
        input.enterUtility(.rightBracket)
        input.enterUtility(.equal)
        
        XCTAssertNotNil(result, "Result cant be nil")
        XCTAssert(result == "0", "Result must be 0, but \(result!) is presented")
    }
    
    func testPythagoreanTrigonometricIdentity() {
        input.enterUtility(.clear)
        input.enterUtility(.leftBracket)
        input.enterUtility(.sin)
        input.enterNum(6)
        input.enterUtility(.rightBracket)
        input.enterUtility(.pow)
        input.enterNum(2)
        input.enterUtility(.pls)
        input.enterUtility(.leftBracket)
        input.enterUtility(.cos)
        input.enterNum(6)
        input.enterUtility(.rightBracket)
        input.enterUtility(.pow)
        input.enterNum(2)
        input.enterUtility(.equal)
        
        XCTAssertNotNil(result, "Result cant be nil")
        XCTAssert(result == "1", "Result must be 1, but \(result!) is presented")
    }
}
