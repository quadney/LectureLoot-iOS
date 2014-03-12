//
//  InitialViewController.m
//  Lecture Loot
//
//  Created by Sydney Richardson on 3/11/14.
//  Copyright (c) 2014 CashU. All rights reserved.
//

#import "InitialViewController.h"
#import "SignInViewController.h"
#import "SignUpViewController.h"

@interface InitialViewController ()
- (IBAction)registerWithFacebook:(id)sender;


@end

@implementation InitialViewController

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

- (IBAction)registerWithFacebook:(id)sender {
    
}

- (IBAction)registerWithEmail:(id)sender {
    SignUpViewController *signUpVC = [[SignUpViewController alloc] init];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:signUpVC];
    
    [self presentViewController:navController animated:YES completion:nil];
}

@end
