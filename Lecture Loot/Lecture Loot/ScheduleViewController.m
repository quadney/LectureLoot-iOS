//
//  ScheduleViewController.m
//  Lecture Loot
//
//  Created by Sydney Richardson on 3/1/14.
//  Copyright (c) 2014 CashU. All rights reserved.
//

#import "ScheduleViewController.h"
#import "User.h"
#import "Course.h"
#import "Meeting.h"
#import "ScheduleCell.h"
#import "AddCourseViewController.h"
#import "CourseDetailsViewController.h"
#import "Utilities.h"

@interface ScheduleViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *courses;
@property (strong, nonatomic) User *currentUser;

- (IBAction)addCourse:(id)sender;
- (BOOL)loadCourses;

@end

@implementation ScheduleViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.currentUser = [[Utilities sharedUtilities] currentUser];
    NSLog(@"Current user: %@", self.currentUser);
    self.currentUser.userId = 1;//TODO this needs to be set dynamically
    self.currentUser.authorizationToken = @"fRkaPSt5JgwjQP7DggybHxZ0J8OLfKo2eLhhEEF6";
    
    self.currentUser.courses = [[NSMutableArray alloc] init];
    [self loadCourses];
    
    [self.tableView reloadData];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear called");
    
    [self.tableView reloadData];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear called");
    
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableview numberOfRowsInSection:(NSInteger)section
{
    return [_currentUser.courses count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ScheduleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"courseCell" forIndexPath:indexPath];
    
    Course *currentCourse = [_currentUser.courses objectAtIndex:indexPath.row];
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
        ctrl.course = _currentUser.courses[[self.tableView indexPathForSelectedRow].row];
    }
}

- (IBAction)addCourse:(id)sender {
}

- (void)dropCourse:(Course *)courseToBeDropped
{
    [[[User currentUser] courses] removeObjectIdenticalTo:courseToBeDropped];
    [self.tableView reloadData];
}

