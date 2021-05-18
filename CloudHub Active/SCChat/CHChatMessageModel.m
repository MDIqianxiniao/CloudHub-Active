//
//  CHChatMessageModel.m
//  CloudHub
//
//

#import "CHChatMessageModel.h"

@implementation CHChatMessageModel

- (void)setTimeInterval:(NSTimeInterval)timeInterval
{
    _timeInterval = timeInterval;
    self.timeStr = [NSDate ch_stringFromTs:timeInterval formatter:@"HH:mm"];
}

@end
