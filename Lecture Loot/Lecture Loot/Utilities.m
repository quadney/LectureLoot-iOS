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
                              authorizationToken:(NSString *)authorizationToken
{
    self.currentUser = [User currentUser];
    [self.currentUser setUserInformationWithFirstName:firstName
                                             lastName:lastName
                                             username:username
                                         emailAddress:email
                                             password:password
                                   authorizationToken:authorizationToken
                                               points:0];
}

@end
