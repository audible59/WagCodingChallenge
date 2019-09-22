//
//  AddUserViewController.m
//  WheelsCodingChallenge
//
//  Created by Kevin E. Rafferty II on 9/21/19.
//  Copyright © 2019 Kevin E. Rafferty II. All rights reserved.
//

#import "AddUserViewController.h"

@interface AddUserViewController ()

#pragma mark - Properties
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *reputationTextField;
@property (weak, nonatomic) IBOutlet UITextField *displayNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *goldBadgeCountTextField;
@property (weak, nonatomic) IBOutlet UITextField *silverBadgeCountTextField;
@property (weak, nonatomic) IBOutlet UITextField *bronzeBadgeCountTextField;

@end

@implementation AddUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
