//
//  SendMessageViewController.swift
//  Celebgrams
//
//  Created by dev on 10/11/16.
//  Copyright © 2016 Simon Gladman. All rights reserved.
//

import UIKit

class SendMessageViewController: UIViewController, UITextViewDelegate {

    @IBOutlet var viewClose: UIView!
  
    @IBOutlet var txtMessage: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        viewPop.setRadius(radius: 15)
       
        

        txtMessage.text = "Add a caption"
        txtMessage.textColor = UIColor.lightGray
        
                txtMessage.delegate = self
    
      
        
         self.hideKeyboardWhenTappedAround()
    }

    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Add a caption"
            textView.textColor = UIColor.lightGray      }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet var viewPop: UIView!
    

    @IBAction func btnClose(_ sender: AnyObject) {
        
    
        self.presentingViewController?.dismiss(animated: false, completion: nil)

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
