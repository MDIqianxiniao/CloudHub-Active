//
//  UIButton+CHCategory.m
//  CloudHub
//
//  Created by jiang deng on 2021/2/24.
//  Copyright 2019 The CloudHub project authors. All Rights Reserved.

#import "UIButton+CHCategory.h"

@implementation UIButton (CHCategory)

+ (nonnull instancetype)ch_buttonWithFrame:(CGRect)frame color:(nonnull UIColor *)color highlightedColor:(nonnull UIColor *)highlightedColor disableColor:(nonnull UIColor *)disableColor
{
    return [UIButton ch_buttonWithFrame:frame title:nil backgroundImage:[UIImage ch_imageWithColor:color] highlightedBackgroundImage:[UIImage ch_imageWithColor:highlightedColor] disableBackgroundImage:[UIImage ch_imageWithColor:disableColor]];
}

+ (instancetype)ch_buttonWithFrame:(CGRect)frame title:(NSString *)title backgroundImage:(UIImage *)backgroundImage highlightedBackgroundImage:(UIImage *)highlightedBackgroundImage  disableBackgroundImage:(UIImage *)disableBackgroundImage
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightedBackgroundImage forState:UIControlStateHighlighted];
    [button setBackgroundImage:disableBackgroundImage forState:UIControlStateDisabled];

    return button;
}

+ (instancetype)ch_buttonWithFrame:(CGRect)frame image:(UIImage *)image
{
    return [UIButton ch_buttonWithFrame:frame image:image highlightedImage:nil];
}

+ (instancetype)ch_buttonWithFrame:(CGRect)frame image:(UIImage *)image highlightedImage:(UIImage *)highlightedImage
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:highlightedImage forState:UIControlStateHighlighted];
    
    return button;
}


@end
