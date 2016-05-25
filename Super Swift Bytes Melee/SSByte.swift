//
//  SSByte.swift
//  Super Swift Bytes Melee
//
//  Created by Joe Wilcoxson on 5/24/16.
//  Copyright © 2016 Joe Wilcoxson. All rights reserved.
//

import Foundation

infix operator --> {associativity left}
func --> (lhs: UInt8, rhs: Int) -> Bool {
    return SSByte.getBitOfByte(lhs, bitNumber: rhs)
}

infix operator >>> {associativity left}
func >>> (lhs: UInt8, rhs: Int) -> UInt8 {
    return SSByte.rotateRightByte(lhs, bits: rhs)
}

infix operator <<< {associativity left}
func <<< (lhs: UInt8, rhs: Int) -> UInt8 {
    return SSByte.rotateLeftByte(lhs, bits: rhs)
}

class SSByte {
    
    
    class func getBitOfByte(byte: UInt8, bitNumber: Int) -> Bool
    {
        
        let b = byte >> (UInt8)(bitNumber % 8)
        
        return (b % 2 == 1 ? true : false)
        
    }
    
    class func setBitOfByte(byte: UInt8, bitNumber: Int, value: Bool) -> UInt8
    {
        var b : UInt8
        
        if (value)
        {
            b = byte ^ (0x01 << (UInt8)(bitNumber % 8))

        }
        else
        {
            b = (0xFE << (UInt8)(bitNumber % 8)) ^ (UInt8)(pow(2.0, (Double)(bitNumber % 8)) - 1)
        }
        
        return b
    }
    
    class func rotateLeftByte(byte: UInt8, bits: Int) -> UInt8
    {
        let bitsToRotate : UInt8 = (UInt8)(bits % 8)
        
        let w : UInt16 = UInt16(byte) << UInt16(bitsToRotate)
        
        return UInt8(truncatingBitPattern: w) ^ UInt8(truncatingBitPattern: (w >> 8))
    }
    
    class func rotateRightByte(byte: UInt8, bits: Int) -> UInt8
    {
        let bitsToRotate : UInt8 = (UInt8)(bits % 8)
        
        let w : UInt16 = (UInt16(byte) << 8) >> UInt16(bitsToRotate)
        
        return UInt8(truncatingBitPattern: w) ^ UInt8(truncatingBitPattern: (w >> 8))
    }

}