//
//  CHLiveViewController.m
//  CloudHub Active
//
//  Created by 马迪 on 2021/4/21.
//

#import "CHCreatLiveVC.h"

#import "CHCreatLiveFrontView.h"

#import "CHVideoSetView.h"
#import "CHResolutionView.h"
#import "CHLiveRoomVC.h"




@interface CHCreatLiveVC ()

@property (nonatomic, weak) CHCreatLiveFrontView *liveFrontView;

@property (nonatomic, weak) UIButton *startButton;

@property (nonatomic, weak) CHVideoSetView *videoSetView;

/// 分辨率
@property (nonatomic, weak) CHResolutionView *resolutionView;

/// 帧率
@property (nonatomic, weak) CHResolutionView *rateView;

@end

@implementation CHCreatLiveVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
            
    // 上层试图的View
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
            
//            if (![self.liveFrontView.channelId ch_isNotEmpty])
//            {
//                [CHProgressHUD ch_showHUDAddedTo:self.view animated:YES withText:CH_Localized(@"Live_InputRoomNumPrompt") delay:2.0];
//
//                return;
//            }
            
            CHLiveRoomVC *liveRoomVC = [[CHLiveRoomVC alloc]init];
            liveRoomVC.channelId = self.liveFrontView.channelId;
            liveRoomVC.nickName = self.nickName;
            liveRoomVC.roleType = CHUserType_Anchor;
            [self.navigationController pushViewController:liveRoomVC animated:YES];
        }
            break;
        case 5:
        {// 设置
            if (!self.videoSetView)
            {
                CHVideoSetView *videoSetView = [[CHVideoSetView alloc]initWithFrame:CGRectMake(0, self.view.ch_height, self.view.ch_width, 0) itemGap:CellGap];
                [self.view addSubview:videoSetView];
                self.videoSetView = videoSetView;
                
                CHWeakSelf
                videoSetView.setArrowButtonClick = ^(UIButton * _Nonnull button) {
                    [weakSelf setViewArrowButtonClick:button];
                };
            }
            
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


- (void)setViewArrowButtonClick:(UIButton *)button
{
    if (button.tag == 100)
    {
        if (!self.resolutionView)
        {
            NSArray * dataArray = @[@"240 × 240",@"360 × 360",@"480 × 848",@"720 × 1080",@"1080 × 1920"];
            
            CHResolutionView *resolutionView = [[CHResolutionView alloc]initWithFrame:CGRectMake(0, self.view.ch_height, self.view.ch_width, 0) itemGap:CellGap type:CHVideoSetViewType_Resolution withData:dataArray];
            [self.view addSubview:resolutionView];
            self.resolutionView = resolutionView;
            
            CHWeakSelf
            __weak CHResolutionView *weakResolutionView = self.resolutionView;
            resolutionView.resolutionViewButtonClick = ^(NSString * _Nullable value) {
                if ([value ch_isNotEmpty])
                {
                    weakSelf.videoSetView.resolutionString = value;
                }
                else
                {
                    weakSelf.videoSetView.ch_originY = weakSelf.view.ch_height - weakSelf.videoSetView.ch_height;
                    weakResolutionView.ch_originY = weakSelf.view.ch_height;
                }
            };
        }
                
        [self.resolutionView ch_bringToFront];
        
        [UIView animateWithDuration:0.25 animations:^{
            self.resolutionView.ch_originY = self.view.ch_height - self.resolutionView.ch_height;
       }];
        
    }
    else if (button.tag == 101)
    {
        if (!self.rateView)
        {
            NSArray * dataArray = @[@"240 × 240",@"360 × 360",@"480 × 848"];
            CHResolutionView *rateView = [[CHResolutionView alloc]initWithFrame:CGRectMake(0, self.view.ch_height, self.view.ch_width, 0) itemGap:CellGap type:CHVideoSetViewType_Rate withData:dataArray];
            [self.view addSubview:rateView];
            self.rateView = rateView;
            
            CHWeakSelf
            __weak CHResolutionView *weakRateView = self.rateView;
            rateView.resolutionViewButtonClick = ^(NSString * _Nullable value) {
                if ([value ch_isNotEmpty])
                {
                    weakSelf.videoSetView.rateString = value;
                }
                else
                {
                    weakSelf.videoSetView.ch_originY = weakSelf.view.ch_height - weakSelf.videoSetView.ch_height;
                    weakRateView.ch_originY = weakSelf.view.ch_height;
                }
            };
        }
        
        [self.rateView ch_bringToFront];
        
         [UIView animateWithDuration:0.25 animations:^{
             self.rateView.ch_originY = self.view.ch_height - self.rateView.ch_height;
        }];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.liveFrontView.liveNumField resignFirstResponder];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.beautyView.ch_originY = self.view.ch_height;
        self.videoSetView.ch_originY = self.view.ch_height;
        self.resolutionView.ch_originY = self.view.ch_height;
        self.rateView.ch_originY = self.view.ch_height;
    }];
}




@end
