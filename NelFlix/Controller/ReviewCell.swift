//
//  ReviewCell.swift
//  NelFlix
//
//  Created by ZHI XUAN MO on 4/19/20.
//  Copyright © 2020 zhixuan mo. All rights reserved.
//

import UIKit

protocol ReviewCellDelegate {
    func likeBtnPressedHandler(_ cell: ReviewCell)
    func dislikeBtnPressedHandler(_ cell: ReviewCell)
}



class ReviewCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var bodyLabel: UILabel!
    
    @IBOutlet weak var likeLabel: UILabel!
    
    @IBOutlet weak var dislikeLabel: UILabel!
    
    @IBOutlet weak var likeBtn: UIButton!
    
    @IBOutlet weak var dislikeBtn: UIButton!
    
    
    var delegate : ReviewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bringSubviewToFront(likeBtn)
        self.bringSubviewToFront(dislikeBtn)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func setup(with Review: review)
    {
        usernameLabel.text = Review.username
        bodyLabel.text = Review.body
        likeLabel.text = String(Review.likes)
        dislikeLabel.text = String(Review.dislike)
    }
    
    @objc func likeBtnPressed(_ sender: UIButton)
    {
        delegate?.likeBtnPressedHandler(self)
    }
    
    @objc func dislikeBtnPressed(_ sender: UIButton)
    {
        delegate?.dislikeBtnPressedHandler(self)
    }
    
}
