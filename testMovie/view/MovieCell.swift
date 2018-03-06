//
//  MovieCell.swift
//  testMovie
//
//  Created by José Guilherme Alves da Cunha on 05/03/2018.
//  Copyright © 2018 José Guilherme Alves da Cunha. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var overviewLabel: UILabel!
    
    @IBOutlet weak var posterImageView: UIImageView!
    
    var movies: NSDictionary!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
