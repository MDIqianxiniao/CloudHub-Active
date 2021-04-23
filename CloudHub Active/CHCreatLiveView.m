//
//  CHCreatLiveView.m
//  CloudHub Active
//
//  Created by 马迪 on 2021/4/22.
//

#import "CHCreatLiveView.h"

#define ButtonWidth  32


@interface CHCreatLiveView ()

@property (nonatomic, weak) UITextField *liveNumField;

@property (nonatomic, weak) UIButton *startButton;

/// 温馨提示
@property (nonatomic, weak) UIView *promptView;

@end

@implementation CHCreatLiveView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setTopbarViews];
        
        [self setBottomViews];
        
        [self addPrompt];
    }
    return self;
}

// 顶部试图
- (void)setTopbarViews
{
    CGFloat leftMargin = 20;
    
    CGFloat buttonY = StatusBarH + 15;
    
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(leftMargin, buttonY, ButtonWidth, ButtonWidth)];
    backButton.tag = 1;
    [backButton setImage:[UIImage imageNamed:@"live_backButton"] forState:UIControlStateNormal];
    [backButton setBackgroundColor:CHBlackColor];
    [backButton addTarget:self action:@selector(liveButtonsClick:) forControlEvents:UIControlEventTouchUpInside];
    backButton.layer.cornerRadius = ButtonWidth * 0.5;
    [self addSubview:backButton];
    
    UIButton *cameraButton = [[UIButton alloc]initWithFrame:CGRectMake(self.ch_width - leftMargin - ButtonWidth, buttonY, ButtonWidth, ButtonWidth)];
    cameraButton.tag = 2;
    [cameraButton setImage:[UIImage imageNamed:@"live_cameraChange"] forState:UIControlStateNormal];
    [cameraButton setBackgroundColor:CHBlackColor];
    [cameraButton addTarget:self action:@selector(liveButtonsClick:) forControlEvents:UIControlEventTouchUpInside];
    cameraButton.layer.cornerRadius = ButtonWidth * 0.5;
    [self addSubview:cameraButton];
    
    UIView *fieldBgView = [[UIView alloc]initWithFrame:CGRectMake(backButton.ch_right + 25, buttonY, cameraButton.ch_left - (backButton.ch_right + 25) - 25, ButtonWidth)];
    fieldBgView.backgroundColor = [CHBlackColor ch_changeAlpha:0.6];
    fieldBgView.layer.cornerRadius = 4;
    [self addSubview:fieldBgView];
    
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(fieldBgView.ch_width - ButtonWidth, 0, ButtonWidth, ButtonWidth)];
    [cancelBtn setImage:[UIImage imageNamed:@"live_fieldCancel"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(liveNumFieldClear) forControlEvents:UIControlEventTouchUpInside];
    [fieldBgView addSubview:cancelBtn];
    
    UITextField *liveNumField = [[UITextField alloc]initWithFrame:CGRectMake(8, 0, fieldBgView.ch_width - 8 - ButtonWidth, ButtonWidth)];
    liveNumField.font = CHFont12;
    liveNumField.textColor = CHWhiteColor;
    NSAttributedString *placeholderStr = [[NSAttributedString alloc]initWithString:CH_Localized(@"list_liveName") attributes:@{NSForegroundColorAttributeName:CHWhiteColor,NSFontAttributeName:CHFont12}];
    liveNumField.attributedPlaceholder = placeholderStr;
    liveNumField.returnKeyType = UIReturnKeyDone;
    self.liveNumField = liveNumField;
    [fieldBgView addSubview:liveNumField];

}


// 底部试图
- (void)setBottomViews
{
    CGFloat leftMargin = 80;
    UIButton *beautySetButton = [[UIButton alloc]initWithFrame:CGRectMake(leftMargin, 0, ButtonWidth, ButtonWidth)];
    beautySetButton.tag = 3;
    beautySetButton.ch_bottom = self.ch_height - 45;
    [beautySetButton setImage:[UIImage imageNamed:@"live_beauty_set"] forState:UIControlStateNormal];
    [beautySetButton setBackgroundColor:CHBlackColor];
    [beautySetButton addTarget:self action:@selector(liveButtonsClick:) forControlEvents:UIControlEventTouchUpInside];
    beautySetButton.layer.cornerRadius = ButtonWidth * 0.5;
    [self addSubview:beautySetButton];
    
    UIButton *startButton = [[UIButton alloc]initWithFrame:CGRectMake(0, beautySetButton.ch_originY, 100, ButtonWidth)];
    startButton.ch_centerX = self.ch_width * 0.5;
    startButton.tag = 4;
    [startButton setBackgroundImage:[UIImage imageNamed:@"live_enterButton"] forState:UIControlStateNormal];
    [startButton setTitle:CH_Localized(@"live_startLive") forState:UIControlStateNormal];
    startButton.titleLabel.font = CHFont12;
    [startButton addTarget:self action:@selector(liveButtonsClick:) forControlEvents:UIControlEventTouchUpInside];
    startButton.layer.cornerRadius = ButtonWidth * 0.5;
    self.startButton = startButton;
    [self addSubview:startButton];
    
    UIButton *setButton = [[UIButton alloc]initWithFrame:CGRectMake(self.ch_width - leftMargin - ButtonWidth, beautySetButton.ch_originY, ButtonWidth, ButtonWidth)];
    setButton.tag = 5;
    [setButton setImage:[UIImage imageNamed:@"live_set"] forState:UIControlStateNormal];
    [setButton setBackgroundColor:CHBlackColor];
    [setButton addTarget:self action:@selector(liveButtonsClick:) forControlEvents:UIControlEventTouchUpInside];
    setButton.layer.cornerRadius = ButtonWidth * 0.5;
    [self addSubview:setButton];
}

// 温馨提示
- (void)addPrompt
{
    UIView *promptView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 230, 85)];
    promptView.layer.cornerRadius = 4;
    promptView.ch_centerX = self.ch_width * 0.5;
    promptView.ch_bottom = self.startButton.ch_originY - 30;
    self.promptView = promptView;
    [self addSubview:promptView];
    
    UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 8, 100, 15)];
    titleLable.text = CH_Localized(@"list_popup_mine");
    titleLable.font = CHFont12;
    titleLable.textColor = CHColor_6D7278;
    [promptView addSubview:titleLable];
    titleLable.ch_centerX = promptView.ch_width *0.5;
    
    UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 15, 15)];
    [cancelButton setImage:[UIImage imageNamed:@"list_cancelButton"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(promptViewCancelButtonsClick) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.tag = 1;
    [promptView addSubview:cancelButton];
    cancelButton.ch_right = promptView.ch_width - 10;
    cancelButton.ch_centerY = titleLable.ch_centerY;
    
    UILabel *nickLable = [[UILabel alloc]initWithFrame:CGRectMake(5, titleLable.ch_bottom + 10, promptView.ch_width - 10, promptView.ch_height - (titleLable.ch_bottom + 10) - 10)];
    nickLable.text = CH_Localized(@"list_popup_nick");
    nickLable.font = CHFont12;
    nickLable.textColor = CHColor_6D7278;
    [promptView addSubview:nickLable];
    nickLable.ch_centerX = promptView.ch_width *0.5;
}

- (void)liveButtonsClick:(UIButton *)sender
{
    if (_creatLiveViewButtonsClick)
    {
        _creatLiveViewButtonsClick(sender);
    }
}

- (void)liveNumFieldClear
{
    self.liveNumField.text = nil;
}

- (void)promptViewCancelButtonsClick
{
    self.promptView.hidden = YES;
}


@end
