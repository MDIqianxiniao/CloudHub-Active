//
//  NSDictionary+CHCategory.m
//  CloudHub
//
//  Created by jiang deng on 2021/2/24.
//  Copyright 2019 The CloudHub project authors. All Rights Reserved.

#import "NSDictionary+CHCategory.h"

@implementation NSDictionary (CHCategory)

- (long long)ch_longForKey:(id)key
{
    return [self ch_longForKey:key withDefault:0];
}

- (long long)ch_longForKey:(id)key withDefault:(long long)theDefault
{
    return [self ch_longForKey:key formatNumberStyle:NSNumberFormatterNoStyle withDefault:theDefault];
}

- (long long)ch_longForKey:(id)key formatNumberStyle:(NSNumberFormatterStyle)numberStyle withDefault:(long long)theDefault
{
    long long value = 0;
    
    id object = [self objectForKey:key];
    if ([object ch_isValided] && ([object isKindOfClass:[NSNumber class]] || [object isKindOfClass:[NSString class]]))
    {
        if ([object isKindOfClass:[NSString class]])
        {
            // ((NSString *)object).longLongValue;
            // @"1,000" -> 1
            NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
            nf.numberStyle = numberStyle;
            object = [nf numberFromString:object];
        }
        
        if ([object isKindOfClass:[NSNumber class]])
        {
            value = [object longLongValue];
        }
    }
    
    return value;
}

- (NSInteger)ch_intForKey:(id)key
{
    return [self ch_intForKey:key withDefault:0];
}

- (NSInteger)ch_intForKey:(id)key withDefault:(NSInteger)theDefault
{
    return [self ch_intForKey:key formatNumberStyle:NSNumberFormatterNoStyle withDefault:theDefault];
}

- (NSInteger)ch_intForKey:(id)key formatNumberStyle:(NSNumberFormatterStyle)numberStyle withDefault:(NSInteger)theDefault
{
    NSInteger value = theDefault;
    
    id object = [self objectForKey:key];
    if ([object ch_isValided] && ([object isKindOfClass:[NSNumber class]] || [object isKindOfClass:[NSString class]]))
    {
        if ([object isKindOfClass:[NSString class]])
        {
            NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
            nf.numberStyle = numberStyle;
            object = [nf numberFromString:object];
        }
        
        if ([object isKindOfClass:[NSNumber class]])
        {
            value = [object integerValue];
        }
    }
    
    return value;
}

- (NSUInteger)ch_uintForKey:(id)key
{
    return [self ch_uintForKey:key withDefault:0];
}

- (NSUInteger)ch_uintForKey:(id)key withDefault:(NSUInteger)theDefault
{
    return [self ch_uintForKey:key formatNumberStyle:NSNumberFormatterNoStyle withDefault:theDefault];
}

- (NSUInteger)ch_uintForKey:(id)key formatNumberStyle:(NSNumberFormatterStyle)numberStyle withDefault:(NSUInteger)theDefault
{
    NSUInteger value = theDefault;
    
    id object = [self objectForKey:key];
    if ([object ch_isValided] && ([object isKindOfClass:[NSNumber class]] || [object isKindOfClass:[NSString class]]))
    {
        if ([object isKindOfClass:[NSString class]])
        {
            NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
            nf.numberStyle = numberStyle;
            object = [nf numberFromString:object];
        }
        
        if ([object isKindOfClass:[NSNumber class]])
        {
            return [object unsignedIntegerValue];
        }
    }
    
    return value;
}

- (double)ch_doubleForKey:(id)key
{
    return [self ch_doubleForKey:key withDefault:0.0f];
}

