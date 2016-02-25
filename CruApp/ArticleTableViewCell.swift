//
//  ArticleTableViewCell.swift
//  CruApp
//
//  Created by Eric Tran on 12/1/15.
//  Copyright © 2015 iCrew. All rights reserved.
//

import UIKit

/* ArticleTableViewCell is a representation of a single cell in our table view controller.
 * It contains video information that will populate and display an article in the cell */
class ArticleTableViewCell: UITableViewCell {

    @IBOutlet weak var articleNameLabel: UILabel!
    var article : Article
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setName(name: String) {
        articleNameLabel.text = article.title
    }

}
