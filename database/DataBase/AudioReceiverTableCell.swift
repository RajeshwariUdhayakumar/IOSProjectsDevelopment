//
//  AudioReceiverTableCell.swift
//  MessageApp
//
//  Created by macmini on 02/01/17.
//  Copyright © 2017 nointernetcheck.businessdragan.com. All rights reserved.
//

import UIKit

class AudioReceiverTableCell: UITableViewCell {
    @IBOutlet var RAudionameLbl: UILabel!
    @IBOutlet var RtimeLbl: UILabel!
    @IBOutlet var RPlayorPause: UIButton!
    @IBOutlet var RstopBtn: UIButton!
    @IBOutlet var RrangeSlider: UISlider!
    @IBOutlet var TotaltimeLbl: UILabel!
    
    @IBOutlet var RdateLbl: UILabel!
    @IBOutlet var lbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
