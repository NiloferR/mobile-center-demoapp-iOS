//
//  TwitterSocialService.swift
//  MobileCenterExample
//
//  Created by Ruslan Mansurov on 6/1/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import UIKit

import Fabric
import TwitterKit

class TwitterSocialService {
    
    init(settingsService: SettingsService) {
        Fabric.with( [Twitter.self] )
        Twitter.sharedInstance().start( withConsumerKey: settingsService.twitterConsumerKey, consumerSecret: settingsService.twitterConsumerSecret )
    }
}

// MARK: - SocialService
extension TwitterSocialService: SocialService {
    
    func logIn(with viewController: UIViewController, completion: @escaping (User?, Error?) -> Void) {
        
        Twitter.sharedInstance().logIn(with: viewController) { ( session, error ) in
            
            guard let session = session else {
                completion(nil, error)
                return
            }
            
            let twitterClient = TWTRAPIClient.withCurrentUser()
            guard let userId = twitterClient.userID else {
                let logInError = error ?? NSError(type: .Unknown)
                completion(nil, logInError)
                return
            }
            
            twitterClient.loadUser(withID: userId) { ( user, error ) in
                var myUser: User?
                if let user = user {
                    myUser = User(fullName: user.name,
                                  accessToken: session.authToken,
                                  socialNetwork: SocialNetwork.Twitter,
                                  imageUrlString: user.profileImageLargeURL
                    )
                }
                completion(myUser, error)
            }
        }
    }
}
