//
//  MyTableViewController.swift
//  Test VK
//
//  Created by Stepan Chegrenev on 13.05.17.
//  Copyright © 2017 Stepan Chegrenev. All rights reserved.
//

import UIKit
import SwiftyVK
import SDWebImage

class MyTableViewController: UITableViewController {
    
    @IBOutlet weak var loginButtonOutlet: UIBarButtonItem!
    
    var friendsArray = [Friend]()
    var components = "photo_100, photo_id"
    var reuseIdentifier = "MyCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (VK.state == .authorized) {
            getFriends()
            loginButtonOutlet.title = "Logout"
        } else {
            loginButtonOutlet.title = "Login"
        }
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        NotificationCenter.default.addObserver(self, selector: #selector(getFriends), name: Notification.Name(rawValue: "VkDidAuthorize"), object: nil)
    }
    
    func getFriends() {
        
        VK.API.Friends.get([.fields : components]).send(onSuccess: { (response) in
            
            self.reloadTable(aFriends: self.changeJSON(aJSON: response))
            
        }, onError: { (error) in
            print("SwiftyVK: friends.get fail \n \(error)")
        }, onProgress: nil)
        
    }
    
    func addLike(atRow: Int) {
        
        let friend = friendsArray[atRow]
        
        VK.API.Likes.add([.ownerId : friend.userID! , .type : "photo", .itemId : friend.photoID!]).send(onSuccess: { (response) in
        }, onError: { (error) in
            print("SwiftyVK: likes.add fail \n \(error)")
        }, onProgress: nil)
        
        
    }
    
    func changeJSON(aJSON: JSON) -> [Friend] {
        
        var array: [Friend] = []
        
        let str = aJSON.description
        
        if let data = str.data(using: String.Encoding.utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary
                
                let people = json?["items"] as! NSArray
                
                for person in people {
                    
                    let human = person as! NSDictionary
                    
                    var firstName: String!
                    var lastName: String!
                    var userID: String!
                    var photo: String!
                    var photoID: String!
                    
                    for attribute in human {
                        
                        if ((attribute.key as! String) == "first_name") {
                            firstName = attribute.value as! String
                        } else if ((attribute.key as! String) == "last_name") {
                            lastName = attribute.value as! String
                        } else if ((attribute.key as! String) == "photo_100") {
                            photo = attribute.value as! String
                        } else if ((attribute.key as! String) == "id") {
                            
                            userID = "\(attribute.value as! Int)"
                            
                        } else if ((attribute.key as! String) == "photo_id") {
                            
                            let strArr = (attribute.value as! String).components(separatedBy: "_")
                            
                            photoID = strArr[1]
                        }
                    }
                    
                    if photoID == nil {
                        photoID = "empty"
                    }
                    
                    let friend = Friend(aFirstName: firstName, aLastName: lastName, aPhoto: photo, aUserID: userID, aPhotoID: photoID)
                    
                    array.append(friend)
                }
            } catch {
                print("Something went wrong")
            }
        }
        
        return array
    }
    
    func reloadTable(aFriends: [Friend]) {
        friendsArray = aFriends
        refreshUI()
    }
    
    func refreshUI() {
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        });
    }
    
    @IBAction func loginButtonAction(_ sender: Any) {
        
        if (VK.state == .authorized) {
            print(VK.state)
            VK.logOut()
            friendsArray.removeAll()
            refreshUI()
            loginButtonOutlet.title = "Login"
        } else {
            print(VK.state)
            VK.logIn()
            loginButtonOutlet.title = "Logout"        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (friendsArray.count)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        let friend = friendsArray[indexPath.row]
        
        cell.textLabel?.text = friend.firstName! + " " + friend.lastName!
        
        cell.imageView?.sd_setImage(with: URL(string: friend.photo!), placeholderImage: UIImage(named: "placeholder.png") )
        
        if friend.photoID != "empty" {
            let buttonLike = UIButton(type: .custom)
            buttonLike.frame = CGRect(x: 0, y: 0, width: 50, height: cell.frame.size.height)
            buttonLike.setImage(#imageLiteral(resourceName: "Heart"), for: .normal)
            buttonLike.tag = indexPath.row
            buttonLike.addTarget(self, action: #selector(accessoryButtonTapped(sender:)), for: .touchUpInside)
            
            cell.accessoryView = buttonLike
        }
        
        return cell
    }
    
    func accessoryButtonTapped(sender: UIButton){
        addLike(atRow: sender.tag)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let friend = friendsArray[indexPath.row]
        
        if friend.photoID != "empty" {
            self.performSegue(withIdentifier: "FriendPhotoViewControllerSegue", sender: friend)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "FriendPhotoViewControllerSegue" {
            
            let destViewController = segue.destination as! FriendPhotoViewController
            
            let friend = sender as? Friend
            
            destViewController.friend = friend
        }
    }
}
