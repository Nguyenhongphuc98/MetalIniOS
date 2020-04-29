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
    
    var metalPreview: MetalView!
    
    var sketchBtn: UIButton!
    var inversionBtn: UIButton!
    
    let sketch = ZAColorSketch()
    let inversion = ZAColorInversion()
    
    var camera: ZACamera!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        metalPreview = MetalView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        previewView.addSubview(metalPreview)
        previewView.sendSubviewToBack(metalPreview)
        

        sketchBtn = UIButton(frame: CGRect(x: 30 + 0 * (80 + 20), y: 20, width: 80, height: 40))
        sketchBtn.backgroundColor = .gray
        sketchBtn.setTitle("Sketch", for: .normal)
        previewView.addSubview(sketchBtn)
        sketchBtn.addTarget(self, action: #selector(changeFilterDidClick(sender:)), for: .touchUpInside)
        
        inversionBtn = UIButton(frame: CGRect(x: 30 + 1 * (80 + 20), y: 20, width: 80, height: 40))
        inversionBtn.backgroundColor = .gray
        inversionBtn.setTitle("Insersion", for: .normal)
        previewView.addSubview(inversionBtn)
        inversionBtn.addTarget(self, action: #selector(changeFilterDidClick(sender:)), for: .touchUpInside)
        
        

        camera = try! ZACamera(preset: .high)
        
        func openDeniedPage() {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "PermisionViewController")
            navigationController?.show(vc, sender: nil)
        }
        
        func startCapture() {
            try! camera.setup()

            camera.startCapture()
            try! camera.preview(on: previewView)
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
    
    @objc func changeFilterDidClick(sender: UIButton) {
        if sender === sketchBtn {
            camera.clear()
            camera+>sketch+>metalPreview
        } else {
            camera.clear()
            camera+>inversion+>metalPreview
        }
    }
}
