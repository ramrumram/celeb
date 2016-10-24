//
//  HomeViewController.swift
//  SmoothScribble
//
//  Created by dev on 9/26/16.
//  Copyright © 2016 Simon Gladman. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet var imgview: UIImageView!
    
    
    @IBOutlet var filterView: UIImageView!
    @IBOutlet var viewClose: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let point = CGPoint()
        UIGraphicsBeginImageContextWithOptions((imgview.image?.size)!, false, 0.0)
        imgview.image?.draw(in: CGRect(x: 0, y: 0, width: (imgview.image?.size.width)!, height: (imgview.image?.size.height)!))
        filterView.image?.draw(in: CGRect(x: point.x, y: point.y, width: (filterView.image?.size.width)!, height: (filterView.image?.size.height)!))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
  
        imgview.image = newImage
        
        // Do any additional setup after loading the view.
    }

    
 
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
