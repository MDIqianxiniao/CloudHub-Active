//
//  CHCommon.h
//  CloudHub
//
//  Created by jiang deng on 2021/2/24.
//  Copyright 2019 The CloudHub project authors. All Rights Reserved.

#ifndef CHCommon_h
#define CHCommon_h

#import "NSObject+CHCategory.h"
#import "NSBundle+CHCategory.h"
#import "NSDictionary+CHCategory.h"
#import "NSDate+CHCategory.h"
#import "NSString+CHCategory.h"
#import "NSAttributedString+CHCategory.h"
#import "NSArray+CHCategory.h"
#import "NSNumber+CHCategory.h"

#import "UIView+CHCategory.h"
#import "UIDevice+CHCategory.h"
#import "UIColor+CHCategory.h"
#import "UIButton+CHCategory.h"
#import "UIImage+CHCategory.h"
#import "UIImageView+CHCategory.h"
#import "UILabel+CHCategory.h"
#import "NSObject+CHCategory.h"

//#import "CHCloudHubUtil.h"
#import "Masonry.h"

#import "UIImageView+WebCache.h"

#import "CHProgressHUD.h"

#define CHHost_API          1


#define CHUI_SCREEN_WIDTH                 ([[UIScreen mainScreen] bounds].size.width)
#define CHUI_SCREEN_HEIGHT                ([[UIScreen mainScreen] bounds].size.height)

#define CHUI_SCREEN_WIDTH_ROTATE          ([UIScreen mainScreen].bounds.size.width > [UIScreen mainScreen].bounds.size.height ? [UIScreen mainScreen].bounds.size.width : [UIScreen mainScreen].bounds.size.height)
#define CHUI_SCREEN_HEIGHT_ROTATE         ([UIScreen mainScreen].bounds.size.width < [UIScreen mainScreen].bounds.size.height ? [UIScreen mainScreen].bounds.size.width : [UIScreen mainScreen].bounds.size.height)

#define CHUI_NAVIGATION_BAR_HEIGHT        44.0f

#define kCHScale_W(w) ((CHUI_SCREEN_WIDTH)/375.0f) * (w)
#define kCHScale_H(h) ((CHUI_SCREEN_HEIGHT)/667.0f) * (h)


#ifndef CHIOS_VERSION
#define CHIOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#endif

#define CHIS_IPHONE4  (CGSizeEqualToSize(CGSizeMake(320.0f, 480.0f), [[UIScreen mainScreen] bounds].size) || CGSizeEqualToSize(CGSizeMake(480.0f, 320.0f), [[UIScreen mainScreen] bounds].size) ? YES : NO)
#define CHIS_IPHONE5  (CGSizeEqualToSize(CGSizeMake(320.0f, 568.0f), [[UIScreen mainScreen] bounds].size) || CGSizeEqualToSize(CGSizeMake(568.0f, 320.0f), [[UIScreen mainScreen] bounds].size) ? YES : NO)
#define CHIS_IPHONE6  (CGSizeEqualToSize(CGSizeMake(375.0f, 667.0f), [[UIScreen mainScreen] bounds].size) || CGSizeEqualToSize(CGSizeMake(667.0f, 375.0f), [[UIScreen mainScreen] bounds].size) ? YES : NO)
#define CHIS_IPHONE6P (CGSizeEqualToSize(CGSizeMake(414.0f, 736.0f), [[UIScreen mainScreen] bounds].size) || CGSizeEqualToSize(CGSizeMake(736.0f, 414.0f), [[UIScreen mainScreen] bounds].size) ? YES : NO)
#define CHIS_IPHONEX  (CGSizeEqualToSize(CGSizeMake(375.0f, 812.0f), [[UIScreen mainScreen] bounds].size) || CGSizeEqualToSize(CGSizeMake(812.0f, 375.0f), [[UIScreen mainScreen] bounds].size) ?  YES : NO)
#define CHIS_IPHONEXP (CGSizeEqualToSize(CGSizeMake(414.0f, 896.0f), [[UIScreen mainScreen] bounds].size) || CGSizeEqualToSize(CGSizeMake(896.0f, 414.0f), [[UIScreen mainScreen] bounds].size) ? YES : NO)

#define CHDEFAULT_DELAY_TIME              (0.25f)
#define CHPROGRESSBOX_DEFAULT_HIDE_DELAY  (2.0f)

#define CHWeakSelf                  __weak __typeof(self) weakSelf = self;
#define CHStrongSelf                __strong __typeof(weakSelf) strongSelf = weakSelf;

#define CHWeakType(type)            __weak __typeof(type) weak##type = type;
#define CHStrongType(type)          __strong __typeof(weak##type) strong##type = weak##type;

#define  RtcEngine ((AppDelegate *)[[UIApplication sharedApplication] delegate]).rtcEngine

#define  CHUserDefault [NSUserDefaults standardUserDefaults]

/// UIFont
#define CHFont(size) [UIFont systemFontOfSize:size]
#define CHFont18 CHFont(18)
#define CHFont17 CHFont(17)
#define CHFont16 CHFont(16)
#define CHFont15 CHFont(15)
#define CHFont13 CHFont(13)
#define CHFont12 CHFont(12)
#define CHFont10 CHFont(10)

/// UIColor
#define CHWhiteColor UIColor.whiteColor
#define CHBlackColor UIColor.blackColor
#define CHColor_212121 [UIColor ch_colorWithHex:0x212121]
#define CHColor_6D7278 [UIColor ch_colorWithHex:0x6D7278]
#define CHColor_DBDBDB [UIColor ch_colorWithHex:0x6D7278]
#define CHColor_C4C4C4 [UIColor ch_colorWithHex:0xC4C4C4]
#define CHColor_24D3EE [UIColor ch_colorWithHex:0x24D3EE]
#define CHColor_BBBBBB [UIColor ch_colorWithHex:0xBBBBBB]
#define CHColor_D8D8D8 [UIColor ch_colorWithHex:0xD8D8D8]
#define CHColor_40424A [UIColor ch_colorWithHex:0x40424A]
#define CHColor_24262C [UIColor ch_colorWithHex:0x24262C]

/// StatusBar
#define StatusBarH_iPhone 20
#define StatusBarH_iPad 44
#define StatusBarH ([UIDevice ch_isiPad] ? StatusBarH_iPad : StatusBarH_iPhone)

#define CHVideoViewW 86
#define CHVideoViewH 115

#define CHProgressDelay 1.5f

#endif /* CHCommon_h */
