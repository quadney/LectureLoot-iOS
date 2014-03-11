//
//  AddWagerViewController.h
//  Lecture Loot
//
//  Created by Sydney Richardson on 3/3/14.
//  Copyright (c) 2014 CashU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLParentViewController.h"

@class Wager;

@interface AddWagerViewController : LLParentViewController

@property (nonatomic, strong) Wager *wager;
@property (nonatomic, copy) void (^dismissBlock)(void);

- (instancetype)initForNewItem:(BOOL)isNew;

@end
