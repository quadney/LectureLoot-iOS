//
//  SignInViewController.m
//  Lecture Loot
//
//  Created by Sydney Richardson on 3/11/14.
//  Copyright (c) 2014 CashU. All rights reserved.
//

#import "SignInViewController.h"
#import "Utilities.h"

@interface SignInViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userEmailField;
@property (weak, nonatomic) IBOutlet UITextField *userPasswordField;
- (IBAction)logInUser:(id)sender;

@end

@implementation SignInViewController

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
}

- (IBAction)logInUser:(id)sender {
    // validate that there's stuff in the text fields
    if (!self.userEmailField.text.length ||
        !self.userPasswordField.text.length) {
        UIAlertView *formValidationAlert = [[UIAlertView alloc] initWithTitle:@"Missing Fields"
                                                                      message:@"Bro, all fields are required."
                                                                     delegate:nil
                                                            cancelButtonTitle:@"Fine. I'll do it"
                                                            otherButtonTitles:nil];
        [formValidationAlert show];
        return;
    }
    
    // for testing purposes
    [[Utilities sharedUtilities] createAndSetUserInformationWithFirstName:@"Test"
                                                                 lastName:@"Example"
                                                                 username:@"squidkneeIsAwesome"
                                                                    email:self.userEmailField.text
                                                                 password:self.userPasswordField.text];

    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
