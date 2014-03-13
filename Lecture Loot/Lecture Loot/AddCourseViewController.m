//
//  AddCourseViewController.m
//  Lecture Loot
//
//  Created by Sydney Richardson on 3/3/14.
//  Copyright (c) 2014 CashU. All rights reserved.
//

#import "AddCourseViewController.h"
#import "Course.h"

@interface AddCourseViewController () <UINavigationControllerDelegate>

@end

@implementation AddCourseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem: UIBarButtonSystemItemDone
                                                                                 target:self action:@selector(save:)];
        self.navigationItem.rightBarButtonItem = doneItem;
        
        UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                    target:self action:@selector(cancel:)];
        self.navigationItem.leftBarButtonItem = cancelItem;
        
//        [self.coursePicker.num  ;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateUI];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    // return the number of components required
    return 3;
}

- (void)updateUI
{
    
}

- (void)save:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}

- (void)cancel:(id)sender
{
    // If the user cancelled, then remove the course from the store
    //[[BNRItemStore sharedStore] removeItem:self.item];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}



@end
