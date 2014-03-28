//
//  Wager.h
//  Lecture Loot
//
//  Created by Sydney Richardson on 3/1/14.
//  Copyright (c) 2014 CashU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Wager : NSObject

@property int wagerId;
@property int sessionId;
@property int wagerAmountPerMeeting;
@property int totalWagerAmount;
@property int pointsLost;
@property (nonatomic, strong) NSDate *weekOfDate;

- (int)calculateTotalWagerAmount;

@end
