//
//  TextReceiverTableCell.swift
//  MessageApp
//
//  Created by macmini on 02/01/17.
//  Copyright © 2017 nointernetcheck.businessdragan.com. All rights reserved.
//

import UIKit

class TextReceiverTableCell: UITableViewCell {
    @IBOutlet var receivernameLbl: UILabel!
    
    @IBOutlet var receiverDateLbl: UILabel!
    
    @IBOutlet var receiverMsgLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
