//
//  UIImageView+CHCategory.m
//  CloudHub
//
//  Created by jiang deng on 2021/2/24.
//  Copyright 2019 The CloudHub project authors. All Rights Reserved.

#import "UIImageView+CHCategory.h"

@implementation UIImageView (CHCategory)

+ (instancetype)ch_imageViewWithImageArray:(NSArray *)imageArray duration:(NSTimeInterval)duration
{
    return [UIImageView ch_imageViewWithImageArray:imageArray duration:duration repeatCount:0];
}

+ (instancetype)ch_imageViewWithImageArray:(NSArray *)imageArray duration:(NSTimeInterval)duration repeatCount:(NSUInteger)repeatCount
{
    if (![imageArray ch_isNotEmpty])
    {
        return nil;
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[imageArray objectAtIndex:0]]];

    NSMutableArray *images = [NSMutableArray array];
    
    for (NSUInteger i = 0; i < imageArray.count; i++)
    {
        UIImage *image = [UIImage imageNamed:[imageArray objectAtIndex:i]];
        if ([image ch_isNotEmpty])
        {
            [images addObject:image];
        }
    }
    
//    [imageView setImage:[images objectAtIndex:0]];
    
    if (images.count > 1)
    {
        [imageView setAnimationImages:images];
        [imageView setAnimationDuration:duration];
        [imageView setAnimationRepeatCount:repeatCount];
        
        [imageView stopAnimating];
    }
    
    return imageView;
}

- (void)ch_animationWithImageArray:(NSArray *)imageArray duration:(NSTimeInterval)duration repeatCount:(NSUInteger)repeatCount
{
    [self ch_animationWithImageArray:imageArray duration:duration repeatCount:repeatCount imageWithIndex:0];
}

- (void)ch_animationWithImageArray:(NSArray *)imageArray duration:(NSTimeInterval)duration repeatCount:(NSUInteger)repeatCount imageWithIndex:(NSUInteger)index
{
    NSMutableArray *images = [NSMutableArray array];
    
    for (NSUInteger i = 0; i < imageArray.count; i++)
    {
        UIImage *image = [UIImage imageNamed:[imageArray objectAtIndex:i]];
        if ([image ch_isNotEmpty])
        {
            [images addObject:image];
        }
    }
    
    if (images.count > 1)
    {
        UIImage *image = [images ch_safeObjectAtIndex:index];
        if (image)
        {
            [self setImage:image];
        }
        
        [self setAnimationImages:images];
        [self setAnimationDuration:duration];
        [self setAnimationRepeatCount:repeatCount];
    }
    
    [self stopAnimating];
}

@end
