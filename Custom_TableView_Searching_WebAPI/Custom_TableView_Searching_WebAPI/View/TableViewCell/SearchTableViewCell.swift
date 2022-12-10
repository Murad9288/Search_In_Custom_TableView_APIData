//
//  SearchTableViewCell.swift
//  Custom_TableView_Searching_WebAPI
//
//  Created by Md Murad Hossain on 10/12/22.
//

import UIKit


class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var myLabel: UILabel!
    
    @IBOutlet weak var myView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        myImageView.layer.cornerRadius = 30
        myView.layer.cornerRadius = 30
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
