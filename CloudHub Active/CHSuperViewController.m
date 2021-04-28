//
//  CHSuperViewController.m
//  CloudHub Active
//
//  Created by 马迪 on 2021/4/25.
//

#import "CHSuperViewController.h"
#import <CoreMotion/CoreMotion.h>

@interface CHSuperViewController ()

@property (strong, nonatomic) CMMotionManager *motionManager;
@property (assign, nonatomic) BOOL isHeng;   // 判断横竖屏

@end

@implementation CHSuperViewController

- (CHLiveModel *)liveModel
{
    if (!_liveModel)
    {
        _liveModel = [[CHLiveModel alloc]init];
    }
    return _liveModel;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.rtcEngine = RtcEngine;
    
    // 主播视频
    [self setupLargeVideoView];
    
    [self initMotionManager];
    
    if (![UIDevice currentDevice].generatesDeviceOrientationNotifications)
    {
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleDeviceOrientationDidChange:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}

// 主播视频
- (void)setupLargeVideoView
{
    CHVideoView *largeVideoView = [[CHVideoView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:largeVideoView];
    largeVideoView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    largeVideoView.isBigView = YES;
    self.largeVideoView = largeVideoView;
}

- (CHBeautySetView *)beautyView
{
    if (!_beautyView)
    {
        _beautyView = [[CHBeautySetView alloc]initWithFrame:CGRectMake(0, self.view.ch_height, self.view.ch_width, 0) itemGap:CellGap];
        [self.view addSubview:_beautyView];
        
        CHWeakSelf
        _beautyView.beautySetModelChange = ^{
            weakSelf.liveModel.beautySetModel = weakSelf.beautyView.beautySetModel;
        };
    }
    return _beautyView;
}

/**
 *  在真机关闭屏幕旋转功能时如何去判断屏幕方向
 */
- (void)initMotionManager
{
    if (_motionManager == nil)
    {
        _motionManager = [[CMMotionManager alloc] init];
    }
    _motionManager.deviceMotionUpdateInterval = .3;

    if (_motionManager.deviceMotionAvailable)
    {
        [_motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {

            [self performSelectorOnMainThread:@selector(handleDeviceMotion:) withObject:motion waitUntilDone:YES];
        }];
    }else
    {
        [self setMotionManager:nil];
    }
}
- (void)handleDeviceMotion:(CMDeviceMotion *)deviceMotion
{
    double x = deviceMotion.gravity.x;
    double y = deviceMotion.gravity.y;

    if (fabs(y) >= fabs(x))
    {
        if (self.isHeng == YES) {
            [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
            [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
            self.isHeng = NO;
        }
    }
    else
    {
        if (self.isHeng == NO) {
            [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
            [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
            self.isHeng = YES;
        }
    }
}

- (void)handleDeviceOrientationDidChange:(NSNotification *)notification
{
    UIDevice *device = [UIDevice currentDevice] ;
    
    switch (device.orientation)
    {
        case UIDeviceOrientationPortrait:
            NSLog(@"Home Button On Bottom");
            [self.rtcEngine setVideoRotation:CloudHubHomeButtonOnBottom];
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            NSLog(@"Home Button On Top");
            [self.rtcEngine setVideoRotation:CloudHubHomeButtonOnBottom];
            break;
            
        case UIDeviceOrientationLandscapeLeft:
            NSLog(@"Home Button On Right");
            [self.rtcEngine setVideoRotation:CloudHubHomeButtonOnBottom];
            break;
        case UIDeviceOrientationLandscapeRight:
            NSLog(@"Home Button On Left");
            [self.rtcEngine setVideoRotation:CloudHubHomeButtonOnBottom];
            break;
        case UIDeviceOrientationUnknown:
            NSLog(@"Unknown");
        default:
        {

        }
            break;
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
//    return UIInterfaceOrientationMaskPortrait;
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}


@end
