//
//  AddWagerViewController.m
//  Lecture Loot
//
//  Created by Sydney Richardson on 3/3/14.
//  Copyright (c) 2014 CashU. All rights reserved.
//

#import "AddWagerViewController.h"
#import "Wager.h"
#import "User.h"
#import "Utilities.h"

@interface AddWagerViewController () <UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *wagerAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *weekOfLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *sessionPicker;
@property (weak, nonatomic) IBOutlet UIStepper *stepper;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountWageringLabel;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
- (IBAction)wagerValueChanged:(id)sender;

@property (strong, nonatomic) NSArray *sessionCodes;
@property (nonatomic) UIActivityIndicatorView *loadingSpinner;

@end

@implementation AddWagerViewController

- (instancetype)initForNewItem:(BOOL)isNew
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        if (isNew) {
            UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save:)];
            self.navigationItem.rightBarButtonItem = doneItem;
            
            UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
            
            self.navigationItem.leftBarButtonItem = cancelItem;
        }
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    @throw [NSException exceptionWithName:@"Wrong initializer" reason:@"Use initForNewItem" userInfo:nil];
    return nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self initSessionDictionary];
    
    self.stepper.value = self.wager.wagerAmountPerMeeting;
//    self.wager.weekOfDate = self.datePicker.date;
    
    [self updateUI];
}

- (void)initSessionDictionary
{
    if (![[Utilities sharedUtilities] sessions]) {
        
        self.loadingSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.view addSubview:self.loadingSpinner];
        [self.loadingSpinner setCenter:[self.view center]];

        [self.loadingSpinner startAnimating];
        self.loadingSpinner.hidesWhenStopped = YES;

        self.sessionCodes = [[Utilities sharedUtilities] getSessionsWithCompletionBlock:^{
            [self.loadingSpinner stopAnimating];
            NSLog(@"reloading all components in picker");
            [self.sessionPicker reloadAllComponents];
        }];
    }
    else{
        self.sessionCodes = [[Utilities sharedUtilities] sessions];
    }
    
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.sessionCodes count]-1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //NSLog(@"Month: %@", [self.sessionCodes[row] date]);
    return [self.dateFormatter stringFromDate:self.sessionCodes[row+1]];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.weekOfLabel.text = [self.dateFormatter stringFromDate:self.sessionCodes[row+1]];
    self.wager.sessionId = row+1;
    self.wager.weekOfDate = self.sessionCodes[row+1];
}

- (IBAction)wagerValueChanged:(id)sender {
    //increment or decrement the wager amount label
    // and change the amount of the total amount wagering
    [self.wager setWagerAmountPerMeeting:(int)self.stepper.value];
    
    [self updateUI];
}


- (void)updateUI
{
    if (!self.dateFormatter) {
        self.dateFormatter = [[NSDateFormatter alloc] init];
        self.dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        self.dateFormatter.timeStyle = NSDateFormatterNoStyle;
    }
//    self.weekOfLabel.text = [self.dateFormatter stringFromDate:];
//    if([self.wager sessionId] != 0)
//        [self.sessionPicker selectRow:[self.wager sessionId] inComponent:1 animated:YES];

    self.wagerAmountLabel.text = [NSString stringWithFormat:@"$%i per class", self.wager.wagerAmountPerMeeting];
    self.totalAmountWageringLabel.text = [NSString stringWithFormat:@"$%i total", self.wager.calculateTotalWagerAmount];
}

- (void)save:(id)sender
{
//    [[Utilities sharedUtilities] addWagerToUserWithWager:self.wager completion:^{
//        // let the user know somehow that the wager was accepted?
//        // or only let them know if there was a problem...
//    }];
    
    [[[Utilities sharedUtilities] currentUser] addWager:self.wager];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissCompletionBlock];
}

- (void)cancel:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissCompletionBlock];
}


@end
