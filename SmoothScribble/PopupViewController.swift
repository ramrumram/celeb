import UIKit

protocol communicationControllerPopup1 {
    func backFromPopup()
}




class PopupViewController: UIViewController {
    
    var delegate: communicationControllerPopup1? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate?.backFromPopup()
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
