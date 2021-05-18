//
//  AppDelegate.m
//  CloudHub Active
//
//  Created by 马迪 on 2021/4/19.
//

#import "AppDelegate.h"
#import "CHLiveListVC.h"
#import "CHNavigationController.h"


/// https://itunes.apple.com/cn/app/id1559508438  App Store下载链接

#if CHHost_API

static NSString *const kAppkey = @"EosBxj1PWonrI2rG";

#else

static NSString *const kAppkey = @"4dAxkcHvEOhF5HIS";

#endif



@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    self.window.backgroundColor = [UIColor whiteColor];
    
    CHLiveListVC *vc= [[CHLiveListVC alloc] init];
    
    CHNavigationController *nav = [[CHNavigationController alloc]initWithRootViewController:vc];
    self.window.rootViewController = nav;
    
    [self.window makeKeyAndVisible];
    
    
    NSDictionary *rtcEngineKitConfig = @{ @"server": CHLiveActive_Server, @"port":@(80), @"secure":@(NO) };
    self.rtcEngine = [CloudHubRtcEngineKit sharedEngineWithAppId:kAppkey config:[rtcEngineKitConfig ch_toJSON]];
    
    [self.rtcEngine setChannelProfile:CloudHubChannelProfileLiveBroadcasting];
    
    return YES;
}


@end
