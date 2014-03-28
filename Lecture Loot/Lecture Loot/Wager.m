//
//  Wager.m
//  Lecture Loot
//
//  Created by Sydney Richardson on 3/1/14.
//  Copyright (c) 2014 CashU. All rights reserved.
//

#import "Wager.h"
#import "Meeting.h"


@interface Wager()

@property int numMeetings;

@end

@implementation Wager

- (int)calculateTotalWagerAmount
{
    self.numMeetings = 15;
    // TODO - get the number of meetings that the user has to go to, for now let's call it 15;
    return self.wagerAmountPerMeeting * self.numMeetings;
}

@end
