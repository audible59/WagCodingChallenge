//
//  AddUserViewController.m
//  WheelsCodingChallenge
//
//  Created by Kevin E. Rafferty II on 9/21/19.
//  Copyright © 2019 Kevin E. Rafferty II. All rights reserved.
//

#import "AddUserViewController.h"

@interface AddUserViewController () <UITextFieldDelegate>

#pragma mark - Properties

@property (assign, nonatomic) CGPoint lastScrollViewOffset;

@property (strong, nonatomic) UITextField *activeTextField;

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
    
    // A Toolbar with a Done UIBarButtonITem is added to the UITextFields that present a Number Pad to the user
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
                                             selector:@selector(keyboardWasShown:)
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
        NSDictionary *userInfo = @{ @"reputation" : self.reputationTextField.text,
                                    @"displayName" : self.displayNameTextField.text,
                                    @"goldBadgeCount" : self.goldBadgeCountTextField.text,
                                    @"silverBadgeCount" : self.silverBadgeCountTextField.text,
                                    @"bronzeBadgeCount" : self.bronzeBadgeCountTextField.text };
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AddNewUserToTableView"
                                                             object:nil
                                                           userInfo:userInfo];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UIKeyboard Selector Methods

- (void)dissmissKeyboard {
    [self.view endEditing:YES];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification *)notification {
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

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification *)aNotification {
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

//- (void)textFieldDidBeginEditing:(UITextField *)textField {
//
//}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    self.activeTextField = nil;
    return YES;
}

//- (void)textFieldDidEndEditing:(UITextField *)textField {
//
//}

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
    if ([displayName length] == 0) {
        [self presentAlertViewWithTitle:@"Missing Display Name"
                                message:@"Please enter a valid Display Name."];
        return NO;
    }
    if ([reputation length] != 0) {
        NSInteger reputationInt = [reputation integerValue];
        
        // If the reputation value is not an odd number
        if ((reputationInt % 2) == 0) {
            [self presentAlertViewWithTitle:@"Incorrect Reputation"
                                    message:@"Please enter a valid Reputation value that is an odd number."];
            return NO;
        }
    } else {
        [self presentAlertViewWithTitle:@"Missing Reputation"
                                message:@"Please enter a valid Reputation value that is an odd number."];
        return NO;
    }
    if ([goldBadgeCount length] != 0) {
        NSInteger goldBadgeCountInt = [goldBadgeCount integerValue];
        
        // If the Gold Badge Count value is not a multiple of three
        if ((goldBadgeCountInt % 3) != 0) {
            [self presentAlertViewWithTitle:@"Incorrect Gold Badge Count"
                                    message:@"Please enter a Gold Badge Count value that is a multiple of 3."];
            return NO;
        }
    } else {
        [self presentAlertViewWithTitle:@"Missing Gold Badge Count"
                                message:@"Please enter a valid Gold Badge Count value that is a multiple of 3."];
        return NO;
    }
    if ([silverBadgeCount length] != 0) {
        NSInteger silverBadgeCountInt = [silverBadgeCount integerValue];
        
        // If the Silver Badge Count value is not a multiple of three
        if ((silverBadgeCountInt % 3) != 0) {
            [self presentAlertViewWithTitle:@"Incorrect Silver Badge Count"
                                    message:@"Please enter a valid Silver Badge Count value that is a multiple of 3."];
            return NO;
        }
    } else {
        [self presentAlertViewWithTitle:@"Missing Silver Badge Count"
                                message:@"Please enter a valid Silver Badge Count value that is a multiple of 3."];
        return NO;
    }
    if ([bronzeBadgeCount length] != 0) {
        NSInteger bronzeBadgeCountInt = [bronzeBadgeCount integerValue];
        
        // If the Bronze Badge Count value is not a multiple of three
        if ((bronzeBadgeCountInt % 3) != 0) {
            [self presentAlertViewWithTitle:@"Incorrect Bronze Badge Count"
                                    message:@"Please enter a valid Bronze Badge Count value that is a multiple of 3."];
            return NO;
        }
    } else {
        [self presentAlertViewWithTitle:@"Missing Bronze Badge Count"
                                message:@"Please enter a valid Bronze Badge Count value that is a multiple of 3."];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
