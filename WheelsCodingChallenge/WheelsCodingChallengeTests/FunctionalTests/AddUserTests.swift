//
//  AddUserTests.swift
//  WheelsCodingChallengeTests
//
//  Created by Kevin E. Rafferty II on 9/22/19.
//  Copyright © 2019 Kevin E. Rafferty II. All rights reserved.
//

import XCTest
@testable import WheelsCodingChallenge

class AddUserTests: XCTestCase {

    //MARK: - Testing Lifecycle
    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        
        super.tearDown()
    }
    
    //MARK: - User Selections are Successfull
    func testCheckingUserSelectionsIsSuccessful() {
        let isSuccessful = AddUserViewController().checkUserSelections(for: "1234567",
                                                                       displayName: "Totes",
                                                                       goldBadgeCount: "9999",
                                                                       silverBadgeCount: "9999",
                                                                       bronzeBadgeCount: "9999")
        
        XCTAssertTrue(isSuccessful, "We expected the user selections to be correct.")
    }
    
    //MARK: - Blank User Selections
    func testCheckingUserSelectionsIsUnsuccessfulWithBlankReputation() {
        let isSuccessful = AddUserViewController().checkUserSelections(for: "",
                                                                       displayName: "Totes",
                                                                       goldBadgeCount: "9999",
                                                                       silverBadgeCount: "9999",
                                                                       bronzeBadgeCount: "9999")
        
        XCTAssertFalse(isSuccessful, "We expected the user selections to be correct.")
    }
    
    func testCheckingUserSelectionsIsUnsuccessfulWithBlankDisplayName() {
        let isSuccessful = AddUserViewController().checkUserSelections(for: "1234567",
                                                                       displayName: "",
                                                                       goldBadgeCount: "9999",
                                                                       silverBadgeCount: "9999",
                                                                       bronzeBadgeCount: "9999")
        
        XCTAssertFalse(isSuccessful, "We expected the user selections to be correct.")
    }
    
    func testCheckingUserSelectionsIsUnsuccessfulWithBlankGoldBadgeCount() {
        let isSuccessful = AddUserViewController().checkUserSelections(for: "1234567",
                                                                       displayName: "Totes",
                                                                       goldBadgeCount: "",
                                                                       silverBadgeCount: "9999",
                                                                       bronzeBadgeCount: "9999")
        
        XCTAssertFalse(isSuccessful, "We expected the user selections to be correct.")
    }
    
    func testCheckingUserSelectionsIsUnsuccessfulWithBlankSilverBadgeCount() {
        let isSuccessful = AddUserViewController().checkUserSelections(for: "1234567",
                                                                       displayName: "Totes",
                                                                       goldBadgeCount: "9999",
                                                                       silverBadgeCount: "",
                                                                       bronzeBadgeCount: "9999")
        
        XCTAssertFalse(isSuccessful, "We expected the user selections to be correct.")
    }
    
    func testCheckingUserSelectionsIsUnsuccessfulWithBlankBronzeBadgeCount() {
        let isSuccessful = AddUserViewController().checkUserSelections(for: "1234567",
                                                                       displayName: "Totes",
                                                                       goldBadgeCount: "9999",
                                                                       silverBadgeCount: "9999",
                                                                       bronzeBadgeCount: "")
        
        XCTAssertFalse(isSuccessful, "We expected the user selections to be correct.")
    }
    
    //MARK: - Even Reputation Selection
    func testCheckingUserSelectionsIsUnsuccessfulWithEvenReputation() {
        let isSuccessful = AddUserViewController().checkUserSelections(for: "222222",
                                                                       displayName: "Totes",
                                                                       goldBadgeCount: "9999",
                                                                       silverBadgeCount: "9999",
                                                                       bronzeBadgeCount: "9999")
        
        XCTAssertFalse(isSuccessful, "We expected the user selections to be correct.")
    }
    
    //MARK: - Non Multiple of Three Badge Count Selections
    func testCheckingUserSelectionsIsUnsuccessfulWithGoldBadgeCountNotBeingAMultipleOfThree() {
        let isSuccessful = AddUserViewController().checkUserSelections(for: "222222",
                                                                       displayName: "Totes",
                                                                       goldBadgeCount: "1234",
                                                                       silverBadgeCount: "9999",
                                                                       bronzeBadgeCount: "9999")
        
        XCTAssertFalse(isSuccessful, "We expected the user selections to be correct.")
    }
    
    func testCheckingUserSelectionsIsUnsuccessfulWithSilverBadgeCountNotBeingAMultipleOfThree() {
        let isSuccessful = AddUserViewController().checkUserSelections(for: "222222",
                                                                       displayName: "Totes",
                                                                       goldBadgeCount: "9999",
                                                                       silverBadgeCount: "1234",
                                                                       bronzeBadgeCount: "9999")
        
        XCTAssertFalse(isSuccessful, "We expected the user selections to be correct.")
    }
    
    func testCheckingUserSelectionsIsUnsuccessfulWithBronzeBadgeCountNotBeingAMultipleOfThree() {
        let isSuccessful = AddUserViewController().checkUserSelections(for: "222222",
                                                                       displayName: "Totes",
                                                                       goldBadgeCount: "9999",
                                                                       silverBadgeCount: "9999",
                                                                       bronzeBadgeCount: "1234")
        
        XCTAssertFalse(isSuccessful, "We expected the user selections to be correct.")
    }
    
    //MARK: - Selections Exceeds Character MAX
    func testCheckingUserSelectionsIsUnsuccessfulWithMaxExceededReputation() {
        let isSuccessful = AddUserViewController().checkUserSelections(for: "12345678",
                                                                       displayName: "Totes",
                                                                       goldBadgeCount: "9999",
                                                                       silverBadgeCount: "9999",
                                                                       bronzeBadgeCount: "9999")
        
        XCTAssertFalse(isSuccessful, "We expected the user selections to be correct.")
    }
    
    func testCheckingUserSelectionsIsUnsuccessfulWithMaxExceededDisplayName() {
        let isSuccessful = AddUserViewController().checkUserSelections(for: "1234567",
                                                                       displayName: "123456789012345678901234567890",
                                                                       goldBadgeCount: "9999",
                                                                       silverBadgeCount: "9999",
                                                                       bronzeBadgeCount: "9999")
        
        XCTAssertFalse(isSuccessful, "We expected the user selections to be correct.")
    }
    
    func testCheckingUserSelectionsIsUnsuccessfulWithMaxExceededGoldBadgeCount() {
        let isSuccessful = AddUserViewController().checkUserSelections(for: "1234567",
                                                                       displayName: "Totes",
                                                                       goldBadgeCount: "12345",
                                                                       silverBadgeCount: "9999",
                                                                       bronzeBadgeCount: "9999")
        
        XCTAssertFalse(isSuccessful, "We expected the user selections to be correct.")
    }
    
    func testCheckingUserSelectionsIsUnsuccessfulWithMaxExceededSilverBadgeCount() {
        let isSuccessful = AddUserViewController().checkUserSelections(for: "1234567",
                                                                       displayName: "Totes",
                                                                       goldBadgeCount: "9999",
                                                                       silverBadgeCount: "12345",
                                                                       bronzeBadgeCount: "9999")
        
        XCTAssertFalse(isSuccessful, "We expected the user selections to be correct.")
    }
    
    func testCheckingUserSelectionsIsUnsuccessfulWithMaxExceededBronzeBadgeCount() {
        let isSuccessful = AddUserViewController().checkUserSelections(for: "1234567",
                                                                       displayName: "Totes",
                                                                       goldBadgeCount: "9999",
                                                                       silverBadgeCount: "9999",
                                                                       bronzeBadgeCount: "12345")
        
        XCTAssertFalse(isSuccessful, "We expected the user selections to be correct.")
    }
}
