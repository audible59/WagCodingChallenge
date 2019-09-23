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
    var stackOverflowUsers: [Users.Item]?
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.setupNotifications()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - Setup
    private func setup() {
        self.fetchStackOverflowUsers()
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(forName: Notification.Name("AddNewUserToTableView"),
                                               object: nil,
                                               queue: nil,
                                               using: self.updateTableForNewUser(_:))
    }
    
    //MARK: - Networking
    func fetchStackOverflowUsers() {
        Networking().getStackOverflowUsers { [weak self] (stackOverflowUsers, resultStatus) in
            guard let strongSelf = self else { return }
            // If there are valid users and there are one or more users
            if let users = stackOverflowUsers as? Users, users.items.count > 0 {
                strongSelf.stackOverflowUsers = users.items
                strongSelf.tableView.reloadData()
            } else {
                
            }
        }
    }
    
    //MARK: - Notification Delector Methods
    private func updateTableForNewUser(_ notification: Notification) {
        guard let userInfo = notification.userInfo else {
            print("User UITableViewController Line# \(#line) - We did not receive any data to update the UITableView")
            return
        }
        
        if let reputation = userInfo["reputation"] as? String,
            let displayName = userInfo["displayName"] as? String,
            let goldBadgeCount = userInfo["goldBadgeCount"] as? String,
            let silverBadgeCount = userInfo["silverBadgeCount"] as? String,
            let bronzeBadgeCount = userInfo["bronzeBadgeCount"] as? String {
            let newUserBadgeCount = Users.Item.BadgeCounts(gold: Int(goldBadgeCount) ?? 0,
                                                           bronze: Int(bronzeBadgeCount) ?? 0,
                                                           silver: Int(silverBadgeCount) ?? 0)
            
            let newUser = Users.Item(link: nil,
                                     userID: nil,
                                     location: nil,
                                     userType: nil,
                                     accountID: nil,
                                     acceptRate: nil,
                                     reputation: Int(reputation),
                                     isEmployee: nil,
                                     websiteURL: nil,
                                     badgeCounts: newUserBadgeCount,
                                     displayName: displayName,
                                     creationDate: nil,
                                     profileImage: "",
                                     lastAccessDate: nil,
                                     lastModifiedDate: nil,
                                     reputationChangeDay: nil,
                                     reputationChangeWeek: nil,
                                     reputationChangeYear: nil,
                                     reputationChangeMonth: nil,
                                     reputationChangeQuarter: nil)
            
            print("User UITableViewController Line# \(#line) - Inserting new Stack Overflow user: \(newUser)")
            self.stackOverflowUsers?.insert(newUser, at: 0)
            self.tableView.reloadData()
        } else {
            print("User UITableViewController Line# \(#line) - There was an error inserting new Stack Overflow user. ")
        }
    }

    //MARK: - UITableView Data Source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // If there are users available return the count otherwise we set the number of rows to 0
        return self.stackOverflowUsers?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UsersIdentifier", for: indexPath) as! UsersTableViewCell

        if let user = self.stackOverflowUsers?[indexPath.row] {
            if let reputation = user.reputation {
                cell.userReputationLabel.text = String(reputation)
            } else {
                cell.userReputationLabel.text = "no rep"
            }
            cell.userNameLabel.text = user.displayName
            cell.goldBadgeLabel.text = String(user.badgeCounts.gold)
            cell.silverBadgeLabel.text = String(user.badgeCounts.silver)
            cell.bronzeBadgeLabel.text = String(user.badgeCounts.bronze)
            
            if let url = URL(string: user.profileImage) {
                cell.userAvatarImage.af_setImage(withURL: url, placeholderImage: UIImage(named: "placeHolderImage"))
            } else {
                cell.userAvatarImage.image = UIImage(named: "placeHolderImage")
            }
        }

        return cell
    }
}
