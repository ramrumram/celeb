//
//  MailboxTableViewCell.swift
//  Heartboxx
//
//  Created by dev on 5/12/16.
//  Copyright © 2016 heartboxx. All rights reserved.
//

import UIKit

class MailboxTableViewCell: UITableViewCell {
    
    @IBOutlet var lblTo: UILabel!
    
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblBody: UILabel!
    
    @IBOutlet var btnAccept: UIButton!
    
    
    @IBOutlet var viewContainer: UIView!
    @IBOutlet var imgView: UIImageView!
}
