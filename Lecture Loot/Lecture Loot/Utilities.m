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
                                  authorizationToken:@"qqNguwzODzYG3RadBLGTHwZTVddCg6efteMJrpOS"
                                              points:50
                                              userId:1];
}

- (NSArray *)getSessionsWithCompletionBlock:(DismissBlock)completionBlock
{
    if (!self.sessions) {
        [self fetchAllWagerSessionsWithCompletionBlock:^{
            NSLog(@"Completed fetching the sessions");
            if (completionBlock) {
                completionBlock();
            }
        }];
    }
    else
        return self.sessions;
    return nil;
    
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
- (void)fetchUserDataWithCompletion:(DismissBlock)completionBlock
{
    NSString *urlString = [NSString stringWithFormat:@"%@users/%i", baseURLString, [self.currentUser userId]];
    NSLog(@"%@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request setValue:[self.currentUser authorizationToken] forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"GET"];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               //parse JSON data
                               
                               NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                                              options:0
                                                                                                error:nil];
                               
                               NSLog(@"getting the user's points");
                               NSLog(@"Json dictionary: %@", jsonDictionary);
                               NSLog(@"user point balance before pull: %i", [self.currentUser points]);
                               [self.currentUser setPoints:[[jsonDictionary objectForKey:@"pointBalance"] intValue]];
                               
                               NSLog(@"user point balance after pull: %i", [self.currentUser points]);
                               //TODO would also be nice to get the user's courses and wagers in this pull request
                               
                               // call the caller's completion block
                               if(completionBlock)
                                   completionBlock();
                               
                           }
     ];

    //[self fetchAllUserWagers];
    //[self fetchAllUsersCourses];
}

- (void)fetchAllUserWagersWithCompletion:(DismissBlock)completionBlock
{
    NSString *urlString = [NSString stringWithFormat:@"%@users/%i/wagers", baseURLString, [self.currentUser userId]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSLog(@"%@", urlString);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
        
    [request setValue:[self.currentUser authorizationToken] forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"GET"];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               //parse JSON data
                               
                               NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                                              options:0
                                                                                                error:nil];
                               
                               NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                               [formatter setDateFormat:@"YYYY-MM-DD"];
                               
                               for (NSDictionary *wagerDictionary in jsonDictionary) {
                                   Wager *wager = [[Wager alloc] init];
                                   [wager setWagerAmountPerMeeting:[[wagerDictionary objectForKey:@"wagerUnitValue"] intValue]];
                                   [wager setWagerId:[[wagerDictionary objectForKey:@"id"] intValue]];
                                   [wager setSessionId:[[wagerDictionary objectForKey:@"session_id"] intValue]];
                                   [wager setTotalWagerAmount:[[wagerDictionary objectForKey:@"wagerTotalValue"] intValue]];
                                   [wager setPointsLost:[[wagerDictionary objectForKey:@"pointsLost"] intValue]];
                                   [wager setWeekOfDate:[formatter dateFromString:[wagerDictionary objectForKey:@"startDate"]]];
                                   
                                   [self.currentUser addWager:wager];
                               }
                               
                               // call the caller's completion block
                               if(completionBlock)
                                   completionBlock();
                               
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

- (void)fetchAllWagerSessionsWithCompletionBlock:(DismissBlock)completionBlock
{
    NSString *urlString = [NSString stringWithFormat:@"%@sessions", baseURLString];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request setValue:[self.currentUser authorizationToken] forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"GET"];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               //parse JSON data
                               
                               NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                                              options:0
                                                                                                error:nil];
                               NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                               [formatter setDateFormat:@"yyyy-MM-dd"];
                               
                               self.sessions = [[NSMutableArray alloc] init];
                               [self.sessions addObject:@"Do not get the 0th object in this array"];
                               for (NSDictionary *sessionDictionary in jsonDictionary) {
                                   NSLog(@"Start Date: %@", [sessionDictionary objectForKey:@"startDate"]);
                                   NSDate *sessionDate = [formatter dateFromString:[sessionDictionary objectForKey:@"startDate"]];
                                   [self.sessions addObject:sessionDate];
                               }
                               
                               // call the caller's completion block
                               if(completionBlock)
                                   completionBlock();
                               
                           }
     ];

}

// create new wager
- (void)addWagerToUserWithWager:(Wager *)newWager completion:(DismissBlock)completionBlock
{
    NSString *urlString = [NSString stringWithFormat:@"%@users/%i/wagers?user_id=%i&session_id=%i&wagerUnitValue=%i&wagerTotalValue=%i&pointsLost=%i", baseURLString, [self.currentUser userId], [self.currentUser userId], newWager.sessionId, newWager.wagerAmountPerMeeting, [newWager totalWagerAmount], 0];
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
                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Wager not created"
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
