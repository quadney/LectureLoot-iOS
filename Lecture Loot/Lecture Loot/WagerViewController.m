//
//  WagerViewController.m
//  Lecture Loot
//
//  Created by Sydney Richardson on 3/1/14.
//  Copyright (c) 2014 CashU. All rights reserved.
//

#import "WagerViewController.h"
#import "AddWagerViewController.h"
#import "WagerCell.h"
#import "Wager.h"
#import "User.h"
#import "Utilities.h"

@interface WagerViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) User *currentUser;

@end

@implementation WagerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    // THIS IS SUPER IMPORTANT. Because this is a UIViewController, and not a UITableViewController
    // need to remember to tell this class that it is the delegate of its tableView.
    // this cause me a lot of confusion. -s
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    self.currentUser = [[Utilities sharedUtilities] currentUser];
    NSLog(@"Current user: %@", self.currentUser);
    
    if (!self.dateFormatter) {
        self.dateFormatter = [[NSDateFormatter alloc] init];
        self.dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        self.dateFormatter.timeStyle = NSDateFormatterNoStyle;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.currentUser allWagers] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //get a new or recycled table cell
    WagerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WagerTableViewCell" forIndexPath:indexPath];
    NSArray *wagers = [self.currentUser allWagers];
    Wager *currentWager = wagers[indexPath.row];
    
    //populate with the information in the wager to the cell
    
    //get the wagers mutable array from the user
    //get the wager at indexPath.row
    //set the information
    
    cell.weekOfLabel.text = [self.dateFormatter stringFromDate:[currentWager weekOfDate]];
    cell.wagerAmountLabel.text = [NSString stringWithFormat:@"%i pts", [currentWager wagerAmountPerMeeting]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddWagerViewController *newWagerVC = [[AddWagerViewController alloc] initForNewItem:NO];
    
    NSArray *wagers = [self.currentUser allWagers];
    Wager *selectedWager = wagers[indexPath.row];

    [newWagerVC setWager:selectedWager];
    
    [self.navigationController pushViewController:newWagerVC animated:YES];
}

- (IBAction)addWager:(id)sender {
    
    // create a new wager, this also adds the new wager to the wager list
    Wager *newWager = [self.currentUser createWager];
    newWager.wagerAmountPerMeeting = 5;
    
    AddWagerViewController *newWagerVC = [[AddWagerViewController alloc] initForNewItem:YES];
    newWagerVC.wager = newWager;
    newWagerVC.dismissBlock = ^{
        [self.tableView reloadData];
    };
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:newWagerVC];
    
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:navController animated:YES completion:nil];

}
@end
