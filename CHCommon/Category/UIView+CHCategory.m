//
//  UIView+CHCategory.m
//  CloudHub
//
//  Created by jiang deng on 2021/2/24.
//  Copyright 2019 The CloudHub project authors. All Rights Reserved.

#import "UIView+CHCategory.h"

@implementation UIView (CHCategory)

- (void)setCh_size:(CGSize)size
{
    CGPoint origin = [self frame].origin;
    
    [self setFrame:CGRectMake(origin.x, origin.y, size.width, size.height)];
}

- (CGSize)ch_size
{
    return [self frame].size;
}

- (void)setCh_origin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)ch_origin
{
    return self.frame.origin;
}

- (CGFloat)ch_left
{
    return CGRectGetMinX([self frame]);
}

- (void)setCh_left:(CGFloat)x
{
    CGRect frame = [self frame];
    frame.origin.x = x;
    [self setFrame:frame];
}

- (CGFloat)ch_top
{
    return CGRectGetMinY([self frame]);
}

- (void)setCh_top:(CGFloat)y
{
    CGRect frame = [self frame];
    frame.origin.y = y;
    [self setFrame:frame];
}

- (CGFloat)ch_right
{
    return CGRectGetMaxX([self frame]);
}

- (void)setCh_right:(CGFloat)right
{
    CGRect frame = [self frame];
    frame.origin.x = right - frame.size.width;
    
    [self setFrame:frame];
}

- (CGFloat)ch_bottom
{
    return CGRectGetMaxY([self frame]);
}

- (void)setCh_bottom:(CGFloat)bottom
{
    CGRect frame = [self frame];
    frame.origin.y = bottom - frame.size.height;
    
    [self setFrame:frame];
}

- (CGFloat)ch_originX
{
    return CGRectGetMinX(self.frame);
}

- (void)setCh_originX:(CGFloat)aOriginX
{
    self.frame = CGRectMake(aOriginX, CGRectGetMinY(self.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}

- (CGFloat)ch_originY
{
    return CGRectGetMinY(self.frame);
}

- (void)setCh_originY:(CGFloat)aOriginY
{
    self.frame = CGRectMake(CGRectGetMinX(self.frame), aOriginY, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}

- (CGFloat)ch_centerX
{
    return [self center].x;
}

- (void)setCh_centerX:(CGFloat)centerX
{
    [self setCenter:CGPointMake(centerX, self.center.y)];
}

- (CGFloat)ch_centerY
{
    return [self center].y;
}

- (void)setCh_centerY:(CGFloat)centerY
{
    [self setCenter:CGPointMake(self.center.x, centerY)];
}

- (CGFloat)ch_width
{
    return CGRectGetWidth([self frame]);
}

- (void)setCh_width:(CGFloat)width
{
    CGRect frame = [self frame];
    frame.size.width = width;
    
    [self setFrame:CGRectStandardize(frame)];
}

- (CGFloat)ch_height
{
    return CGRectGetHeight([self frame]);
}

- (void)setCh_height:(CGFloat)height
{
    CGRect frame = [self frame];
    frame.size.height = height;
    
    [self setFrame:CGRectStandardize(frame)];
}

- (void)ch_setLeft:(CGFloat)left right:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x = left;
    frame.size.width = right - left;
    self.frame = frame;
}

- (void)ch_setWidth:(CGFloat)width right:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x = right - width;
    frame.size.width = width;
    self.frame = frame;
}

- (void)ch_setTop:(CGFloat)top bottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = top;
    frame.size.height = bottom - top;
    self.frame = frame;
}

- (void)ch_setHeight:(CGFloat)height bottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = bottom - height;
    frame.size.height = height;
    self.frame = frame;
}

- (void)ch_centerInRect:(CGRect)rect
{
    [self setCenter:CGPointMake(floorf(CGRectGetMidX(rect)) + ((int)floorf([self ch_width]) % 2 ? .5 : 0) , floorf(CGRectGetMidY(rect)) + ((int)floorf([self ch_height]) % 2 ? .5 : 0))];
}

- (void)ch_centerInRect:(CGRect)rect leftOffset:(CGFloat)left
{
    [self setCenter:CGPointMake(left + floorf(CGRectGetMidX(rect)) + ((int)floorf([self ch_width]) % 2 ? .5 : 0) , floorf(CGRectGetMidY(rect)) + ((int)floorf([self ch_height]) % 2 ? .5 : 0))];
}

