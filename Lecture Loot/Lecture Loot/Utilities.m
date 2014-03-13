//
//  Utilities.m
//  Lecture Loot
//
//  Created by Sydney Richardson on 3/7/14.
//  Copyright (c) 2014 CashU. All rights reserved.
//

#import "Utilities.h"
#import "User.h"
//this is where we would import the Google+ and facebook stuff

@implementation Utilities

+ (void)initializeLectureLootApp
{
    
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

// getting user from the database and setting it as the currentUser
- (void)setUserInformationWithUsername:(NSString *)username
                              password:(NSString *)password
{
    //after get all the information from the datbase
    //create the current user
    
    //[[User currentUser] init];
}

//creating a new user
- (void)createAndSetUserInformationWithFirstName:(NSString *)firstName
                                        lastName:(NSString *)lastName
                                        username:(NSString *)username
                                           email:(NSString *)email
                                        password:(NSString *)password
{
    self.currentUser = [User currentUser];
    [self.currentUser setUserInformationWithFirstName:firstName
                                             lastName:lastName
                                             username:username
                                         emailAddress:email
                                             password:password
                                               points:0];
}

@end
