//
//  Networking.swift
//  WheelsCodingChallenge
//
//  Created by Kevin E. Rafferty II on 9/20/19.
//  Copyright © 2019 Kevin E. Rafferty II. All rights reserved.
//

import UIKit
import Alamofire


/// This enum is used within the callback of each networking method to allow the UI
/// to be responsive if a networking error were to be received.
///
/// - error: This status is returned when a networking error is received.
/// - success: This status is returned when the networking call is successful.
enum ResultStatus {
    case error
    case success
}

class Networking: NSObject {
    
    //MARK: - Local Constants
    struct Constants {
        static let stackOverflowURL: String = "https://api.stackexchange.com/2.2/users?site=stackoverflow"
    }
    
    //MARK: - Properties
    let networkingQueue = DispatchQueue.global(qos: .background)
    
    //MARK: - GET Stack Overflow Users
    /// This method will retrieve a user list from the Stack Overflow API. Only the first page will be fetched.
    ///
    /// - Parameter completion: The completion handler to be called for success or failure. A decoded Users object
    ///                         will be returned along with the result of the server response.
    func getStackOverflowUsers(completion: @escaping (Any?, ResultStatus) -> ()) {
        if let url = URL(string: Constants.stackOverflowURL) {
            var request = URLRequest(url: url)
            request.httpMethod = HTTPMethod.get.rawValue
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            Alamofire.request(request)
                .validate(statusCode: 200..<202)
                .validate(contentType: ["application/json"])
                .responseData(queue: self.networkingQueue) { response in
                    DispatchQueue.main.async {
                        switch response.result {
                        case .success(let data):
                            do {
                                let stackOverflowUsers = try JSONDecoder().decode(Users.self, from: data)
                                print("Networking Line# \(#line) - Successfully retrieved the Stack Overflow users)")
                                completion(stackOverflowUsers, .success)
                            } catch {
                                print("Networking Line# \(#line) - There was an error decoding the Stack Overflow users: \(error.localizedDescription)")
                                completion(nil, .error)
                            }
                        case .failure(let error):
                            print("Networking Line# \(#line) - There was an error retrieving the Stack Overflow users: \(error.localizedDescription)")
                            completion(nil, .error)
                        }
                    }
            }
        }
    }
}
