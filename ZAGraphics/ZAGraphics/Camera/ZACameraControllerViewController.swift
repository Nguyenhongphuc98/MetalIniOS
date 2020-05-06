//
//  ZACameraControllerViewController.swift
//  ZAGraphics
//
//  Created by phucnh7 on 4/20/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

import AsyncDisplayKit

class ZACameraControllerViewController: UIViewController {

    @IBOutlet weak var captureButton: UIButton!
    @IBOutlet weak var videoModeButton: UIButton!
    @IBOutlet weak var cameraModeButton: UIButton!
    @IBOutlet weak var toggleCameraButton: UIButton!
    @IBOutlet weak var toggleFlashButton: UIButton!
    @IBOutlet weak var previewView: UIView!
    
    var metalPreview: MetalView!
    
    var colectionNode: ZACollectionNode!
    
    var photos:[PhotoModel]!
    let filters = [PhotoModel]()
    
    var camera: ZACamera!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        metalPreview = MetalView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        previewView.addSubview(metalPreview)
        previewView.sendSubviewToBack(metalPreview)
        
        setupFilterCollection()
    
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
    
    func setupFilterCollection() {
        colectionNode = ZACollectionNode()
        colectionNode.frame = CGRect(x: 100, y: captureButton.frame.origin.y - 220, width: view.frame.width, height: 100)
        view.addSubnode(colectionNode)
        colectionNode.delegate = self
        colectionNode.dataSource = self
        
        //make temp data
        photos = []
        photos.append(ZAFilterModel(image: UIImage(named: "image_0.png")!, type: .FilterNone))
        photos.append(ZAFilterModel(image: UIImage(named: "image_1.jpg")!, type: .FilterInversion))
        photos.append(ZAFilterModel(image: UIImage(named: "image_0.png")!, type: .FilterSketch))
        photos.append(ZAFilterModel(image: UIImage(named: "image_0.png")!, type: .FilterSaturation))
        photos.append(ZAFilterModel(image: UIImage(named: "image_0.png")!, type: .FilterSketch))
        photos.append(ZAFilterModel(image: UIImage(named: "image_0.png")!, type: .FilterSketch))
        
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
    
    }
    
}

extension ZACameraControllerViewController: ZACollectionDelegate {
    
    func collectionNode(_ collectionNode: ZACollectionNode, didSelectItemAt indexPath: IndexPath, with model: PhotoModel) {
        if let filter = model as? ZAFilterModel {
            let operation = filter.filter.getOperation()
            camera+>operation+>metalPreview
        }
    }
}

extension ZACameraControllerViewController: ZACollectionDatasource {
    func dataSourceFor(collection: ZACollectionNode) -> [PhotoModel]? {
        return photos
    }
}
