//
//  WelcomeVC.swift
//  ZAGraphics
//
//  Created by phucnh7 on 5/12/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

import UIKit

class WelcomeVC: UIViewController {

    let camera = try! ZACamera()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let w = view.frame.width / 2
        let h = view.frame.height / 2
        
        let multiConsumerBtn = UIButton(frame: CGRect(x: 0, y: 0, width: w, height: h))
        multiConsumerBtn.backgroundColor = .lightGray
        multiConsumerBtn.setTitle("Multi consumer", for: .normal)
        multiConsumerBtn.addTarget(self, action: #selector(openMultiConsumers), for: .touchUpInside)
        view.addSubview(multiConsumerBtn)
        
        let multiFilterBtn = UIButton(frame: CGRect(x: w, y: 0, width: w, height: h))
        multiFilterBtn.backgroundColor = .systemPink
        multiFilterBtn.setTitle("Multi filter", for: .normal)
        multiFilterBtn.addTarget(self, action: #selector(openMultiFilter), for: .touchUpInside)
        view.addSubview(multiFilterBtn)
        
        let stickerBtn = UIButton(frame: CGRect(x: 0, y: h, width: w, height: h))
        stickerBtn.backgroundColor = .green
        stickerBtn.setTitle("Stickers consumer", for: .normal)
        stickerBtn.addTarget(self, action: #selector(openSticksConsumer), for: .touchUpInside)
        view.addSubview(stickerBtn)
        
        requestAccessCamera()
        navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 20)
    }
    
    @objc func openMultiConsumers() {
        
        camera.clear()
        
        let w = view.frame.width / 2
        let h = view.frame.height / 2
        let consumer1 = PreviewMetalView(frame: CGRect(x: 0, y: 0, width: w, height: h))
        camera +> consumer1
        
        let saturation = ZAColorSaturation()
        let consumer2 = PreviewMetalView(frame: CGRect(x: w, y: 0, width: w, height: h))
        camera +> saturation +> consumer2
        
        let constrat = ZAColorContrast()
        let consumer3 = PreviewMetalView(frame: CGRect(x: 0, y: h, width: w, height: h))
        camera +> constrat +> consumer3
        
        let crosshatch = ZAEffectCrosshatch()
        let consumer4 = PreviewMetalView(frame: CGRect(x: w, y: h, width: w, height: h))
        camera +> crosshatch +> consumer4
        
        let vc = UIViewController()
        vc.view.addSubview(consumer1)
        vc.view.addSubview(consumer2)
        vc.view.addSubview(consumer3)
        vc.view.addSubview(consumer4)
        
        present(vc, animated: true, completion: nil)
    }
    
    @objc func openMultiFilter() {
         
         camera.clear()
         
         let w = view.frame.width
         let h = view.frame.height
        
         let saturation = ZAColorSaturation()
         let constrat = ZAColorContrast()
         let consumer1 = PreviewMetalView(frame: CGRect(x: 0, y: 0, width: w, height: h))
         camera +> saturation +> constrat +> consumer1
         
         let vc = UIViewController()
         vc.view.addSubview(consumer1)
         navigationController?.pushViewController(vc, animated: true)
     }
    
    @objc func openSticksConsumer() {
        
        camera.clear()
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "ZACameraControllerViewController") as! ZACameraControllerViewController
        
       // let vc = CameraVC()
        vc.camera = self.camera
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func openDeniedPage() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "PermisionViewController")
        navigationController?.show(vc, sender: nil)
    }

    func requestAccessCamera() {
        func startCapture() {
            try! camera.setup()
            camera.startCapture()
            //try! camera.preview(on: previewView)
        }

        switch camera.authorizationStatus() {
        case .authorized:
            startCapture()

        case .notDetermined:
            camera.requestAccess { (granted) in
                DispatchQueue.main.sync {
                    if granted {
                        startCapture()
                    } else { self.openDeniedPage()  }
                }
            }

        default:
            openDeniedPage()
        }
    }
}
