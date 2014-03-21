//
//  Utilities.m
//  Lecture Loot
///Users/ssyyddnneeyy/Documents/SydneysGithub/LectureLoot-iOS/Lecture Loot/Lecture Loot/Utilities.h
//  Created by Sydney Richardson on 3/7/14.
//  Copyright (c) 2014 CashU. All rights reserved.
//

const NSString *baseURLString = @"http://lectureloot.eu1.frbit.net/api/v1/";
#import "Utilities.h"
#import "User.h"
#import "Wager.h"
#import "Course.h"
#import "Meeting.h"
//this is where we would import the Google+ and facebook stuff

@implementation Utilities

+ (void)initializeLectureLootApp
{
    
}

#pragma mark - Singleton

+ (instancetype)sharedUtilities
{
    static Utilities *sharedUtilities;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedUtilities = [[Utilities alloc] init];
    });
    
    return sharedUtilities;
}

- (void)setDefaultUser
{
    _currentUser = [User currentUser];
   [self.currentUser setUserInformationWithFirstName:@"josh"
                                            lastName:@"black"
                                        emailAddress:@"joshuatblack@ufl.edu"
                                  authorizationToken:@"unxWwUVNngaIc114DAW0thZAWJPmrDOHiiISHBwK"
                                              points:100
                                              userId:1];
}

#pragma mark - API definition goes here

// getting user from the database and setting it as the currentUser
- (void)loginUserWithEmail:(NSString *)email
                  password:(NSString *)password
                completion:(DismissBlock)completionBlock
{
    NSString *urlString = [NSString stringWithFormat:@"%@users/login?emailAddress=%@&password=%@", baseURLString, email, password];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               //parse JSON data
                               NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                                              options:0
                                                                                                error:nil];
                               //NSLog(@"JSON Dictionary: %@", jsonDictionary);
                               // returns message and token ... whatever that means
                               if ([[jsonDictionary objectForKey:@"message"] isEqualToString:@"Success, valid credentials"]) {
                                   
                                   // then set that information here:
                                   self.currentUser = [User currentUser];
                                   [self.currentUser setUserInformationWithFirstName:@""
                                                                            lastName:@""
                                                                        emailAddress:email
                                                                  authorizationToken:[jsonDictionary objectForKey:@"token"]
                                                                              points:0
                                                                              userId:[[jsonDictionary objectForKey:@"user_id"] intValue]];
                                   
                                   // call the caller's completion block
                                   if(completionBlock)
                                       completionBlock();
                                   
                               }
                               else {
                                   //there was an error, display an alert view
                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                   message:[jsonDictionary objectForKey:@"message"]
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"Oops"
                                                                         otherButtonTitles:nil];
                                   [alert show];
                                   
                               }
                               //
                           }];
}

//creating a new user and setting the information to the app
- (void)createAndSetUserInformationWithFirstName:(NSString *)firstName
                                        lastName:(NSString *)lastName
                                           email:(NSString *)email
                                        password:(NSString *)password
                                      completion:(DismissBlock)completionBlock
{
    NSString *urlString = [NSString stringWithFormat:@"%@users?emailAddress=%@&password=%@&firstName=%@&lastName=%@&pointBalance=%i", baseURLString, email, password, firstName, lastName, 100];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               //parse JSON data
                               NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                                              options:0
                                                                                                error:nil];
                               
                               // returns message and token ... whatever that means
                               if ([[jsonDictionary objectForKey:@"message"] isEqualToString:@"Success, the user was registered"]) {
                                   
                                   // then set that information here:
                                   self.currentUser = [User currentUser];
                                   [self.currentUser setUserInformationWithFirstName:firstName
                                                                            lastName:lastName
                                                                        emailAddress:email
                                                                  authorizationToken:[jsonDictionary objectForKey:@"token"]
                                                                              points:100
                                                                              userId:[[jsonDictionary objectForKey:@"token"] intValue]];
                                   
                                   // call the caller's completion block
                                   if(completionBlock)
                                       completionBlock();
                               }
                               else {
                                   //there was an error, display an alert view
                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                   message:[jsonDictionary objectForKey:@"message"]
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"Oops"
                                                                         otherButtonTitles:nil];
                                   [alert show];
                                   
                               }
                               //
                           }];
}

