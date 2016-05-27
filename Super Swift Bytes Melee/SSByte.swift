//
//  SSByte.swift
//  Super Swift Bytes Melee
//
//  Created by Joe Wilcoxson on 5/24/16.
//  Copyright © 2016 Joe Wilcoxson. All rights reserved.
//

import Foundation

// MARK: Rotate Operators

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

// MARK: SSByte Handler Class -

/// Handler class for dealing with byte, words and bits.

class SSByte {
    
    // MARK: Byte Functions -
    
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
    
    /**
     Inverts all bits in a byte.
     
     - parameter byte: The byte to invert.
     - returns: The inverted byte.
     */
    
    class func invertByte(byte: UInt8) -> UInt8
    {
        var b : UInt8 = 0x00
        for index : UInt8 in 0...7
        {
            b = setBitOfByte(b, bitNumber: index, value: !getBitOfByte(byte, bitNumber: index))
        }
        return b
    }
    
    // MARK: Word Functions -
    
    /**
     Gets the lower (least significant) byte in a word.
     
     - parameter word: The word to get the low byte from.
     - returns: The lower (least significant) byte of the word.
     */
    
    class func getLowByteOfWord(word: UInt16) -> UInt8
    {
        return UInt8(truncatingBitPattern: word)
    }
    
    /**
     Gets the higher (most significant) byte in a word.
     
     - parameter word: The word to get the high byte from.
     - returns: The higher (most significant) byte of the word.
     */
    
    class func getHighByteOfWord(word: UInt16) -> UInt8
    {
        return UInt8(truncatingBitPattern: (word >> 8))
    }
    
    /**
     Gets the value of a specific bit in a word.
     
     - parameter word: The word to get a bit from.
     - parameter bitNumber: The position of the bit to get (0-15).
     - returns: The Bool value of the requested bit.
     */
    
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
    
    /**
     Sets the value of a specific bit in a word.
     
     - parameter word: The word to set a bit in.
     - parameter bitNumber: The position of the bit to set (0-15).
     - parameter value: Bool value to set the bit to.
     - returns: The input word with the requested bit set.
     */
    
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
    
    /**
     Assembles a word from two bytes.
     
     - parameter highByte: The higher byte of the word.
     - parameter lowByte: The lower byte of the word.
     - returns: The assembled word.
     */
    
    class func wordFromBytes(highByte: UInt8, lowByte: UInt8) -> UInt16
    {
        return (UInt16(highByte) << 8) ^ UInt16(lowByte)
    }
    
    /**
     Swaps the low and high bytes in a word.
     
     - parameter word: The word to swap bytes in.
     - returns: The input word with bytes swapped.
     */
    
    class func swapBytesInWord(word: UInt16) -> UInt16
    {
        return wordFromBytes(getLowByteOfWord(word), lowByte: getHighByteOfWord(word))
    }
    
    /**
     Rotates a word left by a specified number of bits.
     
     - parameter word: The word to rotate.
     - parameter bits: The number of bits to rotate by.
     - returns: The rotated word.
     */
    
    class func rotateLeftWord(word: UInt16, bits: Int) -> UInt16
    {
        let d = UInt32(word) << UInt32(bits % 16)
        
        return UInt16(truncatingBitPattern: d) ^ UInt16(truncatingBitPattern: (d >> 16))
    }
    
    /**
     Rotates a word right by a specified number of bits.
     
     - parameter word: The word to rotate.
     - parameter bits: The number of bits to rotate by.
     - returns: The rotated word.
     */
    
    class func rotateRightWord(word: UInt16, bits: Int) -> UInt16
    {
        let d = (UInt32(word) << 16) >> UInt32(bits % 16)
        
        return UInt16(truncatingBitPattern: d) ^ UInt16(truncatingBitPattern: (d >> 16))
    }
    
    /**
     Reverses the order of the bits in a word.
     
     - parameter word: The word to reverse.
     - returns: The reversed word.
     */
    
    class func reverseWord(word: UInt16) -> UInt16
    {
        var newWord : UInt16 = 0x00
        for index : UInt8 in 0...15
        {
            newWord = setBitOfWord(newWord, bitNumber: (15 - index), value: getBitOfWord(word, bitNumber: index))
        }
        return newWord
    }
    
    /**
     Inverts all bits in a word.
     
     - parameter word: The word to invert.
     - returns: The inverted word.
     */
    
    class func invertWord(word: UInt16) -> UInt16
    {
        let lowByte = invertByte(getLowByteOfWord(word))
        let highByte = invertByte(getHighByteOfWord(word))
        return wordFromBytes(highByte, lowByte: lowByte)
    }
    
