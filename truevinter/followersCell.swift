//
//  followersCell.swift
//  truevinter
//
//  Created by Guillermo García on 01/02/2017.
//  Copyright © 2017 Guillermo García. All rights reserved.
//

import UIKit

class followersCell: UITableViewCell {

    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
