import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON
import KeychainSwift
import SideMenu
//import CameraManager

class MailboxViewController: UIViewController,UITableViewDataSource, UITableViewDelegate   {
    
    @IBOutlet var tableView: UITableView!
    //var visits = [String : AnyObject]()
    var messages = Dictionary<Int, NSMutableArray>()
    let blogSegueIdentifier = "imageCaptureSegue"
    let keychain = KeychainSwift()
   // let cameraManager = CameraManager()

    
    @IBOutlet var imgReqBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        cameraManager.showAccessPermissionPopupAutomatically = true

        
       
        tableView.delegate = self
        tableView.dataSource = self
        
        loadMessages()
        tableView.tableFooterView = UIView()
        

      
        
        
        let attrs = [NSUnderlineStyleAttributeName : 1, NSFontAttributeName : UIFont(name: "AvenirNext-DemiBold", size: 14)!,NSForegroundColorAttributeName : UIColor.black] as [String : Any]
        
        let buttonTitleStr = NSMutableAttributedString(string:"IMAGE REQUESTS", attributes:attrs)
        let attributedString = NSMutableAttributedString(string:"")

        attributedString.append(buttonTitleStr)
        imgReqBtn.setAttributedTitle(attributedString, for: .normal)
        
     
        navigationController?.navigationBar.barTintColor = UIColor(hexString: "#2e2e2e")
        
        let attributes = [NSFontAttributeName : UIFont(name: "AvenirNext-Medium", size: 22)!, NSForegroundColorAttributeName : UIColor.white]
        
        
        
        
        self.navigationController?.navigationBar.titleTextAttributes = attributes
        
      
        let menuLeftNavigationController = UISideMenuNavigationController()
        menuLeftNavigationController.leftSide = true
        SideMenuManager.menuLeftNavigationController = menuLeftNavigationController
        let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "LeftMenu") as! LeftMenuViewController
        
        let customViewControllersArray : NSArray = [newViewController]
        menuLeftNavigationController.viewControllers = customViewControllersArray as! [UIViewController]
       
        
        SideMenuManager.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        
        

        

    }
    
  //  override var preferredStatusBarStyle: UIStatusBarStyle {
      //  print("!!!!!!!!@@@@@@@@!!!!!!!!!")
   //     return .lightContent
  //  }
  
    

    @IBAction func listMenu(_ sender: Any) {
        present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        
        //self.navigationController?.setNavigationBarHidden(true, animated: true)
        

        
          }
    
    
    func loadMessages() {
        
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        
        let cid = self.keychain.get("CG_uid")!
        Alamofire.request("https://cgram.io/russ/cgrams-web/imagejson.php?cid="+cid).responseJSON { response in
  UIApplication.shared.isNetworkActivityIndicatorVisible = false
       
            
            if let retval = response.result.value {
                let res = JSON(retval)
             
               
                if let inbox = res["data"].array {
                    
                    var i = 0
                     while i < inbox.count {
                       
                      
                        var tpic = ""
                        var tto = ""
                        var tmsg = ""
                        var tdate = ""
                        var tid = ""
                        
                        
                        if let pic = inbox[i]["pic"].string {
                            tpic = pic
                        }
                        if let msg = inbox[i]["message"].string {
                            tmsg = msg
                        }
                        if let to = inbox[i]["recipient"].string {
                            tto = to
                        }
                      
                        if let id = inbox[i]["id"].string {
                            tid = id
                        }
                        
                        self.messages [i] = [tpic, tmsg, tto, tdate, tid]
                        
                        i = i+1
                        
                    }
                     self.view.layoutIfNeeded()
                    self.tableView.reloadData()
                   //
                    
                }else{
                    print("empty inbox")
                }
                
            }
            
            
        }
 
        
        
        
             }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
          return self.messages.count ;
        
    }
    
    
    
    @IBAction func actionCamera(_ sender: UIButton) {
     
       

        self.keychain.set(self.messages[sender.tag]?[4] as! String, forKey: "currentReqID")
        self.keychain.set(self.messages[sender.tag]?[1] as! String, forKey: "currentReqmsg")

        
        
        let vc: CameraViewController? = self.storyboard?.instantiateViewController(withIdentifier: "cameraViewController") as? CameraViewController
        
        
        self.navigationController?.pushViewController(vc!, animated: true)
        
        

    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        
     //means exceeded the actual row count by 1...just to add an empty cell
        
        //if will never work now..as extra padding is removed...just for ref..can be removed in future
        if self.messages.count == indexPath.row {
            let cellIdentifier = "dummyCell"
            
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MailboxTableViewCell
            
            return cell
        }else {
            let message = self.messages[indexPath.row]!
       
            let cellIdentifier = "MailboxTableViewCell"
            
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MailboxTableViewCell

           // DispatchQueue.main.async {

            
           
            self.view.layoutIfNeeded()
          
            let imgurl =  message[0] as? String
            let URL = Foundation.URL(string: imgurl!)!
            let placeholderImage = UIImage(named: "icon")!
            
            
            let rect =  CGRect(x: 30, y: 10, width: 50, height: 50)
           // cell.imageView?.image = image
          //  cell.imageView?.image?.draw(in: rect)
            
            let cellImg : UIImageView = UIImageView(frame: rect)
            //cellImg.image = UIImage(named: "2")
            cellImg.af_setImage(withURL: URL, placeholderImage: placeholderImage)
            cellImg.setRadius(radius: 25)

            cell.addSubview(cellImg)
            

            cell.lblDate.setRadius(radius: 5)
           // cell.imageView?.setRadius(radius: 35)
            cell.setNeedsLayout()
       
            
            cell.btnAccept.setRadius(radius: 13)
            cell.btnAccept.tag = indexPath.row
            
            cell.lblTo.text =  message[2] as? String
            cell.lblBody.text =  message[1] as? String
            cell.lblDate.text =  " "+( message[3] as? String)! + " "
            
            
          //  cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            
            
            return cell
            }
    }
    
    
    

            
    

    
}
