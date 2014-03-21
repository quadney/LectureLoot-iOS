//
//  LLTabBarController.m
//  Lecture Loot
//
//  Created by Sydney Richardson on 3/11/14.
//  Copyright (c) 2014 CashU. All rights reserved.
//

#import "LLTabBarController.h"
#import "Utilities.h"
#import "InitialViewController.h"

@interface LLTabBarController ()

@end

@implementation LLTabBarController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        // This is for developement only, until we get the login stuff completed
//        [[Utilities sharedUtilities] createAndSetUserInformationWithFirstName:@"FirstName"
//                                                                     lastName:@"LastName"
//                                                                     username:@"username"
//                                                                        email:@"someone@example.com"
//                                                                     password:@"password"];
        
        // when the tab bar controller initializes, make sure that it loads the middle tab.
        [self setSelectedIndex:1];
    }
    return self;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // for testing purposes
    [[Utilities sharedUtilities] setDefaultUser];
    
    
    if( ![[Utilities sharedUtilities] currentUser]) {
        //there is no user logged in, so present the signin/register storyboard
        InitialViewController *loginVC = [[UIStoryboard storyboardWithName:@"login" bundle:nil] instantiateInitialViewController];
        
        [self presentViewController:loginVC animated:YES completion:nil];
    }
}

@end
