//
//  FQSearchTableViewCell.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 11/23/16.
//  Copyright © 2016 Reminisense. All rights reserved.
//

import UIKit

class FQSearchTableViewCell: UITableViewCell {

    @IBOutlet weak var businessName: UILabel!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var peopleInLine: UILabel!
    @IBOutlet weak var waitingTIme: UILabel!
    @IBOutlet weak var businessLogo: UIImageView!
    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var containerV: UIView!
    @IBOutlet weak var businessCode: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.businessLogo.contentMode = .scaleAspectFit
        self.containerV.layer.cornerRadius = 10.0
        self.containerV.clipsToBounds = true
        self.businessCode.layer.cornerRadius = 10.0
        self.businessCode.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
