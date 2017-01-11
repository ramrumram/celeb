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

class SignViewController: UIViewController, UIScrollViewDelegate
{
    

  
    
    @IBOutlet weak var btnColorPicker: UIButton!
    
    @IBOutlet weak var toolsView: UIView!
    
    var allowZoom = true
    
    var image: UIImage?
  
    var touchOrigin: UIImageView?
    
    let keychain = KeychainSwift()

    @IBOutlet var lblInfo: UILabel!

    
    @IBOutlet var viewContainer: UIView!
    
    var screenSize: CGRect = UIScreen.main.bounds
    
    
    @IBOutlet var scrollView: UIScrollView!
    
    
    @IBOutlet var imgView: UIImageView!
    

    var colorPicked = UIColor.white
    var currentOrientation = "landscape"
    
    
    let hermitePath = UIBezierPath()
    var interpolationPoints = [CGPoint]()
    
    let backgroundLayer1 = CAShapeLayer()
    let drawingLayer = CAShapeLayer()
    let zoomLayer = CAShapeLayer()
    let LineLayer = CAShapeLayer()
    let LineLayer2 = CAShapeLayer()
    let LineLayer3 = CAShapeLayer()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
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
        
        scrollView.delegate = self
        
        //        imgView.image = image!


        backgroundLayer1.strokeColor = UIColor.white.cgColor
        backgroundLayer1.fillColor = nil
        backgroundLayer1.lineWidth = 3.0
        
        backgroundLayer1.lineCap = kCALineCapRound
        backgroundLayer1.lineJoin = kCALineJoinBevel
        backgroundLayer1.frame = imgView.bounds
        
        
        imgView.layer.insertSublayer(backgroundLayer1, at: 0)
        
        
        drawingLayer.strokeColor = UIColor.white.cgColor
        drawingLayer.fillColor = nil
        drawingLayer.lineWidth = 3.0

        imgView.layer.insertSublayer(drawingLayer, at: 1)
        
        
        
        zoomLayer.frame = imgView.bounds
        zoomLayer.backgroundColor =  UIColor.brown.withAlphaComponent(0.5).cgColor
        


        LineLayer.frame =  CGRect(x: (imgView.bounds.width / 7), y: (imgView.bounds.height / 7), width: (imgView.bounds.width / 1.3) , height: 2)
        LineLayer.backgroundColor =  UIColor.white.cgColor

        LineLayer2.frame =  CGRect(x: (imgView.bounds.width / 7), y: (imgView.bounds.height / 4), width: (imgView.bounds.width / 1.3) , height: 2)
        LineLayer2.backgroundColor =  UIColor.white.cgColor


        LineLayer3.frame =  CGRect(x: (imgView.bounds.width / 7), y: (imgView.bounds.height / 1.2), width: (imgView.bounds.width / 1.3) , height: 2)
        LineLayer3.backgroundColor =  UIColor.white.cgColor
        
        
        imgView.layer.insertSublayer(LineLayer, at: 0)
        imgView.layer.insertSublayer(LineLayer2, at: 0)
        imgView.layer.insertSublayer(LineLayer3, at: 0)
        
        

       
        zoomAssign()
        
        imgView.layer.masksToBounds = true
        view.layoutIfNeeded()
        
