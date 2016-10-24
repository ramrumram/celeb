//
//  ViewController.swift
//  SmoothScribble
//
//  Created by Simon Gladman on 04/11/2015.
//  Copyright © 2015 Simon Gladman. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate
{
    let stackView = UIStackView()
    var image: UIImage?

    let hermiteScribbleView = HermiteScribbleView()
    
    var touchOrigin: ScribbleView?
    
    
    @IBOutlet var topHomePrev: UIView!
    @IBOutlet var topNextPrev: UIView!

    @IBOutlet var btnReset: UIButton!

    @IBOutlet var topStack: UIStackView!
    
    
    @IBOutlet var bottomStack: UIStackView!
    @IBOutlet var viewContainer: UIView!
    
    var screenSize: CGRect = UIScreen.main.bounds

    
    @IBOutlet var scrollView: UIScrollView!
    

    @IBOutlet var imgView: UIImageView!
    
    @IBOutlet var viewReset: UIView!
    
    @IBOutlet var viewUse: UIView!
    
    @IBOutlet var viewSubmit: UIView!
    @IBOutlet var lblInfo: UILabel!
    
    var currentOrientation = "portrait"
    
    @IBOutlet var imgFilter: UIImageView!
    
    
    @IBAction func saveAs(_ sender: AnyObject) {
    
        UIGraphicsBeginImageContextWithOptions(viewContainer.bounds.size, viewContainer.isOpaque, 0.0)
        viewContainer!.drawHierarchy(in: viewContainer.bounds, afterScreenUpdates: false)
        let snapshotImageFromMyView = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
    //    UIImageWriteToSavedPhotosAlbum(
//, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)

        UIImageWriteToSavedPhotosAlbum(snapshotImageFromMyView!, nil,nil, nil);

        
        
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
        
        
        scrollView.isScrollEnabled = false
        
         
        imgView.image = image!
        
        viewContainer.addSubview(stackView)

        
        stackView.addArrangedSubview(hermiteScribbleView)
        
        
//        applyFilter
   
  
     /*   let point = CGPoint()
        UIGraphicsBeginImageContextWithOptions((imgView.image?.size)!, false, 0.0)
        imgView.image?.draw(in: CGRect(x: 0, y: 0, width: (imgView.image?.size.width)!, height: (imgView.image?.size.height)!))
        imgFilter.image?.draw(in: CGRect(x: point.x, y: point.y, width: (imgView.image?.size.width)!, height: (imgView.image?.size.height)!))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        imgView.image = newImage
        
        */
        
        portraitOps()
 
    }
    
 

 

    
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
       
        //from potrati..then its landsap
        if(fromInterfaceOrientation.isPortrait) {
        
           hermiteScribbleView.currentStage = 1
            landscapeOps()
           
        }else {
            
            // if it is moving to potrait and passed landscape it should be the last scene...
            //so if user manually roates the screen bing him to last
            if (hermiteScribbleView.currentStage > 0) {
                hermiteScribbleView.currentStage = 3
            }
            
            portraitOps()
        }
    }
    
  
    
    func landscapeOps(){
        
        
        currentOrientation = "landscape"
       
        hermiteScribbleView.triggerLandscape()
        scrollView.contentSize = CGSize(width:  screenSize.height, height:  screenSize.height * 2)

        
        stageOps()
        
        scrollView.setZoomScale(2.0, animated: false)

        if(hermiteScribbleView.currentStage == 1 ) {
            
            scrollView.contentOffset = CGPoint(x: screenSize.width * 1.0 , y: -(scrollView.frame.height * 1.3))
            hermiteScribbleView.backgroundLayer2.isHidden = true
            hermiteScribbleView.backgroundLayer1.isHidden = false

        }else if (hermiteScribbleView.currentStage == 2) {
         
            hermiteScribbleView.LineLayer.isHidden = true
            hermiteScribbleView.backgroundLayer1.isHidden = true
            
            hermiteScribbleView.backgroundLayer2.isHidden = false
            scrollView.contentOffset = CGPoint(x: screenSize.width * 1.0, y: scrollView.frame.height * 2  )
        }
        

    }
    
    

    func portraitOps(){
        
        

        currentOrientation = "portrait"
        

        
        stageOps()
        
                hermiteScribbleView.triggerPotrait()
        
        scrollView.setZoomScale(1.0, animated: false)
       
    }
    
    func stageOps(){
        

        switch (hermiteScribbleView.currentStage) {
        
        case 0:
           topStack.isHidden = true
           bottomStack.isHidden = false
           viewReset.isHidden = true
           viewUse.isHidden = false
           viewSubmit.isHidden = true
            
        case 1:
            topStack.isHidden = false
            bottomStack.isHidden = false
            topNextPrev.isHidden = false
            topHomePrev.isHidden = true
            viewReset.isHidden = false
            viewUse.isHidden = true
            viewSubmit.isHidden = true
              btnReset.imageView?.contentMode = UIViewContentMode.scaleAspectFit
            lblInfo.text = "Requested message goes here..."
           

            
        case 2:
            topStack.isHidden = false
            bottomStack.isHidden = false
            topNextPrev.isHidden = false
            topHomePrev.isHidden = true
            viewReset.isHidden = false
            viewUse.isHidden = true
            viewSubmit.isHidden = true
            btnReset.imageView?.contentMode = UIViewContentMode.scaleAspectFit
            lblInfo.text = "Please sign your name."
            
          //  topNextPrev.backgroundColor = UIColor(hexString: "#2e2e2e").withAlphaComponent(0.7)

            
        default:
            topStack.isHidden = false
            bottomStack.isHidden = false
            topNextPrev.isHidden = true
            topHomePrev.isHidden = false
            viewReset.isHidden = true
            viewUse.isHidden = true
            viewSubmit.isHidden = false
            
            
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imgView
    }
    
    
    @IBAction func btnPrev(_ sender: AnyObject) {
        
        hermiteScribbleView.currentStage = hermiteScribbleView.currentStage - 1
        
        
        if(hermiteScribbleView.currentStage > 0 && hermiteScribbleView.currentStage < 3) {
            let value = UIInterfaceOrientation.landscapeLeft.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
            landscapeOps()
        }else {
            //reached last session
            
            let value = UIInterfaceOrientation.portrait.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
            portraitOps()
        }
        
    }
    
    @IBAction func btnNext(_ sender: AnyObject) {
       // hermiteScribbleView.moveNext()
       
        hermiteScribbleView.currentStage = hermiteScribbleView.currentStage + 1

        
        if(hermiteScribbleView.currentStage > 0 && hermiteScribbleView.currentStage < 3) {
                       let value = UIInterfaceOrientation.landscapeLeft.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
            landscapeOps()
        }else {
            //reached last session
      
            let value = UIInterfaceOrientation.portrait.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
            portraitOps()
        }
        
        

    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
        
        guard let
            location = touches.first?.location(in: self.view) else
        {
            return
        }
        
        if(hermiteScribbleView.frame.contains(location))
        {
            touchOrigin = hermiteScribbleView
        }
      
        else
        {
            touchOrigin = nil
            return
        }
        
        if let adjustedLocationInView = touches.first?.location(in: touchOrigin)
        {
            hermiteScribbleView.beginScribble(adjustedLocationInView)
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
                hermiteScribbleView.appendScribble($0.location(in: touchOrigin))
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        hermiteScribbleView.endScribble()
    }
    
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?)
    {
        if motion == UIEventSubtype.motionShake
        {
            hermiteScribbleView.clearScribble()
        }
    }
    
    override func viewDidLayoutSubviews()
    {
        stackView.frame = CGRect(x: 0,
            y: topLayoutGuide.length,
            width: view.frame.width,
            height: view.frame.height - topLayoutGuide.length).insetBy(dx: 10, dy: 10)
        
        stackView.axis = view.frame.width > view.frame.height
            ? UILayoutConstraintAxis.horizontal
            : UILayoutConstraintAxis.vertical
        
        stackView.spacing = 10
        
        stackView.distribution = UIStackViewDistribution.fillEqually
        
        if( currentOrientation == "portrait") {
            scrollView.contentOffset = CGPoint(x: scrollView.frame.width / 18, y: 0  )
        }
        
    }
    
  
    @IBAction func btnReset(_ sender: AnyObject) {
        hermiteScribbleView.clearScribble()
        
    }
    
}

