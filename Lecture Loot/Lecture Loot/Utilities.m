//
//  Utilities.m
//  Lecture Loot
//
//  Created by Sydney Richardson on 3/7/14.
//  Copyright (c) 2014 CashU. All rights reserved.
//

#import "Utilities.h"
//this is where we would import the Google+ and facebook stuff

@implementation Utilities

+ (void)initializeLectureLootApp
{
    
}

+ (id<User>)currentUser
{
    //get the current user from somewhere. Need to do more research
    
    return nil;
}

#pragma mark - Singleton

+ (instancetype)sharedUtilities
{
    static Utilities *sharedUtilities;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedUtilities = [[Utilities alloc] init];
    });
    
    return sharedUtilities;
}

#pragma mark - API definition goes here

@end
