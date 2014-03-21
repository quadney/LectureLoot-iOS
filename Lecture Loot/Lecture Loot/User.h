//
//  User.h
//  Lecture Loot
//
//  Created by Sydney Richardson on 3/11/14.
//  Copyright (c) 2014 CashU. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Wager;
@class Course;

@interface User : NSObject

@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *emailAddress;
@property (nonatomic, copy) NSString *password; //is it safe to have this like this?
@property (nonatomic, copy) NSString *authorizationToken;
@property (nonatomic, strong) NSURL *profileImageUrl;
@property (nonatomic, strong) UIImage *profileImage;
@property (nonatomic) int points;
@property (nonatomic) int userId;
@property (nonatomic) NSMutableArray *courses;
@property (nonatomic) NSMutableArray *wagers;

+ (instancetype)currentUser;

- (void)setUserInformationWithFirstName:(NSString *)firstName
                               lastName:(NSString *)lastName
                               username:(NSString *)username
                           emailAddress:(NSString *)email
                               password:(NSString *)password
                     authorizationToken:(NSString *)authorizationToken
                                 points:(int) points;

- (Wager *)createWager;
- (void)removeWager:(Wager *)wagerToRemove;
- (NSArray *)allWagers;
- (Wager *)createWagerWithAmount:(int)wagerAmount startingDate:(NSDate *)startingDate;

- (Course *)createCourse;
- (NSArray *)allCourses;
- (void)removeCourse:(Course *)courseToRemove;


@end
