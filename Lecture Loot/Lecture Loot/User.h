//
//  User.h
//  Lecture Loot
//
//  Created by Sydney Richardson on 3/11/14.
//  Copyright (c) 2014 CashU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *emailAddress;
@property (nonatomic, copy) NSString *password; //is it safe to have this like this?
@property (nonatomic, strong) NSURL *profileImageUrl;
@property (nonatomic, strong) UIImage *profileImage;
@property (nonatomic) int points;

+ (instancetype)currentUser;

- (void)setUserInformationWithFirstName:(NSString *)firstName
                               lastName:(NSString *)lastName
                               username:(NSString *)username
                           emailAddress:(NSString *)email
                               password:(NSString *)password
                                 points:(int) points;

@end
