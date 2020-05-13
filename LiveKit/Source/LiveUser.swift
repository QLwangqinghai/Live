//
//  LiveUser.swift
//  Live
//
//  Created by vector on 2020/5/13.
//  Copyright © 2020 haoqi. All rights reserved.
//

import UIKit

public class LiveUser: NSObject {
    public let uid: String
    public dynamic var nick: String = ""
    public dynamic var remark: String = ""
    public dynamic var displayName: String = ""

    public init(uid: String) {
        self.uid = uid
        super.init()
    }
    
    
    
}
