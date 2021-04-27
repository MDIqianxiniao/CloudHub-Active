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
<
    UITextViewDelegate
>

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
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
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
//    userListButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentRight;
    userListButton.hidden = self.roleType;
    self.userListButton = userListButton;
    [self addSubview:userListButton];
    userListButton.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0 );
    
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
    
    //输入框
    UITextView *inputView = [[UITextView alloc]initWithFrame:CGRectMake(leftMargin, backButton.ch_originY, self.ch_width - leftMargin - 4 * width - leftMargin * 0.5, ButtonWidth)];
    inputView.backgroundColor = [CHBlackColor ch_changeAlpha:0.5];
    inputView.returnKeyType = UIReturnKeySend;
    inputView.font = CHFont12;
    inputView.textColor = CHWhiteColor;
    inputView.delegate = self;
    inputView.layer.cornerRadius = ButtonWidth * 0.5;
    //当textview的字符串为0时发送（rerurn）键无效
    self.inputView.enablesReturnKeyAutomatically = YES;
    [self addSubview:inputView];
    self.inputView = inputView;
    
    UILabel *placeholderLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, inputView.ch_width - 20, ButtonWidth)];
    placeholderLable.text = CH_Localized(@"Live_ChatPlaceholder");
    placeholderLable.font = CHFont12;
    placeholderLable.textColor = CHColor_BBBBBB;
    self.placeholderLable = placeholderLable;
    [inputView addSubview:placeholderLable];
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

- (void)setSCMessageList:(NSMutableArray<CHChatMessageModel *> *)SCMessageList
{
    _SCMessageList = SCMessageList;
    self.chatView.SCMessageList = SCMessageList;
}

-(void)textViewDidChange:(UITextView *)textView
{
    self.placeholderLable.hidden = [textView.text ch_isNotEmpty];
    
    UITextRange *selectedRange = [textView markedTextRange];
    if (!selectedRange)
    {//拼音全部输入完成
        if (textView.text.length > 80)
        {
            textView.text = [textView.text substringToIndex:80];
            [CHProgressHUD ch_showHUDAddedTo:self animated:YES withText:CH_Localized(@"Live_ChatTextNumber") delay:1.5];
        }
    }
}

#pragma mark - 发送消息（键盘的return按钮点击事件）
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"] && [text ch_isNotEmpty])
    {
        if (_sendMessage)
        {
            _sendMessage(text);
        }
        return NO;
    }
    return YES;
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

- (void)keyboardWillShow:(NSNotification *)notification
{
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardF = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView animateWithDuration:duration animations:^{
        self.chatView.ch_originY = ChatVieY - keyboardF.size.height + (self.ch_height - self.backButton.ch_bottom);
        self.inputView.ch_originY = InputViewY - keyboardF.size.height + (self.ch_height - self.backButton.ch_bottom);
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        self.chatView.ch_originY = ChatVieY;
        self.inputView.ch_originY = InputViewY;
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
