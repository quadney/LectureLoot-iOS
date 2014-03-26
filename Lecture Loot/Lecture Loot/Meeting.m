//
//  Meeting.m
//  Lecture Loot
//
//  Created by Sydney Richardson on 3/1/14.
//  Copyright (c) 2014 CashU. All rights reserved.
//

#import "Meeting.h"

@interface Meeting()

@property (nonatomic) NSDateComponents *meetingDateComponent;

@end

@implementation Meeting

- (NSDateComponents *)getDateComponents
{
    if(!self.meetingDateComponent){
        self.meetingDateComponent = [[NSDateComponents alloc] init];
        
        [self setPeriodToDateComponent];
        [self setDayToDateComponent];
    }
    return self.meetingDateComponent;
}

- (void)setPeriodToDateComponent
{
    int hour;
    int mins;
    int period = 0;
    
    if ([self.period isEqualToString:@"E1"]) {
        //the time is already set, just need to catch it
        period = 12;
    }
    else if ([self.period isEqualToString:@"E2"]) {
        period = 13;
    }
    else if ([self.period isEqualToString:@"E3"]) {
        period = 14;
    }
    else{
        period = [self.period intValue];
    }
    
    if (period < 8){
        hour = period + 6;
    }
    else {
        hour = period + 7;
    }
    mins = (((period - 1)*5)+25) % 60;
    
    [self.meetingDateComponent setHour:hour];
    [self.meetingDateComponent setMinute:mins];
}

- (void)setDayToDateComponent
{
    int day = 0;
    if ([self.meetingDay isEqualToString:@"M"]) {
        day = 2;
    }
    else if ([self.meetingDay isEqualToString:@"T"]) {
         day = 3;
    }
    else if ([self.meetingDay isEqualToString:@"W"]) {
         day = 4;
    }
    else if ([self.meetingDay isEqualToString:@"R"]) {
         day = 5;
    }
    else if ([self.meetingDay isEqualToString:@"F"]) {
         day = 6;
    }
    [self.meetingDateComponent setWeekday:day];
}



@end