- (double)ch_doubleForKey:(id)key withDefault:(double)theDefault
{
    double value = theDefault;
    
    id object = [self objectForKey:key];
    if ([object ch_isValided] && ([object isKindOfClass:[NSNumber class]] || [object isKindOfClass:[NSString class]]))
    {
        if ([object isKindOfClass:[NSString class]])
        {
            NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
            nf.numberStyle = NSNumberFormatterNoStyle;
            object = [nf numberFromString:object];
        }
        
        if ([object isKindOfClass:[NSNumber class]])
        {
            return [object doubleValue];
        }
    }
    
    return value;
}

- (BOOL)ch_boolForKey:(id)key
{
    return [self ch_boolForKey:key withDefault:NO];
}

- (BOOL)ch_boolForKey:(id)key withDefault:(BOOL)theDefault
{
    BOOL value = theDefault;
    
    id object = [self objectForKey:key];
    if ([object ch_isValided] && ([object isKindOfClass:[NSNumber class]] || [object isKindOfClass:[NSString class]]))
    {
        value = [object boolValue];
    }
    
    return value;
}

- (NSString *)ch_stringForKey:(id)key
{
    return [self ch_stringForKey:key withDefault:nil];
}

- (NSString *)ch_stringForKey:(id)key withDefault:(NSString *)theDefault
{
    NSString *value = theDefault;
    
    id object = [self objectForKey:key];
    if ([object ch_isValided])
    {
        if ([object isKindOfClass:[NSString class]])
        {
            value = (NSString *)object;
        }
        else if ([object isKindOfClass:[NSNumber class]])
        {
            value = ((NSNumber *)object).stringValue;
        }
        else if ([object isKindOfClass:[NSURL class]])
        {
            value = ((NSURL *)object).absoluteString;
        }
    }
    
    return value;
}

- (NSDictionary *)ch_dictionaryForKey:(id)key
{
    NSDictionary *value = nil;
    
    id object = [self objectForKey:key];
    if ([object ch_isValided] && [object isKindOfClass:[NSDictionary class]])
    {
        value = (NSDictionary *)object;
    }
    
    return value;
}

- (NSMutableDictionary *)ch_mutableDictionaryForKey:(id)key
{
    NSMutableDictionary *value = nil;
    
    id object = [self objectForKey:key];
    if ([object ch_isValided] && [object isKindOfClass:[NSMutableDictionary class]])
    {
        value = [NSMutableDictionary dictionaryWithDictionary:object];
    }
    
    if (value == nil)
    {
        value = [NSMutableDictionary dictionary];
    }
    
    return value;
}

- (BOOL)ch_containsObjectForKey:(id)key
{
    return [[self allKeys] containsObject:key];
}

- (NSString *)ch_toJSON
{
    // NSJSONWritingPrettyPrinted
    return [self ch_toJSONWithOptions:0];
}

- (NSString *)ch_toJSONWithOptions:(NSJSONWritingOptions)options
{
    NSString *json = nil;
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:options error:&error];
    
    if (!jsonData)
    {
        return @"{}";
    }
    else if (!error)
    {
        json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return json;
    }
    else
    {
        NSLog(@"%@", error.localizedDescription);
    }
    
    return nil;
}

+ (NSDictionary *)ch_dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if (err) {
        NSLog(@"json serialize fail：%@",err);
        return nil;
    }
    
    return dic;
}

@end

@implementation NSMutableDictionary (CHSetCategory)

- (void)ch_setInteger:(NSInteger)value forKey:(id)key
{
    NSNumber *number = [NSNumber numberWithInteger:value];
    [self setObject:number forKey:key];
}

- (void)ch_setUInteger:(NSUInteger)value forKey:(id)key
{
    NSNumber *number = [NSNumber numberWithUnsignedInteger:value];
    [self setObject:number forKey:key];
}

- (void)ch_setBool:(BOOL)value forKey:(id)key
{
    NSNumber *number = [NSNumber numberWithBool:value];
    [self setObject:number forKey:key];
}

- (void)ch_setString:(NSString *)value forKey:(id)key
{
    if (!value)
    {
       return;
    }
    [self setObject:value forKey:key];
}


@end
