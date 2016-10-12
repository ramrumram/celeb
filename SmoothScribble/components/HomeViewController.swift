//
//  HomeViewController.swift
//  SmoothScribble
//
//  Created by dev on 9/26/16.
//  Copyright © 2016 Simon Gladman. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet var viewClose: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        viewClose.addBottomBorderWithColor(color: UIColor.red, width: 10)
        // Do any additional setup after loading the view.
    }

    
    @IBAction func cameraClick(_ sender: AnyObject) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
