//
//  LLParentViewController.m
//  Lecture Loot
//
//  Created by Sydney Richardson on 3/11/14.
//  Copyright (c) 2014 CashU. All rights reserved.
//

#import "LLParentViewController.h"

@interface LLParentViewController ()

@end

@implementation LLParentViewController

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
    [self enableBackgroundTapToDismissKeyboard];
    [self registerForKeyboardNotifications];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)enableBackgroundTapToDismissKeyboard
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(backgroundWasTapped:)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)backgroundWasTapped:(UITapGestureRecognizer *)tapGesture
{
    [self.view endEditing:YES];
}

- (void)registerForKeyboardNotifications
{
//    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification
//                                                      object:nil
//                                                       queue:[NSOperationQueue mainQueue]
//                                                  usingBlock:^(NSNotification *note) {
//                                                      
//                                                      id keyboardData = [[note userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey];
//                                                      CGSize keyboardSize = [keyboardData CGRectValue].size;
//                                                      
//                                                      [UIView animateWithDuration:0.5
//                                                                            delay:0.0
//                                                                          options:UIViewAnimationOptionCurveEaseInOut
//                                                                       animations:^{
//                                                                           CGRect newFrame = self.view.frame;
//                                                                           newFrame.origin.y -= keyboardSize.height;
//                                                                           self.view.frame = newFrame;
//                                                                       } completion:nil];
//                                                  }];
//    
//    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification
//                                                      object:nil
//                                                       queue:[NSOperationQueue mainQueue]
//                                                  usingBlock:^(NSNotification *note) {
//                                                      
//                                                      id keyboardData = [[note userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey];
//                                                      CGSize keyboardSize = [keyboardData CGRectValue].size;
//                                                      
//                                                      [UIView animateWithDuration:0.1
//                                                                            delay:0.0
//                                                                          options:UIViewAnimationOptionCurveEaseInOut
//                                                                       animations:^{
//                                                                           CGRect newFrame = self.view.frame;
//                                                                           newFrame.origin.y += keyboardSize.height;
//                                                                           self.view.frame = newFrame;
//                                                                       } completion:nil];
//                                                  }];
}

@end
