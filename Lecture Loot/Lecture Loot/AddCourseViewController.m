//
//  AddCourseViewController.m
//  Lecture Loot
//
//  Created by Sydney Richardson on 3/3/14.
//  Copyright (c) 2014 CashU. All rights reserved.
//

#import "AddCourseViewController.h"
#import "Course.h"
#import "ScheduleCell.h"
#import "Meeting.h"
#import "User.h"
#import "Utilities.h"

@interface AddCourseViewController () <UINavigationControllerDelegate, UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) NSMutableArray *courses;
@property (weak, nonatomic) IBOutlet UITableView *coursesTableView;
@property (strong, nonatomic) User *currentUser;
- (BOOL)validateNewCourse:(Course *)courseToBeAdded;
- (BOOL)addCourse:(Course *)courseToBeAdded;
@end

@implementation AddCourseViewController
NSArray *searchResults;
NSIndexPath *iP;
Course *selectedCourse;
//NSTimeInterval start;




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem: UIBarButtonSystemItemDone
        //                                                                                 target:self action:@selector(save:)];
        //        self.navigationItem.rightBarButtonItem = doneItem;
        //
        //        UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
        //                                                                                    target:self action:@selector(cancel:)];
        //        self.navigationItem.leftBarButtonItem = cancelItem;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.coursesTableView.delegate = self;
    self.coursesTableView.dataSource = self;
    self.coursesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.currentUser = [[Utilities sharedUtilities] currentUser];
    self.courses = [[NSMutableArray alloc] init];
    self.currentUser.userId = 1;//TODO this needs to be set dynamically
    //self.currentUser.authorizationToken = @"fRkaPSt5JgwjQP7DggybHxZ0J8OLfKo2eLhhEEF6";
    NSLog(@"Current user: %@", self.currentUser);
    [self updateUI];
    
}

