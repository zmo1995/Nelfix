//
//  headerCell.swift
//  NelFlix
//
//  Created by ZHI XUAN MO on 4/19/20.
//  Copyright © 2020 zhixuan mo. All rights reserved.
//

import UIKit
class headerCell: UITableViewCell {

    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var voteLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var starView: CosmosView!
    @IBOutlet weak var titleLabel: UILabel!
  

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    var thisMovie : MovieInfo?
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func setup(review_num:Int)
    {
        if let movie = thisMovie
        {
            titleLabel.text = movie.title
            // Genre setup
            var genres : [String] = []
            var genreDateString = ""
            for everygenre in (thisMovie?.genre_ids)!
            {
                genres.append(gendict[everygenre]!)
                if genres.count == 1
                {
                    genreDateString += gendict[everygenre]!
                }
                else if genres.count <= 3
                {
                    genreDateString += ", " + gendict[everygenre]!
                    if genres.count == 3 {break}
                }
            }
            starView.rating = (movie.vote_average)!/10
            scoreLabel.text = "\(String(describing: (movie.vote_average)!))/10"
            voteLabel.text = "\(String(describing:(movie.vote_count)!)) Votes"
            genreLabel.text = genreDateString + " | " + (movie.release_date)!
            reviewLabel.text = String(review_num)
            
        }
    }

    
}
