//
//  User.m
//  Lecture Loot
//
//  Created by Sydney Richardson on 3/11/14.
//  Copyright (c) 2014 CashU. All rights reserved.
//

#import "User.h"
#import "Wager.h"
#import "Course.h"
#import "Meeting.h"

@interface User()

@property (nonatomic) NSMutableArray *meetings;

@end

@implementation User

+ (instancetype)currentUser
{
    static User *currentUser = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        currentUser = [[self alloc] initPrivate];
    });
    
    return currentUser;
}

// If a programmer calls [[BNRItemStore alloc] init], let him
// know the error of his ways
- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[User initUserSingletonWithFirstName] with all the user information"
                                 userInfo:nil];
    return nil;
}
                       
- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        _courses = [[NSMutableArray alloc] init];
        _wagers = [[NSMutableArray alloc] init];
    }
    return self;
}

//this is a private method because we only want the program to call it, to ensure single-tonian
- (void)setUserInformationWithFirstName:(NSString *)firstName
                               lastName:(NSString *)lastName
                           emailAddress:(NSString *)email
                     authorizationToken:(NSString *)authorizationToken
                                 points:(int)points
                                 userId:(int)idNum
{
    self.firstName = firstName;
    self.lastName = lastName;
    self.emailAddress = email;
    self.authorizationToken = authorizationToken;
    self.points = points;
    self.userId = idNum;
}


#pragma Wager add remove get update

- (void)removeWager:(Wager *)wagerToRemove
{
    [self.wagers removeObjectIdenticalTo:wagerToRemove];
}

- (Wager *)createWagerWithAmount:(int)wagerAmount startingDate:(NSDate *)startingDate
{
    Wager *newWager = [[Wager alloc] init];
    newWager.wagerAmountPerMeeting = wagerAmount;
    newWager.weekOfDate = startingDate;
    
    [self.wagers addObject:newWager];
    
    return newWager;
}

- (void)addWager:(Wager *)newWager
{
    [self.wagers addObject:newWager];
}

- (NSArray *)allWagers
{
    return [self.wagers copy];
}

#pragma Meetings

- (NSArray *)getAllMeetings
{
    self.meetings = [[NSMutableArray alloc] init];
    for (Course *course in self.courses){
        for (Meeting *meeting in [course meetings]) {
            [self.meetings addObject:meeting];
        }
    }
    return self.meetings;
}

- (Meeting *)getUpcomingMeeting
{
    [self getAllMeetings];
    Meeting *upcomingMeeting;
    //get the time
    NSDate *currentTime = [NSDate date];
    
    // setting units we would like to use in future
    unsigned units = NSWeekdayCalendarUnit | NSMinuteCalendarUnit | NSHourCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSDayCalendarUnit;
    // creating NSCalendar object
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // extracting components from date
    //this is what we want to get nearest
    NSDateComponents *currentComp = [calendar components:units fromDate:currentTime];
    //this has the day of week and the time
    
    
    //parse through all the meetings and decide which is the next one
    for(Meeting *meeting in self.meetings){
        //need to make the curre
        NSDateComponents *comparingMeeting = [meeting getDateComponents];
        if ([currentComp weekday] == [comparingMeeting weekday]) {
            //the dates are the same
            
            //now to compare the times
            //get the closest meeting to the current time
            if (([currentComp hour] <= [comparingMeeting hour]) && ([currentComp minute] <= [comparingMeeting minute])) {
                // if the current hour is less than the meeting that compaing to
                //meaning that the meeting has not occured yet
                if (!upcomingMeeting){
                    upcomingMeeting = meeting;
                }
                else if (([comparingMeeting hour] < [[upcomingMeeting getDateComponents] hour])
                         && ([comparingMeeting minute] < [[upcomingMeeting getDateComponents] minute])) {
                    
                    //if the comparing meeting is less than the upcoming meeting, then set it as the upcoming meeting
                    upcomingMeeting = meeting;
                }
                [comparingMeeting setDay:[currentComp day]];
                [comparingMeeting setYear:[currentComp year]];
                [comparingMeeting setMonth:[currentComp month]];
                
                [upcomingMeeting setUpcomingDate:[calendar dateFromComponents:comparingMeeting]];
            }
        }
    }
    
    return upcomingMeeting;
}

#pragma Course add remove get update

- (Course *)createCourse
{
    return nil;
}

- (void)removeCourse:(Course *)courseToRemove
{
    [self.courses removeObjectIdenticalTo:courseToRemove];
}

- (NSArray *)allCourses
{
    return [self.courses copy];
}




@end
