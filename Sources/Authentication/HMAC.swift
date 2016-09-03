//
//  HMAC.swift
//  CryptoKit
//
//  Created by Chris Amanse on 02/09/2016.
//
//

import Foundation

public struct HMAC<Hash: HashAlgorithm> {
    public static func generate(key: Data, message: Data) -> Data {
        let blockSize = Int(Hash.blockSize)
        
        // Shorten key if greater than block size
        var newKey: Data = key.count > blockSize ? Hash.digest(key) : key
        
        // Zero pad when key is less than block size
        let zeroPaddingCount = blockSize - newKey.count
        if zeroPaddingCount > 0 {
            newKey.append(contentsOf: Array(repeating: UInt8(0x00), count: zeroPaddingCount))
        }
        
        var oBytes: [UInt8] = []
        var iBytes: [UInt8] = []
        
        newKey.forEach {
            oBytes.append($0 ^ 0x5c)
            iBytes.append($0 ^ 0x36)
        }
        
        // o key pad = XOR key with 0x5c bytes
        let oKeyPad = Data(oBytes)
        
        // i key pad = XOR key with 0x36 bytes
        let iKeyPad = Data(iBytes)
        
        return Hash.digest(oKeyPad + Hash.digest(iKeyPad + message))
    }
}
