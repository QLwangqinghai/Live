//
//  RtmFileCache.swift
//  RtmKit
//
//  Created by vector on 2020/6/11.
//  Copyright © 2020 haoqi. All rights reserved.
//

import UIKit
import CommonCrypto



public final class RtmFile: NSObject {
    public let digest: String
    
    public var type: Int?
    public var width: Int?
    public var height: Int?
    public var duration: Double?
    
    public init(digest: String) {
        self.digest = digest
    }
    
//    public func create
    
    
    /*
     et://expiration time

     file: {
     hx: hash
     tp: type
     w:
     h:
     d: duration
     }
     */
}

public final class RtmFileCache: NSObject {
    private override init() {
        super.init()
    }

    public func file(for identifier: String) -> RtmFile? {
        return nil
    }
    
    public static let shared: RtmFileCache = RtmFileCache()
}


public final class RtmFileManager {
    
    public let queue: DispatchQueue
    public let directory: String
    public let tmpDirectory: String
    private let fileManager: FileManager

    private init() {
        let directoryName = "com.angfung.assets.rtm"
        let library = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first!
        let directory: String = library.appending(directoryName)
        let tmpDirectory = NSTemporaryDirectory().appending(directoryName)
        let fileManager = FileManager()
        let queue = DispatchQueue(label: directoryName, qos: DispatchQoS.userInitiated, attributes: [], autoreleaseFrequency: .inherit, target: nil)

        self.directory = directory
        self.tmpDirectory = tmpDirectory
        self.fileManager = fileManager
        self.queue = queue
    }
    
    public func makeTmpFile(_ data: Data) throws -> String {
        let fileName = NSUUID().uuidString
        let url = URL(fileURLWithPath: self.tmpDirectory.appending("/\(fileName)"))
        try data.write(to: url)
        return fileName
    }
    
    public func sha512(_ data: NSData) -> Data {
//            const char *str = self.UTF8String;
//            uint8_t buffer[CC_SHA512_DIGEST_LENGTH];
//            CC_SHA512(str, (CC_LONG)strlen(str), buffer);
//            return [self stringFromBytes:buffer length:CC_SHA512_DIGEST_LENGTH];
        let hash: NSMutableData = NSMutableData(length: Int(CC_SHA512_DIGEST_LENGTH))!
        CC_SHA512(data.bytes, CC_LONG(data.count), hash.mutableBytes.bindMemory(to: UInt8.self, capacity: hash.length))
        var result: String = ""
        (hash as Data).forEach { (byte) in
            result.append(String.init(format: "%02x", byte))
        }
        return hash as Data
    }
    

    public func file(for identifier: String) -> RtmFile? {
        return nil
    }
    
    public static let shared: RtmFileManager = RtmFileManager()
}
