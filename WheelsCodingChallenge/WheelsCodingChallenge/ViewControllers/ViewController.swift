//
//  ViewController.swift
//  WheelsCodingChallenge
//
//  Created by Kevin E. Rafferty II on 9/20/19.
//  Copyright © 2019 Kevin E. Rafferty II. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchStackOverflowUsers()
    }
    
    func fetchStackOverflowUsers() {
        Networking().getStackOverflowUsers { [weak self] (stackOverflowUsers, resultStatus) in
            guard let strongSelf = self else { return }
            // If there are valid users and there are one or more users
            if let users = stackOverflowUsers as? Users, users.items.count > 0 {
                
            } else {
                
            }
        }
    }
}
