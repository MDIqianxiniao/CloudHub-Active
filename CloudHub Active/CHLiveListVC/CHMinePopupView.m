//
//  CHMineView.m
//  CloudHub Active
//
//  Created by 马迪 on 2021/4/21.
//

#import "CHMinePopupView.h"


@implementation CHMinePopupView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setupViews];
    }
    return self;
}

- (void)setupViews
{
    UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 8, 50, 15)];
    titleLable.text = CH_Localized(@"list_popup_mine");
    titleLable.font = CHFont12;
    titleLable.textColor = CHColor_212121;
    [self addSubview:titleLable];
    titleLable.ch_centerX = self.ch_width *0.5;
    
    UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 15, 15)];
    [cancelButton setImage:[UIImage imageNamed:@"list_cancelButton"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(buttonsClick:) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.tag = 1;
    [self addSubview:cancelButton];
    cancelButton.ch_right = self.ch_width - 10;
    cancelButton.ch_centerY = titleLable.ch_centerY;
    
    UILabel *nickLable = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, 30, 15)];
    nickLable.text = CH_Localized(@"list_popup_nick");
    nickLable.font = CHFont12;
    nickLable.textColor = CHColor_6D7278;
    [self addSubview:nickLable];
    nickLable.ch_centerY = self.ch_height *0.5;
    
    CGFloat leftMargin = 10.0;
    
    UIView *fieldBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.ch_width - 30 - nickLable.ch_right - leftMargin, 28)];
    fieldBgView.layer.cornerRadius = fieldBgView.ch_height *0.5;
    fieldBgView.layer.borderWidth = 1.0;
    fieldBgView.layer.borderColor = CHColor_DBDBDB.CGColor;
    [self addSubview:fieldBgView];
    fieldBgView.ch_left = nickLable.ch_right + 5;
    fieldBgView.ch_centerY = nickLable.ch_centerY;
    
    UITextField *nameField = [[UITextField alloc]initWithFrame:CGRectMake(leftMargin, 0, fieldBgView.ch_width - leftMargin, fieldBgView.ch_height)];
    nameField.font = CHFont12;
    NSAttributedString *placeholderStr = [[NSAttributedString alloc]initWithString:CH_Localized(@"list_popup_defaultNick") attributes:@{NSForegroundColorAttributeName:CHColor_6D7278,NSFontAttributeName:CHFont12}];
    nameField.attributedPlaceholder = placeholderStr;
    [fieldBgView addSubview:nameField];
    nameField.clearButtonMode = UITextFieldViewModeAlways;

    UIButton *finishButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 84, 28)];
    [finishButton setBackgroundImage:[UIImage imageNamed:@"list_finishButton"] forState:UIControlStateNormal];
    [finishButton setTitle:CH_Localized(@"list_popup_finish") forState:UIControlStateNormal];
    [finishButton setTitleColor:CHWhiteColor forState:UIControlStateNormal];
    finishButton.titleLabel.font = CHFont12;
    finishButton.ch_centerX = self.ch_width *0.5;
    finishButton.ch_bottom = self.ch_height - 10;
    [self addSubview:finishButton];
    [finishButton addTarget:self action:@selector(buttonsClick:) forControlEvents:UIControlEventTouchUpInside];
    finishButton.tag = 2;
}

- (void)buttonsClick:(UIButton *)sender
{
    if (sender.tag == 1)
    {
        self.hidden = YES;
    }
    else if (sender.tag == 2)
    {
        NSLog(@"点击了我的，完成");
    }
    self.hidden = YES;
}

@end
