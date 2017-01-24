//
//  FQCategoriesCollectionViewCell.swift
//  FeatherQ Mockup
//
//  Created by Paul Andrew Gutib on 11/10/16.
//  Copyright © 2016 Reminisense. All rights reserved.
//

import UIKit

class FQCategoriesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryTitle: UILabel!
    @IBOutlet weak var categoryBackground: UIImageView!
    @IBOutlet weak var categoryChecked: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.categoryTitle.font = UIFont.boldSystemFont(ofSize: 50.0)
        }
    }
    
}
