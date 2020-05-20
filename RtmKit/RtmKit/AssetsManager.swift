//
//  AssetsManager.swift
//  RtmKit
//
//  Created by vector on 2020/5/18.
//  Copyright © 2020 haoqi. All rights reserved.
//

import UIKit

public final class AssetsManager: NSObject {
    public let queue: DispatchQueue
    public let directory: String
    public let tmpDirectory: String
    private let fileManager: FileManager

    public override init() {
        let directoryName = "com.angfung.assets"
        let library = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first!
        let directory: String = library.appending(directoryName)
        let tmpDirectory = NSTemporaryDirectory().appending(directoryName)
        let fileManager = FileManager()
        let queue = DispatchQueue(label: directoryName, qos: DispatchQoS.userInitiated, attributes: [], autoreleaseFrequency: .inherit, target: nil)

        self.directory = directory
        self.tmpDirectory = tmpDirectory
        self.fileManager = fileManager
        self.queue = queue
        super.init()
    }
    
    public func makeTmpFile(_ data: Data) throws -> String {
        let fileName = NSUUID().uuidString
        let url = URL(fileURLWithPath: self.tmpDirectory.appending("/\(fileName)"))
        try data.write(to: url)
        return fileName
    }
    
}
