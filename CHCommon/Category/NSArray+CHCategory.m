//
//  NSArray+CHCategory.m
//  CloudHub
//
//  Created by jiang deng on 2021/2/24.
//  Copyright 2019 The CloudHub project authors. All Rights Reserved.

#import "NSArray+CHCategory.h"

@implementation NSArray (CHCategory)

- (id)ch_safeObjectAtIndex:(NSUInteger)index
{
    if (self.count > 0 && self.count > index)
    {
        return [self objectAtIndex:index];
    }
    else
    {
        return nil;
    }
}

- (id)ch_findFirstObjectWithKey:(NSString *)key value:(id)value
{
    __block id findObj = nil;
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([[obj valueForKey:key] isEqual:value])
        {
            findObj = obj;
            *stop = YES;
        }
    }];

    return findObj;
}


@end
