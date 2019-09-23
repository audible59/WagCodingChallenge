//
//  AddUserViewController.m
//  WheelsCodingChallenge
//
//  Created by Kevin E. Rafferty II on 9/21/19.
//  Copyright © 2019 Kevin E. Rafferty II. All rights reserved.
//

#import "AddUserViewController.h"

// Character Limit Constanst
static const int MAX_REPUTATION_CHARACTER_LIMIT = 7;
static const int MAX_DISPLAY_NAME_CHARACTER_LIMIT = 25;
static const int MAX_GOLD_BADGE_COUNT_CHARACTER_LIMIT = 4;
static const int MAX_SILVER_BADGE_COUNT_CHARACTER_LIMIT = 4;
static const int MAX_BRONZE_BADGE_COUNT_CHARACTER_LIMIT = 4;

// User Info Constants
static NSString * const reputationInfo = @"reputation";
static NSString * const displayNameInfo = @"displayName";
static NSString * const goldBadgeCountInfo = @"goldBadgeCount";
static NSString * const silverBadgeCountInfo = @"silverBadgeCount";
static NSString * const bronzeBadgeCountInfo = @"bronzeBadgeCount";

// NSNotification Name Constant
static NSString * const addNewUserNotificationName = @"AddNewUserToTableView";

// Reputation UIAlertController Constants
static NSString * const reputationAlertViewMessage = @"Please enter a valid Reputation value that is an odd number.";
static NSString * const missingReputationAlertViewTitle = @"Missing Reputation";
static NSString * const incorrectReputationAlertViewTitle = @"Incorrect Reputation";

static NSString * const maximumReputationAlertViewTitle = @"Reputation Limit";
static NSString * const maximumReputationAlertViewMessage = @"Please enter a Reputation that is less than 8 characters";

// Display Name UIAlertController Constants
static NSString * const missingDisplayNameAlertViewTitle = @"Missing Display Name";
static NSString * const missingDisplayNameAlertViewMessage = @"Please enter a valid Display Name.";

static NSString * const maximumDisplayNameAlertViewTitile = @"Display Name Limit";
static NSString * const maximumDisplayNameAlertViewMessage = @"Please enter a Display Name that is less than 25 characters.";

// Gold Badge Count UIAlertController Constants
static NSString * const goldBadgeCountAlertViewMessage = @"Please enter a valid Gold Badge Count value that is a multiple of 3.";
static NSString * const missingGoldBadgeCountAlertViewTitle = @"Missing Gold Badge Count";
static NSString * const incorrectGoldBadgeCountAlertViewTitle = @"Incorrect Gold Badge Count";

static NSString * const maximumGoldBadgeCountAlertViewTitile = @"Gold Badge Count Limit";
static NSString * const maximumGoldBadgeCountAlertViewMessage = @"Please enter a Gold Badge Count that is less than 5 characters.";

// Silver Badge Count UIAlertController Constants
static NSString * const silverBadgeCountAlertViewMessage = @"Please enter a valid Silver Badge Count value that is a multiple of 3.";
static NSString * const missingSilverBadgeCountAlertViewTitle = @"Missing Silver Badge Count";
static NSString * const incorrectSilverBadgeCountAlertViewTitle = @"Incorrect Silver Badge Count";

static NSString * const maximumSilverBadgeCountAlertViewTitile = @"Silver Badge Count Limit";
static NSString * const maximumSilverBadgeCountAlertViewMessage = @"Please enter a Silver Badge Count that is less than 5 characters.";

// Bronze Badge Count UIAlertController Constants
static NSString * const bronzeBadgeCountAlertViewMessage = @"Please enter a valid Bronze Badge Count value that is a multiple of 3.";
static NSString * const missingBronzeBadgeCountAlertViewTitle = @"Missing Bronze Badge Count";
static NSString * const incorrectBronzeBadgeCountAlertViewTitle = @"Incorrect Bronze Badge Count";

static NSString * const maximumBronzeBadgeCountAlertViewTitile = @"Bronze Badge Count Limit";
static NSString * const maximumBronzeBadgeCountAlertViewMessage = @"Please enter a Bronze Badge Count that is less than 5 characters.";

@interface AddUserViewController () <UITextFieldDelegate>

#pragma mark - Properties

@property (assign, nonatomic) CGPoint lastScrollViewOffset;

@property (strong, nonatomic) UITextField *activeTextField;

