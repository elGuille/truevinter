//
//  homeVC.swift
//  truevinter
//
//  Created by Guillermo García on 31/01/2017.
//  Copyright © 2017 Guillermo García. All rights reserved.
//

import UIKit
import Parse

class homeVC: UICollectionViewController {
    
    // refresher variable
    var refresher : UIRefreshControl!
    
    // size of page
    var page : Int = 10
    
    var uuidArray = [String]()
    var picArray = [PFFile]()
    

    // default function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // background color
        collectionView?.backgroundColor = UIColor.white
        
        // title at the top
        self.navigationItem.title = PFUser.current()?.username?.uppercased()
        
        
        // pull down to refresh
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: "refresh", for: UIControlEvents.valueChanged)
        collectionView?.addSubview(refresher)
        
        // load posts function
        loadPosts()
        

           }

    // refreshing function
    func refresh() {
        
        // reload data information
        collectionView?.reloadData()
        
        // stop refresher animation 
        refresher.endRefreshing()
    }
    
    // upload posts function
    func loadPosts() {
        let query = PFQuery(className: "posts")
        query.whereKey("username", equalTo: PFUser.current()!.username!)
        query.limit = page
        query.findObjectsInBackground (block: { (objects:[PFObject]?, error: Error?) -> Void in
            if error == nil {
                
                // clean up
                self.uuidArray.removeAll(keepingCapacity: false)
                self.picArray.removeAll(keepingCapacity: false)
                
                // find objects related to our request
                for object in objects! {
                    
                    // add found data to Arrays (holders)
                    self.uuidArray.append(object.value(forKey: "uuid") as! String)
                    self.picArray.append(object.value(forKey: "pic") as! PFFile)
                }
                
                self.collectionView?.reloadData()
            } else {
                print(error!.localizedDescription)
            }
        })
    }


    // number of cells
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return picArray.count
    }
    
    // cell configuration
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // define Cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! pictureCell
        
        // get picture from the picArray
        picArray[indexPath.row].getDataInBackground { (data: Data?, error: Error?) in
            if error == nil {
                cell.picImg.image = UIImage(data: data!)
            }
        }
        
        return cell
    }

    // header config
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        // define header
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath) as! headerView
        
        // STEP 1. Get user data
        // get user data with conection to collums of PFUser class
        header.fullnameLbl.text = (PFUser.current()?.object(forKey: "fullname") as? String)?.uppercased()
        header.webTxt.text = PFUser.current()?.object(forKey: "web") as? String
        header.webTxt.sizeToFit()
        header.bioLbl.text = PFUser.current()?.object(forKey: "bio") as? String
        header.bioLbl.sizeToFit()
        
        let avaQuery = PFUser.current()?.object(forKey: "ava") as? PFFile
        avaQuery?.getDataInBackground(block: { (data: Data?, error: Error?) -> Void in
            header.avaImg.image = UIImage(data: data!)
        })
        header.button.setTitle("edit profile", for: UIControlState.normal)
        
        
        // STEP 2. Count statistics
        // count total posts
        let posts = PFQuery(className: "posts")
        posts.whereKey("username", equalTo: PFUser.current()?.username)
        posts.countObjectsInBackground (block: { (count: Int32, error: Error?) in
            if error == nil {
                header.posts.text = "\(count)"
            }
        })
        
        // count total followers
        let followers = PFQuery(className: "follow")
        followers.whereKey("following", equalTo: PFUser.current()?.username)
        followers.countObjectsInBackground (block: { (count: Int32, error: Error?) in
            if error == nil {
                header.followers.text = "\(count)"
            }
        })
        
        // count total followings
        let followings = PFQuery(className: "follow")
        followings.whereKey("follower", equalTo: PFUser.current()?.username)
        followings.countObjectsInBackground (block: { (count: Int32, error: Error?) in
            if error == nil {
                header.followings.text = "\(count)"
            }
        })
        
        // STEP 3. Implement tap gestures
        // tap posts
        let postsTap = UITapGestureRecognizer(target: self, action: "postsTap")
        postsTap.numberOfTapsRequired = 1
        header.posts.isUserInteractionEnabled = true
        header.posts.addGestureRecognizer(postsTap)
        
        // tap followers
        let followersTap = UITapGestureRecognizer(target: self, action: "followersTap")
        followersTap.numberOfTapsRequired = 1
        header.followers.isUserInteractionEnabled = true
        header.followers.addGestureRecognizer(followersTap)
        
        // tap following
        let followingTap = UITapGestureRecognizer(target: self, action: "followingTap")
        followingTap.numberOfTapsRequired = 1
        header.followings.isUserInteractionEnabled = true
        header.followings.addGestureRecognizer(followingTap)
        
        return header

    }
    // MARK
    // tapped posts label
    func postsTap() {
        if !picArray.isEmpty {
            let index = NSIndexPath(item: 0, section: 0)
            self.collectionView?.scrollToItem(at: index as IndexPath, at: UICollectionViewScrollPosition.top, animated: true)
        }
    }
    
    // tapped followers label
    func followersTap() {
        
        user = PFUser.current()!.username!
        shows = "followers"
        
        
        // make references to followersVC
        let followers = self.storyboard?.instantiateViewController(withIdentifier: "followersVC") as! followersVC
        
        // present it
        self.navigationController?.pushViewController(followers, animated: true)
        
    }
    
    // tapped following label
    func followingTap() {
        user = PFUser.current()!.username!
        shows = "following"
        
        // make references to followersVC
        let followings = self.storyboard?.instantiateViewController(withIdentifier: "followersVC") as! followersVC
        
        // present it
        self.navigationController?.pushViewController(followings, animated: true)
    }

    /*
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
    
        return cell
    }
    */

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
