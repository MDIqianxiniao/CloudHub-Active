//
//  NSObject+CHCategory.m
//  CloudHub
//
//  Created by jiang deng on 2021/2/24.
//  Copyright 2019 The CloudHub project authors. All Rights Reserved.

#import "NSObject+CHCategory.h"

@implementation NSObject (CHCategory)

- (BOOL)ch_isValided
{
    return !(self == nil || [self isKindOfClass:[NSNull class]]);
}

- (BOOL)ch_isNotNSNull
{
    return ![self isKindOfClass:[NSNull class]];
}

- (BOOL)ch_isNotEmpty
{
    return !(self == nil
             || [self isKindOfClass:[NSNull class]]
             || ([self respondsToSelector:@selector(length)]
                 && [(NSData *)self length] == 0)
             || ([self respondsToSelector:@selector(count)]
                 && [(NSArray *)self count] == 0));
}

- (BOOL)ch_isNotEmptyExceptNSNull
{
    return !(self == nil
             || ([self respondsToSelector:@selector(length)]
                 && [(NSData *)self length] == 0)
             || ([self respondsToSelector:@selector(count)]
                 && [(NSArray *)self count] == 0));
}

- (BOOL)ch_isNotEmptyDictionary
{
    if ([self ch_isNotEmpty])
    {
        if ([self isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dict = (NSDictionary *)self;
            return (dict.allKeys.count > 0);
        }
    }
    
    return NO;
}

@end
