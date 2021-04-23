//
//  NSString+CHCategory.m
//  CloudHub
//
//  Created by jiang deng on 2021/2/24.
//  Copyright 2019 The CloudHub project authors. All Rights Reserved.

#import "NSString+CHCategory.h"

@implementation NSString (CHCategory)

- (CGSize)ch_sizeToFitWidth:(CGFloat)width withFont:(UIFont *)font
{
    CGSize maxSize = CGSizeMake(width, CGFLOAT_MAX);
    
    return [self ch_sizeToFit:maxSize withFont:font lineBreakMode:NSLineBreakByCharWrapping];
}

- (CGFloat)ch_widthToFitHeight:(CGFloat)height withFont:(UIFont *)font
{
    return [self ch_sizeToFitHeight:height withFont:font].width;
}

- (CGSize)ch_sizeToFitHeight:(CGFloat)height withFont:(UIFont *)font
{
    CGSize maxSize = CGSizeMake(CGFLOAT_MAX, height);
    
    return [self ch_sizeToFit:maxSize withFont:font lineBreakMode:NSLineBreakByCharWrapping];
}

- (CGSize)ch_sizeToFit:(CGSize)maxSize withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    if (!font)
    {
        font = [UIFont systemFontOfSize:12.0f];
    }
    
    CGSize textSize = CGSizeZero;

    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)])
    {
        NSMutableDictionary *attr = [NSMutableDictionary new];
        attr[NSFontAttributeName] = font;
        if (lineBreakMode != NSLineBreakByWordWrapping)
        {
            NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
            paragraphStyle.lineBreakMode = lineBreakMode;
            attr[NSParagraphStyleAttributeName] = paragraphStyle;
        }
        NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        CGRect rect = [self boundingRectWithSize:maxSize
                                         options:options
                                      attributes:attr context:nil];
        textSize = CGSizeMake(ceil(rect.size.width), ceil(rect.size.height));
    }
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        textSize = [self sizeWithFont:font constrainedToSize:maxSize lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
    }
    
    return textSize;
}

- (NSString *)ch_trimAllSpace
{
    NSString *resultStr;
    
    resultStr = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSArray *components = [resultStr componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    components = [components filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != ' ' AND SELF != '\t'"]];
    resultStr = [components componentsJoinedByString:@""];
    
    return resultStr;
}





@end
