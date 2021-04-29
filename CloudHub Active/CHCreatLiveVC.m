//
//  CHLiveViewController.m
//  CloudHub Active
//
//  Created by 马迪 on 2021/4/21.
//

#import "CHCreatLiveVC.h"
#import "CHCreatLiveFrontView.h"


#import "CHLiveRoomVC.h"

@interface CHCreatLiveVC ()

@property (nonatomic, weak) CHCreatLiveFrontView *liveFrontView;

@property (nonatomic, weak) UIButton *startButton;

@end

@implementation CHCreatLiveVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
        
    [self.rtcEngine enableLocalAudio:YES];
    [self.rtcEngine enableLocalVideo:YES];
    
    [self.rtcEngine startPlayingLocalVideo:self.largeVideoView.contentView renderMode:CloudHubVideoRenderModeHidden mirrorMode:CloudHubVideoMirrorModeEnabled];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self setupFrontViewUI];
}

- (void)setupFrontViewUI
{
    CHCreatLiveFrontView *liveFrontView = [[CHCreatLiveFrontView alloc]initWithFrame:self.view.bounds];
    self.liveFrontView = liveFrontView;
    [self.view addSubview:liveFrontView];
    
    CHWeakSelf
    liveFrontView.creatLiveViewButtonsClick = ^(UIButton * _Nonnull sender) {
        [weakSelf creatLiveViewButtonsSelect:sender];
    };
}

- (void)creatLiveViewButtonsSelect:(UIButton *)button
{
    switch (button.tag)
    {
        case 1:
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case 2:
        {
            [RtcEngine switchCamera:button.selected];
            button.selected = !button.selected;
            
            self.liveModel.isMirror = button.selected;
        }
            break;
        case 3:
        {// 美颜设置
            
            [UIView animateWithDuration:0.25 animations:^{
                self.beautyView.ch_originY = self.view.ch_height - self.beautyView.ch_height;
           }];
            
            [self.beautyView ch_bringToFront];
        }
            break;
        case 4:
        {// 开始直播
            
            if (![self.liveFrontView.channelId ch_isNotEmpty])
            {
                [CHProgressHUD ch_showHUDAddedTo:self.view animated:YES withText:CH_Localized(@"Live_InputRoomNumPrompt") delay:2.0];
                return;
            }
            
            [self.rtcEngine stopPlayingLocalVideo];
            
            self.liveModel.channelId = self.liveFrontView.channelId;
            
            CHLiveRoomVC *liveRoomVC = [[CHLiveRoomVC alloc]init];
            liveRoomVC.liveModel = self.liveModel;
            liveRoomVC.roleType = CHUserType_Anchor;
            [self.navigationController pushViewController:liveRoomVC animated:YES];
        }
            break;
        case 5:
        {// 设置

            [UIView animateWithDuration:0.25 animations:^{
                self.videoSetView.ch_originY = self.view.ch_height - self.videoSetView.ch_height;
           }];
            
            [self.videoSetView ch_bringToFront];
        }
            break;
            
        default:
            break;
    }
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.liveFrontView.liveNumField resignFirstResponder];
    
    if (self.resolutionView && self.resolutionView.ch_originY < self.view.ch_height)
    {
        [UIView animateWithDuration:0.25 animations:^{
            self.resolutionView.ch_originY = self.view.ch_height;
            self.videoSetView.ch_originY = self.view.ch_height - self.videoSetView.ch_height;
        }];
        return;
    }
    
    if (self.rateView && self.rateView.ch_originY < self.view.ch_height)
    {
        [UIView animateWithDuration:0.25 animations:^{
            self.rateView.ch_originY = self.view.ch_height;
            self.videoSetView.ch_originY = self.view.ch_height - self.videoSetView.ch_height;
        }];
        return;
    }
        
    [UIView animateWithDuration:0.25 animations:^{
        self.beautyView.ch_originY = self.view.ch_height;
        self.videoSetView.ch_originY = self.view.ch_height;
    }];
}




@end
