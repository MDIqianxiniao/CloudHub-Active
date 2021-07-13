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
        case CHCreateRoomFrontButton_Back:
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case CHCreateRoomFrontButton_Camera:
        {
            [RtcEngine switchCamera:button.selected];
            button.selected = !button.selected;
            
            self.liveModel.isMirror = button.selected;
        }
            break;
        case CHCreateRoomFrontButton_Beauty:
        {// Beauty Settings
            [UIView animateWithDuration:0.25 animations:^{
                self.beautyView.ch_originY = self.view.ch_height - self.beautyView.ch_height;
           }];
            
            [self.beautyView ch_bringToFront];
        }
            break;
        case CHCreateRoomFrontButton_Start:
        {// Begin to live
            if (![self.liveFrontView.channelId ch_isNotEmpty])
            {
                [CHProgressHUD ch_showHUDAddedTo:self.view animated:YES withText:CH_Localized(@"Live_InputRoomNumPrompt") delay:CHProgressDelay];
                return;
            }
            
            [CHProgressHUD ch_showHUDAddedTo:self.view animated:YES];
            CHWeakSelf
            [CHNetworkRequest getWithURLString:sCHGetConfig params:@{@"channel":self.liveFrontView.channelId,@"user_role":@(CHUserType_Anchor)} progress:nil success:^(NSDictionary * _Nonnull dictionary) {
                
                [weakSelf.rtcEngine stopPlayingLocalVideo];
                
                weakSelf.liveModel.channelId = weakSelf.liveFrontView.channelId;
                
                NSDictionary *dict = dictionary[@"data"];
                CHLiveRoomVC *liveRoomVC = [[CHLiveRoomVC alloc]init];
                liveRoomVC.liveModel = weakSelf.liveModel;
                liveRoomVC.roleType = CHUserType_Anchor;
                liveRoomVC.chToken = dict[@"token"];
                
                liveRoomVC.videoSetView.resolutionString = weakSelf.videoSetView.resolutionString;
                liveRoomVC.videoSetView.rateString = weakSelf.videoSetView.rateString;
                
                [weakSelf.navigationController pushViewController:liveRoomVC animated:YES];
                
                [CHProgressHUD ch_hideHUDForView:weakSelf.view animated:YES];
                
            } failure:^(NSError * _Nonnull error) {
                [CHProgressHUD ch_hideHUDForView:weakSelf.view animated:YES];
                
                NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
                if (response.statusCode == 400)
                {
                    [CHProgressHUD ch_showHUDAddedTo:weakSelf.view animated:YES withText:CH_Localized(@"Live_Channel_use") delay:CHProgressDelay];
                }
            }];
        }
            break;
        case CHCreateRoomFrontButton_Setting:
        {// Settings
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
    UITouch *touch = nil;
    
    for (UITouch *cc in touches)
    {
        touch = cc;
        break;
    }
    CGPoint point = [touch locationInView:self.view];
    
    [self.liveFrontView.liveNumField resignFirstResponder];
        
    if (point.y < self.resolutionView.ch_originY && self.resolutionView && self.resolutionView.ch_originY < self.view.ch_height)
    {
        [UIView animateWithDuration:0.25 animations:^{
            self.resolutionView.ch_originY = self.view.ch_height;
            self.videoSetView.ch_originY = self.view.ch_height - self.videoSetView.ch_height;
        }];
        return;
    }
    
    if (point.y < self.rateView.ch_originY && self.rateView && self.rateView.ch_originY < self.view.ch_height)
    {
        [UIView animateWithDuration:0.25 animations:^{
            self.rateView.ch_originY = self.view.ch_height;
            self.videoSetView.ch_originY = self.view.ch_height - self.videoSetView.ch_height;
        }];
        return;
    }
      
    if (point.y < self.videoSetView.ch_originY && self.videoSetView && self.videoSetView.ch_originY < self.view.ch_height)
    {
        [UIView animateWithDuration:0.25 animations:^{
            self.videoSetView.ch_originY = self.view.ch_height;
        }];
        return;
    }
    
    if (point.y < self.beautyView.ch_originY && self.beautyView && self.beautyView.ch_originY < self.view.ch_height)
    {
        [UIView animateWithDuration:0.25 animations:^{
            self.beautyView.ch_originY = self.view.ch_height;
        }];
        return;
    }
}

@end
