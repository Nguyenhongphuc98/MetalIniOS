//
//  ZACameraControllerViewController.swift
//  ZAGraphics
//
//  Created by phucnh7 on 4/20/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

import UIKit

class ZACameraControllerViewController: UIViewController {

    
    @IBOutlet weak var captureButton: UIButton!
    @IBOutlet weak var videoModeButton: UIButton!
    @IBOutlet weak var cameraModeButton: UIButton!
    @IBOutlet weak var toggleCameraButton: UIButton!
    @IBOutlet weak var toggleFlashButton: UIButton!
    @IBOutlet weak var previewView: UIView!
    
    var camera: ZACamera!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)

        camera = try! ZACamera(preset: .high)
        
        func openDeniedPage() {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "PermisionViewController")
            navigationController?.show(vc, sender: nil)
        }
        
        func startCapture() {
            try! camera.setup()
            camera.startCapture()
        }
        
        switch camera.authorizationStatus() {
        case .authorized:
            startCapture()
            
        case .notDetermined:
            camera.requestAccess { (granted) in
                DispatchQueue.main.sync {
                    if granted {
                        startCapture()
                    } else {
                        openDeniedPage()
                    }
                }
            }
            
        default:
            openDeniedPage()
        }
        
        //try! camera.preview(on: previewView)
        //camera.stopCapture()
    }
    
    @IBAction func switchCameraDidClick(_ sender: Any) {
        try! camera.switchCamera()
        if camera.position == .front {
             toggleCameraButton.setImage(#imageLiteral(resourceName: "Front Camera Icon"), for: .normal)
        } else {
             toggleCameraButton.setImage(#imageLiteral(resourceName: "Rear Camera Icon"), for: .normal)
        }
       
    }
    
    @IBAction func captureButtonDidClick(_ sender: Any) {
    
    }
}
