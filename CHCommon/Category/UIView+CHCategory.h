//
//  UIView+CHCategory.h
//  CloudHub
//
//  Created by jiang deng on 2021/2/24.
//  Copyright 2019 The CloudHub project authors. All Rights Reserved.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (CHCategory)

@property (nonatomic, assign) CGPoint ch_origin;
@property (nonatomic, assign) CGSize ch_size;
@property (nonatomic, assign) CGFloat ch_left;
@property (nonatomic, assign) CGFloat ch_right;
@property (nonatomic, assign) CGFloat ch_top;
@property (nonatomic, assign) CGFloat ch_bottom;
@property (nonatomic, assign) CGFloat ch_originX;
@property (nonatomic, assign) CGFloat ch_originY;
@property (nonatomic, assign) CGFloat ch_centerX;
@property (nonatomic, assign) CGFloat ch_centerY;
@property (nonatomic, assign) CGFloat ch_width;
@property (nonatomic, assign) CGFloat ch_height;

- (void)ch_setLeft:(CGFloat)left right:(CGFloat)right;
- (void)ch_setWidth:(CGFloat)width right:(CGFloat)right;
- (void)ch_setTop:(CGFloat)top bottom:(CGFloat)bottom;
- (void)ch_setHeight:(CGFloat)height bottom:(CGFloat)bottom;

- (void)ch_centerInRect:(CGRect)rect;
- (void)ch_centerInRect:(CGRect)rect leftOffset:(CGFloat)left;
- (void)ch_centerInRect:(CGRect)rect topOffset:(CGFloat)top;
- (void)ch_centerVerticallyInRect:(CGRect)rect;
- (void)ch_centerVerticallyInRect:(CGRect)rect left:(CGFloat)left;
- (void)ch_centerHorizontallyInRect:(CGRect)rect;
- (void)ch_centerHorizontallyInRect:(CGRect)rect top:(CGFloat)top;

- (void)ch_centerInSuperView;
- (void)ch_centerInSuperViewWithLeftOffset:(CGFloat)left;
- (void)ch_centerInSuperViewWithTopOffset:(CGFloat)top;
- (void)ch_centerVerticallyInSuperView;
- (void)ch_centerVerticallyInSuperViewWithLeft:(CGFloat)left;
- (void)ch_centerHorizontallyInSuperView;
- (void)ch_centerHorizontallyInSuperViewWithTop:(CGFloat)top;

- (void)ch_removeAllSubviews;

- (void)ch_bringToFront;

- (UIView *)ch_firstResponder;

- (void)ch_roundedRect:(CGFloat)radius;

- (void)ch_connerWithRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii;

- (UIView *)ch_viewOfClass:(Class)viewClass;

@end

NS_ASSUME_NONNULL_END
