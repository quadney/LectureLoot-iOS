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
@property (strong, nonatomic) NSString *buildingCode;
@property (strong, nonatomic) NSString *roomNumber;
@property (strong, nonatomic) NSString *meetingDay;
@property (strong, nonatomic) NSString *period;
@property long time;


@end
