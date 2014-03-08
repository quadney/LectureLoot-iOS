//
//  ScheduleCell.h
//  Lecture Loot
//
//  Created by Sydney Richardson on 3/7/14.
//  Copyright (c) 2014 CashU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScheduleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *CourseCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *SectionNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *CreditsLabel;

@end