        btnColorPicker.setRadius(radius: 10)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap2.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap2)
        
        
        
        portraitOps()
        
       
        
    }
    
    
    func zoomAssign() {
        scrollView.isUserInteractionEnabled = allowZoom
        scrollView.isScrollEnabled = allowZoom
        
        if (allowZoom) {
            imgView.layer.insertSublayer(zoomLayer, at: 3)
            toolsView.isHidden = false
        }else {
            zoomLayer.removeFromSuperlayer()
            toolsView.isHidden = true
        }
    }
    
    
    func doubleTapped() {
        
         zoomAssign()
       
         allowZoom = !allowZoom
        
    
    }
    
    
  
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        
        //from potrati..then its landsap
        if(fromInterfaceOrientation.isPortrait) {
            
            landscapeOps()
            
        }else {
            
            // if it is moving to potrait and passed landscape it should be the last scene...
            //so if user manually roates the screen bing him to last
            
            portraitOps()
        }
    }
    
    
    
    func landscapeOps(){
        
        
        currentOrientation = "landscape"

        scrollView.minimumZoomScale = 1.5
        scrollView.maximumZoomScale = 5.0
        
        scrollView.setZoomScale(1.5, animated: false)
        
    }
    
    
    func portraitOps(){
        
        currentOrientation = "portrait"
        
        scrollView.minimumZoomScale = 1.1
        scrollView.maximumZoomScale = 4.0
        
        scrollView.setZoomScale(1.1, animated: false)
        
    }
    
    
    func stageOps(){
        
            lblInfo.text = keychain.get("currentReqmsg")
            
    }
    
    
   
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imgView
    }
    
  
    

    
    @IBAction func btnPrev(_ sender: AnyObject) {
        
        
     
      
        
    }
    
    @IBAction func btnNext(_ sender: AnyObject) {
        // hermiteScribbleView.moveNext()
        
        
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
        guard let
            location = touches.first?.location(in: self.view) else
        {
            return
        }
        
        if(imgView.frame.contains(location))
        {
            touchOrigin = imgView
        }
            
        else
        {
            touchOrigin = nil
            return
        }
        
        if let adjustedLocationInView = touches.first?.location(in: touchOrigin)
        {
            interpolationPoints = [adjustedLocationInView]
            //imgView.beginScribble(adjustedLocationInView)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        guard let
            touch = touches.first,
            let coalescedTouches = event?.coalescedTouches(for: touch),
            let touchOrigin = touchOrigin
            else
        {
            return
        }
        
        coalescedTouches.forEach
            {
               // imgView.appendScribble($0.location(in: touchOrigin))
                
                interpolationPoints.append($0.location(in: touchOrigin))
                hermitePath.removeAllPoints()
                hermitePath.interpolatePointsWithHermite(interpolationPoints)
                drawingLayer.path = hermitePath.cgPath

        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
      
        
        if let backgroundPath = backgroundLayer1.path
        {
            hermitePath.append(UIBezierPath(cgPath: backgroundPath))
        }
        
        backgroundLayer1.path = hermitePath.cgPath
        
        hermitePath.removeAllPoints()
        
        drawingLayer.path = hermitePath.cgPath
    }
    
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?)
    {
        if motion == UIEventSubtype.motionShake
        {
            backgroundLayer1.path = nil
            
        }
    }
    
    override func viewDidLayoutSubviews()
    {
        
        super.viewDidLayoutSubviews()
        
      /*  imgView.frame = CGRect(x: 0,
                                 y: topLayoutGuide.length,
                                 width: view.frame.width,
                                 height: view.frame.height - topLayoutGuide.length).insetBy(dx: 10, dy: 10)
 
    */
        
    }
    
    
    @IBAction func btnReset(_ sender: AnyObject) {
        
    }
    
    @IBAction func btnColor(_ sender: Any) {
        colorPicked = (colorPicked == UIColor.white ? UIColor.black : UIColor.white)
        btnColorPicker.backgroundColor = colorPicked
        
        backgroundLayer1.strokeColor = colorPicked.cgColor
        drawingLayer.strokeColor = colorPicked.cgColor


    }
    
    @IBAction func btnDone(_ sender: Any) {
        let vc: FinalViewController? = self.storyboard?.instantiateViewController(withIdentifier: "FinalVC") as? FinalViewController
        if let validVC: FinalViewController = vc {
            if let capturedImage = imgView.image {
                validVC.image = capturedImage
                self.navigationController?.pushViewController(validVC, animated: true)
            }
        }
    }
}

