//
//  UsersTableViewController.swift
//  WheelsCodingChallenge
//
//  Created by Kevin E. Rafferty II on 9/21/19.
//  Copyright © 2019 Kevin E. Rafferty II. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class UsersTableViewController: UITableViewController {
    
    //MARK: - Properties
    var stackOverflowUsers: Users?
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    //MARK: - Setup
    private func setup() {
        self.fetchStackOverflowUsers()
    }
    
    //MARK: - Networking
    func fetchStackOverflowUsers() {
        Networking().getStackOverflowUsers { [weak self] (stackOverflowUsers, resultStatus) in
            guard let strongSelf = self else { return }
            // If there are valid users and there are one or more users
            if let users = stackOverflowUsers as? Users, users.items.count > 0 {
                strongSelf.stackOverflowUsers = users
                strongSelf.tableView.reloadData()
            } else {
                
            }
        }
    }

    //MARK: - UITableView Data Source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // If there are users available return the count otherwise we set the number of rows to 0
        return self.stackOverflowUsers?.items.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UsersIdentifier", for: indexPath) as! UsersTableViewCell

        if let user = self.stackOverflowUsers?.items[indexPath.row] {
            if let reputation = user.reputation {
                cell.userReputationLabel.text = String(reputation)
            } else {
                cell.userReputationLabel.text = "no rep"
            }
            cell.userNameLabel.text = user.displayName
            cell.goldBadgeLabel.text = String(user.badgeCounts.gold)
            cell.silverBadgeLabel.text = String(user.badgeCounts.silver)
            cell.bronzeBadgeLabel.text = String(user.badgeCounts.bronze)
            
            Alamofire.request(user.profileImage).responseImage(completionHandler: { (response) in
                print(response)
                if let image = response.result.value {
                    cell.userAvatarImage.image = image
                }
            })
        }

        return cell
    }
}
