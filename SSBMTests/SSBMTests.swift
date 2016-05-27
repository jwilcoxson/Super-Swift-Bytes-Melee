//
//  SSBMTests.swift
//  SSBMTests
//
//  Created by Joe Wilcoxson on 5/24/16.
//  Copyright © 2016 Joe Wilcoxson. All rights reserved.
//

import XCTest
@testable import Super_Swift_Bytes_Melee

class SSBMTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            _ = SSByte.invertDoubleWord(0x12345678)
        }
    }
    
    func testGetBit() {
        XCTAssertTrue(SSByte.getBitOfByte(9, bitNumber: 0))
        XCTAssertFalse(SSByte.getBitOfByte(8, bitNumber: 5))
        XCTAssertTrue(SSByte.getBitOfByte(189, bitNumber: 7))
    }
    
    func testSetBit() {
        let b : UInt8 = SSByte.setBitOfByte(52, bitNumber: 7, value: true)
        XCTAssertTrue(b == 180)
    }
    
    func testLeftRotate() {
        let b : UInt8 = SSByte.rotateLeftByte(240, bits: 5)
        XCTAssertTrue(b == 30)
    }
    
    func testRightRotate() {
        let b : UInt8 = SSByte.rotateRightByte(240, bits: 5)
        XCTAssertTrue(b == 135)
    }
    
    func testRevByte() {
        let b : UInt8 = SSByte.reverseByte(UInt8(1))
        XCTAssertTrue(b == 128)
    }
    
    func testRevWord() {
        let w : UInt16 = SSByte.reverseWord(UInt16(1))
        XCTAssertTrue(w == 32768)
    }
    
    func testDoubletoFloat() {
        var test : UInt32 = 0xc3c09400
        var f : Float = SSByte.doubleWordToFloat(test)
        
        XCTAssertTrue((f < -385.0) && (f > -390.0))
        
        test = 0x7fc00000
        f = SSByte.doubleWordToFloat(test)
        
        XCTAssertTrue(f.isNaN)
        
    }
    
}
