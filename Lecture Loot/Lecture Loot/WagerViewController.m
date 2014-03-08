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

@interface WagerViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSMutableArray *wagers;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;

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
    
    if (!self.dateFormatter) {
        self.dateFormatter = [[NSDateFormatter alloc] init];
        self.dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        self.dateFormatter.timeStyle = NSDateFormatterNoStyle;
    }

    
    self.wagers = [[NSMutableArray alloc] init];
    for (int i = 0; i < 3; i++) {
        Wager *newWager = [[Wager alloc] init];
        [newWager setWagerAmountPerMeeting:((i+1)*10)];
        [newWager setWeekOfDate:[NSDate date]];
        
        [self.wagers addObject:newWager];
    }
    
    //[self.tableView registerClass:[WagerCell class] forCellReuseIdentifier:@"WagerTableViewCell"];
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.wagers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //get a new or recycled table cell
    WagerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WagerTableViewCell" forIndexPath:indexPath];
    Wager *currentWager = [self.wagers objectAtIndex:indexPath.row];
    
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
    
    Wager *selectedWager = self.wagers[indexPath.row];
    [newWagerVC setWager:selectedWager];
    
    [self.navigationController pushViewController:newWagerVC animated:YES];
}

- (IBAction)addWager:(id)sender {
    
    Wager *newWager = [[Wager alloc] init];
    [newWager setWagerAmountPerMeeting:20];
    AddWagerViewController *newWagerVC = [[AddWagerViewController alloc] initForNewItem:YES];
    
    newWagerVC.wager = newWager;
    [self.wagers addObject:newWager];
    newWagerVC.dismissBlock = ^{
        [self.tableView reloadData];
    };
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:newWagerVC];
    
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:navController animated:YES completion:nil];
    
}
@end
