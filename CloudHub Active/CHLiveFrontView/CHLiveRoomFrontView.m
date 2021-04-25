//
//  CHLiveRoomFrontView.m
//  CloudHub Active
//
//  Created by 马迪 on 2021/4/25.
//

#import "CHLiveRoomFrontView.h"


#define leftMargin  20
#define ButtonWidth  32


@interface CHLiveRoomFrontView ()

@property (nonatomic, weak) UILabel *nameLable;

@property (nonatomic, weak) UIButton *userListButton;

@property (nonatomic, assign) CHUserRoleType roleType;


@end


@implementation CHLiveRoomFrontView

- (instancetype)initWithFrame:(CGRect)frame WithUserType:(CHUserRoleType)roleType
{
    if (self = [super initWithFrame:frame])
    {
        self.roleType = roleType;
        
        [self setTopbarViews];
        
        [self setBottomViews];
        
    }
    return self;
}

// 顶部试图
- (void)setTopbarViews
{
    CGFloat buttonY = StatusBarH + 15;
        
    UILabel *nameLable = [[UILabel alloc]initWithFrame:CGRectMake(leftMargin, buttonY, 100, ButtonWidth)];
    nameLable.backgroundColor = CHBlackColor;
    nameLable.font = CHFont12;
    nameLable.textColor = CHWhiteColor;
    nameLable.textAlignment = NSTextAlignmentCenter;
    self.nameLable = nameLable;
    [self addSubview:nameLable];
    self.nameLable.layer.cornerRadius = ButtonWidth * 0.5f;
    self.nameLable.layer.masksToBounds = YES;
    
    UIButton *userListButton = [[UIButton alloc]initWithFrame:CGRectMake(self.ch_width - leftMargin - ButtonWidth, buttonY, 10, ButtonWidth)];
    userListButton.tag = CHLiveRoomFrontButton_userList;
    [userListButton setImage:[UIImage imageNamed:@"live_userList"] forState:UIControlStateNormal];
    [userListButton setBackgroundColor:CHBlackColor];
    [userListButton addTarget:self action:@selector(buttonsClick:) forControlEvents:UIControlEventTouchUpInside];
    userListButton.layer.cornerRadius = ButtonWidth * 0.5f;
    userListButton.hidden = self.roleType;
    self.userListButton = userListButton;
    [self addSubview:userListButton];
    userListButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentRight;
    
    [userListButton setTitle:@"21" forState:UIControlStateNormal];
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
    [self addSubview:backButton];
    
    UIButton *chatButton = [[UIButton alloc]initWithFrame:CGRectMake(backButton.ch_left - width, backButton.ch_originY, ButtonWidth, ButtonWidth)];
    chatButton.tag = CHLiveRoomFrontButton_Chat;
    chatButton.ch_bottom = self.ch_height - 45;
    [chatButton setImage:[UIImage imageNamed:@"live_chat"] forState:UIControlStateNormal];
    [chatButton setBackgroundColor:CHBlackColor];
    [chatButton addTarget:self action:@selector(buttonsClick:) forControlEvents:UIControlEventTouchUpInside];
    chatButton.layer.cornerRadius = ButtonWidth * 0.5;
    [self addSubview:chatButton];
    
    UIButton *musicButton = [[UIButton alloc]initWithFrame:CGRectMake(chatButton.ch_left - width, backButton.ch_originY, ButtonWidth, ButtonWidth)];
    musicButton.tag = CHLiveRoomFrontButton_Music;
    musicButton.ch_bottom = self.ch_height - 45;
    [musicButton setImage:[UIImage imageNamed:@"live_bgMusic_set"] forState:UIControlStateNormal];
    [musicButton addTarget:self action:@selector(buttonsClick:) forControlEvents:UIControlEventTouchUpInside];
    musicButton.layer.cornerRadius = ButtonWidth * 0.5;
    [self addSubview:musicButton];
    
    UIButton *beautySetButton = [[UIButton alloc]initWithFrame:CGRectMake(musicButton.ch_left - width, backButton.ch_originY, ButtonWidth, ButtonWidth)];
    beautySetButton.tag = CHLiveRoomFrontButton_Beauty;
    beautySetButton.ch_bottom = self.ch_height - 45;
    [beautySetButton setImage:[UIImage imageNamed:@"live_beauty_set"] forState:UIControlStateNormal];
    [beautySetButton addTarget:self action:@selector(buttonsClick:) forControlEvents:UIControlEventTouchUpInside];
    beautySetButton.layer.cornerRadius = ButtonWidth * 0.5;
    [self addSubview:beautySetButton];
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

- (void)setUserList:(NSMutableArray *)userList
{
    _userList = userList;
    [self.userListButton setTitle:[NSString stringWithFormat:@"%ld",userList.count] forState:UIControlStateNormal];
}

@end
