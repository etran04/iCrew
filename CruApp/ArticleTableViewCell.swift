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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setArticleInfo(name: String, link: String) {
        articleNameLabel.text = name;
    }

}
