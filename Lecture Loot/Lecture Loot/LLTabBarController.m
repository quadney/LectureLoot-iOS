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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super init];
    if (self) {
        NSLog(@"Init with nib tab bar controller");
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        // this is where the stuff would be loaded from the plist

        
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
