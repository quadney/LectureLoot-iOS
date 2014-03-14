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
@property (nonatomic, copy) NSString *emailAddress;
@property (nonatomic, strong) NSURL *profileImageUrl;
@property (nonatomic, strong) UIImage *profileImage;
@property (nonatomic) int points;
@property (nonatomic) NSMutableArray *courses;
@property (nonatomic) NSMutableArray *wagers;
@property int userId;

+ (instancetype)currentUser;

- (void)setUserInformationWithFirstName:(NSString *)firstName
                               lastName:(NSString *)lastName
                           emailAddress:(NSString *)email
                                 points:(int) points
                                 userId:(int)idNum;

- (Wager *)createWager;
- (void)removeWager:(Wager *)wagerToRemove;
- (NSArray *)allWagers;
- (Wager *)createWagerWithAmount:(int)wagerAmount startingDate:(NSDate *)startingDate;

- (Course *)createCourse;
- (NSArray *)allCourses;
- (void)removeCourse:(Course *)courseToRemove;


@end
