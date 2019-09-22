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
    [self registerForKeyboardNotifications];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGRect convertedFrameToWindow = [self.bronzeBadgeCountTextField convertRect:self.bronzeBadgeCountTextField.frame toView:nil];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, convertedFrameToWindow.origin.y + 120);
}

#pragma mark - Setup

- (void)setupView {
    self.reputationTextField.delegate = self;
    self.displayNameTextField.delegate = self;
    self.goldBadgeCountTextField.delegate = self;
    self.silverBadgeCountTextField.delegate = self;
    self.bronzeBadgeCountTextField.delegate = self;
}

#pragma mark - IBAction Methods

- (IBAction)onAddUserButtonPressed:(id)sender {
    
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
}

#pragma mark - UITextField Delegates

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.activeTextField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.activeTextField = nil;
}

#pragma mark - UITouch Methods

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
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
