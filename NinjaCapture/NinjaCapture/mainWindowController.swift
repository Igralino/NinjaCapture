//
//  mainWindowController.swift
//  NinjaCapture
//
//  Created by Igor Yunash on 23.01.18.
//  Copyright © 2018 Igralino. All rights reserved.
//

import Cocoa
class mainWindowController: NSWindowController {

    @IBOutlet weak var mainWindow: NSWindow!
    
    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        
        //let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if flag {
            mainWindow.orderFront(self)
        } else {
            mainWindow.makeKeyAndOrderFront(self)
        }
        return true
    }

}
