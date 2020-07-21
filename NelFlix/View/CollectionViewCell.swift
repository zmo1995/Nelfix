//
//  CollectionViewCell.swift
//  NelFlix
//
//  Created by ZHI XUAN MO on 2/25/20.
//  Copyright © 2020 zhixuan mo. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    class var reuseIdentifier: String {
        return "myCustomCell"
    }
    class var nibName: String {
        return "CollectionViewCell"
    }
    func configureCell(description: String , path: String) {
        
        self.descriptionLabel.text = description
        self.image.downloaded(from: "https://image.tmdb.org/t/p/w500/" + path)
        self.image.contentMode = .scaleToFill
        
        NSLayoutConstraint(item: image!, attribute: .leading, relatedBy: .equal, toItem: self.contentView, attribute: .leadingMargin, multiplier: 1.0, constant: 0.0).isActive = true
        
        NSLayoutConstraint(item: image!, attribute: .trailing, relatedBy: .equal, toItem: self.contentView, attribute: .trailingMargin, multiplier: 1.0, constant: 0.0).isActive = true

    
        NSLayoutConstraint(item: descriptionLabel!, attribute: .trailing, relatedBy: .equal, toItem: self.contentView, attribute: .trailingMargin, multiplier: 1.0, constant: 0.0).isActive = true


    }
}
