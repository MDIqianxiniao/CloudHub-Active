//
//  NSAttributedString+CHCategory.m
//  CloudHub
//
//  Created by jiang deng on 2021/2/24.
//  Copyright 2019 The CloudHub project authors. All Rights Reserved.

#import "NSAttributedString+CHCategory.h"

@implementation NSAttributedString (CHCategory)

- (CGSize)ch_sizeToFitWidth:(CGFloat)width
{
    CGSize maxSize = CGSizeMake(width, CGFLOAT_MAX);
    
    return [self ch_sizeToFit:maxSize lineBreakMode:NSLineBreakByCharWrapping];
}

- (CGSize)ch_sizeToFitHeight:(CGFloat)height
{
    CGSize maxSize = CGSizeMake(CGFLOAT_MAX, height);
    
    return [self ch_sizeToFit:maxSize lineBreakMode:NSLineBreakByCharWrapping];
}

- (CGSize)ch_sizeToFit:(CGSize)maxSize lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    if (lineBreakMode ==  NSLineBreakByTruncatingHead ||
        lineBreakMode ==  NSLineBreakByTruncatingTail ||
        lineBreakMode ==  NSLineBreakByTruncatingMiddle )
    {
        options |= NSStringDrawingTruncatesLastVisibleLine;
    }

    CGRect textRect = [self boundingRectWithSize:maxSize options:options context:nil];
    
    return textRect.size;
}

@end
