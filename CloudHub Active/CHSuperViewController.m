//
//  CHSuperViewController.m
//  CloudHub Active
//
//  Created by 马迪 on 2021/4/25.
//

#import "CHSuperViewController.h"



@interface CHSuperViewController ()


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
            [self.rtcEngine setVideoRotation:CloudHubHomeButtonOnTop];
            break;
        case UIDeviceOrientationLandscapeRight:
            NSLog(@"Home Button On Left");
            [self.rtcEngine setVideoRotation:CloudHubHomeButtonOnTop];
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
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}


@end
