//
//  AddWagerViewController.m
//  Lecture Loot
//
//  Created by Sydney Richardson on 3/3/14.
//  Copyright (c) 2014 CashU. All rights reserved.
//

#import "AddWagerViewController.h"
#import "Wager.h"

@interface AddWagerViewController () <UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *wagerAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *weekOfLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIStepper *stepper;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountWageringLabel;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
- (IBAction)wagerValueChanged:(id)sender;
- (IBAction)dateChanged:(id)sender;

@end

@implementation AddWagerViewController

- (instancetype)initForNewItem:(BOOL)isNew
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        if (isNew) {
            UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                      target:self
                                                                                      action:@selector(save:)];
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
    
    self.stepper.value = self.wager.wagerAmountPerMeeting;
    self.wager.weekOfDate = self.datePicker.date;
    
    [self updateUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:60];

}

- (IBAction)wagerValueChanged:(id)sender {
    //increment or decrement the wager amount label
    // and change the amount of the total amount wagering
    [self.wager setWagerAmountPerMeeting:(int)self.stepper.value];
    
    [self updateUI];
}

- (IBAction)dateChanged:(id)sender {
    //set the date label to the date that is selected and change the wager to reflect that
    self.weekOfLabel.text = [self.dateFormatter stringFromDate:self.datePicker.date];
    self.wager.weekOfDate = self.datePicker.date;
}

- (void)updateUI
{
    if (!self.dateFormatter) {
        self.dateFormatter = [[NSDateFormatter alloc] init];
        self.dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        self.dateFormatter.timeStyle = NSDateFormatterNoStyle;
    }
    self.weekOfLabel.text = [self.dateFormatter stringFromDate:self.datePicker.date];
    self.wagerAmountLabel.text = [NSString stringWithFormat:@"%i pts per class", self.wager.wagerAmountPerMeeting];
    self.totalAmountWageringLabel.text = [NSString stringWithFormat:@"%i points total", self.wager.wagerAmountPerMeeting*15];
}

- (void)save:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}

- (void)cancel:(id)sender
{
    // If the user cancelled, then remove the wager
    // TODO
    //[[BNRItemStore sharedStore] removeItem:self.item];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}


@end
