//
//  FQProcessQueueTableViewCell.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 11/16/16.
//  Copyright © 2016 Reminisense. All rights reserved.
//

import UIKit

class FQProcessQueueTableViewCell: UITableViewCell {

    @IBOutlet weak var callNum: UIButton!
    @IBOutlet weak var runningTime: UILabel!
    @IBOutlet weak var priorityNum: UILabel!
    @IBOutlet weak var notesValue: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.callNum.layer.cornerRadius = 5.0
        self.callNum.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
