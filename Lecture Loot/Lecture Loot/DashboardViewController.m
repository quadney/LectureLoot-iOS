//
//  DashboardViewController.m
//  Lecture Loot
//
//  Created by Sydney Richardson on 3/1/14.
//  Copyright (c) 2014 CashU. All rights reserved.
//

#import "DashboardViewController.h"
#import "Meeting.h"
#import "Utilities.h"

@interface DashboardViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *userPointsLabel;
@property (weak, nonatomic) IBOutlet UIView *day1View;
@property (weak, nonatomic) IBOutlet UIView *day2View;
@property (weak, nonatomic) IBOutlet UIView *day3View;
@property (weak, nonatomic) IBOutlet UIView *day4View;
@property (weak, nonatomic) IBOutlet UIView *day5View;

@property (weak, nonatomic) IBOutlet UIView *checkInStateContainer;
@property (weak, nonatomic) IBOutlet UIButton *checkInButton;
@property (weak, nonatomic) IBOutlet UILabel *countdownLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@property (strong, nonatomic) Meeting *upcomingMeeting;
@property (weak, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) NSTimer *timer;
- (IBAction)checkIn:(id)sender;

@property (strong, nonatomic) NSDate *nextMeeting;

typedef enum  {
    UserNeedsToCheckIn = 0,
    UserHasUpcomingMeeting = 1,
    UserIsDoneForDay = 2,
    UserCheckedIn = 3
} UserCheckInState;
@property (nonatomic) UserCheckInState checkInState;

@end

@implementation DashboardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSLog(@"Hello, init");
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //calculate upcoming meeting
    Meeting *upcomingMeeting = [[[Utilities sharedUtilities] currentUser] getUpcomingMeeting];
    
    if(!upcomingMeeting){
        self.checkInState = UserIsDoneForDay;
    }
    else{
        //convert the meeting to time?
        self.nextMeeting = [upcomingMeeting upcomingDate];
        NSLog(@"Next Meeting Course id %i", [upcomingMeeting courseId]);
        NSLog(@"Next Meeting RoomNumber %@", [upcomingMeeting roomNumber]);
        
        [self figureOutCheckInState];
        [self updateTimerLabel:nil];
    }
    
    [self updateUI];
}

- (IBAction)checkIn:(id)sender {
    
    // get the user's location
    // check with the database if it's right
    // if check in was good, enable user checked in
    // else display a message to the user that something went wrong
    BOOL checkedIn = true;
    if (checkedIn) {
        [self enableUserCheckedInView];
        [self getLocation];
        //stop the timer
        [self killTimer];
    }
    else {
        [self displayCheckInUnsuccessfulAlert:NO];
    }
}

- (void)getLocation
{
    [self.locationManager startUpdatingLocation];
    self.currentLocation = [self.locationManager location];
    [self.locationManager stopUpdatingLocation];
}

- (void)updateUI
{
    switch (self.checkInState) {
        case UserNeedsToCheckIn:
            [self enableNeedsToCheckInView];
            //initialize timer for the time left
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                          target:self
                                                        selector:@selector(updateTimerLabel:)
                                                        userInfo:nil
                                                         repeats:YES];
            break;
        case UserCheckedIn:
            [self enableUserCheckedInView];
            //make sure timer has stopped
            break;
        case UserHasUpcomingMeeting:
            [self enableHasUpcomingMeetingView];
            //start the timer for the next meeting
            self.timer = [NSTimer scheduledTimerWithTimeInterval:60.0
                                                          target:self
                                                        selector:@selector(updateTimerLabel:)
                                                        userInfo:nil
                                                         repeats:YES];
            break;
        case UserIsDoneForDay:
            [self enableUserIsDoneForDayView];
            break;
        default:
            break;
    }
}

- (void)enableNeedsToCheckInView
{
    //background red and the countdown label is red bold
    self.checkInStateContainer.backgroundColor = [[UIColor alloc] initWithRed:1.0
                                                                        green:0.86
                                                                         blue:0.9137
                                                                        alpha:1.0];
    [self.checkInButton setHidden:NO];
    [self.countdownLabel setHidden:NO];
    [self.countdownLabel setTextColor:[UIColor redColor]];
    [self.countdownLabel setFont:[UIFont boldSystemFontOfSize:44]];
    
    [self.courseLabel setHidden:NO];
    [self.locationLabel setHidden:NO];
}