- (void)updateUI
{
    
    NSString *baseURLString = @"http://lectureloot.eu1.frbit.net/api/v1/";
    NSString *getCoursesURLString = [NSString stringWithFormat:@"%@courses", baseURLString];
    NSURL *coursesURL = [NSURL URLWithString:getCoursesURLString];
    NSMutableURLRequest *coursesRequest = [NSMutableURLRequest requestWithURL:coursesURL
                                                                  cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                              timeoutInterval:60.0];
    [coursesRequest setValue:self.currentUser.authorizationToken forHTTPHeaderField:@"Authorization"];
    [coursesRequest setHTTPMethod:@"GET"];
    
    NSMutableURLRequest *courseRequest = [NSMutableURLRequest requestWithURL:coursesURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [courseRequest setValue:self.currentUser.authorizationToken forHTTPHeaderField:@"Authorization"];
    [courseRequest setHTTPMethod:@"GET"];
    NSURLResponse *response;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:courseRequest returningResponse:&response   error:nil];
    //    NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    //    [NSURLConnection sendAsynchronousRequest:coursesRequest
    //                                       queue:[NSOperationQueue mainQueue]
    //                           completionHandler:^(NSURLResponse *coursesResponse, NSData *coursesData, NSError *coursesConnectionError) {
    
    //                               NSLog([NSString stringWithFormat: @"Authorization: %@", [coursesRequest valueForHTTPHeaderField:@"Authorization"]]);
    //                               NSLog(@"%@",[[NSString alloc] initWithData:coursesData encoding:NSUTF8StringEncoding]);
    //                               NSLog(@"%@",[[NSString alloc] initWithString:[coursesResponse description]]);
    //                               NSLog(@"%@",[[NSString alloc] initWithString:[coursesConnectionError description] == nil ? @"" : [coursesConnectionError description]]);
    
    NSMutableArray *coursesJSONArray = [NSJSONSerialization JSONObjectWithData:data//coursesData
                                                                       options:0
                                                                         error:nil];
    //NSLog(@"JSON Dictionary: %@", coursesJSONArray);
    Course *newCourse;
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
        if (NO)
        {
            NSString *getCourseMeetingsURLString = [NSString stringWithFormat:@"%@courses/%d/meetings",baseURLString,newCourse.courseId];
            NSURL *meetingsURL = [NSURL URLWithString:getCourseMeetingsURLString];
            NSMutableURLRequest *meetingsRequest = [NSMutableURLRequest requestWithURL:meetingsURL
                                                                           cachePolicy:(NSURLRequestUseProtocolCachePolicy)
                                                                       timeoutInterval:60.0];
            [meetingsRequest setValue:self.currentUser.authorizationToken forHTTPHeaderField:@"Authorization"];
            [meetingsRequest setHTTPMethod:@"GET"];
            NSURLResponse *resp;
            
            NSData *mData = [NSURLConnection sendSynchronousRequest:meetingsRequest
                                                  returningResponse:&resp
                                                              error:nil];
            NSMutableArray *meetingsJSONArray = [NSJSONSerialization JSONObjectWithData:mData//meetingsData
                                                                                options:(0)
                                                                                  error:nil];
            
            
            Meeting *newMeeting = [[Meeting alloc] init];
            
            for (NSDictionary *meetingDictionary in meetingsJSONArray)
            {
                newMeeting = [[Meeting alloc] init];
                [newMeeting setMeetingId:(int)[meetingDictionary objectForKey:@"id"]];
                [newMeeting setRoomNumber:[meetingDictionary objectForKey:@"roomNumber"]];
                [newMeeting setPeriod:[meetingDictionary objectForKey:@"period"]];
                [newMeeting setMeetingDay:[meetingDictionary objectForKey:@"meetingDay"]];
                [newMeeting setCourseId:(int)[meetingDictionary objectForKey:@"course_id"]];
                [newMeeting setBuildingId:(int)[meetingDictionary objectForKey:@"building_id"]];
                
                
                //send request for the building code per meeting
                NSString *getBuildingCodePerMeetingUrlString = [NSString stringWithFormat:@"%@/buildings/%d",baseURLString,newMeeting.buildingId];
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
                NSMutableArray *buildingArray = [NSJSONSerialization JSONObjectWithData:buildingData
                                                                                options:0
                                                                                  error:nil];
                
                //                                           NSLog(@"Building Dictionary:%@",buildingArray);
                //                                           NSLog(@"newMeeting:%@",newMeeting);
                //                                           NSLog(@"buildingDictionary:%@",buildingArray);
                [newMeeting setBuildingCode:[[buildingArray objectAtIndex:0] objectForKey:@"buildingCode"]];
                NSLog(@"%@",newMeeting.buildingCode);
                //                NSLog(@"%@",[buildi objectForKey:@"buildingCode"]);
                [newMeeting setGPSLongitude:[[[buildingArray objectAtIndex:0] objectForKey:@"gpsLongitude"]floatValue]];
                [newMeeting setGPSLatitude: [[[buildingArray objectAtIndex:0] objectForKey:@"gpsLatitude"] floatValue]];                                       }
        }
        
        [self.courses addObject:newCourse];
        [self.coursesTableView reloadData];
    }
    //                               NSTimeInterval after = [[NSDate date] timeIntervalSince1970];
    //                               double difference = after - start;
    //                               NSLog(@"initial in millis: %f",start);
    //                               NSLog(@"after in millis: %f",after);
    //                               NSLog(@"difference in millis: %f",difference);
    //                           }];
    
    [self.coursesTableView reloadData];
    
    
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"courseCode beginswith[c] %@", searchText];
    searchResults = [self.courses filteredArrayUsingPredicate:resultPredicate];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ScheduleCell *cell = [self.coursesTableView dequeueReusableCellWithIdentifier:@"courseCell" forIndexPath:indexPath];
    
    Course *currentCourse = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        currentCourse = [searchResults objectAtIndex:indexPath.row];
    } else {
        currentCourse = [self.courses objectAtIndex:indexPath.row];
    }
    cell.CourseCodeLabel.text = [NSString stringWithFormat:@"%@ (Section %@)",currentCourse.courseCode,currentCourse.sectionNumber];
    
    
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    iP = indexPath;
    Course *currentCourse = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        currentCourse = [searchResults objectAtIndex:indexPath.row];
        selectedCourse = [searchResults objectAtIndex:indexPath.row];
    } else {
        currentCourse = [self.courses objectAtIndex:indexPath.row];
        selectedCourse = [self.courses objectAtIndex:indexPath.row];
    }
    
    UIAlertView *confirmAddCourseAlertView = [[UIAlertView alloc] init];
    [confirmAddCourseAlertView setTitle:@"Confirm"];
    [confirmAddCourseAlertView setMessage:[NSString stringWithFormat:@"Are you sure you want to add %@ (Section %@) to your schedule?",currentCourse.courseCode, currentCourse.sectionNumber]];
    [confirmAddCourseAlertView setDelegate:self];
    [confirmAddCourseAlertView addButtonWithTitle:@"Yes"];
    [confirmAddCourseAlertView addButtonWithTitle:@"No"];
    [confirmAddCourseAlertView show];
    
    //load the selected courses data in the background while the dialog is displayed
    NSString *baseURLString = @"http://lectureloot.eu1.frbit.net/api/v1/";
    NSString *getCourseMeetingsURLString = [NSString stringWithFormat:@"%@courses/%d/meetings",baseURLString,selectedCourse.courseId];
    NSURL *meetingsURL = [NSURL URLWithString:getCourseMeetingsURLString];
    NSMutableURLRequest *meetingsRequest = [NSMutableURLRequest requestWithURL:meetingsURL
                                                                   cachePolicy:(NSURLRequestUseProtocolCachePolicy)
                                                               timeoutInterval:60.0];
    [meetingsRequest setValue:self.currentUser.authorizationToken forHTTPHeaderField:@"Authorization"];
    [meetingsRequest setHTTPMethod:@"GET"];
    //    NSURLResponse *resp;
    
    //    NSData *mData = [NSURLConnection sendSynchronousRequest:meetingsRequest
    //                                          returningResponse:&resp
    //                                                      error:nil];
    
    [NSURLConnection sendAsynchronousRequest:meetingsRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *meetingsResponse, NSData *meetingsData, NSError *meetingsConnectionError) {
                               NSMutableArray *meetingsJSONArray = [NSJSONSerialization JSONObjectWithData:meetingsData//mData//meetingsData
                                                                                                   options:(0)
                                                                                                     error:nil];
                               
                               
                               Meeting *newMeeting = [[Meeting alloc] init];
                               
                               for (NSDictionary *meetingDictionary in meetingsJSONArray)
                               {
                                   newMeeting = [[Meeting alloc] init];
                                   [newMeeting setMeetingId:(int)[[meetingDictionary objectForKey:@"id"] integerValue]];
                                   [newMeeting setRoomNumber:[meetingDictionary objectForKey:@"roomNumber"]];
                                   [newMeeting setPeriod:[meetingDictionary objectForKey:@"period"]];
                                   [newMeeting setMeetingDay:[meetingDictionary objectForKey:@"meetingDay"]];
                                   [newMeeting setCourseId:(int)[[meetingDictionary objectForKey:@"course_id"] integerValue]];
                                   [newMeeting setBuildingId:(int)[[meetingDictionary objectForKey:@"building_id"]integerValue]];
                                   
                                   
                                   //send request for the building code per meeting
                                   NSString *getBuildingCodePerMeetingUrlString = [NSString stringWithFormat:@"%@buildings/%d",baseURLString,newMeeting.buildingId];
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
                                   
                                   NSMutableArray *buildingArray = [NSJSONSerialization JSONObjectWithData:buildingData
                                                                                                   options:0
                                                                                                     error:nil];
                                   
                                   NSLog(@"Building Dictionary:%@",buildingArray);
                                   NSLog(@"newMeeting:%@",newMeeting);
                                   NSLog(@"buildingDictionary:%@",buildingArray);
                                   [newMeeting setBuildingCode:[[buildingArray objectAtIndex:0] objectForKey:@"buildingCode"]];
                                   NSLog(@"%@",newMeeting.buildingCode);
                                   [newMeeting setGPSLongitude:[[[buildingArray objectAtIndex:0] objectForKey:@"gpsLongitude"]floatValue]];
                                   [newMeeting setGPSLatitude: [[[buildingArray objectAtIndex:0] objectForKey:@"gpsLatitude"] floatValue]];
                                   
                                   [selectedCourse.meetings addObject:newMeeting];
                                   
                               }
                           }];
    NSLog(@"Exit didSelect");
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[alertView title] isEqualToString:@"Confirm"]) {
        if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Yes"])
        {
            // Yes selected
            
            
            
            
            //use iVar selected courses and Add it to the User's courses
            if ([self validateNewCourse:selectedCourse] == YES)
            {
                BOOL result = [self addCourse:selectedCourse];
                if (result == YES) {
                    [[self.currentUser courses] addObject:selectedCourse];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                } else {
                    UIAlertView *rejectedCourseAddition = [[UIAlertView alloc] init];
                    [rejectedCourseAddition setTitle:@"Error"];
                    [rejectedCourseAddition setMessage:[NSString stringWithFormat:@"%@ could not be added due to a conflicting class in your schedule",selectedCourse.courseCode]];
                    [rejectedCourseAddition setDelegate:self];
                    [rejectedCourseAddition addButtonWithTitle:@"OK"];
                    [rejectedCourseAddition show];
                }
            } else {
                UIAlertView *rejectedCourseAddition = [[UIAlertView alloc] init];
                [rejectedCourseAddition setTitle:@"Error"];
                [rejectedCourseAddition setMessage:[NSString stringWithFormat:@"%@ could not be added due to a conflicting class in your schedule",selectedCourse.courseCode]];
                [rejectedCourseAddition setDelegate:self];
                [rejectedCourseAddition addButtonWithTitle:@"OK"];
                [rejectedCourseAddition show];
            }
        }
        else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"No"])
        {
            // No Selected
        }
        [self.coursesTableView deselectRowAtIndexPath:iP animated:YES];
        [self.searchDisplayController.searchResultsTableView deselectRowAtIndexPath:iP
                                                                           animated:YES];
    }
}

