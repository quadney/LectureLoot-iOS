//
//  SignUpViewController.m
//  Lecture Loot
//
//  Created by Sydney Richardson on 3/11/14.
//  Copyright (c) 2014 CashU. All rights reserved.
//

#import "SignUpViewController.h"
#import "User.h"
#import "Utilities.h"

@interface SignUpViewController ()
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
- (IBAction)signUpNewUser:(id)sender;

@end

@implementation SignUpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.signUpButton setEnabled:NO];
}

- (IBAction)enableSignUpButton:(id)sender {
    [self.signUpButton setEnabled:YES];
}

- (IBAction)signUpNewUser:(id)sender {
    
    // validate that there's stuff in the text fields
    if (!self.usernameField.text.length ||
        !self.emailField.text.length ||
        !self.passwordField.text.length ||
        !self.firstNameField.text.length ||
        !self.lastNameField.text.length) {
        UIAlertView *formValidationAlert = [[UIAlertView alloc] initWithTitle:@"Missing Fields"
                                                                      message:@"Bro, all fields are required."
                                                                     delegate:nil
                                                            cancelButtonTitle:@"Fine. I'll do it"
                                                            otherButtonTitles:nil];
        [formValidationAlert show];
        return;
    }
    
    //[Utilities sharedUtilities] create
    
    [self dismissViewControllerAnimated:YES completion:nil];

}
@end
