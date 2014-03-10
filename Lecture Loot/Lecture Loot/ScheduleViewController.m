//
//  ScheduleViewController.m
//  Lecture Loot
//
//  Created by Sydney Richardson on 3/1/14.
//  Copyright (c) 2014 CashU. All rights reserved.
//

#import "ScheduleViewController.h"
#import "Course.h"
#import "Meeting.h"
#import "ScheduleCell.h"
#import "AddCourseViewController.h"
#import "CourseDetailsViewController.h"

@interface ScheduleViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *courses;

- (IBAction)addCourse:(id)sender;

@end

@implementation ScheduleViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.courses = [[NSMutableArray alloc] init];
    
    
        Course *newCourse1 = [[Course alloc] init];
        [newCourse1 setCourseCode:@"CEN3031"];
        [newCourse1 setCourseId:0];
        [newCourse1 setCredits:@"3"];
        [newCourse1 setInstructor:@"Bermudez, Manuel E."];
        [newCourse1 setCourseTitle:@"Intro Software Engineering"];
        [newCourse1 setSectionNumber:@"5842"];
        
        newCourse1.meetings = [[NSMutableArray alloc] init];
        
        Meeting *newMeeting1 = [[Meeting alloc] init];
        [newMeeting1 setMeetingId:0];
        [newMeeting1 setBuildingCode:@"LIT"];
        [newMeeting1 setRoomNumber:@"109"];
        [newMeeting1 setMeetingDay:@"M"];
        [newMeeting1 setPeriod:@"6"];
        
        [newCourse1.meetings addObject:newMeeting1];
        
        Meeting *newMeeting2 = [[Meeting alloc] init];
        [newMeeting2 setMeetingId:1];
        [newMeeting2 setBuildingCode:@"LIT"];
        [newMeeting2 setRoomNumber:@"109"];
        [newMeeting2 setMeetingDay:@"W"];
        [newMeeting2 setPeriod:@"6"];
        
        [newCourse1.meetings addObject:newMeeting2];
        
        Meeting *newMeeting3 = [[Meeting alloc] init];
        [newMeeting3 setMeetingId:2];
        [newMeeting3 setBuildingCode:@"LIT"];
        [newMeeting3 setRoomNumber:@"109"];
        [newMeeting3 setMeetingDay:@"F"];
        [newMeeting3 setPeriod:@"6"];
        
        [newCourse1.meetings addObject:newMeeting3];
        
        Meeting *newMeeting4 = [[Meeting alloc] init];
        [newMeeting4 setMeetingId:3];
        [newMeeting4 setBuildingCode:@"CSE"];
        [newMeeting4 setRoomNumber:@"E115"];
        [newMeeting4 setMeetingDay:@"W"];
        [newMeeting4 setPeriod:@"7"];
        
        [newCourse1.meetings addObject:newMeeting4];
        
        
        [self.courses addObject:newCourse1];
    
    
    
    Course *newCourse2 = [[Course alloc] init];
    [newCourse2 setCourseCode:@"MAS4203"];
    [newCourse2 setCourseId:1];
    [newCourse2 setCredits:@"3"];
    [newCourse2 setInstructor:@"Shen, Li"];
    [newCourse2 setCourseTitle:@"Intro Number Theory"];
    [newCourse2 setSectionNumber:@"8430"];
    
    newCourse2.meetings = [[NSMutableArray alloc] init];
    
    Meeting *numTheoryMeeting1 = [[Meeting alloc] init];
    [numTheoryMeeting1 setMeetingId:0];
    [numTheoryMeeting1 setBuildingCode:@"LIT"];
    [numTheoryMeeting1 setRoomNumber:@"219"];
    [numTheoryMeeting1 setMeetingDay:@"M"];
    [numTheoryMeeting1 setPeriod:@"4"];
    
    [newCourse2.meetings addObject:numTheoryMeeting1];
    
    Meeting *numTheoryMeeting2 = [[Meeting alloc] init];
    [numTheoryMeeting2 setMeetingId:1];
    [numTheoryMeeting2 setBuildingCode:@"LIT"];
    [numTheoryMeeting2 setRoomNumber:@"219"];
    [numTheoryMeeting2 setMeetingDay:@"W"];
    [numTheoryMeeting2 setPeriod:@"4"];
    
    [newCourse2.meetings addObject:numTheoryMeeting2];
    
    Meeting *numTheoryMeeting3 = [[Meeting alloc] init];
    [numTheoryMeeting3 setMeetingId:2];
    [numTheoryMeeting3 setBuildingCode:@"LIT"];
    [numTheoryMeeting3 setRoomNumber:@"219"];
    [numTheoryMeeting3 setMeetingDay:@"F"];
    [numTheoryMeeting3 setPeriod:@"4"];
    
    [newCourse2.meetings addObject:numTheoryMeeting3];
    
    [self.courses addObject:newCourse2];

    [self.tableView reloadData];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableview numberOfRowsInSection:(NSInteger)section
{
    return [self.courses count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ScheduleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"courseCell" forIndexPath:indexPath];
    
    Course *currentCourse = [self.courses objectAtIndex:indexPath.row];
    cell.CourseCodeLabel.text = [NSString stringWithFormat:@"%@ (Section %@)",currentCourse.courseCode,currentCourse.sectionNumber];
//    cell.SectionNumberLabel.text = [NSString stringWithFormat:@"Section: %@",currentCourse.sectionNumber];
    cell.CreditsLabel.text = [NSString stringWithFormat:@"Credits: %@",currentCourse.credits];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    CourseDetailsViewController *newCourseVC = [[CourseDetailsViewController alloc] initWithNibName:nil bundle:nil];
    //    Course *selectedCourse = self.courses[indexPath.row];
    //    [[newCourseVC setCourse:selectedCourse];
    //    [self.navigationController pushViewController:newCourseVC animated:YES];
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"courseDetailsSegue"]) {
        //        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        //        CourseDetailsViewController *newCourseDetailsViewController = (CourseDetailsViewController *)navController.topViewController;
        //        NSIndexPath *index = [self.tableView indexPathForSelectedRow];
        //        newCourseDetailsViewController.course = self.courses[index.row];
        
        CourseDetailsViewController *ctrl = (CourseDetailsViewController *)segue.destinationViewController;
        ctrl.course = self.courses[[self.tableView indexPathForSelectedRow].row];
    }
}

- (IBAction)addCourse:(id)sender {
}
@end
