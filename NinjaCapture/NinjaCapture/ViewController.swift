//
//  ViewController.swift
//  NinjaCapture
//
//  Created by Igor Yunash on 18.01.18.
//  Copyright © 2018 Igralino. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        _ = Capture()
        var a = Merge.init(pathToVideos: "1", pathToSave: "2")
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

