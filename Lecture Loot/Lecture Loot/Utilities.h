//
//  Utilities.h
//  Lecture Loot
//
//  Created by Sydney Richardson on 3/7/14.
//  Copyright (c) 2014 CashU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Utilities : NSObject

// this is the initialization of the app.
// Background services such as api calls are outlined here

+ (void)initializeLectureLootApp;
+ (id<User>)currentUser;

#pragma mark - Singleton

+ (instancetype)sharedUtilities;

#pragma mark - API calls

// do this later once we get everything set up in the interface

@end