#pragma mark - IBOutlet Properties

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *reputationTextField;
@property (weak, nonatomic) IBOutlet UITextField *displayNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *goldBadgeCountTextField;
@property (weak, nonatomic) IBOutlet UITextField *silverBadgeCountTextField;
@property (weak, nonatomic) IBOutlet UITextField *bronzeBadgeCountTextField;

@end

@implementation AddUserViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupTextFields];
    [self setupKeyboardNotifications];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGRect convertedFrameToWindow = [self.bronzeBadgeCountTextField convertRect:self.bronzeBadgeCountTextField.frame toView:nil];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, convertedFrameToWindow.origin.y + 150);
}

#pragma mark - Setup

- (void)setupView {
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissmissKeyboard)];
//    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)setupTextFields {
    self.reputationTextField.delegate = self;
    self.displayNameTextField.delegate = self;
    self.goldBadgeCountTextField.delegate = self;
    self.silverBadgeCountTextField.delegate = self;
    self.bronzeBadgeCountTextField.delegate = self;
    
    // A Toolbar with a Done UIBarButtonITem is only added to the UITextFields that present a Number Pad to the user
    UIToolbar *keyboardToolbar = [[UIToolbar alloc] init];
    [keyboardToolbar sizeToFit];
    
    UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                   target:nil
                                                                                   action:nil];
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                   target:self.view
                                                                                   action:@selector(endEditing:)];
    keyboardToolbar.items = @[ flexBarButton, doneBarButton ];
    self.reputationTextField.inputAccessoryView = keyboardToolbar;
    self.goldBadgeCountTextField.inputAccessoryView = keyboardToolbar;
    self.silverBadgeCountTextField.inputAccessoryView = keyboardToolbar;
    self.bronzeBadgeCountTextField.inputAccessoryView = keyboardToolbar;
}

- (void)setupKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - IBAction Methods

- (IBAction)onAddUserButtonPressed:(id)sender {
    NSLog(@"Attempting to add a new user...");
    if ([self checkUserSelectionsFor:self.reputationTextField.text
                         displayName:self.displayNameTextField.text
                      goldBadgeCount:self.goldBadgeCountTextField.text
                    silverBadgeCount:self.silverBadgeCountTextField.text
                    bronzeBadgeCount:self.bronzeBadgeCountTextField.text]) {
        // Setup the data to be passed into the notification post
        NSDictionary *userInfo = @{ reputationInfo : self.reputationTextField.text,
                                    displayNameInfo : self.displayNameTextField.text,
                                    goldBadgeCountInfo : self.goldBadgeCountTextField.text,
                                    silverBadgeCountInfo : self.silverBadgeCountTextField.text,
                                    bronzeBadgeCountInfo : self.bronzeBadgeCountTextField.text };
        
        [[NSNotificationCenter defaultCenter] postNotificationName:addNewUserNotificationName
                                                             object:nil
                                                           userInfo:userInfo];
        
        // Dismiss this UIViewController and go back to the Stack Overflow Users List
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UIKeyboard Selector Methods

- (void)dissmissKeyboard {
    [self.view endEditing:YES];
}

- (void)keyboardWillBeShown:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;

    // Scroll to the active UITextField so that it is visible
    CGRect aRect = self.view.frame;
    aRect.size.height -= keyboardSize.height;
    if (!CGRectContainsPoint(aRect, self.activeTextField.frame.origin)) {
        CGPoint scrollToPoint = CGPointMake(0.0, self.activeTextField.frame.origin.y - keyboardSize.height);
        [self.scrollView setContentOffset:scrollToPoint animated:YES];
    }
}


- (void)keyboardWillBeHidden:(NSNotification *)notification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    [self.scrollView setContentOffset: self.lastScrollViewOffset];
}

#pragma mark - UITextField Delegates

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.activeTextField = textField;
    self.lastScrollViewOffset = self.scrollView.contentOffset;
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    self.activeTextField = nil;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    self.activeTextField = nil;
    return YES;
}

#pragma mark - UITouch Methods

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - Helper Methods