- (BOOL)addCourse:(Course *)courseToBeAdded
{
    __block BOOL result= NO;
    NSString *baseURLString = @"http://lectureloot.eu1.frbit.net/api/v1/";
    NSString *addCourseURLString = [NSString stringWithFormat:@"%@users/%d/courses?course_id=%d", baseURLString, self.currentUser.userId,courseToBeAdded.courseId];
    NSURL *addCourseURL = [NSURL URLWithString:addCourseURLString];
    NSMutableURLRequest *addCourseRequest = [NSMutableURLRequest requestWithURL:addCourseURL
                                                                    cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                                timeoutInterval:60.0];
    [addCourseRequest setValue:self.currentUser.authorizationToken forHTTPHeaderField:@"Authorization"];
    [addCourseRequest setHTTPMethod:@"POST"];
    NSURLResponse *response;
    NSData *syncData = [NSURLConnection sendSynchronousRequest:addCourseRequest returningResponse:&response error:nil];
    
    
    
    //    [NSURLConnection sendAsynchronousRequest:addCourseRequest
    //                                       queue:[NSOperationQueue mainQueue]
    //                           completionHandler:^(NSURLResponse *addCourseResponse, NSData *addCourseData, NSError *addCourseConnectionError) {
    
    
    
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:syncData//addCourseData
                                                                 options:0
                                                                   error:nil];
    NSLog(@"JSON Dictionary: %@", responseJSON);
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;//addCourseResponse;
    if ([httpResponse statusCode] == 200 ) {
        //The course has been added in the backend DB
        result = YES;
    } else {
        //The course has not been added in the backend DB
        result = NO;
    }
    //                           }];
    return result;
}

- (BOOL)validateNewCourse:(Course *)courseToBeAdded
{
    BOOL valid = YES;
    for (Course *iterCourse in [self.currentUser courses]) {
        if ([iterCourse.courseCode isEqualToString:courseToBeAdded.courseCode]) {
            valid = NO;
            break;
        }
        for (Meeting *iterMeeting in iterCourse.meetings) {
            for (Meeting *innerMeeting in courseToBeAdded.meetings) {
                if ([iterMeeting.meetingDay isEqualToString:innerMeeting.meetingDay] &&
                    [iterMeeting.period isEqualToString:innerMeeting.period]) {
                    valid = NO;
                    break;
                }
            }
        }
    }
    return valid;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
        
    } else {
        return [self.courses count];
    }
}



@end
