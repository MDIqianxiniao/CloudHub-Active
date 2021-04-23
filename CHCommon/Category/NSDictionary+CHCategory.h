//
//  NSDictionary+CHCategory.h
//  CloudHub
//
//  Created by jiang deng on 2021/2/24.
//  Copyright 2019 The CloudHub project authors. All Rights Reserved.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (CHCategory)

- (long long)ch_longForKey:(nonnull id)key;
- (long long)ch_longForKey:(nonnull id)key withDefault:(long long)theDefault;
- (long long)ch_longForKey:(nonnull id)key formatNumberStyle:(NSNumberFormatterStyle)numberStyle withDefault:(long long)theDefault;
- (NSInteger)ch_intForKey:(nonnull id)key;
- (NSInteger)ch_intForKey:(nonnull id)key withDefault:(NSInteger)theDefault;
- (NSInteger)ch_intForKey:(nonnull id)key formatNumberStyle:(NSNumberFormatterStyle)numberStyle withDefault:(NSInteger)theDefault;
- (NSUInteger)ch_uintForKey:(nonnull id)key;
- (NSUInteger)ch_uintForKey:(nonnull id)key withDefault:(NSUInteger)theDefault;
- (NSUInteger)ch_uintForKey:(nonnull id)key formatNumberStyle:(NSNumberFormatterStyle)numberStyle withDefault:(NSUInteger)theDefault;

- (double)ch_doubleForKey:(nonnull id)key;
- (double)ch_doubleForKey:(nonnull id)key withDefault:(double)theDefault;

- (BOOL)ch_boolForKey:(nonnull id)key;
- (BOOL)ch_boolForKey:(nonnull id)key withDefault:(BOOL)theDefault;


- (nullable NSString *)ch_stringForKey:(nonnull id)key;
- (nullable NSString *)ch_stringForKey:(nonnull id)key withDefault:(nullable NSString *)theDefault;

- (nullable NSDictionary *)ch_dictionaryForKey:(nonnull id)key;
- (nullable NSMutableDictionary *)ch_mutableDictionaryForKey:(nonnull id)key;

- (BOOL)ch_containsObjectForKey:(nonnull id)key;

- (nullable NSString *)ch_toJSON;
- (nullable NSString *)ch_toJSONWithOptions:(NSJSONWritingOptions)options;
+ (nullable NSDictionary *)ch_dictionaryWithJsonString:(nullable NSString *)jsonString;

@end

@interface NSMutableDictionary (CHSetCategory)

- (void)ch_setInteger:(NSInteger)value forKey:(nonnull id)key;
- (void)ch_setUInteger:(NSUInteger)value forKey:(nonnull id)key;
- (void)ch_setBool:(BOOL)value forKey:(nonnull id)key;
- (void)ch_setString:(nullable NSString *)value forKey:(nonnull id)key;

@end

NS_ASSUME_NONNULL_END
