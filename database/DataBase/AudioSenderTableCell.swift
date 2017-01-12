//
//  AudioSenderTableCell.swift
//  MessageApp
//
//  Created by macmini on 02/01/17.
//  Copyright © 2017 nointernetcheck.businessdragan.com. All rights reserved.
//

import UIKit

class AudioSenderTableCell: UITableViewCell {
    @IBOutlet var AudionameLbl: UILabel!
    @IBOutlet var timeLbl: UILabel!
    @IBOutlet var PlayorPause: UIButton!
    @IBOutlet var stopBtn: UIButton!
    @IBOutlet var RangeSlider: UISlider!
    
    @IBOutlet var lbl: UILabel!
    
    
    @IBOutlet var DateLbl: UILabel!
    
    @IBOutlet var TotaltimeLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