- (BOOL)checkUserSelectionsFor:(NSString *)reputation
                   displayName:(NSString *)displayName
                goldBadgeCount:(NSString *)goldBadgeCount
              silverBadgeCount:(NSString *)silverBadgeCount
              bronzeBadgeCount:(NSString *)bronzeBadgeCount {
    // If the display name text field is not empty
    if ([displayName length] == 0) {
        [self presentAlertViewWithTitle:missingDisplayNameAlertViewTitle
                                message:missingDisplayNameAlertViewMessage];
        return NO;
        
      // Else if the display name is greater than 30 characters
    } else if ([displayName length] > MAX_DISPLAY_NAME_CHARACTER_LIMIT) {
        [self presentAlertViewWithTitle:maximumDisplayNameAlertViewTitile
                                message:maximumDisplayNameAlertViewMessage];
        return NO;
    }
    // If the reputation text field is not empty
    if ([reputation length] != 0) {
        // If the Reputation text field is greater than 7 characters
        if ([reputation length] > MAX_REPUTATION_CHARACTER_LIMIT) {
            [self presentAlertViewWithTitle:maximumReputationAlertViewTitle
                                    message:maximumReputationAlertViewMessage];
            return NO;
        }
        
        NSInteger reputationInt = [reputation integerValue];
        
        // If the reputation value is not an odd number
        if ((reputationInt % 2) == 0) {
            [self presentAlertViewWithTitle:incorrectReputationAlertViewTitle
                                    message:reputationAlertViewMessage];
            return NO;
        }
    } else {
        [self presentAlertViewWithTitle:missingReputationAlertViewTitle
                                message:reputationAlertViewMessage];
        return NO;
    }
    // If the gold badge count text field is not empty
    if ([goldBadgeCount length] != 0) {
        // If the Gold Badge Count text field is greater than 4 characters
        if ([goldBadgeCount length] > MAX_GOLD_BADGE_COUNT_CHARACTER_LIMIT) {
            [self presentAlertViewWithTitle:maximumGoldBadgeCountAlertViewTitile
                                    message:maximumGoldBadgeCountAlertViewMessage];
            return NO;
        }
        
        NSInteger goldBadgeCountInt = [goldBadgeCount integerValue];
        
        // If the Gold Badge Count value is not a multiple of three
        if ((goldBadgeCountInt % 3) != 0) {
            [self presentAlertViewWithTitle:incorrectGoldBadgeCountAlertViewTitle
                                    message:goldBadgeCountAlertViewMessage];
            return NO;
        }
    } else {
        [self presentAlertViewWithTitle:missingGoldBadgeCountAlertViewTitle
                                message:goldBadgeCountAlertViewMessage];
        return NO;
    }
    // If the silver badge count text field is not empty
    if ([silverBadgeCount length] != 0) {
        // If the Silver Badge Count text field is greater than 4 characters
        if ([silverBadgeCount length] > MAX_SILVER_BADGE_COUNT_CHARACTER_LIMIT) {
            [self presentAlertViewWithTitle:maximumSilverBadgeCountAlertViewTitile
                                    message:maximumSilverBadgeCountAlertViewMessage];
            return NO;
        }
        
        NSInteger silverBadgeCountInt = [silverBadgeCount integerValue];
        
        // If the Silver Badge Count value is not a multiple of three
        if ((silverBadgeCountInt % 3) != 0) {
            [self presentAlertViewWithTitle:incorrectSilverBadgeCountAlertViewTitle
                                    message:silverBadgeCountAlertViewMessage];
            return NO;
        }
    } else {
        [self presentAlertViewWithTitle:missingSilverBadgeCountAlertViewTitle
                                message:silverBadgeCountAlertViewMessage];
        return NO;
    }
    // If the bronze badge count text field is not empty
    if ([bronzeBadgeCount length] != 0) {
        // If the Bronze Badge Count text field is greater than 4 characters
        if ([bronzeBadgeCount length] > MAX_BRONZE_BADGE_COUNT_CHARACTER_LIMIT) {
            [self presentAlertViewWithTitle:maximumBronzeBadgeCountAlertViewTitile
                                    message:maximumBronzeBadgeCountAlertViewMessage];
            return NO;
        }
        
        NSInteger bronzeBadgeCountInt = [bronzeBadgeCount integerValue];
        
        // If the Bronze Badge Count value is not a multiple of three
        if ((bronzeBadgeCountInt % 3) != 0) {
            [self presentAlertViewWithTitle:incorrectBronzeBadgeCountAlertViewTitle
                                    message:bronzeBadgeCountAlertViewMessage];
            return NO;
        }
    } else {
        [self presentAlertViewWithTitle:missingBronzeBadgeCountAlertViewTitle
                                message:bronzeBadgeCountAlertViewMessage];
        return NO;
    }
    
    return YES;
}

- (void)presentAlertViewWithTitle:(NSString *)title
                          message:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
        NSLog(@"The user pressed the OK button");
    }];
    
    [alertController addAction:defaultAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
