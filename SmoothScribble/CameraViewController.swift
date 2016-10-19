//
//  CameraViewController.swift
//  Celebgrams
//
//  Created by dev on 9/26/16.
//  Copyright © 2016 Simon Gladman. All rights reserved.
//

import UIKit
import CameraManager


class CameraViewController: UIViewController {
    @IBOutlet var cameraView: UIView!

    @IBOutlet var overlayView: UIView!
    let cameraManager = CameraManager()

    override func viewDidLoad() {
        super.viewDidLoad()

    
        cameraManager.showAccessPermissionPopupAutomatically = true
        cameraManager.writeFilesToPhoneLibrary = false

        cameraManager.flashMode = .auto
        cameraManager.cameraDevice = .front

        
        let currentCameraState = cameraManager.currentCameraStatus()
        
        if currentCameraState == .notDetermined {
          
        } else if (currentCameraState == .ready) {
            addCameraToView()
        }

 
        
        UINavigationBar.appearance().barStyle = .blackTranslucent

        // Do any additional setup after loading the view.
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        cameraManager.resumeCaptureSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
        cameraManager.stopCaptureSession()
    }
    
    
    fileprivate func addCameraToView()
    {
        cameraManager.cameraOutputQuality = .high

        cameraManager.addPreviewLayerToView(cameraView, newCameraOutputMode: CameraOutputMode.stillImage)
        cameraManager.showErrorBlock = { [weak self] (erTitle: String, erMessage: String) -> Void in
            
            let alertController = UIAlertController(title: erTitle, message: erMessage, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (alertAction) -> Void in  }))
            
            self?.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
   
    
    
    @IBAction func btnCapture(_ sender: AnyObject) {
 
        cameraManager.capturePictureWithCompletion({ (image, error) -> Void in
            
            if let errorOccured = error {
                self.cameraManager.showErrorBlock("Error occurred", errorOccured.localizedDescription)
            }
            else {
                let vc: ImageViewController? = self.storyboard?.instantiateViewController(withIdentifier: "ImageVC") as? ImageViewController
                if let validVC: ImageViewController = vc {
                    if let capturedImage = image {
                                                
                        
                        
                        validVC.image = capturedImage
                        self.navigationController?.pushViewController(validVC, animated: true)
                    }
                }
            }
        })
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
