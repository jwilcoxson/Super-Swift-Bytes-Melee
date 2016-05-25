//
//  SSByte.swift
//  Super Swift Bytes Melee
//
//  Created by Joe Wilcoxson on 5/24/16.
//  Copyright © 2016 Joe Wilcoxson. All rights reserved.
//

import Foundation

//Rotate Right Operator
infix operator >>> {associativity left}
func >>> (lhs: UInt8, rhs: Int) -> UInt8 {
    return SSByte.rotateRightByte(lhs, bits: rhs)
}
func >>> (lhs: UInt16, rhs: Int) -> UInt16 {
    return SSByte.rotateRightWord(lhs, bits: rhs)
}
func >>> (lhs: UInt32, rhs: Int) -> UInt32 {
    return SSByte.rotateRightDoubleWord(lhs, bits: rhs)
}

//Rotate Left Operator
infix operator <<< {associativity left}
func <<< (lhs: UInt8, rhs: Int) -> UInt8 {
    return SSByte.rotateLeftByte(lhs, bits: rhs)
}
func <<< (lhs: UInt16, rhs: Int) -> UInt16 {
    return SSByte.rotateLeftWord(lhs, bits: rhs)
}
func <<< (lhs: UInt32, rhs: Int) -> UInt32 {
    return SSByte.rotateLeftDoubleWord(lhs, bits: rhs)
}

/// Handler class for dealing with byte, words and bits.

class SSByte {
    
    /*
        Byte Functions
    */
    
    /**
      Gets the value of a specific bit in a byte.
     
      - parameter byte: The byte to get a bit from.
      - parameter bitNumber: The position of the bit to get (0-7).
      - returns: The Bool value of the requested bit.
    */
    
    class func getBitOfByte(byte: UInt8, bitNumber: UInt8) -> Bool
    {
        let b = byte >> (bitNumber % 8)
        
        return (b % 2 == 1 ? true : false)
    }
    
    /**
     Sets the value of a specific bit in a byte.
     
     - parameter byte: The byte to set a bit in.
     - parameter bitNumber: The position of the bit to set (0-7).
     - parameter value: Bool value to set the bit to.
     - returns: The input byte with the requested bit set.
     */
    
    class func setBitOfByte(byte: UInt8, bitNumber: UInt8, value: Bool) -> UInt8
    {
        return (value ? (byte ^ (0x01 << (bitNumber % 8))) : byte & rotateLeftByte(0xFE, bits: Int(bitNumber % 8)))
    }
    
    /**
     Rotates a byte left by a specified number of bits.
     
     - parameter byte: The byte to rotate.
     - parameter bits: The number of bits to rotate by.
     - returns: The rotated byte.
    */
    
    class func rotateLeftByte(byte: UInt8, bits: Int) -> UInt8
    {
        let w = UInt16(byte) << UInt16(bits % 8)
        
        return UInt8(truncatingBitPattern: w) ^ UInt8(truncatingBitPattern: (w >> 8))
    }
    
    /**
     Rotates a byte right by a specified number of bits.
    
     - parameter byte: The byte to rotate.
     - parameter bits: The number of bits to rotate by.
     - returns: The rotated byte.
    */
    
    class func rotateRightByte(byte: UInt8, bits: Int) -> UInt8
    {
        let w = (UInt16(byte) << 8) >> UInt16(bits % 8)
        
        return UInt8(truncatingBitPattern: w) ^ UInt8(truncatingBitPattern: (w >> 8))
    }

    /**
     Reverses the order of the bits in a byte.
     
     - parameter byte: The byte to reverse.
     - returns: The reversed byte.
     */
    
    class func reverseByte(byte: UInt8) -> UInt8
    {
        var b : UInt8 = 0x00
        for index :UInt8 in 0...7
        {
            b = setBitOfByte(b, bitNumber: (7 - index), value: getBitOfByte(byte, bitNumber: UInt8(index)))
        }
        return b
    }
    
    class func invertByte(byte: UInt8) -> UInt8
    {
        var b : UInt8 = 0x00
        for index : UInt8 in 0...7
        {
            b = setBitOfByte(b, bitNumber: index, value: !getBitOfByte(byte, bitNumber: index))
        }
        return b
    }
    
    /*
        Word Functions
     */
    
    class func getLowByteOfWord(word: UInt16) -> UInt8
    {
        return UInt8(truncatingBitPattern: word)
    }
    
    class func getHighByteOfWord(word: UInt16) -> UInt8
    {
        return UInt8(truncatingBitPattern: (word >> 8))
    }
    
    class func getBitOfWord(word: UInt16, bitNumber: UInt8) -> Bool
    {
        if ((bitNumber % 16) >= 8)
        {
            let b = getHighByteOfWord(word)
            return getBitOfByte(b, bitNumber: ((bitNumber % 16) - 8))
        }
        else
        {
            let b = getLowByteOfWord(word)
            return getBitOfByte(b, bitNumber: (bitNumber % 16))
        }
    }
    
    class func setBitOfWord(word: UInt16, bitNumber: UInt8, value: Bool) -> UInt16
    {
        var lowByte : UInt8
        var highByte : UInt8
        
        if ((bitNumber % 16) >= 8)
        {
            let b = getHighByteOfWord(word)
            lowByte = getLowByteOfWord(word)
            highByte = setBitOfByte(b, bitNumber: ((bitNumber % 16) - 8), value: value)
        }
        else
        {
            let b = getLowByteOfWord(word)
            lowByte = setBitOfByte(b, bitNumber: (bitNumber % 16), value: value)
            highByte = getHighByteOfWord(word)
        }
        return wordFromBytes(highByte, lowByte: lowByte)
    }
    
