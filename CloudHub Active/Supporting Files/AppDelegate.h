//
//  AppDelegate.h
//  CloudHub Active
//
//  Created by 马迪 on 2021/4/19.
//

#import <UIKit/UIKit.h>

@class CHBeautySetModel;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;

@property (nonatomic, strong) CloudHubRtcEngineKit *rtcEngine;
@property (nonatomic, strong, readonly) CHBeautySetModel *beautySetModel;

@end

