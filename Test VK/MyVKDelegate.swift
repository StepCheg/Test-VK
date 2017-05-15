//
//  MyVKDelegate.swift
//  Test VK
//
//  Created by Stepan Chegrenev on 12.05.17.
//  Copyright © 2017 Stepan Chegrenev. All rights reserved.
//

import Foundation
import SwiftyVK

class MyVKDelegate: VKDelegate {
    let appID = "6028197"
    let scope: Set<VK.Scope> = [.friends, .offline, .wall, .photos]
    
    init() {
        //        VK.config.logToConsole = true
        VK.configure(withAppId: appID, delegate: self)
    }
    
    func vkWillAuthorize() -> Set<VK.Scope> {
        //        print("vkWillAuthorize")
        return scope
    }
    
    func vkDidAuthorizeWith(parameters: [String : String]) {
        //        print("vkDidAuthorizeWith")
        NotificationCenter.default.post(name: Notification.Name(rawValue: "VkDidAuthorize"), object: nil)
    }
    
    func vkAutorizationFailedWith(error: AuthError) {
        print("Autorization failed with error: \n\(error)")
        NotificationCenter.default.post(name: Notification.Name(rawValue: "VkDidNotAuthorize"), object: nil)
    }
    
    func vkDidUnauthorize() {
        //        print("vkDidUnauthorize")
    }
    
    func vkShouldUseTokenPath() -> String? {
        // ---DEPRECATED. TOKEN NOW STORED IN KEYCHAIN---
        
        return nil
    }
    
    func vkWillPresentView() -> UIViewController {
        
        return UIApplication.shared.delegate!.window!!.rootViewController!
        
    }
    
}
