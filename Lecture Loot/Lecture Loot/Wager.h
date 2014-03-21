//
//  Wager.h
//  Lecture Loot
//
//  Created by Sydney Richardson on 3/1/14.
//  Copyright (c) 2014 CashU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Wager : NSObject

@property int wagerAmountPerMeeting;
@property int wagerId;
@property int sessionId;
@property (nonatomic, strong) NSDate *weekOfDate;

- (int)totalWagerAmount;

@end