- (BOOL)loadCourses{
    __block BOOL result= YES;
    if ([self.currentUser.courses count] == 0) {
        NSString *baseURLString = @"http://lectureloot.eu1.frbit.net/api/v1/";
        NSString *getUserCoursesURLString = [NSString stringWithFormat:@"%@users/%d/courses", baseURLString, self.currentUser.userId];
        NSURL *getUserCoursesURL = [NSURL URLWithString:getUserCoursesURLString];
        NSMutableURLRequest *getUserCoursesRequest = [NSMutableURLRequest requestWithURL:getUserCoursesURL
                                                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                                         timeoutInterval:60.0];
        [getUserCoursesRequest setValue:self.currentUser.authorizationToken forHTTPHeaderField:@"Authorization"];
        [getUserCoursesRequest setHTTPMethod:@"GET"];
        
        //        [NSURLConnection sendAsynchronousRequest:getUserCoursesRequest
        //                                           queue:[NSOperationQueue mainQueue]
        //                               completionHandler:^(NSURLResponse *getUserCoursesResponse, NSData *getUserCoursesData, NSError *getUserCoursesConnectionError) {
        //                                   NSMutableArray *coursesJSONArray = [NSJSONSerialization JSONObjectWithData:getUserCoursesData
        //                                                                                                      options:0
        //                                                                                                        error:nil];
        NSURLResponse *coursesResponse;
        NSData *coursesData = [NSURLConnection sendSynchronousRequest:getUserCoursesRequest
                                                    returningResponse:&coursesResponse
                                                                error:nil];
        NSMutableArray *coursesJSONArray = [NSJSONSerialization JSONObjectWithData:coursesData
                                                                           options:0
                                                                             error:nil];
        Course *newCourse;
        //                                   NSLog(coursesJSONArray);
        for (NSDictionary *courseDictionary in coursesJSONArray) {
            newCourse = [[Course alloc] init];
            [newCourse setMeetings:[[NSMutableArray alloc]init]];
            //                                   NSLog([courseDictionary objectForKey:@"deptCode"]);
            [newCourse setCourseCode:[NSString stringWithFormat:@"%@%@",[courseDictionary objectForKey:@"deptCode"],[courseDictionary objectForKey:@"courseNumber"]]];
            [newCourse setCourseId:(int)[[courseDictionary objectForKey:@"id"] integerValue]];
            //                                   NSLog(@"newCourse.courseId: %@",[newCourse courseId]);
            //                                   NSLog(@"courseDictionary objectForKey: %@",[courseDictionary objectForKey:@"id"]);
            [newCourse setCredits:[courseDictionary objectForKey:@"credits"]];
            [newCourse setInstructor:[courseDictionary objectForKey:@"instructor"]];
            [newCourse setCourseTitle:[courseDictionary objectForKey:@"courseTitle"]];
            [newCourse setSectionNumber:[courseDictionary objectForKey:@"sectionNumber"]];
            
            //send request to get meetings for the current course
            NSString *getCourseMeetingsURLString = [NSString stringWithFormat:@"%@courses/%d/meetings",baseURLString,newCourse.courseId];
            NSURL *meetingsURL = [NSURL URLWithString:getCourseMeetingsURLString];
            NSMutableURLRequest *meetingsRequest = [NSMutableURLRequest requestWithURL:meetingsURL
                                                                           cachePolicy:(NSURLRequestUseProtocolCachePolicy)
                                                                       timeoutInterval:60.0];
            [meetingsRequest setValue:self.currentUser.authorizationToken forHTTPHeaderField:@"Authorization"];
            [meetingsRequest setHTTPMethod:@"GET"];
            NSURLResponse *meetingsResponse;
            //                                   NSLog(@"Meeting Synch Request %d",newCourse.courseId);
            NSData *meetingsData = [NSURLConnection sendSynchronousRequest:meetingsRequest returningResponse:&meetingsResponse error:nil];
            //                                   NSLog(@"%@",[[NSString alloc] initWithData:mData encoding:NSUTF8StringEncoding]);
            
            //                                   NSLog(@"Meeting Synch Request Completed %d",newCourse.courseId);
            
            //                                   [NSURLConnection sendAsynchronousRequest:meetingsRequest
            //                                                                      queue:[NSOperationQueue mainQueue]
            //                                                          completionHandler:^(NSURLResponse *meetingsResponse, NSData *meetingsData, NSError *meetingsConnectionError) {
            NSMutableArray *meetingsJSONArray = [NSJSONSerialization JSONObjectWithData:meetingsData//meetingsData
                                                                                options:(0)
                                                                                  error:nil];
            //                                   NSLog(@"%@",meetingsJSONArray);
            //                                                            NSLog(@"test1 %d",newCourse.courseId);
            
            Meeting *newMeeting = [[Meeting alloc] init];
            //                                                                NSLog(@"newMeeting: %@", newMeeting);
            //                                                                NSLog(@"meetingsJSONArray: %@", meetingsJSONArray);
            for (NSDictionary *meetingDictionary in meetingsJSONArray)
            {
                //                                                                  NSLog(@"test2 %d",newCourse.courseId);
                //                                                                  NSLog(@"Meeting Dictionary: %@", meetingDictionary);
                newMeeting = [[Meeting alloc] init];
                [newMeeting setMeetingId:(int)[[meetingDictionary objectForKey:@"id"] integerValue]];
                [newMeeting setBuildingId:(int)[[meetingDictionary objectForKey:@"building_id"] integerValue]];
                [newMeeting setRoomNumber:[meetingDictionary objectForKey:@"roomNumber"]];
                [newMeeting setPeriod:[meetingDictionary objectForKey:@"period"]];
                [newMeeting setMeetingDay:[meetingDictionary objectForKey:@"meetingDay"]];
                [newMeeting setCourseId:(int)[[meetingDictionary objectForKey:@"course_id"] integerValue]];
                
                
                //send request for the building code per meeting
                NSString *getBuildingCodePerMeetingUrlString = [NSString stringWithFormat:@"%@buildings/%d",baseURLString,newMeeting.buildingId];
                NSLog(@"buildings url:%@",getBuildingCodePerMeetingUrlString);
                NSURL *buildingURL = [NSURL URLWithString:getBuildingCodePerMeetingUrlString];
                NSMutableURLRequest *buildingRequest = [NSMutableURLRequest requestWithURL:buildingURL
                                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                                           timeoutInterval:60.0];
                [buildingRequest setValue:self.currentUser.authorizationToken forHTTPHeaderField:@"Authorization"];
                [buildingRequest setHTTPMethod:@"GET"];
                NSURLResponse *buildingResponse;
                NSData *buildingData = [NSURLConnection sendSynchronousRequest:buildingRequest
                                                             returningResponse:&buildingResponse
                                                                         error:nil];
//                NSDictionary *buildingDictionary = [NSJSONSerialization JSONObjectWithData:buildingData
//                                                                                   options:0
//                                                                                     error:nil];
//                NSLog(@"Building Dictionary:%@",buildingDictionary);
//                NSLog(@"newMeeting:%@",newMeeting);
//                NSLog(@"buildingDictionary:%@",buildingDictionary);
//                [newMeeting setBuildingCode:[buildingDictionary objectForKey:@"buildingCode"]];
//                NSLog(@"%@",newMeeting.buildingCode);
//                NSLog(@"%@",[buildingDictionary objectForKey:@"buildingCode"]);
//                [newMeeting setGPSLongitude:[[buildingDictionary objectForKey:@"gpsLongitude"]floatValue]];
//                [newMeeting setGPSLatitude: [[buildingDictionary objectForKey:@"gpsLatitude"] floatValue]];
                
                
                NSMutableArray *buildingArray = [NSJSONSerialization JSONObjectWithData:buildingData
                                                                                options:0
                                                                                  error:nil];
                
                NSLog(@"Building Dictionary:%@",buildingArray);
                NSLog(@"newMeeting:%@",newMeeting);
                NSLog(@"buildingDictionary:%@",buildingArray);
                [newMeeting setBuildingCode:[[buildingArray objectAtIndex:0] objectForKey:@"buildingCode"]];
                NSLog(@"%@",newMeeting.buildingCode);
//                NSLog(@"%@",[buildi objectForKey:@"buildingCode"]);
                [newMeeting setGPSLongitude:[[[buildingArray objectAtIndex:0] objectForKey:@"gpsLongitude"]floatValue]];
                [newMeeting setGPSLatitude: [[[buildingArray objectAtIndex:0] objectForKey:@"gpsLatitude"] floatValue]];


                
                [newCourse.meetings addObject:newMeeting];
            }
            
            
            [self.currentUser.courses addObject:newCourse];
        }
        //                               }];
    }
    return result;
}

@end
