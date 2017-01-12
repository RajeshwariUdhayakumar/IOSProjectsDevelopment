//
//  TextSenderTableCell.swift
//  MessageApp
//
//  Created by macmini on 02/01/17.
//  Copyright © 2017 nointernetcheck.businessdragan.com. All rights reserved.
//

import UIKit

class TextSenderTableCell: UITableViewCell {

    
    @IBOutlet var sendernameLbl: UILabel!
    
    @IBOutlet var senderDateLbl: UILabel!
    
    @IBOutlet var senderMsgLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
