//
//  CHChatInputView.m
//  CloudHub Active
//
//  Created by 马迪 on 2021/4/29.
//

#import "CHChatInputView.h"

#define TopMargin  5

#define LeftMargin  10

@interface CHChatInputView ()
<
    UITextViewDelegate
>

@property (nonatomic, weak) UILabel *placeholderLable;

@end

@implementation CHChatInputView

- (instancetype)initWithFrame:(CGRect)frame;
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = CHWhiteColor;
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    UIView *inputBgView = [[UIView alloc]initWithFrame:CGRectMake(LeftMargin, TopMargin, self.ch_width - LeftMargin * 2, self.ch_height - 2 * TopMargin)];
    inputBgView.backgroundColor = CHColor_DBDBDB;
    [self addSubview:inputBgView];
    inputBgView.layer.cornerRadius = inputBgView.ch_height * 0.5;
    
    UITextView *inputView = [[UITextView alloc]initWithFrame:CGRectMake(LeftMargin, 0, self.ch_width - LeftMargin * 3, inputBgView.ch_height)];
    inputView.backgroundColor = UIColor.clearColor;
    inputView.returnKeyType = UIReturnKeySend;
    inputView.font = CHFont12;
    inputView.textColor = CHWhiteColor;
    inputView.delegate = self;
    self.inputView.enablesReturnKeyAutomatically = YES;
    [inputBgView addSubview:inputView];
    self.inputView = inputView;
    
    UILabel *placeholderLable = [[UILabel alloc]initWithFrame:inputBgView.bounds];
    placeholderLable.text = CH_Localized(@"Live_ChatPlaceholder");
    placeholderLable.font = CHFont12;
    placeholderLable.textColor = CHColor_BBBBBB;
    self.placeholderLable = placeholderLable;
    [inputView addSubview:placeholderLable];
}

-(void)textViewDidChange:(UITextView *)textView
{
    self.placeholderLable.hidden = [textView.text ch_isNotEmpty];
    
    UITextRange *selectedRange = [textView markedTextRange];
    if (!selectedRange)
    {
        if (textView.text.length > 80)
        {
            textView.text = [textView.text substringToIndex:80];
            [CHProgressHUD ch_showHUDAddedTo:self animated:YES withText:CH_Localized(@"Live_ChatTextNumber") delay:CHProgressDelay];
        }
    }
}

#pragma mark -
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"] && [self.inputView.text ch_isNotEmpty])
    {
        if (_sendMessage)
        {
            _sendMessage(self.inputView.text);
            self.inputView.text = nil;
        }
        return NO;
    }
    return YES;
}

@end
