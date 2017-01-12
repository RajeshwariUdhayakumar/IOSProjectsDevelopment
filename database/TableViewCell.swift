//
//  TableViewCell.swift
//  DataBase
//
//  Created by macmini on 09/01/17.
//  Copyright © 2017 nointernetcheck.businessdragan.com. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet var statusLbl: UILabel!
    
    @IBOutlet var contactPhoneNum: UILabel!
    @IBOutlet var contactnameLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
