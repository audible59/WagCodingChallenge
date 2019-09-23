//
//  WheelsCodingChallengeTests.swift
//  WheelsCodingChallengeTests
//
//  Created by Kevin E. Rafferty II on 9/20/19.
//  Copyright © 2019 Kevin E. Rafferty II. All rights reserved.
//

import XCTest
import OHHTTPStubs
@testable import WheelsCodingChallenge

class NetworkingTests: XCTestCase {
    
    //MARK: - Properties
    var host: String!
    var path: String!
    var stubbedJSON: [String : Any]!
    
    //MARK: - Testing Lifecycle
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        self.host = ""
        self.path = ""
        self.stubbedJSON = [:]
        OHHTTPStubs.removeAllStubs()
        super.tearDown()
    }
    
    //MARK: - Networking Tests
    func testRetrievingStackOverflowUsers() {
        self.host = "api.stackexchange.com"
        self.path = "/2.2/users?site=stackoverflow"
        
        // Create the POST stub for Patient Vitals
        stub(condition: isHost(self.host)) { _ in
            let stubbedJSON = """
                              {"items":[{"badge_counts":{"bronze":8588,"silver":8202,"gold":717},"account_id":11683,"is_employee":false,"last_modified_date":1568689297,"last_access_date":1569009389,"reputation_change_year":54765,"reputation_change_quarter":16891,"reputation_change_month":4141,"reputation_change_week":1230,"reputation_change_day":0,"reputation":1132296,"creation_date":1222430705,"user_type":"registered","user_id":22656,"accept_rate":86,"location":"Reading, United Kingdom","website_url":"http://csharpindepth.com","link":"https://stackoverflow.com/users/22656/jon-skeet","profile_image":"https://www.gravatar.com/avatar/6d8ebb117e8d83d74ea95fbdd0f87e13?s=128&d=identicon&r=PG","display_name":"Jon Skeet"},{"badge_counts":{"bronze":3485,"silver":2899,"gold":328},"account_id":4243,"is_employee":false,"last_modified_date":1568881812,"last_access_date":1569018488,"reputation_change_year":62318,"reputation_change_quarter":19359,"reputation_change_month":4715,"reputation_change_week":1355,"reputation_change_day":0,"reputation":892864,"creation_date":1221344553,"user_type":"registered","user_id":6309,"accept_rate":100,"location":"France","website_url":"http://careers.stackoverflow.com/vonc","link":"https://stackoverflow.com/users/6309/vonc","profile_image":"https://www.gravatar.com/avatar/7aa22372b695ed2b26052c340f9097eb?s=128&d=identicon&r=PG","display_name":"VonC"}],"has_more":true,"quota_max":300,"quota_remaining":299}
                              """
            return OHHTTPStubsResponse(data: stubbedJSON.data(using: .utf8)!, statusCode: 200, headers: ["Content-Type" : "application/json"])
        }
        
        // Expectation
        let stackOverflowUsersExpectation = self.expectation(description: "We expected the getStackOverflowUsers method's completion handler to be called.")
        
        // Code Under Test
        Networking().getStackOverflowUsers { (stackOverflowUsers, resultStatus) in
            switch resultStatus {
            case .error:
                break
            case .success:
                if let users = stackOverflowUsers as? Users {
                    // User One
                    XCTAssertEqual(users.items[0].badgeCounts.gold, 717)
                    XCTAssertEqual(users.items[0].badgeCounts.silver, 8202)
                    XCTAssertEqual(users.items[0].badgeCounts.bronze, 8588)
                    XCTAssertEqual(users.items[0].displayName, "Jon Skeet")
                    XCTAssertEqual(users.items[0].profileImage, "https://www.gravatar.com/avatar/6d8ebb117e8d83d74ea95fbdd0f87e13?s=128&d=identicon&r=PG")
                    
                    // User Two
                    XCTAssertEqual(users.items[1].badgeCounts.gold, 328)
                    XCTAssertEqual(users.items[1].badgeCounts.silver, 2899)
                    XCTAssertEqual(users.items[1].badgeCounts.bronze, 3485)
                    XCTAssertEqual(users.items[1].displayName, "VonC")
                    XCTAssertEqual(users.items[1].profileImage, "https://www.gravatar.com/avatar/7aa22372b695ed2b26052c340f9097eb?s=128&d=identicon&r=PG")
                } else {
                    
                }
                stackOverflowUsersExpectation.fulfill()
            }
        }
        self.waitForExpectations(timeout: 1.0, handler: .none)
    }
}
