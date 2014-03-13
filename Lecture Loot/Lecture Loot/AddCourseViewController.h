//
//  AddCourseViewController.h
//  Lecture Loot
//
//  Created by Sydney Richardson on 3/3/14.
//  Copyright (c) 2014 CashU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Course;

@interface AddCourseViewController : UIViewController

@property (strong, nonatomic) Course *course;
@property (strong, nonatomic) void (^dismissBlock)(void);

//- (instancetype)initForNewItem:(BOOL)isNew;

@end
