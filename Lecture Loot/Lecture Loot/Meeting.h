//
//  Meeting.h
//  Lecture Loot
//
//  Created by Sydney Richardson on 3/1/14.
//  Copyright (c) 2014 CashU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Meeting : NSObject

@property int meetingId;
@property int courseId;
@property int buildingId;
@property double GPSLongitude;
@property double GPSLatitude;
@property (strong, nonatomic) NSString *buildingCode;
@property (strong, nonatomic) NSString *roomNumber;
@property (strong, nonatomic) NSString *meetingDay;     //M,T,W,R,F ?
@property (strong, nonatomic) NSString *period;         //1,2,3...,11,E1,E2,E3
@property long time;
@property (strong, nonatomic) NSDate *upcomingDate;

- (NSDateComponents *)getDateComponents;
//- (void)createMeetingDateWithDateComponents;

@end
