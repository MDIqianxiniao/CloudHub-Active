//
//  CHCreatLiveView.m
//  CloudHub Active
//
//  Created by 马迪 on 2021/4/22.
//

#import "CHCreatLiveFrontView.h"

#define ButtonWidth  32


@interface CHCreatLiveFrontView ()
<
    UITextFieldDelegate
>

@property (nonatomic, weak) UITextField *liveNumField;

@property (nonatomic, weak) UIButton *startButton;

/// 温馨提示
@property (nonatomic, weak) UIView *promptView;

@end

@implementation CHCreatLiveFrontView

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
    backButton.tag = CHCreateRoomFrontButton_Back;
    [backButton setImage:[UIImage imageNamed:@"live_backButton"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(liveButtonsClick:) forControlEvents:UIControlEventTouchUpInside];
    backButton.layer.cornerRadius = ButtonWidth * 0.5;
    [self addSubview:backButton];
    
    UIButton *cameraButton = [[UIButton alloc]initWithFrame:CGRectMake(self.ch_width - leftMargin - ButtonWidth, buttonY, ButtonWidth, ButtonWidth)];
    cameraButton.tag = CHCreateRoomFrontButton_Camera;
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
    NSAttributedString *placeholderStr = [[NSAttributedString alloc]initWithString:CH_Localized(@"Live_InputRoomNum") attributes:@{NSForegroundColorAttributeName:CHWhiteColor,NSFontAttributeName:CHFont12}];
    liveNumField.attributedPlaceholder = placeholderStr;
    liveNumField.returnKeyType = UIReturnKeyDone;
    liveNumField.keyboardType = UIKeyboardTypeURL;
    self.liveNumField = liveNumField;
    [fieldBgView addSubview:liveNumField];
    [liveNumField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    liveNumField.delegate = self;

}

#pragma  mark - 监听输入
- (void)textChange:(UITextField *)textField
{
    UITextRange *selectedRange = [textField markedTextRange];
    NSString * newText = [textField textInRange:selectedRange];
    // 获取高亮部分
    if(newText.length > 0)
    {
        return;
    }
    
    if (textField.text.length > 10)
    {
        textField.text = [textField.text substringToIndex:10];
    }
    
    self.channelId = textField.text;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSUInteger lengthOfString = string.length;  //lengthOfString的值始终为1
    for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {
        unichar character = [string characterAtIndex:loopIndex]; //将输入的值转化为ASCII值（即内部索引值），可以参考ASCII表
        // 48-57;{0,9};65-90;{A..Z};97-122:{a..z}
        if (character < 48) return NO; // 48 unichar for 0
        if (character > 57 && character < 65) return NO; //
        if (character > 90 && character < 97) return NO;
        if (character > 122) return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

// 底部试图
- (void)setBottomViews
{
    CGFloat leftMargin = 80;
    UIButton *beautySetButton = [[UIButton alloc]initWithFrame:CGRectMake(leftMargin, 0, ButtonWidth, ButtonWidth)];
    beautySetButton.tag = CHCreateRoomFrontButton_Beauty;
    beautySetButton.ch_bottom = self.ch_height - 45;
    [beautySetButton setImage:[UIImage imageNamed:@"live_beauty_set"] forState:UIControlStateNormal];
    [beautySetButton addTarget:self action:@selector(liveButtonsClick:) forControlEvents:UIControlEventTouchUpInside];
    beautySetButton.layer.cornerRadius = ButtonWidth * 0.5;
    [self addSubview:beautySetButton];
//    beautySetButton.hidden = YES;
    
    UIButton *startButton = [[UIButton alloc]initWithFrame:CGRectMake(0, beautySetButton.ch_originY, 100, ButtonWidth)];
    startButton.ch_centerX = self.ch_width * 0.5;
    startButton.tag = CHCreateRoomFrontButton_Start;
    [startButton setBackgroundImage:[UIImage imageNamed:@"live_enterButton"] forState:UIControlStateNormal];
    [startButton setTitle:CH_Localized(@"Live_StartLive") forState:UIControlStateNormal];
    startButton.titleLabel.font = CHFont12;
    [startButton addTarget:self action:@selector(liveButtonsClick:) forControlEvents:UIControlEventTouchUpInside];
    startButton.layer.cornerRadius = ButtonWidth * 0.5;
    self.startButton = startButton;
    [self addSubview:startButton];
    
    UIButton *setButton = [[UIButton alloc]initWithFrame:CGRectMake(self.ch_width - leftMargin - ButtonWidth, beautySetButton.ch_originY, ButtonWidth, ButtonWidth)];
    setButton.tag = CHCreateRoomFrontButton_Setting;
    [setButton setImage:[UIImage imageNamed:@"live_set"] forState:UIControlStateNormal];
    [setButton addTarget:self action:@selector(liveButtonsClick:) forControlEvents:UIControlEventTouchUpInside];
    setButton.layer.cornerRadius = ButtonWidth * 0.5;
    [self addSubview:setButton];
}

// 温馨提示
- (void)addPrompt
{
    UIView *promptView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 250, 85)];
    promptView.backgroundColor = CHWhiteColor;
    promptView.layer.cornerRadius = 4;
    promptView.ch_centerX = self.ch_width * 0.5;
    promptView.ch_bottom = self.startButton.ch_originY - 30;
    self.promptView = promptView;
    [self addSubview:promptView];
    
    UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 8, 100, 15)];
    titleLable.text = CH_Localized(@"Live_Prompt_Title");
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
    
    UILabel *promptLable = [[UILabel alloc]initWithFrame:CGRectMake(5, titleLable.ch_bottom + 10, promptView.ch_width - 10, promptView.ch_height - (titleLable.ch_bottom + 10) - 10)];
    promptLable.text = CH_Localized(@"Live_Prompt_Content");
    promptLable.font = CHFont12;
    promptLable.textColor = CHColor_6D7278;
    promptLable.numberOfLines = 0;
    promptLable.textAlignment = NSTextAlignmentCenter;
    [promptView addSubview:promptLable];
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
