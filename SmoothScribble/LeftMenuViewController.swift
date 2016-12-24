//
//  LeftMenuViewController.swift
//  Celebgrams
//
//  Created by dev on 12/23/16.
//  Copyright © 2016 Simon Gladman. All rights reserved.
//

import UIKit
import KeychainSwift

class LeftMenuViewController: UIViewController {

    let keychain = KeychainSwift()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btnLogout(_ sender: Any) {
        
        keychain.clear()
        
        let vc: LoginViewController? = self.storyboard?.instantiateViewController(withIdentifier: "LoginView") as? LoginViewController
     
        self.navigationController?.pushViewController(vc!, animated: true)
        
        
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
