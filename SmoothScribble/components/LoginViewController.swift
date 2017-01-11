//
//  LoginViewController.swift
//  Celebgrams
//
//  Created by dev on 10/3/16.
//  Copyright © 2016 Simon Gladman. All rights reserved.
//

import UIKit
import KeychainSwift
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController {

    let keychain = KeychainSwift()
    
    let Fields = ["Email", "Password"]

    @IBOutlet var txtPassword: UITextField!
    
    @IBOutlet var txtEmail: UITextField!
    
    @IBOutlet var lblError: UILabel!
    
    
    @IBOutlet var lblError1: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.isHidden = false
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        
        // Do any additional setup after loading the view.
    }
    
    //Calls this function when the tap is recognized.
    override func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func login(_ sender: Any) {
        
        
        var dict = Dictionary<Int, NSMutableArray>()
        dict[0] = [txtEmail, lblError, ["not-empty", "email"] ] as NSMutableArray
        dict[1] = [txtPassword, lblError1, ["not-empty"]] as NSMutableArray

        
        
        
        let validator = Validator()
        
        if(validator.validate(dict)) {

            UIApplication.shared.isNetworkActivityIndicatorVisible = true

            
            Alamofire.request(WS_DOMAIN + "/celebrity/login",
                method: .post,
                parameters: ["username": txtEmail.text!.trim(), "password": txtPassword.text!.trim(), "format": "json"],
                encoding: URLEncoding.default
                ).validate().responseJSON { response in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                   
                    
               //     print (response.result.value)
                    
                    guard response.result.isSuccess else {
                        self.lblError.text = "Invalid credentials"
                        print("Error connecting remote: \(response.result.error)")
                        //  completion(nil)
                        return
                    }
                    
                if let retval = response.result.value {
                    let res = JSON(retval)
                    

                        let uid = res["cid"].string
                        self.keychain.set(uid!, forKey: "CG_uid")
                    
                    
//                      let vc: MailboxViewController? = self.storyboard?.instantiateViewController(withIdentifier: "ImageQueue") as? MailboxViewController
                    
                  //  let vc: ImageViewController? = self.storyboard?.instantiateViewController(withIdentifier: "ImageVC") as? ImageViewController
                    
                    let vc: SignViewController? = self.storyboard?.instantiateViewController(withIdentifier: "SignVC") as? SignViewController
  
                    
                       self.navigationController?.pushViewController(vc!, animated: true)
                }
                
            }

        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        if (self.keychain.get("CG_uid") != nil) {
       //     let vc: MailboxViewController? = self.storyboard?.instantiateViewController(withIdentifier: "ImageQueue") as? MailboxViewController
            
           //  let vc: ImageViewController? = self.storyboard?.instantiateViewController(withIdentifier: "ImageVC") as? ImageViewController
            
             let vc: SignViewController? = self.storyboard?.instantiateViewController(withIdentifier: "SignVC") as? SignViewController
            
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        
        
        
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
          navigationController?.navigationBar.isHidden = false
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
