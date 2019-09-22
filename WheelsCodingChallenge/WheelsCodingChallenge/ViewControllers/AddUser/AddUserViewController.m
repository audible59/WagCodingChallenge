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

@property (strong, nonatomic) UITextField *activeTextField;

@property (weak, nonatomic) IBOutlet UIView *containerView;
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
    [self registerForKeyboardNotifications];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGRect convertedFrameToWindow = [self.bronzeBadgeCountTextField convertRect:self.bronzeBadgeCountTextField.frame toView:nil];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, convertedFrameToWindow.origin.y + 120);
}

#pragma mark - Setup

- (void)setupView {
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissmissKeyboard)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)setupTextFields {
    self.reputationTextField.delegate = self;
    self.displayNameTextField.delegate = self;
    self.goldBadgeCountTextField.delegate = self;
    self.silverBadgeCountTextField.delegate = self;
    self.bronzeBadgeCountTextField.delegate = self;
    
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

#pragma mark - IBAction Methods

- (IBAction)onAddUserButtonPressed:(id)sender {
    NSLog(@"Add User");
    if ([self checkUserSelections]) {
        //TODO: Add the new user to the User List
    }
}

#pragma mark - UIKeyboard Notifications

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
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
    
//    // Scroll to the active UITextField so that it is visible
//    CGRect aRect = self.view.frame;
//    aRect.size.height -= keyboardSize.height;
//    if (!CGRectContainsPoint(aRect, self.activeTextField.frame.origin)) {
//        CGPoint scrollToPoint = CGPointMake(0.0, self.activeTextField.frame.origin.y - keyboardSize.height);
//        [self.scrollView setContentOffset:scrollToPoint animated:YES];
//    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification *)aNotification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

#pragma mark - UITextField Delegates

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.activeTextField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.activeTextField = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITouch Methods

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - Helper Methods

- (BOOL)checkUserSelections {
    if ([self.displayNameTextField.text length] == 0) {
        [self presentAlertViewWithTitle:@"Missing Display Name"
                                message:@"Please enter a valid Display Name."];
        return NO;
    }
    if ([self.reputationTextField.text length] != 0) {
        NSInteger reputation = [self.reputationTextField.text integerValue];
        
        // If the reputation value is not an odd number
        if (!(reputation % 2)) {
            [self presentAlertViewWithTitle:@"Incorrect Reputation"
                                    message:@"Please enter a valid Reputation value that is an odd number."];
            return NO;
        }
    } else {
        [self presentAlertViewWithTitle:@"Missing Reputation"
                                message:@"Please enter a valid Reputation value that is an odd number."];
        return NO;
    }
    if ([self.goldBadgeCountTextField.text length] != 0) {
        NSInteger goldBadgeCount = [self.goldBadgeCountTextField.text integerValue];
        
        // If the Gold Badge Count value is not a multiple of three
        if (!(goldBadgeCount % 3)) {
            [self presentAlertViewWithTitle:@"Incorrect Gold Badge Count"
                                    message:@"Please enter a Gold Badge Count value that is a multiple of 3."];
            return NO;
        }
    } else {
        [self presentAlertViewWithTitle:@"Missing Gold Badge Count"
                                message:@"Please enter a valid Gold Badge Count value that is a multiple of 3."];
        return NO;
    }
    if ([self.silverBadgeCountTextField.text length] != 0) {
        NSInteger silverBadgeCount = [self.silverBadgeCountTextField.text integerValue];
        
        // If the Silver Badge Count value is not a multiple of three
        if (!(silverBadgeCount % 3)) {
            [self presentAlertViewWithTitle:@"Incorrect Silver Badge Count"
                                    message:@"Please enter a valid Silver Badge Count value that is a multiple of 3."];
            return NO;
        }
    } else {
        [self presentAlertViewWithTitle:@"Missing Silver Badge Count"
                                message:@"Please enter a valid Silver Badge Count value that is a multiple of 3."];
        return NO;
    }
    if ([self.bronzeBadgeCountTextField.text length] != 0) {
        NSInteger bronzeBadgeCount = [self.bronzeBadgeCountTextField.text integerValue];
        
        // If the Bronze Badge Count value is not a multiple of three
        if (!(bronzeBadgeCount % 3)) {
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
    
    [self presentViewController:alertController
                       animated:YES
                     completion:nil];
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
