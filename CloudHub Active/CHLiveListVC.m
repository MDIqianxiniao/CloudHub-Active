//
//  ViewController.m
//  CloudHub Active
//
//  Created by 马迪 on 2021/4/19.
//

#import "CHLiveListVC.h"
#import "CHLiveListTableView.h"
#import "CHMinePopupView.h"
#import "CHCreatLiveVC.h"
#import "CHLiveRoomVC.h"
#import "AFNetworking.h"
#import "CHLiveChannelModel.h"

@interface CHLiveListVC ()

@property (nonatomic, strong) NSMutableArray *channelListArray;

@property (nonatomic, strong) UIImageView *centreImageView;

@property (nonatomic, strong) UILabel *noLiveLable;

@property (nonatomic, strong) CHLiveListTableView *liveListTableView;

@property (nonatomic, strong) CHMinePopupView *minPopupView;

@property (nonatomic, weak) UIRefreshControl *refresh;

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
    
    [self getChannelListArray];
}

- (void)viewDidLoad {
    [super viewDidLoad];
        
    [[NSUserDefaults standardUserDefaults] setValue:[UIDevice currentDevice].name forKey:CHCacheAnchorName];
    
    self.channelListArray = [NSMutableArray array];
    
    [self setupViews];

    UIRefreshControl *refresh = [[UIRefreshControl alloc]init];
    [refresh addTarget:self action:@selector(getChannelListArray) forControlEvents:UIControlEventValueChanged];
    [self.liveListTableView addSubview:refresh];
    [refresh beginRefreshing];
    self.refresh = refresh;
}

- (void)getChannelListArray
{
    CHWeakSelf
    [CHNetworkRequest getWithURLString:sCHGetChannelList params:nil progress:nil success:^(NSDictionary * _Nonnull dictionary) {
        
        NSArray *array = dictionary[@"data"];
        [weakSelf.channelListArray removeAllObjects];
        for (NSDictionary *dict in array)
        {
            CHLiveChannelModel *model = [[CHLiveChannelModel alloc]init];
            model.channelId = dict[@"channel"];
            model.memberNum = [dict[@"online_num"] integerValue];
            
            [weakSelf.channelListArray addObject:model];
        }
        weakSelf.liveListTableView.dataArray = weakSelf.channelListArray;
        
        [weakSelf.liveListTableView reloadData];
        weakSelf.centreImageView.hidden = weakSelf.noLiveLable.hidden = (weakSelf.channelListArray.count > 0);
        
        [weakSelf.refresh endRefreshing];
    } failure:^(NSError * _Nonnull error) {
        
        weakSelf.liveListTableView.dataArray = nil;
        [weakSelf.liveListTableView reloadData];
        weakSelf.centreImageView.hidden = weakSelf.noLiveLable.hidden = NO;
        
        [weakSelf.refresh endRefreshing];
    }];
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
    noLiveLable.text = CH_Localized(@"List_NoLive");
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
    
    CGFloat leftMargin = 25.0f;
    
    CHLiveListTableView *liveListTableView = [[CHLiveListTableView alloc]initWithFrame:CGRectMake(leftMargin, StatusBarH + 30, bgImageView.ch_width - 2*leftMargin, creatLiveButton.ch_originY - (StatusBarH + 30) - 10)];
    self.liveListTableView = liveListTableView;
    [bgImageView addSubview:liveListTableView];
    
    CHWeakSelf
    liveListTableView.liveListCellClick = ^(NSIndexPath * _Nonnull index) {
        
        CHLiveChannelModel * model = weakSelf.channelListArray[index.row];
        CHLiveRoomVC *vc = [[CHLiveRoomVC alloc]init];
        vc.liveModel = model;
        vc.roleType = CHUserType_Audience;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    
}

- (void)clickToCreatLive
{
    CHCreatLiveVC *liveVC = [[CHCreatLiveVC alloc]init];
    [self.navigationController pushViewController:liveVC animated:YES];
}

- (void)clickToSetName
{
    self.minPopupView.hidden = !self.minPopupView.hidden;
}

- (CHMinePopupView *)minPopupView
{
    if (!_minPopupView)
    {
        _minPopupView = [[CHMinePopupView alloc]initWithFrame:CGRectMake(0, 0, 240, 162)];
        _minPopupView.layer.cornerRadius = 10;
        _minPopupView.ch_centerX = self.view.ch_width *0.5;
        _minPopupView.ch_centerY = self.view.ch_height *0.5 - 100;
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
