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
    
    var metalPreview: PreviewMetalView!
    
    var colectionNode: ZACollectionNode!
    
    var photos:[PhotoModel]!
    let filters = [PhotoModel]()
    
    var blendAlpha = ZABlendOperation()
    
    var camera: ZACamera!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        metalPreview = PreviewMetalView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        previewView.addSubview(metalPreview)
        previewView.sendSubviewToBack(metalPreview)

        setupFilterCollection()

        camera = try! ZACamera()

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
            self.openDeniedPage()
        }
        
        //try! camera.preview(on: previewView)
        //camera.stopCapture()
    }
    
    func setupFilterCollection() {
        colectionNode = ZACollectionNode()
        colectionNode.frame = CGRect(x: 100, y: captureButton.frame.origin.y - 220, width: view.frame.width - 100, height: 100)
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
    
    func openDeniedPage() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "PermisionViewController")
        navigationController?.show(vc, sender: nil)
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
    
    @IBAction func recordButtonDidClick(_ sender: Any) {
        let width = view.frame.width / 4
        let height = view.frame.height / 5
        
        let spaceWidth = view.frame.width
        let spaceHeight = view.frame.height
        
        let sticker = ZAStickControl(frame: CGRect(x: 0, y: 0, width: width, height: height))
        
        sticker.didMove = { sender, translation in
            sticker.frame.origin = CGPoint(x: sticker.frame.origin.x + translation.x,
                                           y: sticker.frame.origin.y + translation.y)
            
            let tl = CGPoint(x: 0 - sticker.frame.origin.x / spaceWidth, y: 0 - sticker.frame.origin.y / spaceHeight)
            let bl = CGPoint(x: tl.x, y: 1 - (sticker.frame.origin.y + height) / spaceHeight)
            let br = CGPoint(x: 1 - (sticker.frame.origin.x + width) / spaceWidth, y: bl.y)
            let tr = CGPoint(x: tl.y, y: br.x)
            
//            let tl = CGPoint(x: 0, y: 0)
//            let bl = CGPoint(x: 0, y: 2)
//            let br = CGPoint(x: 2, y: 2)
//            let tr = CGPoint(x: 2, y: 0)
            
            self.blendAlpha.updateVerties(topleft: tl,
                                     bottomleft: bl,
                                     bottomright: br,
                                     topright: tr)
            
        }
        
        view.addSubview(sticker)
    }
    
}

extension ZACameraControllerViewController: ZACollectionDelegate {
    
    func collectionNode(_ collectionNode: ZACollectionNode, didSelectItemAt indexPath: IndexPath, with model: PhotoModel) {
        if let filter = model as? ZAFilterModel {
            camera.clear()
            
            if filter.filter == .AlphaBlend {
                camera +> blendAlpha +> metalPreview
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

extension ZACameraControllerViewController: ZACollectionDatasource {
    func dataSourceFor(collection: ZACollectionNode) -> [PhotoModel]? {
        return photos
    }
}
