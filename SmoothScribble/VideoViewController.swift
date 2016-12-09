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
import Alamofire

class VideoViewController: UIViewController {
    
    var videoData = Data()
    var videoURL = NSURL(string: "")
    
    @IBOutlet var viewVideo: UIView!
    var oplayer: AVPlayer!

    @IBOutlet var viewUse: UIView!
    
    @IBOutlet var viewSend: UIView!
    
    
    @IBOutlet var lblRewVideo: UILabel!
    
    
    @IBOutlet var viewHomePrev: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
     /*  let player = AVQueuePlayer()
       let playerLayer = AVPlayerLayer(player: player)
       let playerItem = AVPlayerItem(url: videoURL! as URL)
       let playerLooper = AVPlayerLooper(player: player, templateItem: playerItem)
        
        let playerController = AVPlayerViewController()
        playerController.showsPlaybackControls = false
        
        playerController.player = player
        self.addChildViewController(playerController)
        viewVideo.addSubview(playerController.view)
        playerController.view.frame = viewVideo.frame
        
        player.play()    
*/
        
       
        let player = AVPlayer(url:  videoURL! as URL)
        oplayer = player
        let playerController = AVPlayerViewController()
        playerController.showsPlaybackControls = false

        playerController.player = oplayer
        self.addChildViewController(playerController)
        viewVideo.addSubview(playerController.view)
        playerController.view.frame = viewVideo.frame
        
        
//        oplayer.actionAtItemEnd = .one

        
        NotificationCenter.default.addObserver(self,
                                                         selector: #selector(VideoViewController.playerItemDidReachEnd),
                                                         name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                                         object: oplayer.currentItem)
        
        
        
        oplayer.play()
        
        
        // Do any additional setup after loading the view.
    }
    
    func playerItemDidReachEnd() {
        oplayer.seek(to: kCMTimeZero)
        oplayer.play()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnUseClick(_ sender: Any) {
        oplayer.pause()
        viewUse.isHidden = true
        viewSend.isHidden = false
        lblRewVideo.isHidden = true
        viewHomePrev.isHidden = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    
    @IBAction func btnSave(_ sender: Any) {
        
 
            
            // define parameters
            let parameters = [
                "hometown": "yalikavak",
                "living": "istanbul"
            ]
            
            Alamofire.upload(multipartFormData: { multipartFormData in
                multipartFormData.append (self.videoData , withName: "file", fileName: "file.mov", mimeType: "video/quicktime")
                
                
                for (key, value) in parameters {
                    multipartFormData.append((value.data(using: .utf8))!, withName: key)
                }}, to: "http://192.168.2.17:8081/cgws/server-vid.php", method: .post, headers: ["Authorization": "auth_token"],
                    encodingCompletion: { encodingResult in
                        switch encodingResult {
                        case .success(let upload, _, _):
                            upload.response { [weak self] response in
                                guard let strongSelf = self else {
                                    return
                                }
                                debugPrint(response)
                            }
                        case .failure(let encodingError):
                            print("error:\(encodingError)")
                        }
            })
            

       
        
       // let videodata = NSData(contentsOf: (videoURL?.filePathURL)! as URL)

        
      //  print(videodata)
        
        
        
        

    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        
        
        oplayer.pause()
        
       
        let fileManager = FileManager.default
        
        // Delete 'hello.swift' file
     //   let path = String(contentsOf: videoURL as! URL)
        
        do {

        //    try fileManager.removeItem(atPath: (videoURL?.path)!)
        }
        catch let error as NSError {
         //   print("Ooops! Something went wrong: \(error)")
        }
 
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
