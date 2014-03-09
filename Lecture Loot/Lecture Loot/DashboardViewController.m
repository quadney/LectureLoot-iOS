//
//  DashboardViewController.m
//  Lecture Loot
//
//  Created by Sydney Richardson on 3/1/14.
//  Copyright (c) 2014 CashU. All rights reserved.
//

#import "DashboardViewController.h"
#import "Meeting.h"

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

@property (weak, nonatomic) IBOutlet UIButton *getLocationButton;

- (IBAction)checkIn:(id)sender;
- (IBAction)getLocation:(id)sender;

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
    
    //userCheckInStateView
    self.checkInState = UserNeedsToCheckIn;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;

}

- (IBAction)checkIn:(id)sender {
    
    // get the user's location
    // check with the database if it's right
    // if check in was good, enable user checked in
    // else display a message to the user that something went wrong
    BOOL checkedIn = false;
    if (checkedIn) {
        [self enableUserCheckedInView];
    }
    else
        [self displayCheckInUnsuccessfulAlert:NO];
}

- (IBAction)getLocation:(id)sender {
    self.getLocationButton.titleLabel.text = @"getting location";
    [self.locationManager startUpdatingLocation];
    self.currentLocation = [self.locationManager location];
    [self.getLocationButton setTitle:[NSString stringWithFormat:@"%f , %f",self.currentLocation.coordinate.latitude, self.currentLocation.coordinate.longitude] forState:UIControlStateNormal];
    [self.locationManager stopUpdatingLocation];
}

- (IBAction)toggleCheckInStateForTesting:(id)sender
{
    switch (self.checkInState) {
        case UserNeedsToCheckIn:
            self.checkInState = UserHasUpcomingMeeting;
            break;
        case UserHasUpcomingMeeting:
            self.checkInState = UserIsDoneForDay;
            break;
        case UserIsDoneForDay:
            self.checkInState = UserCheckedIn;
            break;
        case UserCheckedIn:
            self.checkInState = UserNeedsToCheckIn;
            break;
        default:
            break;
    }
    [self updateUI];
}

- (void)updateUI
{
    switch (self.checkInState) {
        case UserNeedsToCheckIn:
            [self enableNeedsToCheckInView];
            break;
        case UserCheckedIn:
            [self enableUserCheckedInView];
            break;
        case UserHasUpcomingMeeting:
            [self enableHasUpcomingMeetingView];
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
    [self.checkInButton setHidden:YES];
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
    [self.checkInButton setHidden:YES];
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

@end