    // MARK: Double Word Functions -
    
    /**
     Gets the lower (least significant) word in a double word.
     
     - parameter double: The double word to get the low word from.
     - returns: The lower (least significant) word of the double word.
     */
    
    class func getLowWordOfDoubleWord(double: UInt32) -> UInt16
    {
        return UInt16(truncatingBitPattern: double)
    }
    
    /**
     Gets the higher (most significant) word in a double word.
     
     - parameter double: The double word to get the high word from.
     - returns: The higher (most significant) word of the double word.
     */
    
    class func getHighWordOfDoubleWord(double: UInt32) -> UInt16
    {
        return UInt16(truncatingBitPattern: (double >> 16))
    }
    
    /**
     Gets the value of a specific bit in a double word.
     
     - parameter double: The double word to get a bit from.
     - parameter bitNumber: The position of the bit to get (0-31).
     - returns: The Bool value of the requested bit.
     */
    
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
    
    /**
     Sets the value of a specific bit in a double word.
     
     - parameter double: The double word to set a bit in.
     - parameter bitNumber: The position of the bit to set (0-31).
     - parameter value: Bool value to set the bit to.
     - returns: The input double word with the requested bit set.
     */
    
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
    
    /**
     Assembles a double word from two words.
     
     - parameter highWord: The higher word of the double word.
     - parameter lowWord: The lower word of the double word.
     - returns: The assembled double word.
     */
    
    class func doubleWordFromWords(highWord: UInt16, lowWord: UInt16) -> UInt32
    {
        return (UInt32(highWord) << 16) ^ UInt32(lowWord)
    }
    
    /**
     Swaps the low and high word in a double word.
     
     - parameter double: The doublw word to swap words in.
     - returns: The input double word with words swapped.
     */
    
    class func swapWordsInDoubleWord(double: UInt32) -> UInt32
    {
        let lowWord = getLowWordOfDoubleWord(double)
        let highWord = getHighWordOfDoubleWord(double)
        return doubleWordFromWords(lowWord, lowWord: highWord)
    }
    
    /**
     Rotates a double word left by a specified number of bits.
     
     - parameter double: The double word to rotate.
     - parameter bits: The number of bits to rotate by.
     - returns: The rotated double word.
     */
    
    class func rotateLeftDoubleWord(double: UInt32, bits: Int) -> UInt32
    {
        
        let q = UInt64(double) << UInt64(bits % 32)
        
        return UInt32(truncatingBitPattern: q) ^ UInt32(truncatingBitPattern: (q >> 32))
    }
    
    /**
     Rotates a double word right by a specified number of bits.
     
     - parameter double: The double word to rotate.
     - parameter bits: The number of bits to rotate by.
     - returns: The rotated double word.
     */
    
    class func rotateRightDoubleWord(double: UInt32, bits: Int) -> UInt32
    {
        let q = (UInt64(double) << 32) >> UInt64(bits % 32)
        
        return UInt32(truncatingBitPattern: q) ^ UInt32(truncatingBitPattern: (q >> 32))
    }
    
    /**
     Reverses the order of the bits in a double word.
     
     - parameter double: The double word to reverse.
     - returns: The reversed double word.
     */
    
    class func reverseDoubleWord(double: UInt32) -> UInt32
    {
        var newDouble : UInt32 = 0x00
        for index :UInt8 in 0...31
        {
            newDouble = setBitOfDoubleWord(newDouble, bitNumber: (31 - index), value: getBitOfDoubleWord(double, bitNumber: index))
        }
        return newDouble
    }
    
    /**
     Inverts all bits in a double word.
     
     - parameter double: The double word to invert.
     - returns: The inverted double word.
     */
    
    class func invertDoubleWord(double: UInt32) -> UInt32
    {
        let lowWord = invertWord(getLowWordOfDoubleWord(double))
        let highWord = invertWord(getHighWordOfDoubleWord(double))
        return doubleWordFromWords(highWord, lowWord: lowWord)
    }
    
    /**
     Converts a double word to a float value, *maintains bit representation in memory*.
     
     - parameter double: The double word to convert.
     - returns: The float value with the same bit representation in memory.
     */
    
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
        
        for index : UInt8 in 0...22
        {
            if(getBitOfDoubleWord(double, bitNumber: index))
            {
                mantissa = mantissa + (1.0 / pow(2.0, Double(23 - index)))
            }
        }
        
        if ((exponent == 255) && (mantissa > 0.0))
        {
            return Float.NaN
        }
        
        exponent = exponent - 127
        
        return sign * Float(pow(2.0, Double(exponent))) * Float(mantissa)
    }

}