//
//  Utilities.h
//  Lecture Loot
//
//  Created by Sydney Richardson on 3/7/14.
//  Copyright (c) 2014 CashU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "Meeting.h"

typedef void (^DismissBlock)(void);

@interface Utilities : NSObject

@property (nonatomic, strong) User *currentUser;


// this is the initialization of the app.
// Background services such as api calls are outlined here

+ (void)initializeLectureLootApp;

#pragma mark - Singleton

+ (instancetype)sharedUtilities;

#pragma mark - API calls

// getting user from the database and setting it as the currentUser
- (void)loginUserWithEmail:(NSString *)email
                  password:(NSString *)password
                completion:(DismissBlock)completionBlock;

//creating a new user
- (void)createAndSetUserInformationWithFirstName:(NSString *)firstName
                                        lastName:(NSString *)lastName
                                           email:(NSString *)email
                                        password:(NSString *)password
                              authorizationToken:(NSString *)authorizationToken;



@end