- (void)enableHasUpcomingMeetingView
{
    self.checkInStateContainer.backgroundColor = [UIColor clearColor];
    [self.checkInButton setHidden:YES];
    [self.countdownLabel setHidden:NO];
    [self.countdownLabel setTextColor:[UIColor blackColor]];
    [self.countdownLabel setFont:[UIFont systemFontOfSize:44]];
    
    [self.courseLabel setHidden:NO];
    [self.locationLabel setHidden:NO];
}

- (void)enableUserIsDoneForDayView
{
    self.checkInStateContainer.backgroundColor = [UIColor clearColor];
    [self.checkInButton setEnabled:NO];
    [self.checkInButton setBackgroundColor:[[UIColor alloc] initWithRed:0.01 green:0.54 blue:0.25 alpha:1.0]];
    [self.checkInButton setTitle:@"Done for the day!" forState:UIControlStateDisabled];

    [self.countdownLabel setHidden:YES];
    [self.courseLabel setHidden:YES];
    [self.locationLabel setHidden:YES];
}

- (void)enableUserCheckedInView
{
    self.checkInStateContainer.backgroundColor = [[UIColor alloc] initWithRed:0.5294
                                                                        green:0.894
                                                                         blue:0.5843
                                                                        alpha:1.0];
    [self.checkInButton setHidden:NO];
    [self.checkInButton setEnabled:NO];
    [self.checkInButton setBackgroundColor:[[UIColor alloc] initWithRed:0.01 green:0.54 blue:0.25 alpha:1.0]];
    [self.checkInButton setTitle:@"Checked In!" forState:UIControlStateDisabled];
    [self.countdownLabel setHidden:YES];
    [self.courseLabel setHidden:YES];
    [self.locationLabel setHidden:YES];
}

- (void)displayCheckInUnsuccessfulAlert:(BOOL)successful
{
    if (!successful) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Check In Unsuccessful"
                                                        message:@"Something went wrong"
                                                       delegate:nil
                                              cancelButtonTitle:@"Oh No :("
                                              otherButtonTitles:nil, nil];
        [alert show];
        
    } else {
        NSLog(@"Failure :( ");
    }
}

- (void)figureOutCheckInState
{
    NSTimeInterval secondsLeft = [self.nextMeeting timeIntervalSinceNow];
    NSTimeInterval minutesLeft = (int)secondsLeft / 60;
    secondsLeft = (int)secondsLeft % 60;
    NSLog(@"Seconds Left: %f", secondsLeft);
    NSLog(@"Minutes Left: %f", minutesLeft);
    
    if (minutesLeft <= 15) {
        //user needs to check in
        self.checkInState = UserNeedsToCheckIn;
    }
    else {
        self.checkInState = UserHasUpcomingMeeting;
    }

    NSLog(@"Check in state: %u", self.checkInState);
}

- (NSTimeInterval)calculateRemainingTime:(NSDate *)futureTime
{
    NSTimeInterval seconds = [futureTime timeIntervalSinceNow];
    NSLog(@"Time Interval: %f", seconds);
    return seconds;
}

- (void)updateTimerLabel:(id)sender
{
    NSTimeInterval secondsLeft = [self.nextMeeting timeIntervalSinceNow];
    NSTimeInterval minutesLeft = (int)secondsLeft / 60;
    secondsLeft = (int)secondsLeft % 60;
    
    if(minutesLeft <= 15) {
        //red background, need to update every second
        //NSLog(@"Updating Timer %@", self.timeUntilNextMeeting.description);
        self.countdownLabel.text = [NSString stringWithFormat:@"%i:%i", (int)minutesLeft, (int)secondsLeft];
    }
    else {
        //not as important, update every minute
        self.countdownLabel.text = [NSString stringWithFormat:@"%i mins", (int)minutesLeft];
    }
}

- (void)killTimer{
	if(self.timer){
		[self.timer invalidate];
		self.timer = nil;
	}
}

@end
