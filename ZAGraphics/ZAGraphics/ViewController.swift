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
}

