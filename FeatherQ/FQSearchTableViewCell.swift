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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.businessLogo.contentMode = .scaleAspectFill
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
