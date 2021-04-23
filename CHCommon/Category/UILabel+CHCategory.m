//
//  UILabel+CHCategory.m
//  CloudHub
//
//  Created by jiang deng on 2021/2/24.
//  Copyright 2019 The CloudHub project authors. All Rights Reserved.

#import "UILabel+CHCategory.h"

@implementation UILabel (CHCategory)

- (CGSize)ch_labelSizeToFitWidth:(CGFloat)width
{
    CGSize maxSize = CGSizeMake(width, CGFLOAT_MAX);
    
    return [self ch_labelSizeToFit:maxSize];
}

- (CGSize)ch_labelSizeToFit:(CGSize)maxSize
{
    CGSize size = [self.text ch_sizeToFit:maxSize withFont:self.font lineBreakMode:self.lineBreakMode];
    
    return size;
}

- (CGSize)ch_attribSizeToFitWidth:(CGFloat)width
{
    CGSize maxSize = CGSizeMake(width, CGFLOAT_MAX);
    
    return [self ch_attribSizeToFit:maxSize];
}

- (CGSize)ch_attribSizeToFit:(CGSize)maxSize
{
    CGSize textSize = CGSizeZero;

    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    if (self.lineBreakMode ==  NSLineBreakByTruncatingHead ||
        self.lineBreakMode ==  NSLineBreakByTruncatingTail ||
        self.lineBreakMode ==  NSLineBreakByTruncatingMiddle )
    {
        options |= NSStringDrawingTruncatesLastVisibleLine;
    }
//    NSLineBreakMode mode  = self.lineBreakMode;
//    self.lineBreakMode = NSLineBreakByCharWrapping;

    CGRect textRect  = [self.attributedText boundingRectWithSize:maxSize options:options context:NULL];
//    self.lineBreakMode = mode;
    textSize = CGSizeMake(ceil(textRect.size.width), ceil(textRect.size.height));

    return textSize;
}

- (CGFloat)ch_calculatedHeight
{
    if (self.attributedText)
    {
        return [self ch_attribSizeToFitWidth:self.ch_width].height;
    }
    else
    {
        return [self ch_labelSizeToFitWidth:self.ch_width].height;
    }
}

@end
