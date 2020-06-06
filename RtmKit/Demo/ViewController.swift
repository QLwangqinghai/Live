//
//  ViewController.swift
//  Demo
//
//  Created by vector on 2020/5/16.
//  Copyright © 2020 haoqi. All rights reserved.
//

import UIKit
import RtmKit

class ViewController: UIViewController {

    public let rtmKit: RtmKit = RtmKit(account: "007")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print("\(self.rtmKit)")
        
        self.rtmKit.login(token: nil)
        
        let image = UIImage(named: "058f99f392446c526b9ea278faf4bed3")!
        let data = image.jpegData(compressionQuality: 1.0)!
        
        let filePath = "\(NSHomeDirectory())/Library/a.png"
        try! data.write(to: URL(fileURLWithPath: filePath))
        
        print("data.size \(data.count)")
        
        self.rtmKit.fileManager.create(filePath: filePath)

    }


}

