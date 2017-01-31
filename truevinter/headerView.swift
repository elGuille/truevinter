//
//  headerView.swift
//  truevinter
//
//  Created by Guillermo García on 31/01/2017.
//  Copyright © 2017 Guillermo García. All rights reserved.
//

import UIKit

class headerView: UICollectionReusableView {
    
    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var fullnameLbl: UILabel!
    @IBOutlet weak var webTxt: UITextView!
    @IBOutlet weak var bioLbl: UILabel!
    
    @IBOutlet weak var posts: UILabel!
    @IBOutlet weak var followers: UILabel!
    @IBOutlet weak var following: UILabel!
    
    @IBOutlet weak var postsTitle: UILabel!
    @IBOutlet weak var followersTitle: UILabel!
    @IBOutlet weak var followingTitle: UILabel!
    
    @IBOutlet weak var button: UIButton!
}
