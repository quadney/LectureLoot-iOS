//
//  CourseDetailsViewController.m
//  Lecture Loot
//
//  Created by Austin Bruch on 3/9/14.
//  Copyright (c) 2014 CashU. All rights reserved.
//

#import "CourseDetailsViewController.h"
#import "ScheduleViewController.h"
#import "Course.h"
#import "Meeting.h"
#import "User.h"
#import "Utilities.h"

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
@property (strong, nonatomic) NSString *scheduleMapURL;
@property (strong, nonatomic) User *currentUser;
- (IBAction)mapButton:(UIButton *)sender;
- (IBAction)dropCourseButton:(id)sender;
- (BOOL)dropCourse:(Course *)courseToBeDropped;


@end

@implementation CourseDetailsViewController
Course *selectedCourse;

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

- (void)mapButton:(UIButton *)sender
{
    
    NSURL *myURL = [NSURL URLWithString:self.scheduleMapURL];
    [[UIApplication sharedApplication] openURL:myURL];
}

- (IBAction)dropCourseButton:(id)sender {
    
    
    UIAlertView *confirmDropourseAlertView = [[UIAlertView alloc] init];
    [confirmDropourseAlertView setTitle:@"Confirm"];
    [confirmDropourseAlertView setMessage:[NSString stringWithFormat:@"Are you sure you want to drop %@ from your schedule?",self.course.courseCode]];
    [confirmDropourseAlertView setDelegate:self];
    [confirmDropourseAlertView addButtonWithTitle:@"Yes"];
    [confirmDropourseAlertView addButtonWithTitle:@"No"];
    [confirmDropourseAlertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[alertView title] isEqualToString:@"Confirm"]) {
        if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Yes"])
        {
            // Yes Selected
            //drop the selected course from the user's schedule
            BOOL result = [self dropCourse:self.course];
            if (result == YES) {
                [self.currentUser.courses removeObjectIdenticalTo:self.course];
                [self.navigationController popToRootViewControllerAnimated:YES];
            } else {
                UIAlertView *rejectedCourseDrop = [[UIAlertView alloc] init];
                [rejectedCourseDrop setTitle:@"Error"];
                [rejectedCourseDrop setMessage:[NSString stringWithFormat:@"%@ could not be dropped due to an internal server error",self.course.courseCode]];
                [rejectedCourseDrop setDelegate:self];
                [rejectedCourseDrop addButtonWithTitle:@"OK"];
                [rejectedCourseDrop show];
            }
            
        }
        else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"No"])
        {
            // No Selected
            //Do Nothing Here
        }
    }
}

