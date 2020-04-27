//
//  PermisionViewController.swift
//  ZAGraphics
//
//  Created by phucnh7 on 4/27/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

import UIKit

class PermisionViewController: UIViewController {
    
    @IBOutlet weak var settingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    func setup() {
        settingButton.backgroundColor = UIColor(displayP3Red: 49 / 255, green: 166 / 255, blue: 245 / 255, alpha: 1)
        settingButton.setTitleColor(.white, for: .normal)
        settingButton.setTitleColor(.orange, for: .highlighted)
        settingButton.layer.cornerRadius = settingButton.frame.height / 2
    }
    
    @IBAction func settingButtonDidClick(_ sender: Any) {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}
