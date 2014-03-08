//
//  Course.h
//  Lecture Loot
//
//  Created by Sydney Richardson on 3/1/14.
//  Copyright (c) 2014 CashU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Course : NSObject

@property int courseId;
@property (strong, nonatomic) NSString *courseCode;
@property (strong, nonatomic) NSString *courseTitle;
@property (strong, nonatomic) NSString *sectionNumber;
@property (strong, nonatomic) NSString *credits;
@property (strong, nonatomic) NSString *instructor;
@property (strong, nonatomic) NSMutableArray *meetings;
@end
