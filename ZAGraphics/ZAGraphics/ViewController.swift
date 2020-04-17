//
//  ViewController.swift
//  ZAGraphics
//
//  Created by phucnh7 on 4/13/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var metalView: MetalView!
    @IBOutlet weak var wireFrameButton: UIButton!
    
    @IBOutlet weak var upButton: UIButton!
    @IBOutlet weak var DownButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    var isOn:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func wireFrameButtonDidClick(_ sender: Any) {
        isOn = !isOn
        metalView.toggleWireFrame(isOn: isOn)
        
        if isOn {
            wireFrameButton.setTitle("WireFrame On", for: .normal)
        } else {
             wireFrameButton.setTitle("WireFrame Off", for: .normal)
        }
    }
    
    
    @IBAction func didUp(_ sender: Any) {
        InputHandler.setKeyPressed(key: KEY_CODES.UP, isOn: false)
    }
    
    @IBAction func didDown(_ sender: Any) {
         InputHandler.setKeyPressed(key: KEY_CODES.DOWN, isOn: false)
    }
    
    @IBAction func didleft(_ sender: Any) {
         InputHandler.setKeyPressed(key: KEY_CODES.LEFT, isOn: false)
    }
    
    @IBAction func didRight(_ sender: Any) {
         InputHandler.setKeyPressed(key: KEY_CODES.RIGHT, isOn: false)
    }
    
    //press
    @IBAction func didDownUP(_ sender: Any) {
        InputHandler.setKeyPressed(key: KEY_CODES.UP, isOn: true)
    }
    
    @IBAction func didDownDown(_ sender: Any) {
        InputHandler.setKeyPressed(key: KEY_CODES.DOWN, isOn: true)
    }
    
    @IBAction func didDownLeft(_ sender: Any) {
        InputHandler.setKeyPressed(key: KEY_CODES.LEFT, isOn: true)
    }
    
    @IBAction func didDownRight(_ sender: Any) {
        InputHandler.setKeyPressed(key: KEY_CODES.RIGHT, isOn: true)
    }
    
    @IBAction func nearUP(_ sender: Any) {
        InputHandler.setKeyPressed(key: KEY_CODES.NEAR, isOn: false)
    }
    
    @IBAction func nearDown(_ sender: Any) {
        InputHandler.setKeyPressed(key: KEY_CODES.NEAR, isOn: true)
    }
    
    @IBAction func farUp(_ sender: Any) {
        InputHandler.setKeyPressed(key: KEY_CODES.FAR, isOn: false)
    }
    
    @IBAction func farDown(_ sender: Any) {
        InputHandler.setKeyPressed(key: KEY_CODES.FAR, isOn: true)
    }
    
    @IBAction func didChangeMode(_ sender: Any) {
        InputHandler.changeMode()
    }
}