// fetch all of user's wagers, courses and meetings
- (void)fetchUserData
{
    [self fetchAllUserWagers];
    //[self fetchAllUsersCourses];
}

- (void)fetchAllUserWagers
{
    NSLog(@"fetching user wagers data");
    //NSString *urlString = [NSString stringWithFormat:@"%@users/%i/wagers", baseURLString, [self.currentUser userId]];

    NSString *urlString = [NSString stringWithFormat:@"%@users/%i", baseURLString, [self.currentUser userId]];
    NSLog(@"%@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    [request setHTTPMethod:@"GET"];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               //parse JSON data
                               NSLog(@"json data: %@", data);
                               NSLog(@"json response: %@", response);
                               NSLog(@"ns error: %@", connectionError);
                               NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                                         options:0
                                                                                           error:nil];
                               NSLog(@"json dictionary: %@", jsonDictionary);
//                               for (int i = 0; i < [jsonDictionary count]; i++) {
//                                   NSLog(@"Number: %i \n %@", i, jsonDictionary[i]);
//                               }
                           }
     ];
    
}

//fetch the users courses/meetings
- (void)fetchAllUserCourses
{
    
}

//fetch all the courses that are on the database
- (void)fetchAllCoursesAtUniversity
{
    
}

// create new wager
- (void)addWagerToUserWithWager:(Wager *)newWager completion:(DismissBlock)completionBlock
{
    NSString *urlString = [NSString stringWithFormat:@"%@users/%i/wagers?user_id=%i&session_id=%i&wagerUnitValue=%i&wagerTotalValue=%i&pointsLost=%i", baseURLString, [self.currentUser userId], [self.currentUser userId], 3, newWager.wagerAmountPerMeeting, [newWager totalWagerAmount], 0];
    // TODO what is session id
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               //parse JSON data
                               NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                                              options:0
                                                                                                error:nil];
                               if ([[jsonDictionary objectForKey:@"message"] isEqualToString:@"Success, wager created and added to the user"]) {
                                   if(completionBlock)
                                       completionBlock();
                               }
                               else {
                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                   message:[jsonDictionary objectForKey:@"message"]
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"Oops"
                                                                         otherButtonTitles:nil];
                                   [alert show];
                               }
                           }
     ];
    
}

// remove wager for user
- (void)removeUsersWagerWithWager:(Wager *)wagerToDelete completion:(DismissBlock)completionBlock
{
    NSString *urlString = [NSString stringWithFormat:@"%@wagers/%i", baseURLString, [wagerToDelete wagerId]];
//    // TODO what is session id
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    [request setHTTPMethod:@"DELETE"];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               //parse JSON data
                               NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                                              options:0
                                                                                                error:nil];
                               
                               NSLog(@"%@", jsonDictionary);
                               
//                               if ([[jsonDictionary objectForKey:@"message"] isEqualToString:@"Success, wager created and added to the user"]) {
//                                   if(completionBlock)
//                                       completionBlock();
//                               }
//                               else {
//                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
//                                                                                   message:[jsonDictionary objectForKey:@"message"]
//                                                                                  delegate:nil
//                                                                         cancelButtonTitle:@"Oops"
//                                                                         otherButtonTitles:nil];
//                                   [alert show];
//                               }
                           }
     ];
}

- (void)editWagerWithWager:(Wager *)wagerToEdit completion:(DismissBlock)completionBlock
{
    
}

// check in user
- (void)checkUserIntoMeeting:(Meeting *)currentMeeting
        wasCheckInSuccessful:(BOOL)userCheckedIn
                  completion:(DismissBlock)completionBlock
{
    
}

// add new course to user
- (void)addCourseToUsersSchedule:(Course *)courseToAdd completion:(DismissBlock)completionBlock
{
    
}

// drop course for user
- (void)dropCourseFromUsersSchedule:(Course *)courseToDrop completion:(DismissBlock)completionBlock
{
    
}

@end