    class func wordFromBytes(highByte: UInt8, lowByte: UInt8) -> UInt16
    {
        return (UInt16(highByte) << 8) ^ UInt16(lowByte)
    }
    
    class func swapBytesInWord(word: UInt16) -> UInt16
    {
        return wordFromBytes(getLowByteOfWord(word), lowByte: getHighByteOfWord(word))
    }
    
    class func rotateLeftWord(word: UInt16, bits: Int) -> UInt16
    {
        let d = UInt32(word) << UInt32(bits % 16)
        
        return UInt16(truncatingBitPattern: d) ^ UInt16(truncatingBitPattern: (d >> 16))
    }
    
    class func rotateRightWord(word: UInt16, bits: Int) -> UInt16
    {
        let d = (UInt32(word) << 16) >> UInt32(bits % 16)
        
        return UInt16(truncatingBitPattern: d) ^ UInt16(truncatingBitPattern: (d >> 16))
    }
    
    class func reverseWord(word: UInt16) -> UInt16
    {
        var newWord : UInt16 = 0x00
        for index : UInt8 in 0...15
        {
            newWord = setBitOfWord(newWord, bitNumber: (15 - index), value: getBitOfWord(word, bitNumber: index))
        }
        return newWord
    }
    
    class func invertWord(word: UInt16) -> UInt16
    {
        let lowByte = invertByte(getLowByteOfWord(word))
        let highByte = invertByte(getHighByteOfWord(word))
        return wordFromBytes(highByte, lowByte: lowByte)
    }
    
    /*
        Double Word Functions
     */
    class func getLowWordOfDoubleWord(double: UInt32) -> UInt16
    {
        return UInt16(truncatingBitPattern: double)
    }
    
    class func getHighWordOfDoubleWord(double: UInt32) -> UInt16
    {
        return UInt16(truncatingBitPattern: (double >> 16))
    }
    
    class func getBitOfDoubleWord(double: UInt32, bitNumber: UInt8) -> Bool
    {
        if ((bitNumber % 32) >= 16)
        {
            let w = getHighWordOfDoubleWord(double)
            return getBitOfWord(w, bitNumber: ((bitNumber % 32) - 16))
        }
        else
        {
            let w = getLowWordOfDoubleWord(double)
            return getBitOfWord(w, bitNumber: (bitNumber % 32))
        }
    }
    
    class func setBitOfDoubleWord(double: UInt32, bitNumber: UInt8, value: Bool) -> UInt32
    {
        var lowWord : UInt16
        var highWord : UInt16
        
        if ((bitNumber % 32) >= 16)
        {
            let w = getHighWordOfDoubleWord(double)
            lowWord = getLowWordOfDoubleWord(double)
            highWord = setBitOfWord(w, bitNumber: ((bitNumber % 32) - 16), value: value)
        }
        else
        {
            let w = getLowWordOfDoubleWord(double)
            lowWord = setBitOfWord(w, bitNumber: (bitNumber % 32), value: value)
            highWord = getHighWordOfDoubleWord(double)
        }
        return doubleWordFromWords(highWord, lowWord: lowWord)
        
    }
    
    class func doubleWordFromWords(highWord: UInt16, lowWord: UInt16) -> UInt32
    {
        return (UInt32(highWord) << 16) ^ UInt32(lowWord)
    }
    
    class func swapWordsInDoubleWord(double: UInt32) -> UInt32
    {
        let lowWord = getLowWordOfDoubleWord(double)
        let highWord = getHighWordOfDoubleWord(double)
        return doubleWordFromWords(lowWord, lowWord: highWord)
    }
    
    class func rotateLeftDoubleWord(double: UInt32, bits: Int) -> UInt32
    {
        
        let q = UInt64(double) << UInt64(bits % 32)
        
        return UInt32(truncatingBitPattern: q) ^ UInt32(truncatingBitPattern: (q >> 32))
    }
    
    class func rotateRightDoubleWord(double: UInt32, bits: Int) -> UInt32
    {
        let q = (UInt64(double) << 32) >> UInt64(bits % 32)
        
        return UInt32(truncatingBitPattern: q) ^ UInt32(truncatingBitPattern: (q >> 32))
    }
    
    class func reverseDoubleWord(double: UInt32) -> UInt32
    {
        var newDouble : UInt32 = 0x00
        for index :UInt8 in 0...31
        {
            newDouble = setBitOfDoubleWord(newDouble, bitNumber: (31 - index), value: getBitOfDoubleWord(double, bitNumber: index))
        }
        return newDouble
    }
    
    class func invertDoubleWord(double: UInt32) -> UInt32
    {
        let lowWord = invertWord(getLowWordOfDoubleWord(double))
        let highWord = invertWord(getHighWordOfDoubleWord(double))
        return doubleWordFromWords(highWord, lowWord: lowWord)
    }
    
    class func doubleWordToFloat(double: UInt32) -> Float
    {
        let sign = Float(getBitOfDoubleWord(double, bitNumber: 31) ? -1.0 : 1.0)
        var exponent = 0
        var mantissa = 1.0
        
        for index : UInt8 in 23...30
        {
            if(getBitOfDoubleWord(double, bitNumber: index))
            {
                exponent = exponent + Int(pow(2.0, Double(index - 23)))
            }
        }
        exponent = exponent - 127
        
        for index : UInt8 in 0...22
        {
            if(getBitOfDoubleWord(double, bitNumber: index))
            {
                mantissa = mantissa + (1.0 / pow(2.0, Double(23 - index)))
            }
        }
        
        return sign * Float(pow(2.0, Double(exponent))) * Float(mantissa)
    }

}