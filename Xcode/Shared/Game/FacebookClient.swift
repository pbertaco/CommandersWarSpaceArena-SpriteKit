//
//  FacebookClient.swift
//  Game
//
//  Created by Paulo Henrique dos Santos on 31/05/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import FBSDKLoginKit

class FacebookClient {
    
    static let sharedInstance = FacebookClient()
    
    func logInWith(successBlock success: @escaping () -> (), andFailureBlock failure: @escaping (Error?) -> ()) {
        
        let loginManager = FBSDKLoginManager()
        let permissions = ["public_profile", "email", "user_friends"]
        let viewController = (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController!
        
        if FBSDKAccessToken.current() != nil {
            #if DEBUG
                loginManager.logOut()
            #else
                success()
                return
            #endif
        }
        
        loginManager.logIn(withReadPermissions: permissions, from: viewController) { (loginManagerLoginResult: FBSDKLoginManagerLoginResult?, error: Error?) in
            if error != nil || loginManagerLoginResult == nil ? true : loginManagerLoginResult!.isCancelled {
                print(error?.localizedDescription ?? "Something went very wrong.")
                loginManager.logOut()
                failure(error)
            } else {
                let loginManagerLoginResult = loginManagerLoginResult!
                
                var allPermissionsGranted = true
                
                var grantedPermissions = Set<String>()
                for item in loginManagerLoginResult.grantedPermissions {
                    if let permission = item as? String {
                        grantedPermissions.insert(permission)
                    }
                }
                
                for permission in permissions {
                    if !grantedPermissions.contains(permission) {
                        allPermissionsGranted = false
                        break
                    }
                }
                
                if allPermissionsGranted {
                    success()
                } else {
                    failure(nil)
                }
            }
        }
    }

}
