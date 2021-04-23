//
//  UIImage+CHCategory.m
//  CloudHub
//
//  Created by jiang deng on 2021/2/24.
//  Copyright 2019 The CloudHub project authors. All Rights Reserved.

#import "UIImage+CHCategory.h"

@implementation UIImage (CHCategory)

+ (UIImage *)ch_imageWithColor:(UIColor *)color
{
    CGSize size = CGSizeMake(1.0f, 1.0f);
    UIImage *image = [UIImage ch_imageWithColor:color size:size];
    
    return image;
}

+ (UIImage *)ch_imageWithColor:(UIColor *)color size:(CGSize)size
{
    //Create a context of the appropriate size
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    if (currentContext == NULL) return nil;
    
    // Build a rect of appropriate size at origin 0,0
    CGRect fillRect = CGRectMake(0, 0, size.width, size.height);
    
    // Set the fill color
    CGContextSetFillColorWithColor(currentContext, color.CGColor);
    
    // Fill the color
    CGContextFillRect(currentContext, fillRect);
    
    // Snap the picture and close the context
    UIImage *colorImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return colorImage;
}

- (UIImage *)ch_imageWithTintColor:(UIColor *)tintColor
{
    // 用kCGBlendModeDestinationIn能保留透明度信息
    return [self ch_imageWithTintColor:tintColor blendMode:kCGBlendModeDestinationIn];
}

- (UIImage *)ch_imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode
{
    CGRect rect = CGRectMake(0.0f, 0.0f, self.size.width, self.size.height);
    return [self ch_imageWithTintColor:tintColor rect:rect blendMode:blendMode alpha:1.0f];
}

- (UIImage *)ch_imageWithTintColor:(UIColor *)tintColor rect:(CGRect)rect blendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha
{
    // We want to keep alpha, set opaque to NO; Use 0.0f for scale to use the scale factor of the device’s main screen.
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0f);
    [tintColor setFill];
    UIRectFill(rect);
    
    // Draw the tinted image in context
    [self drawInRect:rect blendMode:blendMode alpha:alpha];
    
    if (blendMode != kCGBlendModeDestinationIn)
    {
        [self drawInRect:rect blendMode:kCGBlendModeDestinationIn alpha:1.0];
    }
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
}

@end
