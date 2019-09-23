//
//  User.swift
//  WheelsCodingChallenge
//
//  Created by Kevin E. Rafferty II on 9/20/19.
//  Copyright © 2019 Kevin E. Rafferty II. All rights reserved.
//

public struct Users: Decodable {
    
    //MARK: - Properties
    let items: [Item]
    let hasMore: Bool
    let quotaMax: Int
    let quotaRemaining: Int
    
    //MARK: - Coding Keys ENUM
    private enum CodingKeys: String, CodingKey {
        case items
        case hasMore = "has_more"
        case quotaMax = "quota_max"
        case quotaRemaining = "quota_remaining"
    }
    
    //MARK: - Item Struct
    public struct Item: Decodable {
        let link: String?
        let userID: Int?
        let location: String?
        let userType: String?
        let accountID: Int?
        let acceptRate: Int?
        let reputation: Int?
        let isEmployee: Bool?
        let websiteURL: String?
        let badgeCounts: BadgeCounts
        let displayName: String
        let creationDate: Double?
        let profileImage: String
        let lastAccessDate: Double?
        let lastModifiedDate: Double?
        let reputationChangeDay: Int?
        let reputationChangeWeek: Int?
        let reputationChangeYear: Int?
        let reputationChangeMonth: Int?
        let reputationChangeQuarter: Int?
        
        //MARK: - Coding Keys ENUM
        private enum CodingKeys: String, CodingKey {
            case link
            case userID = "user_id"
            case location
            case userType = "user_type"
            case accountID = "account_id"
            case acceptRate = "accept_rate"
            case reputation
            case isEmployee = "is_employee"
            case websiteURL = "website_url"
            case badgeCounts = "badge_counts"
            case displayName = "display_name"
            case creationDate = "creation_date"
            case profileImage = "profile_image"
            case lastAccessDate = "last_access_date"
            case lastModifiedDate = "last_modified_date"
            case reputationChangeDay = "reputation_change_day"
            case reputationChangeWeek = "reputation_change_week"
            case reputationChangeYear = "reputation_change_year"
            case reputationChangeMonth = "reputation_change_month"
            case reputationChangeQuarter = "reputation_change_quarter"
        }
        
        //MARK: - Badge Counts Struct
        public struct BadgeCounts: Decodable {
            let gold: Int
            let bronze: Int
            let silver: Int
        }
    }
}
