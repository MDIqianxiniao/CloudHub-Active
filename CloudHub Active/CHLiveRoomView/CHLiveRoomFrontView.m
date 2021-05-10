//
//  CHLiveRoomFrontView.m
//  CloudHub Active
//
//  Created by 马迪 on 2021/4/25.
//

#import "CHLiveRoomFrontView.h"
#import "SCChatView.h"

#define leftMargin  20
#define ButtonWidth  32
#define ChatViewWidth (self.ch_width - 2 * leftMargin - CHVideoViewW - 5)
#define ChatVieHeight 200

#define ChatVieY (self.backButton.ch_originY - 10 - ChatVieHeight)
#define InputViewY self.backButton.ch_originY

@interface CHLiveRoomFrontView ()


@property (nonatomic, assign) CHUserRoleType roleType;

@property (nonatomic, weak) UILabel *nameLable;

@property (nonatomic, weak) UIButton *userListButton;

@property (nonatomic, weak) UIButton *backButton;

@property (nonatomic, weak) UIButton *beautySetButton;

@property (nonatomic, weak) UILabel *placeholderLable;

@property (nonatomic, weak) SCChatView * chatView;

@end


@implementation CHLiveRoomFrontView

- (instancetype)initWithFrame:(CGRect)frame WithUserType:(CHUserRoleType)roleType
{
    if (self = [super initWithFrame:frame])
    {
        self.roleType = roleType;
        
        [self setTopbarViews];
        
        [self setBottomViews];
        
        [self addChatView];
    }
    return self;
}

// 顶部试图
- (void)setTopbarViews
{
    CGFloat buttonY = StatusBarH + 15;
        
    UILabel *nameLable = [[UILabel alloc]initWithFrame:CGRectMake(leftMargin, buttonY, 100, ButtonWidth)];
    nameLable.text = @"主播的昵称";
    nameLable.backgroundColor = CHBlackColor;
    nameLable.font = CHFont12;
    nameLable.textColor = CHWhiteColor;
    nameLable.textAlignment = NSTextAlignmentCenter;
    self.nameLable = nameLable;
    [self addSubview:nameLable];
    self.nameLable.layer.cornerRadius = ButtonWidth * 0.5f;
    self.nameLable.layer.masksToBounds = YES;
    
    CGFloat buttonW = 70;
    
    UIButton *userListButton = [[UIButton alloc]initWithFrame:CGRectMake(self.ch_width - leftMargin - buttonW, buttonY, buttonW, ButtonWidth)];
    userListButton.tag = CHLiveRoomFrontButton_userList;
    [userListButton setImage:[UIImage imageNamed:@"live_userList"] forState:UIControlStateNormal];
    [userListButton setBackgroundColor:CHBlackColor];
    userListButton.titleLabel.font = CHFont12;
    [userListButton addTarget:self action:@selector(buttonsClick:) forControlEvents:UIControlEventTouchUpInside];
    userListButton.layer.cornerRadius = ButtonWidth * 0.5f;
    userListButton.userInteractionEnabled = !self.roleType;
    self.userListButton = userListButton;
    [self addSubview:userListButton];
    userListButton.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0 );
}

