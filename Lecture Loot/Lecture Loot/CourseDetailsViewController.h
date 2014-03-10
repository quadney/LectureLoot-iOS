//
//  CourseDetailsViewController.h
//  Lecture Loot
//
//  Created by Austin Bruch on 3/9/14.
//  Copyright (c) 2014 CashU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Course;

@interface CourseDetailsViewController : UIViewController

@property (strong, nonatomic) Course *course;
@property (strong, nonatomic) void (^dismissBlock)(void);

@end
