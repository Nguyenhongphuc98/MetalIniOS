//
//  CameraVC.swift
//  ZAGraphics
//
//  Created by phucnh7 on 5/12/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

import UIKit

class CameraVC: UIViewController {
    
    var captureButton: UIButton!
    
    var videoModeButton: UIButton!
    
    var cameraModeButton: UIButton!
    
    var toggleCameraButton: UIButton!
    
    var toggleFlashButton: UIButton!
    
    var metalPreview: PreviewMetalView!
    
    var colectionNode: ZACollectionNode!
    
    var photos:[PhotoModel]!
    
    var agapi: ZABlendSticker!
    
    var rose: ZABlendSticker!
    
    public var camera: ZACamera!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        captureButton = ZACaptureButton(frame: CGRect(x: (view.frame.width - 55) / 2, y: view.frame.height - 100, width: 55, height: 55))
        
        videoModeButton = UIButton(frame: CGRect(x: 40, y: view.frame.height - 152, width: 44, height: 44))
        videoModeButton.setImage(#imageLiteral(resourceName: "Video Camera Icon"), for: .normal)
        view.addSubview(videoModeButton)
        
        cameraModeButton = UIButton(frame: CGRect(x: 40, y: view.frame.height - 100, width: 44, height: 44))
        cameraModeButton.setImage(#imageLiteral(resourceName: "Photo Camera Icon"), for: .normal)
        view.addSubview(cameraModeButton)
        
        toggleFlashButton = UIButton(frame: CGRect(x: view.frame.width - 44 - 40, y: 40, width: 44, height: 44))
        toggleFlashButton.setImage(#imageLiteral(resourceName: "Flash On Icon"), for: .normal)
        view.addSubview(toggleFlashButton)
        
        toggleCameraButton = UIButton(frame: CGRect(x: view.frame.width - 44 - 40, y: 92, width: 44, height: 44))
        captureButton.setImage(#imageLiteral(resourceName: "Rear Camera Icon"), for: .normal)
        view.addSubview(toggleCameraButton)
        
        metalPreview = PreviewMetalView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        view.addSubview(metalPreview)
        view.sendSubviewToBack(metalPreview)
        
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
    }
    
    func setupFilterCollection() {
        colectionNode = ZACollectionNode()
        colectionNode.frame = CGRect(x: 100, y: captureButton.frame.origin.y - 280, width: view.frame.width - 100, height: 100)
        view.addSubnode(colectionNode)
        colectionNode.delegate = self
        colectionNode.dataSource = self
        
        //make temp data
        photos = []
        photos.append(ZAFilterModel(image: UIImage(named: "sample.jpg")!, type: .None))
        photos.append(ZAFilterModel(image: UIImage(named: "sample.jpg")!, type: .Inversion))
        photos.append(ZAFilterModel(image: UIImage(named: "sample.jpg")!, type: .Saturation))
        photos.append(ZAFilterModel(image: UIImage(named: "sample.jpg")!, type: .Contrast))
        photos.append(ZAFilterModel(image: UIImage(named: "sample.jpg")!, type: .Exposure))
        photos.append(ZAFilterModel(image: UIImage(named: "sample.jpg")!, type: .Crosshatch))
        photos.append(ZAFilterModel(image: UIImage(named: "sample.jpg")!, type: .AlphaBlend))
        
        colectionNode.reloadData()
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
        let vc = UIViewController()
        let imageView = UIImageView(frame: view.bounds)
        
        imageView.image = UIImage(cgImage: metalPreview.captureTexture.makeCGImage())
        vc.view.addSubview(imageView)
        navigationController?.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func videoButtonDidclick(_ sender: Any) {
        agapi.control.removeFromSuperview()
        view.addSubview(agapi.control)
        camera +> agapi +> metalPreview
    }
    
    @IBAction func cameraButtonDidClick(_ sender: Any) {
        rose.control.removeFromSuperview()
        view.addSubview(rose.control)
        camera +> rose +> agapi +> metalPreview
    }
    
    @IBAction func flashButtonDidClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

extension CameraVC: ZACollectionDelegate {
    
    func collectionNode(_ collectionNode: ZACollectionNode, didSelectItemAt indexPath: IndexPath, with model: PhotoModel) {
        if let filter = model as? ZAFilterModel {
            camera.clear()
            
            if filter.filter == .AlphaBlend {
                camera +> metalPreview
                return
            }
            
            if filter.filter != .None {
                let operation = filter.filter.getOperation()
                camera +> operation +> metalPreview
                
            } else {
                camera +> metalPreview
            }
            
        }
    }
}

extension CameraVC: ZACollectionDatasource {
    func dataSourceFor(collection: ZACollectionNode) -> [PhotoModel]? {
        return photos
    }
}