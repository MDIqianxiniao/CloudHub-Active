//
//  CHResolutionView.m
//  CloudHub Active
//
//  Created by 马迪 on 2021/4/23.
//

#import "CHResolutionView.h"

#define leftMargin 20.0f
#define CHSetView_SGap               ([UIDevice ch_isiPad] ? 10.0f : 8.0f)
#define CHSetView_ValueHeight          20.0f
#define CHSetView_LineHeight       1.0f



@interface CHResolutionView ()

/// 数据源数组
@property(nonatomic, strong) NSArray *dataArray;

@property (nonatomic, assign) CHVideoSetViewType viewType;

/// 值label的数组
@property(nonatomic, strong) NSMutableArray *valueArray;
/// 下划线的数组
@property(nonatomic, strong) NSMutableArray *lineArray;

@property (nonatomic, assign) CGFloat gap;

@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, weak) UILabel *titleLable;

@end

@implementation CHResolutionView

- (instancetype)initWithFrame:(CGRect)frame itemGap:(CGFloat)gap type:(CHVideoSetViewType)viewType withData:(NSArray *)dataArray
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [CHWhiteColor ch_changeAlpha:0.8];;
        
        self.valueArray = [NSMutableArray array];
        self.lineArray = [NSMutableArray array];
        
        self.gap = gap;
        self.viewType = viewType;
        self.dataArray = dataArray;
                
        [self setupView];
        
        self.cellHeight = CHSetView_ValueHeight + CHSetView_SGap + CHSetView_LineHeight + self.gap;
        
        self.frame = frame;
    }
    
    return self;
}

- (void)setupView
{
    NSString * titleStr = nil;
    if (self.viewType == CHVideoSetViewType_Resolution)
    {
        titleStr = CH_Localized(@"live_set_resolution");
    }
    else if (self.viewType == CHVideoSetViewType_Rate)
    {
        titleStr = CH_Localized(@"live_set_rate");
    }
    
    UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.ch_width, 45)];
    titleLable.text = titleStr;
    titleLable.font = CHFont12;
    titleLable.textColor = CHColor_6D7278;
    titleLable.textAlignment = NSTextAlignmentCenter;
    self.titleLable = titleLable;
    [self addSubview:titleLable];
    
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(15, 0, 25, 25)];
    backButton.ch_centerY = titleLable.ch_centerY;
    [backButton setImage:[UIImage imageNamed:@"live_setNextArrow"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(buttonsClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backButton];
    backButton.tag = 1000;
    
    // 旋转图片
    CGAffineTransform transform= CGAffineTransformMakeRotation(M_PI);
    backButton.imageView.transform = transform;//旋转
    [backButton setBackgroundColor: UIColor.redColor];
    
    for (int i = 0 ; i < self.dataArray.count; i++)
    {
        UIButton *valueButton = [self creatbuttonWithTitle:self.dataArray[i]];
        valueButton.tag = i;
        
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = CHColor_6D7278;
        [self addSubview:lineView];
        
        [self.valueArray addObject: valueButton];
        [self.lineArray addObject:lineView];
    }
}

- (void)setFrame:(CGRect)frame
{
    for (int i = 0 ; i < self.dataArray.count; i++)
    {
        UIButton *valueButton = [self.valueArray ch_safeObjectAtIndex:i];
        
        valueButton.frame = CGRectMake(leftMargin, self.titleLable.ch_bottom + i * self.cellHeight, frame.size.width - 2 * leftMargin, CHSetView_ValueHeight);
        
        UIView *lineView = [self.lineArray ch_safeObjectAtIndex:i];
        lineView.frame = CGRectMake(leftMargin, valueButton.ch_bottom + CHSetView_SGap, frame.size.width - 2 * leftMargin, CHSetView_LineHeight);
        
        if (i == self.dataArray.count - 1)
        {
            frame.size.height = lineView.ch_bottom + self.gap + 20.0f;
        }
    }
    
    [super setFrame:frame];
}

- (UIButton *)creatbuttonWithTitle:(NSString *)title
{
    UIButton *button = [[UIButton alloc]init];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = CHFont12;
    [button setTitleColor:CHColor_6D7278 forState:UIControlStateNormal];
    [button setTitleColor:UIColor.redColor forState:UIControlStateSelected];
//    lable.textAlignment  = NSTextAlignmentCenter;
    [button addTarget:self action:@selector(buttonsClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    return button;
}

- (void)buttonsClick:(UIButton *)button
{
    if (button.tag == 1000)
    {
        if (_resolutionViewButtonClick)
        {
            _resolutionViewButtonClick(nil);
        }
    }
    else
    {
        if (!button.selected)
        {
            NSInteger index = [self.dataArray indexOfObject:self.selectValue];
            UIButton *lastButton = [self.valueArray ch_safeObjectAtIndex:index];
            lastButton.selected = NO;
            
            button.selected = YES;
            self.selectValue = button.titleLabel.text;
            if (_resolutionViewButtonClick)
            {
                _resolutionViewButtonClick(self.selectValue);
            }
        }
    }
}

- (void)buttonClick
{
    
}

@end
