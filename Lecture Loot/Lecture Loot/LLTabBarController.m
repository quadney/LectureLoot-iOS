//
//  LLTabBarController.m
//  Lecture Loot
//
//  Created by Sydney Richardson on 3/11/14.
//  Copyright (c) 2014 CashU. All rights reserved.
//

#import "LLTabBarController.h"
#import "Utilities.h"

@interface LLTabBarController ()

@end

@implementation LLTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (![[Utilities sharedUtilities] currentUser]) {
        
        // TODO
//        UINavigationController *signUpNav = [[UIStoryboard storyboardWithName:@"login" bundle:nil] instantiateInitialViewController];
//        
//        [self presentViewController:signUpNav animated:YES completion:nil];
    }
    else {
        [self setSelectedIndex:1];
    }
}

@end
