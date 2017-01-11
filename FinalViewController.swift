//
//  ViewController.swift
//  SmoothScribble
//
//  Created by Simon Gladman on 04/11/2015.
//  Copyright © 2015 Simon Gladman. All rights reserved.
//

import UIKit
import KeychainSwift
import Alamofire
import NVActivityIndicatorView

class FinalViewController: UIViewController, UIScrollViewDelegate, communicationControllerPopup
{
    
    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTrailingConstraint: NSLayoutConstraint!
    
    let stackView = UIStackView()
    var image: UIImage?
    
    let hermiteScribbleView = HermiteScribbleView()
    
    var touchOrigin: ScribbleView?
    
    let keychain = KeychainSwift()
    
    @IBOutlet var topHomePrev: UIView!
    
    
    @IBOutlet var topStack: UIStackView!
    
    
    @IBOutlet var bottomStack: UIStackView!
    @IBOutlet var viewContainer: UIView!
    
    var screenSize: CGRect = UIScreen.main.bounds
    
    
    @IBOutlet var scrollView: UIScrollView!
    
    
    @IBOutlet var imgView: UIImageView!
    
    @IBOutlet var viewReset: UIView!
    
    @IBOutlet var viewSubmit: UIView!
    
    var currentOrientation = "portrait"
    
    
    
    @IBAction func saveAs(_ sender: AnyObject) {
        
        let popup: SendMessageViewController? = self.storyboard?.instantiateViewController(withIdentifier: "SendMsgPopup") as? SendMessageViewController
        
        popup?.delegate = self
        
        self.present(popup!, animated: true, completion: nil)
        
    }
    
    
    func backFromPopup(value: String) {
        
        UIGraphicsBeginImageContextWithOptions(viewContainer.bounds.size, viewContainer.isOpaque, 0.0)
        viewContainer!.drawHierarchy(in: viewContainer.bounds, afterScreenUpdates: false)
        let snapshotImageFromMyView = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        
        //UIImageWriteToSavedPhotosAlbum(snapshotImageFromMyView!, nil,nil, nil);
        
        
        // define parameters
        let parameters = [
            "message": value,
            "token": TOKEN
        ]
        
        
        let req = self.keychain.get("currentReqID")
        let up_url = IMG_UP_URL + "/" + self.keychain.get("CG_uid")!
        
        
        let alert = UIAlertController(title: "Error", message: "Error in uploading your picture! please try again later", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        
        let frame = CGRect(x: (screenSize.width / 2) - 10, y: screenSize.height / 2, width: 30, height: 30)
        NVActivityIndicatorView.DEFAULT_TYPE = .ballPulseSync
        let activityIndicatorView = NVActivityIndicatorView(frame: frame)
        self.view.addSubview(activityIndicatorView)
        
        activityIndicatorView.startAnimating()
        // let
        Alamofire.upload(multipartFormData: { multipartFormData in
            if let imageData = UIImageJPEGRepresentation(snapshotImageFromMyView!, 1) {
                multipartFormData.append(imageData, withName: "file", fileName: "Image_"+req!+".png", mimeType: "image/png")
            }
            
            for (key, value) in parameters {
                multipartFormData.append((value.data(using: .utf8))!, withName: key)
            }}, to: up_url, method: .post,
                encodingCompletion: { encodingResult in
                    
                    switch encodingResult {
                    case .success(let upload, _, _):
                        
                        upload.response { [weak self] response in
                            guard self != nil else {
                                self?.present(alert, animated: true, completion: nil)
                                return
                            }
                            
                            activityIndicatorView.stopAnimating()
                            //  debugPrint(response)
                            let vc: MailboxViewController? = self?.storyboard?.instantiateViewController(withIdentifier: "ImageQueue") as? MailboxViewController
                            
                            self?.navigationController?.pushViewController(vc!, animated: true)
                            
                            
                        }
                    case .failure(let encodingError):
                        self.present(alert, animated: true, completion: nil)
                    }
        })
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //  let value = UIInterfaceOrientation.landscapeLeft.rawValue
        //   UIDevice.current.setValue(value, forKey: "orientation")
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        
        //   scrollView.isScrollEnabled = false
        
                imgView.image = image!
        
        viewContainer.addSubview(stackView)
        
        
        //    stackView.addArrangedSubview(hermiteScribbleView)
        
        
    }
    
    
    
 
    
    
    
    
    
    
    @IBAction func btnSend(_ sender: Any) {
        
        
    }
    
   
 
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imgView
    }
    
 
    
    private func updateMinZoomScaleForSize(size: CGSize) {
        let widthScale = size.width / imgView.bounds.width
        let heightScale = size.height / imgView.bounds.height
        let minScale = min(widthScale, heightScale)
        
        scrollView.minimumZoomScale = minScale
        
        scrollView.zoomScale = minScale
    }
    
    

    
    @IBAction func btnPrev(_ sender: AnyObject) {
        
     
        
    }
    

    
    

    
}

