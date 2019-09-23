# WheelsCodingChallenge
Biking awesomeness

Once this project has been cloned or downloaded please run `pod install` within the same directory as the `WheelsCodingChallenge.xcodeproj` file. Once completed, ensure that Xcode has been closed down and then open up the newly created `WheelsCodingChallenge.xcworkspace`.

## iOS Supported Devices
Since there were no specifications for which iOS devices were to be supported, this project supports iOS devices iPhone 8/iPhone 8 Plus and above.

## Business Logic
There was no requirement for detecting character limits within the Add User screen. However, since the User List design used cells that are smaller I decided to add character limits so that the labels within this list would not be truncated (i.g. 14,874...) when a new user was added to this list.

## Functional Tests
XCUITest was used for code coverage around the Networking API as well as the add user business logic. To run these Unit Tests you can hit the play button within the Test Navigator or long press the Run button and select the option Test to run all tests.

## Networking
AlamoFire was used because it also comes with AlamoFireImage for image caching.

## Parsing JSON Data
Swift's Codable protocol was used to decode the downloaded JSON data from the Stack Overflow site. This design choice was made so that the `Users.swift` class can neatly package up the decoded data and easily be used when setting up the UITableView. In addition, this allowed for the caching of the Items array and allowed for easy addition of new users within the UITableView.

## Image Caching
AlamoFireImage was used for image caching within the UITableView.

## Notifications
I decided to use the Notification system instead of a block to return the new user information back to the UITableViewController for several reasons:

* The vast majority of projects that I have worked on typically require the need for a one to many solution when updates/changes are made within the application.
* Notifications are easy to follow throughout the application.
* Information can easily be added/deleted from the posting notification.

Other solutions considered for this project:
* Delegates (one-to-one)
* Unwind Segues
* Closures

## Circle CI
Unfortunately, I ran out of time and was not able to setup the YAML file needed to run Circle CI. However, CI/CD is something I prefer to setup in the beginning of projects to monitor all testing and help with the deploying process.
