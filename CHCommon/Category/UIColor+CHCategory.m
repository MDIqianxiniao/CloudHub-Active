//
//  UIColor+CHCategory.m
//  CloudHub
//
//  Created by jiang deng on 2021/2/24.
//  Copyright 2019 The CloudHub project authors. All Rights Reserved.

#import "UIColor+CHCategory.h"

#define DEFAULT_VOID_COLOR [UIColor whiteColor]

@implementation UIColor (CHCategory)

+ (UIColor *)ch_colorWithHex:(UInt32)hex
{
    return [UIColor ch_colorWithHex:hex alpha:1.0f];
}

+ (UIColor *)ch_colorWithHex:(UInt32)hex alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0
                           green:((float)((hex & 0xFF00) >> 8)) / 255.0
                            blue:((float)(hex & 0xFF)) / 255.0
                           alpha:alpha];
}

+ (UIColor *)ch_colorWithHexString:(NSString *)stringToConvert
{
    return [UIColor ch_colorWithHexString:stringToConvert alpha:1.0f];
}

+ (UIColor *)ch_colorWithHexString:(NSString *)stringToConvert alpha:(CGFloat)alpha
{
    return [UIColor ch_colorWithHexString:stringToConvert alpha:alpha default:DEFAULT_VOID_COLOR];
}

+ (UIColor *)ch_colorWithHexString:(NSString *)stringToConvert default:(UIColor *)color
{
    return [UIColor ch_colorWithHexString:stringToConvert alpha:1.0f default:color];
}

+ (CGFloat)ch_colorComponentFrom:(NSString *)string start:(NSUInteger)start length:(NSUInteger)length
{
    NSString *substring = [string substringWithRange:NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat:@"%@%@", substring, substring];
    unsigned int hexComponent;
    [[NSScanner scannerWithString:fullHex] scanHexInt:&hexComponent];
    
    return hexComponent / 255.0f;
}

+ (UIColor *)ch_colorWithHexString:(NSString *)stringToConvert alpha:(CGFloat)alpha default:(UIColor *)color
{
    NSString *colorString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // strip 0X if it appears
    // if ([cString hasPrefix:@"0X"] || [cString hasPrefix:@"0x"])
    if ([colorString hasPrefix:@"0X"])
    {
        colorString = [colorString substringFromIndex:2];
    }
    else if ([colorString hasPrefix:@"＃"] || [colorString hasPrefix:@"#"])
    {
        colorString = [colorString substringFromIndex:1];
    }

    if (![colorString ch_isNotEmpty])
    {
        return color;
    }
    
    CGFloat red, blue, green;
    NSUInteger length = colorString.length;
    switch (length)
    {
        case 1: // 0
            if ([colorString isEqualToString:@"0"])
            {
                return [UIColor clearColor];
            }
            else
            {
                return color;
            }

        case 3: // #RGB ==> #RRGGBB
            red = [UIColor ch_colorComponentFrom:colorString start:0 length:1];
            green = [UIColor ch_colorComponentFrom:colorString start:1 length:1];
            blue = [UIColor ch_colorComponentFrom:colorString start:2 length:1];
            break;
            
        case 4: // #ARGB ==> #AARRGGBB
            alpha = [UIColor ch_colorComponentFrom:colorString start:0 length:1];
            red = [UIColor ch_colorComponentFrom:colorString start:1 length:1];
            green = [UIColor ch_colorComponentFrom:colorString start:2 length:1];
            blue = [UIColor ch_colorComponentFrom:colorString start:3 length:1];
            break;

        case 6: // #RRGGBB
            red = [UIColor ch_colorComponentFrom:colorString start:0 length:2];
            green = [UIColor ch_colorComponentFrom:colorString start:2 length:2];
            blue = [UIColor ch_colorComponentFrom:colorString start:4 length:2];
            break;
            
        case 8: // #AARRGGBB
            alpha = [UIColor ch_colorComponentFrom:colorString start:0 length:2];
            red = [UIColor ch_colorComponentFrom:colorString start:2 length:2];
            green = [UIColor ch_colorComponentFrom:colorString start:4 length:2];
            blue = [UIColor ch_colorComponentFrom:colorString start:6 length:2];
            break;
            
        default:
            
            return color;
    }

    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (UIColor *)ch_changeAlpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:self.ch_red
                    green:self.ch_green
                     blue:self.ch_blue
                    alpha:alpha];
}

- (CGColorSpaceModel)ch_colorSpaceModel
{
    return CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor));
}

- (BOOL)ch_canProvideRGBComponents
{
    switch (self.ch_colorSpaceModel)
    {
        case kCGColorSpaceModelRGB:
        case kCGColorSpaceModelMonochrome:
            
            return YES;
            
        default:
            
            return NO;
    }
}

- (CGFloat)ch_red
{
    NSAssert(self.ch_canProvideRGBComponents, @"Must be an RGB color to use -red");
    
    const CGFloat *c = CGColorGetComponents(self.CGColor);
    
    return c[0];
}

- (CGFloat)ch_green
{
    NSAssert(self.ch_canProvideRGBComponents, @"Must be an RGB color to use -green");
    
    const CGFloat *c = CGColorGetComponents(self.CGColor);
    if (self.ch_colorSpaceModel == kCGColorSpaceModelMonochrome)
        return c[0];
    
    return c[1];
}

- (CGFloat)ch_blue
{
    NSAssert(self.ch_canProvideRGBComponents, @"Must be an RGB color to use -blue");
    
    const CGFloat *c = CGColorGetComponents(self.CGColor);
    if (self.ch_colorSpaceModel == kCGColorSpaceModelMonochrome)
        return c[0];
    
    return c[2];
}

- (UIColor *)ch_colorByDarkeningTo:(CGFloat)f
{
    return [self ch_colorByDarkeningToRed:f green:f blue:f alpha:1.0f];
}

- (UIColor *)ch_colorByDarkeningToRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha
{
    NSAssert(self.ch_canProvideRGBComponents, @"Must be a RGB color to use arithmetic operations");
    
    CGFloat r,g,b,a;
    if (![self ch_red:&r green:&g blue:&b alpha:&a]) return nil;
    
    return [UIColor colorWithRed:MIN(r, red)
                           green:MIN(g, green)
                            blue:MIN(b, blue)
                           alpha:MIN(a, alpha)];
}

- (BOOL)ch_red:(CGFloat *)red green:(CGFloat *)green blue:(CGFloat *)blue alpha:(CGFloat *)alpha
{
    const CGFloat *components = CGColorGetComponents(self.CGColor);
    
    CGFloat r,g,b,a;
    
    switch (self.ch_colorSpaceModel)
    {
        case kCGColorSpaceModelMonochrome:
            r = g = b = components[0];
            a = components[1];
            break;
            
        case kCGColorSpaceModelRGB:
            r = components[0];
            g = components[1];
            b = components[2];
            a = components[3];
            break;
            
        default: // We don't know how to handle this model
            return NO;
    }
    
    if (red)
        *red = r;
    
    if (green)
        *green = g;
    
    if (blue)
        *blue = b;
    
    if (alpha)
        *alpha = a;
    
    return YES;
}

@end
