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

- (void)setDefaultUser;

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
                                      completion:(DismissBlock)completionBlock;

// fetch all of user's wagers, courses and meetings
- (void)fetchUserData;

- (void)fetchAllUserWagers;

// create new wager
- (void)addWagerToUserWithWager:(Wager *)newWager completion:(DismissBlock)completionBlock;

// remove wager for user
- (void)removeUsersWagerWithWager:(Wager *)wagerToDelete completion:(DismissBlock)completionBlock;

// edit wager
- (void)editWagerWithWager:(Wager *)wagerToEdit completion:(DismissBlock)completionBlock;

// add new course to user
- (void)addCourseToUsersSchedule:(Course *)courseToAdd completion:(DismissBlock)completionBlock;

// drop course for user
- (void)dropCourseFromUsersSchedule:(Course *)courseToDrop completion:(DismissBlock)completionBlock;

// check in user
- (void)checkUserIntoMeeting:(Meeting *)currentMeeting
        wasCheckInSuccessful:(BOOL)userCheckedIn
                  completion:(DismissBlock)completionBlock;



@end
