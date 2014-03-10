//
//  CourseDetailsViewController.m
//  Lecture Loot
//
//  Created by Austin Bruch on 3/9/14.
//  Copyright (c) 2014 CashU. All rights reserved.
//

#import "CourseDetailsViewController.h"
#import "Course.h"
#import "Meeting.h"

@interface CourseDetailsViewController () <UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UINavigationItem *navTitle;
@property (weak, nonatomic) IBOutlet UILabel *courseCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sectionLabel;
@property (weak, nonatomic) IBOutlet UILabel *creditsLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *instructorLabel;
@property (weak, nonatomic) IBOutlet UILabel *meeting1Label;
@property (weak, nonatomic) IBOutlet UILabel *meeting2Label;
@property (weak, nonatomic) IBOutlet UILabel *meeting3Label;
@property (weak, nonatomic) IBOutlet UILabel *room1Label;
@property (weak, nonatomic) IBOutlet UILabel *room2Label;
@property (weak, nonatomic) IBOutlet UILabel *room3Label;


@end

@implementation CourseDetailsViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSLog(@"CourseDetailsViewController init enter");

    
//    @throw [NSException exceptionWithName:@"Wrong initializer" reason:@"Use initForNewItem" userInfo:nil];
//    return nil;
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
    }
    NSLog(@"CourseDetailsViewController init exit");
    return self;
}

- (void)viewDidLoad
{
    NSLog(@"CourseDetailsViewController viewDidLoad enter");
    [super viewDidLoad];
    [self updateUI];
    NSLog(@"CourseDetailsViewController viewDidLoad exit");

}

- (void)updateUI
{
    NSLog(@"CourseDetailsViewController updateUI enter");

    if(self){
        [self.navTitle setTitle:self.course.courseCode];
        NSLog(@"navTitle.title = %@", self.navTitle.title);
        NSLog(@"%@", self.course.courseCode);
//        self.courseCodeLabel.text = self.course.courseCode;
        self.courseCodeLabel.text = @"testString";

        NSLog(@"courseCodeLabel.text = %@", self.courseCodeLabel.text);
        
        NSString *sectionString = @"Section: ";
        sectionString = [sectionString stringByAppendingString:[[self course] sectionNumber]];
        [self.sectionLabel setText:sectionString];
        
        NSString *creditsString = @"Credits: ";
        creditsString = [creditsString stringByAppendingString:self.course.credits];
        [self.creditsLabel setText:creditsString];
        
        [self.courseTitleLabel setText:self.course.courseTitle];
        
        NSString *instructorString = @"Instructor: ";
        instructorString = [instructorString stringByAppendingString:self.course.instructor];
        [self.instructorLabel setText:instructorString];
        
        Meeting *meeting1 = [self.course.meetings objectAtIndex:0];
        Meeting *meeting2 = [self.course.meetings objectAtIndex:1];
        Meeting *meeting3 = [self.course.meetings objectAtIndex:2];
        
        [self.meeting1Label setText:meeting1.meetingDay];
        [self.meeting2Label setText:meeting2.meetingDay];
        [self.meeting3Label setText:meeting3.meetingDay];
        
        NSString *room1String = meeting1.buildingCode;
        room1String = [room1String stringByAppendingString:@" "];
        room1String = [room1String stringByAppendingString:meeting1.roomNumber];
        
        NSString *room2String = meeting2.buildingCode;
        room2String = [room2String stringByAppendingString:@" "];
        room2String = [room2String stringByAppendingString:meeting3.roomNumber];
        
        NSString *room3String = meeting3.buildingCode;
        room3String = [room3String stringByAppendingString:@" "];
        room3String = [room3String stringByAppendingString:meeting3.roomNumber];
        
        [self.room1Label setText:room1String];
        [self.room2Label setText:room2String];
        [self.room3Label setText:room3String];
        
    }
    
    NSLog(@"CourseDetailsViewController updateUI exit");

    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setCourse:(Course *)course
{
    _course = course;
}

@end
