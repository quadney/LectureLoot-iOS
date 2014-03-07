//
//  WagerViewController.m
//  Lecture Loot
//
//  Created by Sydney Richardson on 3/1/14.
//  Copyright (c) 2014 CashU. All rights reserved.
//

#import "WagerViewController.h"
#import "WagerCell.h"
#import "Wager.h"

@interface WagerViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) NSMutableArray *wagers;

- (IBAction)addWager:(id)sender;
- (IBAction)editWagers:(id)sender;

@end

@implementation WagerViewController

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
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //get a new or recycled table cell
    WagerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"wagerCell"];
    
    //populate with the information in the wager to the cell
    
    //get the wagers mutable array from the user
    //get the wager at indexPath.row
    //set the information
    
    //cell.weekOfLabel.text = @"Week: %i", indexPath.row;
    //cell.wagerAmountLabel.text = @"
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)addWager:(id)sender {
}

- (IBAction)editWagers:(id)sender {
}
@end