- (void)ch_centerInRect:(CGRect)rect topOffset:(CGFloat)top
{
    [self setCenter:CGPointMake(floorf(CGRectGetMidX(rect)) + ((int)floorf([self ch_width]) % 2 ? .5 : 0) , top + floorf(CGRectGetMidY(rect)) + ((int)floorf([self ch_height]) % 2 ? .5 : 0))];
}

- (void)ch_centerVerticallyInRect:(CGRect)rect
{
    [self setCenter:CGPointMake([self center].x, floorf(CGRectGetMidY(rect)) + ((int)floorf([self ch_height]) % 2 ? .5 : 0))];
}

- (void)ch_centerVerticallyInRect:(CGRect)rect left:(CGFloat)left
{
    [self ch_centerVerticallyInRect:rect];
    self.ch_left = left;
}

- (void)ch_centerHorizontallyInRect:(CGRect)rect
{
    [self setCenter:CGPointMake(floorf(CGRectGetMidX(rect)) + ((int)floorf([self ch_width]) % 2 ? .5 : 0), [self center].y)];
}

- (void)ch_centerHorizontallyInRect:(CGRect)rect top:(CGFloat)top
{
    [self ch_centerHorizontallyInRect:rect];
    self.ch_top = top;
}

- (void)ch_centerInSuperView
{
    [self ch_centerInRect:[[self superview] bounds]];
}

- (void)ch_centerInSuperViewWithLeftOffset:(CGFloat)left
{
    [self ch_centerInRect:[[self superview] bounds] leftOffset:left];
}

- (void)ch_centerInSuperViewWithTopOffset:(CGFloat)top
{
    [self ch_centerInRect:[[self superview] bounds] topOffset:top];
}

- (void)ch_centerVerticallyInSuperView
{
    [self ch_centerVerticallyInRect:[[self superview] bounds]];
}

- (void)ch_centerVerticallyInSuperViewWithLeft:(CGFloat)left
{
    [self ch_centerVerticallyInRect:[[self superview] bounds] left:left];
}

- (void)ch_centerHorizontallyInSuperView
{
    [self ch_centerHorizontallyInRect:[[self superview] bounds]];
}

- (void)ch_centerHorizontallyInSuperViewWithTop:(CGFloat)top
{
    [self ch_centerHorizontallyInRect:[[self superview] bounds] top:top];
}

- (void)ch_removeAllSubviews
{
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull childView, NSUInteger idx, BOOL * _Nonnull stop) {
        [childView removeFromSuperview];
    }];
}

- (void)ch_bringToFront
{
    [self.superview bringSubviewToFront:self];
}

- (UIView *)ch_firstResponder
{
    return [self ch_viewMatchingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, __unused id bindings) {
        return [evaluatedObject isFirstResponder];
    }]];
}

- (UIView *)ch_viewMatchingPredicate:(NSPredicate *)predicate
{
    if ([predicate evaluateWithObject:self])
    {
        return self;
    }
    
    for (UIView *view in self.subviews)
    {
        UIView *match = [view ch_viewMatchingPredicate:predicate];
        if (match)
        {
            return match;
        }
    }
    
    return nil;
}

- (void)ch_roundedRect:(CGFloat)radius
{
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
}

- (void)ch_connerWithRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii
{
    CGRect rect = self.bounds;

    CAShapeLayer *masklayer = [[CAShapeLayer alloc] init];
    masklayer.frame = rect;

    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:cornerRadii];
    masklayer.path = path.CGPath;
    
    self.layer.mask = masklayer;
}

- (UIView *)ch_viewOfClass:(Class)viewClass
{
    return [self ch_viewMatchingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, __unused NSDictionary *bindings) {
        return [evaluatedObject isKindOfClass:viewClass];
    }]];
}

- (NSArray *)ch_viewsMatchingPredicate:(NSPredicate *)predicate
{
    NSMutableArray *matches = [NSMutableArray array];
    
    if ([predicate evaluateWithObject:self])
    {
        [matches addObject:self];
    }
    
    for (UIView *view in self.subviews)
    {
        // check for subviews
        // avoid creating unnecessary array
        if ([view.subviews count])
        {
            [matches addObjectsFromArray:[view ch_viewsMatchingPredicate:predicate]];
        }
        else if ([predicate evaluateWithObject:view])
        {
            [matches addObject:view];
        }
    }
    
    return matches;
}

@end
