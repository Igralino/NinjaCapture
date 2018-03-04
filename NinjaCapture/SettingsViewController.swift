//
//  SettingsViewController.swift
//  NinjaCapture
//
//  Created by Игорь Юнаш on 04.03.2018.
//  Copyright © 2018 Igralino. All rights reserved.
//

import Cocoa

class SettingsViewController: NSViewController {

    @IBOutlet weak var FPSPicker: NSPopUpButton!
    @IBOutlet weak var secondsPicker: NSPopUpButton!
    @IBOutlet weak var qualityPicker: NSPopUpButton!
    var settings = ["FPS" : 30,
                    "seconds" : 60,
                    "quality" : 2] //0 - low, 1 - medium, 3 - high
    
    @IBAction func saveButton(_ sender: Any) {
        settings["FPS"] = FPSPicker.selectedItem?.tag
        settings["seconds"] = secondsPicker.selectedItem?.tag
        settings["quality"] = qualityPicker.selectedItem?.tag
        let parentViewController = presenting as! ViewController
        parentViewController.getSettings(data: settings)
        dismiss(nil)
    }
    
    @IBAction func cancelButton(_ sender: Any) {
            dismiss(nil)
    }
    
    func updatePickers(){
        FPSPicker.selectItem(withTag: settings["FPS"]!)
        secondsPicker.selectItem(withTag: settings["seconds"]!)
        qualityPicker.selectItem(withTag: settings["quality"]!)

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let parentViewController = presenting as! ViewController
        settings = parentViewController.settings
        updatePickers()
    }
    override func viewDidAppear() {
        self.view.window?.styleMask.remove(NSWindow.StyleMask.resizable)

    }
    
}
