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
import KeychainSwift
import NVActivityIndicatorView

class VideoViewController: UIViewController, communicationControllerPopup {
    
    var videoData = Data()
    var videoURL = NSURL(string: "")
    
    @IBOutlet var viewVideo: UIView!
    var oplayer: AVPlayer!

    @IBOutlet var viewUse: UIView!
    
    @IBOutlet var viewSend: UIView!
    
    
    @IBOutlet var lblRewVideo: UILabel!
    
    
    @IBOutlet var viewHomePrev: UIView!
    
    let keychain = KeychainSwift()
    
    var screenSize: CGRect = UIScreen.main.bounds

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
        
       let popup: SendMessageViewController? = self.storyboard?.instantiateViewController(withIdentifier: "SendMsgPopup") as? SendMessageViewController
        
        popup?.delegate = self

       self.present(popup!, animated: true, completion: nil)

    }
   

    
    func backFromPopup(value: String) {
        
       
        
        // define parameters
        let parameters = [
            "message": value,
             "token": TOKEN
        ]
        
        let req = self.keychain.get("currentReqID")
        let up_url = VID_UP_URL + "/" + self.keychain.get("CG_uid")!

        let alert = UIAlertController(title: "Error", message: "Error in uploading your picture! please try again later", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        
        let frame = CGRect(x: (screenSize.width / 2) - 10, y: screenSize.height / 2, width: 30, height: 30)
        NVActivityIndicatorView.DEFAULT_TYPE = .ballPulseSync
        let activityIndicatorView = NVActivityIndicatorView(frame: frame)
        self.view.addSubview(activityIndicatorView)
        
        activityIndicatorView.startAnimating()

        
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append (self.videoData , withName: "file", fileName: "Video_"+req!+".mov", mimeType: "video/quicktime")
            
            
            for (key, value) in parameters {
                multipartFormData.append((value.data(using: .utf8))!, withName: key)
            }}, to: up_url, method: .post,
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.response { [weak self] response in
                            guard self != nil else {
                                self?.present(alert, animated: true, completion: nil)
                                return
                            }
                            activityIndicatorView.stopAnimating()
                            //  debugPrint(response)
                            let vc: VideoRequestsTableViewController? = self?.storyboard?.instantiateViewController(withIdentifier: "VideoQueue") as? VideoRequestsTableViewController
                            
                            self?.navigationController?.pushViewController(vc!, animated: true)
                        }
                    case .failure(let encodingError):
                        self.present(alert, animated: true, completion: nil)
                    }
        })
        
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
