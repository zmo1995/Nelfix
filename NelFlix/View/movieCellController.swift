//
//  MovieCell.swift
//  NelFlix
//
//  Created by ZHI XUAN MO on 2/22/20.
//  Copyright © 2020 zhixuan mo. All rights reserved.
//

import UIKit

class movieCellController: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var starReview: CosmosView!
    @IBOutlet weak var rImage: UIImageView!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var reviewNumLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
