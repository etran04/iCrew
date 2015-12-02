//
//  ArticleTableViewCell.swift
//  CruApp
//
//  Created by Eric Tran on 12/1/15.
//  Copyright © 2015 iCrew. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {

    @IBOutlet weak var articleNameLabel: UILabel!
    
    var articleName = "Discerning God's Will"
    var articleLink = "http://www.slocru.com/assets/resources/pdf/Discerning_Gods_Will_by_Youth_Specialties.pdf"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        articleNameLabel.text = articleName;
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setArticleInfo(name: String, link: String) {
        articleName = name;
        articleLink = link;
    }

}
