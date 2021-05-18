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
/// Judge horizontal and vertical
@property (assign, nonatomic) BOOL isHorizontal;

@end

@implementation CHSuperViewController

- (CHLiveChannelModel *)liveModel
{
    if (!_liveModel)
    {
        _liveModel = [[CHLiveChannelModel alloc]init];
    }
    return _liveModel;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.rtcEngine = RtcEngine;
    
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

- (CHVideoSetView *)videoSetView
{
    if (!_videoSetView)
    {
        _videoSetView = [[CHVideoSetView alloc]initWithFrame:CGRectMake(0, self.view.ch_height, self.view.ch_width, 0) itemGap:CellGap];
        [self.view addSubview:_videoSetView];
        
        CHWeakSelf
        _videoSetView.setArrowButtonClick = ^(UIButton * _Nonnull button) {
            [weakSelf setViewArrowButtonClick:button];
        };
    }
    return _videoSetView;
}

- (void)setViewArrowButtonClick:(UIButton *)button
{
    if (button.tag == 100)
    {
        if (!self.resolutionView)
        {
            NSArray * dataArray = @[@"200 × 150",@"320 × 180",@"320 × 240",@"640 × 360",@"640 × 480",@"1280 × 720",@"1920 × 1080"];
            
            CHResolutionView *resolutionView = [[CHResolutionView alloc]initWithFrame:CGRectMake(0, self.view.ch_height, self.view.ch_width, 0) itemGap:CellGap type:CHVideoSetViewType_Resolution withData:dataArray];
            [self.view addSubview:resolutionView];
            self.resolutionView = resolutionView;
            
            CHWeakSelf
            __weak CHResolutionView *weakResolutionView = self.resolutionView;
            resolutionView.resolutionViewButtonClick = ^(NSString * _Nullable value) {
                if ([value ch_isNotEmpty])
                {
                    weakSelf.videoSetView.resolutionString = value;
                    weakSelf.liveModel.resolution = value;
                    
                    NSArray *array = [value componentsSeparatedByString:@" × "];
                    
                    weakSelf.liveModel.videowidth = [array.firstObject integerValue];
                    weakSelf.liveModel.videoheight = [array.lastObject integerValue];
                    
                    CloudHubVideoEncoderConfiguration *config = [[CloudHubVideoEncoderConfiguration alloc] initWithWidth:weakSelf.liveModel.videowidth height:weakSelf.liveModel.videoheight frameRate:weakSelf.liveModel.rate];
                    [self.rtcEngine setVideoEncoderConfiguration:config];
                    
                }
                else
                {// back
                    
                    [UIView animateWithDuration:0.25 animations:^{
                        weakSelf.videoSetView.ch_originY = weakSelf.view.ch_height - weakSelf.videoSetView.ch_height;
                        weakResolutionView.ch_originY = weakSelf.view.ch_height;
                   }];
                }
            };
        }
                
        [self.resolutionView ch_bringToFront];
        
        [UIView animateWithDuration:0.25 animations:^{
            self.videoSetView.ch_originY = self.view.ch_height;
            self.resolutionView.ch_originY = self.view.ch_height - self.resolutionView.ch_height;
       }];
    }
    else if (button.tag == 101)
    {
        if (!self.rateView)
        {
            NSArray * dataArray = @[@"5",@"10",@"15"];
            CHResolutionView *rateView = [[CHResolutionView alloc]initWithFrame:CGRectMake(0, self.view.ch_height, self.view.ch_width, 0) itemGap:CellGap type:CHVideoSetViewType_Rate withData:dataArray];
            [self.view addSubview:rateView];
            self.rateView = rateView;
            
            CHWeakSelf
            __weak CHResolutionView *weakRateView = self.rateView;
            rateView.resolutionViewButtonClick = ^(NSString * _Nullable value) {
                if ([value ch_isNotEmpty])
                {
                    weakSelf.videoSetView.rateString = value;
                    weakSelf.liveModel.rate = value.integerValue;
                    
                    CloudHubVideoEncoderConfiguration *config = [[CloudHubVideoEncoderConfiguration alloc] initWithWidth:weakSelf.liveModel.videowidth height:weakSelf.liveModel.videoheight frameRate:weakSelf.liveModel.rate];
                    [self.rtcEngine setVideoEncoderConfiguration:config];
                }
                else
                {
                    [UIView animateWithDuration:0.25 animations:^{
                        weakSelf.videoSetView.ch_originY = weakSelf.view.ch_height - weakSelf.videoSetView.ch_height;
                        weakRateView.ch_originY = weakSelf.view.ch_height;
                   }];
                }
            };
        }
        
        [self.rateView ch_bringToFront];
        
         [UIView animateWithDuration:0.25 animations:^{
             self.videoSetView.ch_originY = self.view.ch_height;
             self.rateView.ch_originY = self.view.ch_height - self.rateView.ch_height;
        }];
    }
}

/// How to judge the direction of the screen when the screen rotation function is turned off
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
        if (self.isHorizontal == YES) {
            [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
            [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
            self.isHorizontal = NO;
        }
    }
    else
    {
        if (self.isHorizontal == NO) {
            [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
            [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
            self.isHorizontal = YES;
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

@end
