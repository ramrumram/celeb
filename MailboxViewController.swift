import UIKit
import Alamofire
import SwiftyJSON
import KeychainSwift
class MailboxViewController: UIViewController,UITableViewDataSource, UITableViewDelegate   {
    
    @IBOutlet var tableView: UITableView!
    //var visits = [String : AnyObject]()
    var messages = Dictionary<Int, NSMutableArray>()
    let blogSegueIdentifier = "MessageDetailSegue"
    let keychain = KeychainSwift()
    
    @IBOutlet var imgReqBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       
        tableView.delegate = self
        tableView.dataSource = self
        
        loadMessages()
        tableView.tableFooterView = UIView()
        

        
        navigationController?.navigationBar.barTintColor = UIColor(hexString: "#2e2e2e")

       navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]

        
        
    }
    
    

    
    func loadMessages() {
        
        
    //    UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        
        
        Alamofire.request("http://object90.com/json.php").responseJSON { response in
  UIApplication.shared.isNetworkActivityIndicatorVisible = false
       
            
            if let retval = response.result.value {
                let res = JSON(retval)
             
               
                if let inbox = res["data"].array {
                    
                    var i = 0
                                         while i < inbox.count {
                       
                      
                        var tsub = ""
                        var tto = ""
                        var tmsg = ""
                        var tdate = ""
                        var tid = ""
                        
                        
                        if let sub = inbox[i]["subject"].string {
                            tsub = sub
                        }
                        if let msg = inbox[i]["message"].string {
                            tmsg = msg
                        }
                        if let to = inbox[i]["to"].string {
                            tto = to
                        }
                        if let date = inbox[i]["date"].string {
                            tdate = date
                        }
                        if let id = inbox[i]["id"].string {
                            tid = id
                        }
                        
                        self.messages [i] = [tsub, tmsg, tto, tdate, tid]
                        
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
 
        
        
        
            /*
        
        //   print(API_Domain+"/api/messages/fetch/"+uid)
        Alamofire.request("http://object90.com/json.php")
             .responseJSON { (response) -> Void in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                guard response.result.isSuccess else {
                    print("Error while fetching remote rooms: \(response.result.error)")
                    //  completion(nil)
                    return
                }
                let res = JSON(response.result.value!)
                if let inbox = res["data"].array {
                    
                    var i = 0
                    while i < inbox.count {
                        var tsub = ""
                        var tto = ""
                        var tmsg = ""
                        var tdate = ""
                        var tid = ""
                        
                        
                        if let sub = inbox[i]["subject"].string {
                            tsub = sub
                        }
                        if let msg = inbox[i]["message"].string {
                            tmsg = msg
                        }
                        if let to = inbox[i]["to"].string {
                            tto = to
                        }
                        if let date = inbox[i]["date"].string {
                            tdate = date
                        }
                        if let id = inbox[i]["id"].string {
                            tid = id
                        }
                        
                        self.messages [i] = [tsub, tmsg, tto, tdate, tid]
                        
                        i = i+1
                        
                    }
                    self.tableView.reloadData()
                    
                    
                }else{
                    print("empty inbox")
                }
                
                
 
                
                
        } */
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
          return self.messages.count;
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "MailboxTableViewCell"

        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MailboxTableViewCell
        
     
        let message = self.messages[indexPath.row]!
       
       // DispatchQueue.main.async {

        
        
        
       
        self.view.layoutIfNeeded()

        
        let imageName = "2"

        let image = UIImage(named: imageName)

        let rect =  CGRect(x: 30, y: 10, width: 50, height: 50)
       // cell.imageView?.image = image
      //  cell.imageView?.image?.draw(in: rect)
        
        var cellImg : UIImageView = UIImageView(frame: rect)
        cellImg.image = UIImage(named: "2")
        
        cellImg.setRadius(radius: 25)

        cell.addSubview(cellImg)
        
        

        cell.lblDate.setRadius(radius: 6)
       // cell.imageView?.setRadius(radius: 35)
        cell.setNeedsLayout()
   
        
        cell.btnAccept.setRadius(radius: 10)
        cell.lblTo.text =  message[2] as? String
        cell.lblBody.text =  message[1] as? String
        cell.lblDate.text =  message[3] as? String
        
      //  cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        
        return cell
    }
    
    
    
    /*
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if  segue.identifier == blogSegueIdentifier{
            let destination = segue.destinationViewController as? MailboxDetailViewController,
            indexPath = self.tableView.indexPathForSelectedRow?.row
            
            let message = self.messages[indexPath!]
            
            destination?.to =  (message![2] as? String)!
            destination?.subject =  (message![0] as? String)!
            destination?.body =  (message![1] as? String)!
            destination?.date =  (message![3] as? String)!
            
            
            
            //  print((visit["venue_name"] as? String)!)
            //  print(indexPath.length)
            
        }
        
    }
    
*/
    
}
