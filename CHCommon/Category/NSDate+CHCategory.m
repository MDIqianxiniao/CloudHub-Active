//
//  NSDate+CHCategory.m
//  CloudHub
//
//  Created by jiang deng on 2021/2/24.
//  Copyright 2019 The CloudHub project authors. All Rights Reserved.

#import "NSDate+CHCategory.h"

@implementation NSDate (CHCategory)

+ (NSString *)ch_stringFromTs:(NSTimeInterval)timestamp formatter:(NSString *)formatter
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:formatter];
    
    return [dateFormater stringFromDate:date];
}

+ (NSString *)ch_countDownENStringDateFromTs:(NSUInteger)count
{
    if (count <= 0)
    {
        return @"";
    }
    NSUInteger hour = count/3600;
    NSUInteger min = (count%3600)/60;
    NSUInteger second = count%60;
    
    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)hour, (long)min, (long)second];
}


@end