// 底部试图
- (void)setBottomViews
{
    CGFloat margin = 15.0f;
    
    CGFloat width = margin + ButtonWidth;
    
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(self.ch_width - leftMargin - ButtonWidth, self.ch_height - 45 - ButtonWidth, ButtonWidth, ButtonWidth)];
    backButton.tag = CHLiveRoomFrontButton_Back;
    [backButton setImage:[UIImage imageNamed:@"live_backButton"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(buttonsClick:) forControlEvents:UIControlEventTouchUpInside];
    backButton.layer.cornerRadius = ButtonWidth * 0.5;
    self.backButton = backButton;
    [self addSubview:backButton];
    
    UIButton *moreToolsButton = [[UIButton alloc]initWithFrame:CGRectMake(backButton.ch_left - width, backButton.ch_originY, ButtonWidth, ButtonWidth)];
    moreToolsButton.tag = CHLiveRoomFrontButton_Tools;
    moreToolsButton.ch_bottom = self.ch_height - 45;
    [moreToolsButton setImage:[UIImage imageNamed:@"live_moreTools"] forState:UIControlStateNormal];
    [moreToolsButton setBackgroundColor:CHBlackColor];
    [moreToolsButton addTarget:self action:@selector(buttonsClick:) forControlEvents:UIControlEventTouchUpInside];
    moreToolsButton.layer.cornerRadius = ButtonWidth * 0.5;
    [self addSubview:moreToolsButton];
    
    UIButton *musicButton = [[UIButton alloc]initWithFrame:CGRectMake(moreToolsButton.ch_left - width, backButton.ch_originY, ButtonWidth, ButtonWidth)];
    musicButton.tag = CHLiveRoomFrontButton_Music;
    musicButton.ch_bottom = self.ch_height - 45;
    [musicButton setImage:[UIImage imageNamed:@"live_bgMusic_set"] forState:UIControlStateNormal];
    [musicButton addTarget:self action:@selector(buttonsClick:) forControlEvents:UIControlEventTouchUpInside];
    musicButton.layer.cornerRadius = ButtonWidth * 0.5;
    [self addSubview:musicButton];
    
    UIButton *beautySetButton = [[UIButton alloc]init];
    beautySetButton.tag = CHLiveRoomFrontButton_Beauty;
    beautySetButton.ch_bottom = self.ch_height - 45;
    [beautySetButton setImage:[UIImage imageNamed:@"live_beauty_set"] forState:UIControlStateNormal];
    [beautySetButton addTarget:self action:@selector(buttonsClick:) forControlEvents:UIControlEventTouchUpInside];
    beautySetButton.layer.cornerRadius = ButtonWidth * 0.5;
    self.beautySetButton = beautySetButton;
    [self addSubview:beautySetButton];
    
    CGFloat beautySetButtonX = musicButton.ch_left - width;
    if (self.roleType == CHUserType_Audience)
    {
        beautySetButtonX = moreToolsButton.ch_left - width;
        beautySetButton.frame = CGRectMake(beautySetButtonX, backButton.ch_originY, ButtonWidth, ButtonWidth);
        
        musicButton.hidden = YES;
        beautySetButton.hidden = YES;
    }

    UIButton *inputButton = [[UIButton alloc]initWithFrame:CGRectMake(leftMargin, backButton.ch_originY, self.ch_width - leftMargin - 4 * width - leftMargin * 0.5, ButtonWidth)];
    inputButton.tag = CHLiveRoomFrontButton_Chat;
    [inputButton setBackgroundColor:[CHBlackColor ch_changeAlpha:0.5]];
    [inputButton setTitle:CH_Localized(@"Live_ChatPlaceholder") forState:UIControlStateNormal];
    [inputButton setTitleColor:CHColor_BBBBBB forState:UIControlStateNormal];
    inputButton.titleLabel.font = CHFont12;
    [inputButton addTarget:self action:@selector(buttonsClick:) forControlEvents:UIControlEventTouchUpInside];
    inputButton.layer.cornerRadius = ButtonWidth * 0.5;
    inputButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    inputButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [self addSubview:inputButton];
}

- (void)addChatView
{
    SCChatView * chatView = [[SCChatView alloc]initWithFrame:CGRectMake(leftMargin, ChatVieY, ChatViewWidth, ChatVieHeight)];
    self.chatView = chatView;
    [self addSubview:chatView];
}

- (void)setIsUpStage:(BOOL)isUpStage
{
    _isUpStage = isUpStage;
    self.beautySetButton.hidden = !isUpStage;
}

- (void)setMessageList:(NSMutableArray<CHChatMessageModel *> *)messageList
{
    _messageList = messageList;
    
    if ([messageList ch_isNotEmpty])
    {
        self.chatView.hidden = NO;
        self.chatView.messageList = messageList;
    }
    else
    {
        self.chatView.hidden = YES;
    }
}

- (void)buttonsClick:(UIButton *)button
{
    if (_liveRoomFrontViewButtonsClick)
    {
        _liveRoomFrontViewButtonsClick(button);
    }
}

- (void)setNickName:(NSString *)nickName
{
    _nickName = nickName;
    
    self.nameLable.text = nickName;
    
    CGSize nameWidth = [nickName ch_sizeToFitWidth:self.userListButton.ch_left - leftMargin withFont:CHFont12];
    self.nameLable.ch_width = nameWidth.width + 25;
}

- (void)setUserNum:(NSInteger)userNum
{
    _userNum = userNum;
    [self.userListButton setTitle:[NSString stringWithFormat:@"%ld",userNum] forState:UIControlStateNormal];
}




@end