- (void)viewDidLoad
{
    NSLog(@"CourseDetailsViewController viewDidLoad enter");
    [super viewDidLoad];
    self.currentUser = [[Utilities sharedUtilities] currentUser];
    self.currentUser.userId = 1;//TODO this needs to be set dynamically
    self.currentUser.authorizationToken = @"fRkaPSt5JgwjQP7DggybHxZ0J8OLfKo2eLhhEEF6";
    NSLog(@"Current user: %@", self.currentUser);
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
        self.courseCodeLabel.text = self.course.courseCode;
        
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
        
        NSMutableArray *meetings = [[NSMutableArray alloc] init];
        meetings = self.course.meetings;
        meetings = [self groupMeetingsDays:meetings];
        //        NSLog([NSString stringWithFormat:@"meetings count = %lu",(unsigned long)[meetings count]]);
        NSLog(@"%@",meetings);
        Meeting *meeting1 = ([meetings count] > 0) ? [meetings objectAtIndex:0] : nil;
        Meeting *meeting2 = ([meetings count] > 1)? [meetings objectAtIndex:1] : nil;
        Meeting *meeting3 = [meetings count] > 2 ? [meetings objectAtIndex:2] : nil;
        
        NSString *meeting1String =  [[NSString alloc] init];
        if(meeting1) {
            meeting1String =  meeting1.meetingDay;
            meeting1String = [meeting1String stringByAppendingString:@" "];
            meeting1String = [meeting1String stringByAppendingString:meeting1.period];
        } else {
            meeting1String = nil;
        }
        
        NSString *meeting2String = [[NSString alloc] init];
        if (meeting2) {
            meeting2String =  meeting2.meetingDay;
            meeting2String = [meeting2String stringByAppendingString:@" "];
            meeting2String = [meeting2String stringByAppendingString:meeting2.period];
        } else {
            meeting2String = nil;
        }
        
        
        NSString *meeting3String = [[NSString alloc] init];
        if(meeting3) {
            meeting3String =  meeting3.meetingDay;
            meeting3String = [meeting3String stringByAppendingString:@" "];
            meeting3String = [meeting3String stringByAppendingString:meeting3.period];
        } else {
            meeting3String = nil;
        }
        
        
        [self.meeting1Label setText:meeting1String];
        [self.meeting2Label setText:meeting2String];
        [self.meeting3Label setText:meeting3String];
        
        NSString *room1String = [[NSString alloc] init];
        if (meeting1) {
            room1String = meeting1.buildingCode;
            room1String = [room1String stringByAppendingString:@" "];
            room1String = [room1String stringByAppendingString:meeting1.roomNumber];
        } else {
            room1String = nil;
        }
        
        
        NSString *room2String = [[NSString alloc] init];
        if (meeting2) {
            room2String = meeting2.buildingCode;
            room2String = [room2String stringByAppendingString:@" "];
            room2String = [room2String stringByAppendingString:meeting2.roomNumber];
        } else {
            room2String = nil;
        }
        
        
        NSString *room3String = [[NSString alloc] init];
        if (meeting3) {
            room3String = meeting3.buildingCode;
            room3String = [room3String stringByAppendingString:@" "];
            room3String = [room3String stringByAppendingString:meeting3.roomNumber];
        } else {
            room3String = nil;
        }
        
        
        [self.room1Label setText:room1String];
        [self.room2Label setText:room2String];
        [self.room3Label setText:room3String];
        
        
        self.scheduleMapURL = @"http://campusmap.ufl.edu/?sched=";
        self.scheduleMapURL = [self.scheduleMapURL stringByAppendingString:[self.course.courseCode stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        
        BOOL meet1 = (meeting1String != nil) ? YES : NO;
        self.scheduleMapURL = [self.scheduleMapURL stringByAppendingString: (meet1) ? [NSString stringWithFormat:@"%@,",[meeting1.meetingDay stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]] : @""];
        self.scheduleMapURL = [self.scheduleMapURL stringByAppendingString: (meet1) ? [NSString stringWithFormat:@"%@,",[meeting1.period stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]] : @""];
        self.scheduleMapURL = [self.scheduleMapURL stringByAppendingString: (meet1) ? [NSString stringWithFormat:@"%@,",[meeting1.buildingCode stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]] : @""];
        self.scheduleMapURL = [self.scheduleMapURL stringByAppendingString: (meet1) ? [NSString stringWithFormat:@"%@,",[meeting1.roomNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]] : @""];
        
        
        BOOL meet2 = (meeting2String != nil) ? YES : NO;
        self.scheduleMapURL = [self.scheduleMapURL stringByAppendingString: (meet2) ? [NSString stringWithFormat:@"%@,",[meeting2.meetingDay stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]] : @""];
        self.scheduleMapURL = [self.scheduleMapURL stringByAppendingString: (meet2) ? [NSString stringWithFormat:@"%@,",[meeting2.period stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]] : @""];
        self.scheduleMapURL = [self.scheduleMapURL stringByAppendingString: (meet2) ? [NSString stringWithFormat:@"%@,",[meeting2.buildingCode stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]] : @""];
        self.scheduleMapURL = [self.scheduleMapURL stringByAppendingString: (meet2) ? [NSString stringWithFormat:@"%@,",[meeting2.roomNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]] : @""];
        
        BOOL meet3 = (meeting3String != nil) ? YES : NO;
        self.scheduleMapURL = [self.scheduleMapURL stringByAppendingString: (meet3) ? [NSString stringWithFormat:@"%@,",[meeting3.meetingDay stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]] : @""];
        self.scheduleMapURL = [self.scheduleMapURL stringByAppendingString: (meet3) ? [NSString stringWithFormat:@"%@,",[meeting3.period stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]] : @""];
        self.scheduleMapURL = [self.scheduleMapURL stringByAppendingString: (meet3) ? [NSString stringWithFormat:@"%@,",[meeting3.buildingCode stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]] : @""];
        self.scheduleMapURL = [self.scheduleMapURL stringByAppendingString: (meet3) ? [NSString stringWithFormat:@"%@,",[meeting3.roomNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]] : @""];
        
        self.scheduleMapURL = [self.scheduleMapURL substringToIndex:[self.scheduleMapURL length]];
        self.scheduleMapURL = [self.scheduleMapURL stringByAppendingString:@";"];
        
    }
    
    NSLog(@"CourseDetailsViewController updateUI exit");
    
    
    
}

- (NSMutableArray *)groupMeetingsDays:(NSMutableArray *)meetings
{
    NSLog(@"groupMeetingsDays enter");
    NSMutableArray *groupedMeetingsDays = [[NSMutableArray alloc] init];
    
    Meeting *comparedAgainstMeeting = [[Meeting alloc] init];
    Meeting *testMeeting = [[Meeting alloc] init];
    Meeting *compareTestMeeting = [[Meeting alloc] init];
    
    for (int i = 0; i < [meetings count]; i++) {
        comparedAgainstMeeting = [meetings objectAtIndex:i];
        compareTestMeeting = [meetings objectAtIndex:i];
        BOOL flag = NO;
        for (int j = i+1; j < [meetings count]; j++) {
            testMeeting = [meetings objectAtIndex:j];
            if ([comparedAgainstMeeting.period isEqualToString:testMeeting.period]
                && [comparedAgainstMeeting.buildingCode isEqualToString:testMeeting.buildingCode]
                && [comparedAgainstMeeting.roomNumber isEqualToString:testMeeting.roomNumber]){
                BOOL contains = NO;
                comparedAgainstMeeting.meetingDay = [NSString stringWithFormat:@"%@%@",comparedAgainstMeeting.meetingDay, testMeeting.meetingDay];
                for(Meeting *groupedMeeting in groupedMeetingsDays) {
                    if([groupedMeeting.meetingDay rangeOfString:comparedAgainstMeeting.meetingDay].location != NSNotFound ){
                        contains = YES;
                    }
                }
                if (contains == NO) {
                    [groupedMeetingsDays addObject:comparedAgainstMeeting];
                }
                
            }
        }
        if ([comparedAgainstMeeting.meetingDay length] == 1) {
            for(Meeting *grouped in groupedMeetingsDays) {
                if ([comparedAgainstMeeting.period isEqualToString:grouped.period]
                    && [comparedAgainstMeeting.buildingCode isEqualToString:grouped.buildingCode]
                    && [comparedAgainstMeeting.roomNumber isEqualToString:grouped.roomNumber]){
                    flag = YES;
                }
            }
            if (flag == NO) {
                [groupedMeetingsDays addObject:comparedAgainstMeeting];
            }
        }
    }
    if ([groupedMeetingsDays count] == 0) {
        [groupedMeetingsDays addObjectsFromArray:meetings];
    }
    
    for (int i = 0; i < [groupedMeetingsDays count]; i++) {
        Meeting *groupedMeeting = [[Meeting alloc] init];
        groupedMeeting = [groupedMeetingsDays objectAtIndex:i];
        NSString *meet = [groupedMeeting.meetingDay uppercaseString];
        NSString *sortedMeet = @" ";
        
        if ([meet rangeOfString:@"M"].location != NSNotFound)
        {
            sortedMeet = [sortedMeet stringByAppendingString:@"M"];
        }
        if ([meet rangeOfString:@"T"].location != NSNotFound)
        {
            sortedMeet = [sortedMeet stringByAppendingString:@"T"];
        }
        if ([meet rangeOfString:@"W"].location != NSNotFound)
        {
            sortedMeet = [sortedMeet stringByAppendingString:@"W"];
        }
        if ([meet rangeOfString:@"R"].location != NSNotFound)
        {
            sortedMeet = [sortedMeet stringByAppendingString:@"R"];
        }
        if ([meet rangeOfString:@"F"].location != NSNotFound)
        {
            sortedMeet = [sortedMeet stringByAppendingString:@"F"];
        }
        if ([meet rangeOfString:@"S"].location != NSNotFound)
        {
            sortedMeet = [sortedMeet stringByAppendingString:@"S"];
        }
        
        sortedMeet = [sortedMeet stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        groupedMeeting.meetingDay = sortedMeet;
        [groupedMeetingsDays setObject:groupedMeeting atIndexedSubscript:i];
    }
    
    return groupedMeetingsDays;
}

- (void)setCourse:(Course *)course
{
    _course = course;
}

- (BOOL)dropCourse:(Course *)courseToBeDropped
{
    __block BOOL result;
    NSString *baseURLString = @"http://lectureloot.eu1.frbit.net/api/v1/";
    NSString *dropCourseURLString = [NSString stringWithFormat:@"%@users/%d/courses/%d", baseURLString, self.currentUser.userId,courseToBeDropped.courseId];
    NSURL *dropCourseURL = [NSURL URLWithString:dropCourseURLString];
    NSMutableURLRequest *dropCourseRequest = [NSMutableURLRequest requestWithURL:dropCourseURL
                                                                     cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                                 timeoutInterval:60.0];
    [dropCourseRequest setValue:self.currentUser.authorizationToken forHTTPHeaderField:@"Authorization"];
    [dropCourseRequest setHTTPMethod:@"DELETE"];
    NSURLResponse *deleteResponse;
    NSData *deleteData = [NSURLConnection sendSynchronousRequest:dropCourseRequest
                                               returningResponse:&deleteResponse
                                                           error:nil];
    
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:deleteData//dropCourseData
                                                                 options:0
                                                                   error:nil];
    NSLog(@"JSON Dictionary: %@", responseJSON);
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)deleteResponse;//dropCourseResponse;
    if ([httpResponse statusCode] == 200 ) {
        //The course has been dropped in the backend DB
        result = YES;
    } else {
        //The course has not been dropped in the backend DB
        result = NO;
    }
    return result;
}

@end
