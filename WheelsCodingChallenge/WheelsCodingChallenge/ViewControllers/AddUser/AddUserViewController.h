//
//  AddUserViewController.h
//  WheelsCodingChallenge
//
//  Created by Kevin E. Rafferty II on 9/21/19.
//  Copyright © 2019 Kevin E. Rafferty II. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddUserViewController : UIViewController

- (BOOL)checkUserSelectionsFor:(NSString *)reputation
                   displayName:(NSString *)displayName
                goldBadgeCount:(NSString *)goldBadgeCount
              silverBadgeCount:(NSString *)silverBadgeCount
              bronzeBadgeCount:(NSString *)bronzeBadgeCount;

@end
