//
//  ViewController.m
//  CloudHub Active
//
//  Created by 马迪 on 2021/4/19.
//

#import "CHLiveListVC.h"
#import "CHLiveListTableView.h"
#import "CHMinePopupView.h"
#import "CHLiveViewController.h"

@interface CHLiveListVC ()

@property (nonatomic, strong) UIImageView *centreImageView;

@property (nonatomic, strong) UILabel *noLiveLable;

@property (nonatomic, strong) CHMinePopupView *minPopupView;

@end

@implementation CHLiveListVC


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
}

- (void)setupViews
{
    UIImageView * bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CHUI_SCREEN_HEIGHT_ROTATE, CHUI_SCREEN_WIDTH_ROTATE)];
    bgImageView.image = [UIImage imageNamed:@"list_bgImage"];
    [self.view addSubview:bgImageView];
    bgImageView.userInteractionEnabled = YES;
        
    UIImageView *centreImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 68, 68)];
    centreImageView.image = [UIImage imageNamed:@"list_centreImage"];
    [bgImageView addSubview:centreImageView];
    centreImageView.ch_centerX = bgImageView.ch_width*0.5;
    centreImageView.ch_centerY = bgImageView.ch_height*0.5;
    self.centreImageView = centreImageView;
    
    UILabel *noLiveLable = [[UILabel alloc]initWithFrame:CGRectMake(0, centreImageView.ch_bottom + 10, bgImageView.ch_width, 30)];
    noLiveLable.text = CH_Localized(@"list_noLive");
    noLiveLable.font = CHFont12;
    noLiveLable.textColor = CHWhiteColor;
    noLiveLable.textAlignment = NSTextAlignmentCenter;
    noLiveLable.numberOfLines = 0;
    [bgImageView addSubview:noLiveLable];
    self.noLiveLable = noLiveLable;
    
    UIButton *creatLiveButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 58, 58)];
    [creatLiveButton setImage:[UIImage imageNamed:@"list_creatButton"] forState:UIControlStateNormal];
    [creatLiveButton addTarget:self action:@selector(clickToCreatLive) forControlEvents:UIControlEventTouchUpInside];
    [bgImageView addSubview:creatLiveButton];
    creatLiveButton.ch_centerX = bgImageView.ch_width * 0.5;
    creatLiveButton.ch_bottom = bgImageView.ch_height - 20;
    
    UIButton *mineButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 32, 32)];
    [mineButton setImage:[UIImage imageNamed:@"list_mineButton"] forState:UIControlStateNormal];
    [mineButton addTarget:self action:@selector(clickToSetName) forControlEvents:UIControlEventTouchUpInside];
    [bgImageView addSubview:mineButton];
    mineButton.ch_right = bgImageView.ch_width - 20;
    mineButton.ch_bottom = bgImageView.ch_height - 25;
    
    NSMutableArray *mutArray = [NSMutableArray array];
    for (int i = 0; i<8; i++)
    {
        CHLiveModel *model = [[CHLiveModel alloc]init];
        model.liveName = [NSString stringWithFormat:@"%@：%d",CH_Localized(@"list_liveName"), i];
        model.memberNum = i+100;
        
        [mutArray addObject:model];
    }
    
    CGFloat leftMargin = 25.0f;
    
    CHLiveListTableView *liveListTableView = [[CHLiveListTableView alloc]initWithFrame:CGRectMake(leftMargin, StatusBarH + 30, bgImageView.ch_width - 2*leftMargin, creatLiveButton.ch_originY - (StatusBarH + 30) - 10)];
    liveListTableView.dataArray = mutArray;
    [bgImageView addSubview:liveListTableView];
    
    self.centreImageView.hidden = self.noLiveLable.hidden = (mutArray.count > 0);
}

/// 创建新直播按钮点击
- (void)clickToCreatLive
{
    CHLiveViewController *liveVC = [[CHLiveViewController alloc]init];
    [self.navigationController pushViewController:liveVC animated:YES];
}

/// 我的点击
- (void)clickToSetName
{
    self.minPopupView.hidden = !self.minPopupView.hidden;
}

- (CHMinePopupView *)minPopupView
{
    if (!_minPopupView)
    {
        _minPopupView = [[CHMinePopupView alloc]initWithFrame:CGRectMake(0, 0, 240, 162)];
        _minPopupView.backgroundColor = CHWhiteColor;
        _minPopupView.layer.cornerRadius = 10;
        _minPopupView.ch_centerX = self.view.ch_width *0.5;
        _minPopupView.ch_centerY = self.view.ch_height *0.5;
        _minPopupView.hidden = YES;
        [self.view addSubview:_minPopupView];
    }
    return _minPopupView;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

@end
