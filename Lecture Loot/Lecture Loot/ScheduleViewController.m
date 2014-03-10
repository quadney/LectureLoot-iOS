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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.courses = [[NSMutableArray alloc] init];
    for (int i = 0; i < 3; i++) {
        Course *newCourse = [[Course alloc] init];
        [newCourse setCourseCode:@"CEN3031"];
        [newCourse setCourseId:0];
        [newCourse setCredits:@"3"];
        [newCourse setInstructor:@"Bermudez, Manuel E."];
        [newCourse setCourseTitle:@"Intro Software Engineering"];
        [newCourse setSectionNumber:@"5842"];
        
        for (int j = 1; j < 4; j++){
            Meeting *newMeeting = [[Meeting alloc] init];
            [newMeeting setMeetingId:j];
            [newMeeting setBuildingCode:@"LIT"];
            [newMeeting setRoomNumber:@"109"];
            [newMeeting setMeetingDay:@"M"];
            
            [newCourse.meetings addObject:newMeeting];
        }
        
        [self.courses addObject:newCourse];
    }
    
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
    cell.CourseCodeLabel.text = [currentCourse courseCode];
    cell.SectionNumberLabel.text = [currentCourse sectionNumber];
    cell.CreditsLabel.text = [currentCourse credits];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CourseDetailsViewController *newCourseVC = [[CourseDetailsViewController alloc] init];
    Course *selectedCourse = self.courses[indexPath.row];
    [newCourseVC setCourse:selectedCourse];
    
    [self.navigationController pushViewController:newCourseVC animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addCourse:(id)sender {
}
@end
