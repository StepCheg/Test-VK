//
//  FriendPhotoViewController.swift
//  newProject
//
//  Created by Stepan Chegrenev on 15.05.17.
//  Copyright © 2017 Stepan Chegrenev. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftyVK

class FriendPhotoViewController: UIViewController {
    
    var friend: Friend!

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var friendPhotoImageView: UIImageView!
    
    @IBOutlet weak var friendTextView: UITextView!
    
    @IBAction func reportAction(_ sender: Any) {
        
        friendTextView.resignFirstResponder()
        
        addComment()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = friend.firstName! + " " + friend.lastName!

        friendTextView.layer.borderColor = UIColor.black.cgColor
        friendTextView.layer.borderWidth = 1
        friendTextView.layer.cornerRadius = 5
        
        friendPhotoImageView.sd_setImage(with: URL(string: friend.photo!))
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(FriendPhotoViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        registerKeyboardNotifications()
    }

    
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(_ notification: Notification) {
        
        let userInfo = notification.userInfo
        let keyboardFrameSize = (userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        scrollView.contentOffset = CGPoint(x: 0, y: keyboardFrameSize.height)
    }
    
    func keyboardWillHide() {
        scrollView.contentOffset = CGPoint.zero
    }
    
    func dismissKeyboard() {
        friendTextView.resignFirstResponder()
    }
    
    func addComment() {
      
        VK.API.Photos.createComment([.ownerId : friend.userID! , .photoId : friend.photoID!, .message : friendTextView.text]).send(onSuccess: { (response) in
        }, onError: { (error) in
            print("SwiftyVK: Photos.createComment fail \n \(error)")
        }, onProgress: nil)
        
        friendTextView.text = ""
    }
}
