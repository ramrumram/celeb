//
//  ViewController.swift
//  SmoothScribble
//
//  Created by Simon Gladman on 04/11/2015.
//  Copyright © 2015 Simon Gladman. All rights reserved.
//

import UIKit
import KeychainSwift
import NVActivityIndicatorView

class ImageViewController: UIViewController
{
    
    
    let stackView = UIStackView()
    var image: UIImage?

    
    let keychain = KeychainSwift()
    
    @IBOutlet var bottomStack: UIStackView!
    @IBOutlet var viewContainer: UIView!
    
    @IBOutlet var scrollView: UIScrollView!

    @IBOutlet var imgView: UIImageView!
    
    
    @IBOutlet var viewUse: UIView!
    
  
    

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
        
        
        
        viewContainer.addSubview(stackView)

        
        
 
    }

    
    

  
    
 
    
    @IBAction func btnNext(_ sender: AnyObject) {
       

        
      
        

    }

    
    
 
    
  
   
    
}

