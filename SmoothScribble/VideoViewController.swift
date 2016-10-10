//
//  VideoViewController.swift
//  camera
//
//  Created by dev on 10/6/16.
//  Copyright © 2016 imaginaryCloud. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
class VideoViewController: UIViewController {
    
    var videoURL = NSURL(string: "")
    
    @IBOutlet var viewVideo: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let player = AVPlayer(url:  videoURL! as URL)
        let playerController = AVPlayerViewController()
        
        playerController.player = player
        self.addChildViewController(playerController)
        viewVideo.addSubview(playerController.view)
        playerController.view.frame = viewVideo.frame
        
        player.play()
        
        
        // Do any additional setup after loading the view.
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
