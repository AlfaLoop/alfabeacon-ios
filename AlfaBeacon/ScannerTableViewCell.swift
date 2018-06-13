//
//  ScannerTableViewCell.swift
//  AlfaBeacon
//
//  Created by kuasmis.wmc on 2018/4/9.
//  Copyright © 2018 AlfaLoop. All rights reserved.
//

import UIKit
import MarqueeLabel

class ScannerTableViewCell: UITableViewCell {

    @IBOutlet weak var rssiImageView: UIImageView!
    @IBOutlet weak var rssiLabel: UILabel!
    
    @IBOutlet weak var deviceName: UILabel!
    @IBOutlet weak var ibeaconMajor: UILabel!
    @IBOutlet weak var ibeaconMinor: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
