//
//  Utilities.m
//  Lecture Loot
//
//  Created by Sydney Richardson on 3/7/14.
//  Copyright (c) 2014 CashU. All rights reserved.
//

const NSString *baseURLString = @"http://lectureloot.eu1.frbit.net/api/v1/";
const NSString *userToken;
#import "Utilities.h"
#import "User.h"
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

#pragma mark - API definition goes here

// getting user from the database and setting it as the currentUser
- (void)loginUserWithEmail:(NSString *)email
                              password:(NSString *)password
                            completion:(DismissBlock)completionBlock
{
    //after get all the information from the database
    //create the current user
    BOOL inDevelopment = NO;
    if(inDevelopment) {
        self.currentUser = [User currentUser];
        [self.currentUser setUserInformationWithFirstName:@"First Name"
                                                 lastName:@"Last Name"
                                             emailAddress:email
                                                   points:0
                                                   userId:0];
    }
    else {
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
                                   NSLog(@"JSON Dictionary: %@", jsonDictionary);
                                   // returns message and token ... whatever that means
                                   if ([[jsonDictionary objectForKey:@"message"] isEqualToString:@"Success, valid credentials"]) {
                                       //the user was successfully logged in
                                       // store the token, might delete if we dont need it later
                                       userToken = [jsonDictionary objectForKey:@"token"];
                                       
                                       // then set that information here:
                                       self.currentUser = [User currentUser];
                                       [self.currentUser setUserInformationWithFirstName:@"First Name"
                                                                                lastName:@"Last Name"
                                                                            emailAddress:email
                                                                                  points:0
                                                                                  userId:-1];
//                                   [self.currentUser setUserInformationWithFirstName:firstName
//                                                                            lastName:lastName
//                                                                        emailAddress:email
//                                                                              points:0
//                                                userId:[[jsonDictionary objectForKey:@"user_id"] intValue]];
                                       
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
}

//creating a new user
- (void)createAndSetUserInformationWithFirstName:(NSString *)firstName
                                        lastName:(NSString *)lastName
                                           email:(NSString *)email
                                        password:(NSString *)password
                                      completion:(DismissBlock)completionBlock
{
    NSString *urlString = [NSString stringWithFormat:@"%@users?emailAddress=%@&password=%@&firstName=%@&lastName=%@&pointBalance=%i", baseURLString, email, password, firstName, lastName, 0];
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
                                   //the user was successfully logged in
                                   // store the token, might delete if we dont need it later
                                   userToken = [jsonDictionary objectForKey:@"token"];
                                   
                                   // get all the other information about that user
                                   // such as first name and shit
                                   
                                   
                                   // then set that information here:
                                   self.currentUser = [User currentUser];
                                   [self.currentUser setUserInformationWithFirstName:@"First Name"
                                                                            lastName:@"Last Name"
                                                                        emailAddress:email
                                                                              points:100
                                                                              userId:-1];
//                                   [self.currentUser setUserInformationWithFirstName:firstName
//                                                                            lastName:lastName
//                                                                        emailAddress:email
//                                                                              points:0
//                                                userId:[[jsonDictionary objectForKey:@"user_id"] intValue]];
                                   
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
    
}

// create new wager
- (void)addWagerToUserWithWager:(Wager *)newWager
{
    
}

// remove wager for user
- (void)removeUsersWagerWithWager:(Wager *)wagerToDelete
{
    
}

// add new course to user
- (void)addCourseToUsersSchedule:(Course *)courseToAdd
{
    
}

// drop course for user
- (void)dropCourseFromUsersSchedule:(Course *)courseToDrop
{
    
}

// check in user
- (void)checkUserIntoMeeting:(Meeting *)currentMeeting
        wasCheckInSuccessful:(BOOL)userCheckedIn
{
    
}

@end
