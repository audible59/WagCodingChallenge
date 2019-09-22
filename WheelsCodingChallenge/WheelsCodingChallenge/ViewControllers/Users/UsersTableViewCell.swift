//
//  UsersTableViewCell.swift
//  WheelsCodingChallenge
//
//  Created by Kevin E. Rafferty II on 9/21/19.
//  Copyright © 2019 Kevin E. Rafferty II. All rights reserved.
//

import UIKit

class UsersTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var goldBadgeImage: UIImageView!
    @IBOutlet weak var goldBadgeLabel: UILabel!
    @IBOutlet weak var userAvatarImage: UIImageView!
    @IBOutlet weak var silverBadgeImage: UIImageView!
    @IBOutlet weak var silverBadgeLabel: UILabel!
    @IBOutlet weak var bronzeBadgeImage: UIImageView!
    @IBOutlet weak var bronzeBadgeLabel: UILabel!
    @IBOutlet weak var userReputationLabel: UILabel!
    
    //MARK: - View Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
