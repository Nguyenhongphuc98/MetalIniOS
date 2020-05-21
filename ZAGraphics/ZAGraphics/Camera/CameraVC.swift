//
//  CameraVC.swift
//  ZAGraphics
//
//  Created by phucnh7 on 5/12/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

import UIKit
import AVFoundation

class CameraVC: UIViewController {
    
    var captureButton: UIButton!
    
    var videoModeButton: UIButton!
    
    var cameraModeButton: UIButton!
    
    var toggleCameraButton: UIButton!
    
    var toggleFlashButton: UIButton!
    
    var cameraPreviewView: ZACameraView!
    
    var colectionNode: ZACollectionNode!
    
    var photos:[PhotoModel]!
    
    var agapi: ZABlendSticker!
    
    var rose: ZABlendSticker!
    
    public var camera: ZACamera!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        captureButton = ZACaptureButton(frame: CGRect(x: (view.frame.width - 55) / 2, y: view.frame.height - 100, width: 55, height: 55))
        captureButton.addTarget(self, action: #selector(captureButtonDidClick(_:)), for: .touchUpInside)
        view.addSubview(captureButton)
        
        videoModeButton = UIButton(frame: CGRect(x: 40, y: view.frame.height - 152, width: 44, height: 44))
        videoModeButton.addTarget(self, action: #selector(videoButtonDidclick(_:)), for: .touchUpInside)
        videoModeButton.setImage(#imageLiteral(resourceName: "Video Camera Icon"), for: .normal)
        view.addSubview(videoModeButton)
        
        cameraModeButton = UIButton(frame: CGRect(x: 40, y: view.frame.height - 100, width: 44, height: 44))
        cameraModeButton.setImage(#imageLiteral(resourceName: "Photo Camera Icon"), for: .normal)
        cameraModeButton.addTarget(self, action: #selector(cameraButtonDidClick(_:)), for: .touchUpInside)
        view.addSubview(cameraModeButton)
        
        toggleFlashButton = UIButton(frame: CGRect(x: view.frame.width - 44 - 40, y: 40, width: 44, height: 44))
        toggleFlashButton.setImage(#imageLiteral(resourceName: "Flash On Icon"), for: .normal)
        toggleFlashButton.addTarget(self, action: #selector(flashButtonDidClick(_:)), for: .touchUpInside)
        view.addSubview(toggleFlashButton)
        
        toggleCameraButton = UIButton(frame: CGRect(x: view.frame.width - 44 - 40, y: 92, width: 44, height: 44))
        toggleCameraButton.setImage(#imageLiteral(resourceName: "Rear Camera Icon"), for: .normal)
        toggleCameraButton.addTarget(self, action: #selector(switchCameraDidClick(_:)), for: .touchUpInside)
        view.addSubview(toggleCameraButton)
        
        cameraPreviewView = ZACameraView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        view.addSubview(cameraPreviewView)
        view.sendSubviewToBack(cameraPreviewView)
        
        cameraPreviewView.didFocus = { [unowned self] position in
            self.camera.focus(at: position)
        }
        cameraPreviewView.didZoom = { [unowned self] scale in
            self.camera.zoom(factor: scale)
        }
        cameraPreviewView.didEndZoom = { [unowned self] scale in
            self.camera.resetZoom(factor: scale)
        }
        
        let width: CGFloat = 100
        let height: CGFloat = 86
        
        let spaceWidth = view.frame.width
        let spaceHeight = view.frame.height
        let anchor = CGPoint(x: (spaceWidth - width) / 2, y: (spaceHeight - height) / 2)
        let stickerFrame = CGRect(x: anchor.x, y: anchor.y, width: width, height: height)
        
        agapi = ZABlendSticker(frame: stickerFrame,
                               spaceWidth: spaceWidth,
                               spaceHeight: spaceHeight,
                               image: "qoobee_agapi.png")
        
        rose = ZABlendSticker(frame: stickerFrame,
                              spaceWidth: spaceWidth,
                              spaceHeight: spaceHeight,
                              image: "agapi_rose.png")
        
        setupFilterCollection()
        camera +> cameraPreviewView
        camera.delegate = self
        camera.addMetadataOutput(with: [.face])
    }
    
    func setupFilterCollection() {
        colectionNode = ZACollectionNode()
        colectionNode.frame = CGRect(x: 100, y: captureButton.frame.origin.y - 110, width: view.frame.width - 100, height: 100)
        view.addSubnode(colectionNode)
        colectionNode.delegate = self
        colectionNode.dataSource = self
        
        //make temp data
        photos = []
        photos.append(ZAFilterModel(image: UIImage(named: "sample.jpg")!, type: .LookupTable))
        photos.append(ZAFilterModel(image: UIImage(named: "sample.jpg")!, type: .Inversion))
        photos.append(ZAFilterModel(image: UIImage(named: "sample.jpg")!, type: .Saturation))
        photos.append(ZAFilterModel(image: UIImage(named: "sample.jpg")!, type: .Contrast))
        photos.append(ZAFilterModel(image: UIImage(named: "sample.jpg")!, type: .Exposure))
        photos.append(ZAFilterModel(image: UIImage(named: "sample.jpg")!, type: .Crosshatch))
        photos.append(ZAFilterModel(image: UIImage(named: "sample.jpg")!, type: .AlphaBlend))
        
        colectionNode.reloadData()
    }
    
    @objc func switchCameraDidClick(_ sender: Any) {
        try! camera.switchCamera()
        if camera.position == .front {
            toggleCameraButton.setImage(#imageLiteral(resourceName: "Front Camera Icon"), for: .normal)
        } else {
            toggleCameraButton.setImage(#imageLiteral(resourceName: "Rear Camera Icon"), for: .normal)
        }
        
    }
    
    var count :Int = 0
    var recoder: VideoRecorder = VideoRecorder(size: CGSize(width: 720, height: 1280))
    @objc func captureButtonDidClick(_ sender: Any) {
//        let vc = UIViewController()
//        let imageView = UIImageView(frame: view.bounds)
//
//        imageView.image = UIImage(cgImage: cameraPreviewView.captureTexture.makeCGImage2()!)
//        vc.view.addSubview(imageView)
//        navigationController?.present(vc, animated: true, completion: nil)
        if count == 0 {

            recoder.timeRecordDidChange = { elapsed in
             
                let minutes = elapsed / 60
                let seconds = elapsed % 60
                
                var strSeconds = String("0\(seconds)")
                strSeconds = String(strSeconds.dropFirst(strSeconds.count - 2))
                var strMinutes = String("0\(minutes)")
                strMinutes = String(strMinutes.dropFirst(strMinutes.count - 2))
                
                let timeDisplay = String("\(strMinutes):\(strSeconds)")
                
                DispatchQueue.main.async {
                    self.cameraPreviewView.timeElapsedView.text = timeDisplay
                }
            }
            camera +> recoder
            recoder.startRecord()
            count += 1
        } else {
            recoder.stopRecord(saveToLib: true) { (url) in
                /// Because save to lib so we don't need care about url, this file was delete by default
            }
        }
    }
    
    @objc func videoButtonDidclick(_ sender: Any) {
        
        agapi.remove(consumer: cameraPreviewView)
        agapi.control.removeFromSuperview()
        camera.clear()
        
        camera +> agapi +> cameraPreviewView
        //agapi +> recoder
        
        view.addSubview(agapi.control)
    }
    
    @objc func cameraButtonDidClick(_ sender: Any) {
        
        agapi.remove(consumer: cameraPreviewView)
        rose.remove(consumer: agapi)
        camera.clear()
        
        rose.control.removeFromSuperview()
        agapi.control.removeFromSuperview()
    
        camera +> rose +> agapi +> cameraPreviewView
        
        view.addSubview(rose.control)
        view.addSubview(agapi.control)
    }
    
    @objc func flashButtonDidClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension CameraVC: ZACollectionDelegate {
    
    func collectionNode(_ collectionNode: ZACollectionNode, didSelectItemAt indexPath: IndexPath, with model: PhotoModel) {
        if let filter = model as? ZAFilterModel {
            camera.clear()
            
            if filter.filter == .AlphaBlend {
                camera +> cameraPreviewView
                return
            }
            
            if filter.filter != .None {
                let operation = filter.filter.getOperation()
                camera +> operation +> cameraPreviewView
                
            } else {
                camera +> cameraPreviewView
            }
        }
    }
}

extension CameraVC: ZACollectionDatasource {
    func dataSourceFor(collection: ZACollectionNode) -> [PhotoModel]? {
        return photos
    }
}

extension CameraVC: ZACameraDelegte {
    
    func camera(_ camera: ZACamera, didOutput metadataObjects: [AVMetadataObject]) {
       
        DispatchQueue.main.async { 
            if let face = metadataObjects.first?.bounds {
                self.cameraPreviewView.updateFace(frame: face)
            } else {
                self.cameraPreviewView.updateFace(frame: .zero)
            }
        }
    }
}
