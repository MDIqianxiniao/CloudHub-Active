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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.rtcEngine = RtcEngine;
    self.rtcEngine.delegate = self;

    // 主播视频
    [self setupLargeVideoView];
}

// 主播视频
- (void)setupLargeVideoView
{
    CHVideoView *largeVideoView = [[CHVideoView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:largeVideoView];
    largeVideoView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    largeVideoView.isBigView = YES;
    self.largeVideoView = largeVideoView;
    [self.rtcEngine startPlayingLocalVideo:self.largeVideoView.contentView renderMode:CloudHubVideoRenderModeHidden mirrorMode:CloudHubVideoMirrorModeDisabled];
}

- (CHBeautySetView *)beautyView
{
    if (!_beautyView)
    {
        _beautyView = [[CHBeautySetView alloc]initWithFrame:CGRectMake(0, self.view.ch_height, self.view.ch_width, 0) itemGap:CellGap];
        
        [self.view addSubview:_beautyView];
    }
    return _beautyView;
}


@end
