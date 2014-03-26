//
//  User.h
//  Lecture Loot
//
//  Created by Sydney Richardson on 3/11/14.
//  Copyright (c) 2014 CashU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Meeting.h"

@class Wager;
@class Course;

@interface User : NSObject

@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *emailAddress;
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
                           emailAddress:(NSString *)email
                     authorizationToken:(NSString *)authorizationToken
                                 points:(int)points
                                 userId:(int)idNum;

- (void)addWager:(Wager *)newWager;
- (void)removeWager:(Wager *)wagerToRemove;
- (NSArray *)allWagers;
- (Wager *)createWagerWithAmount:(int)wagerAmount startingDate:(NSDate *)startingDate;

- (NSArray *)getAllMeetings;
- (Meeting *)getUpcomingMeeting;

- (Course *)createCourse;
- (NSArray *)allCourses;
- (void)removeCourse:(Course *)courseToRemove;


@end
