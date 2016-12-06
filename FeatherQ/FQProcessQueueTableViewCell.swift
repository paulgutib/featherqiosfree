//
//  FQProcessQueueTableViewCell.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 11/16/16.
//  Copyright © 2016 Reminisense. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class FQProcessQueueTableViewCell: MGSwipeTableCell {

    @IBOutlet weak var callNum: UIButton!
    @IBOutlet weak var runningTime: UILabel!
    @IBOutlet weak var priorityNum: UILabel!
    @IBOutlet weak var notesValue: UILabel!
    @IBOutlet weak var confirmCode: UILabel!
    @IBOutlet weak var buttonContainer: UIView!
    @IBOutlet weak var serveNum: UIButton!
    @IBOutlet weak var dropNum: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.callNum.layer.cornerRadius = 5.0
        self.callNum.clipsToBounds = true
        self.serveNum.layer.cornerRadius = 5.0
        self.serveNum.clipsToBounds = true
        self.dropNum.layer.cornerRadius = 5.0
        self.dropNum.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
