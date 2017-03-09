//
//  FQChooseTerminalTableViewCell.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 3/9/17.
//  Copyright © 2017 Reminisense. All rights reserved.
//

import UIKit

class FQChooseTerminalTableViewCell: UITableViewCell {
    
    @IBOutlet weak var terminalName: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var redStatus: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.status.layer.cornerRadius = 10.0
        self.status.clipsToBounds = true
        self.redStatus.layer.cornerRadius = 10.0
        self.redStatus.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
