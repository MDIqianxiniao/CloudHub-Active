//
//  CHVideoSetView.m
//  CloudHub Active
//
//  Created by 马迪 on 2021/4/23.
//

#import "CHVideoSetView.h"

#define leftMargin 20.0f
#define CHSetView_SGap               12.0f
#define CHSetView_LabelHeight          20.0f
#define CHSetView_LineHeight       1.0f

@interface CHVideoSetView ()

@property (nonatomic,strong) NSMutableArray *bgButtonArray;

@property (nonatomic,strong) NSMutableArray *titleArray;

@property (nonatomic,strong) NSMutableArray *valueArray;

@property (nonatomic,strong) NSMutableArray *arrowArray;

@property (nonatomic,strong) NSMutableArray *lineArray;

@property (nonatomic, weak) UILabel *titleLable;

@property (nonatomic, assign) CGFloat gap;

@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, weak) UILabel *resolutionLable;

@property (nonatomic, weak) UILabel *rateLable;

@end

@implementation CHVideoSetView

- (instancetype)initWithFrame:(CGRect)frame itemGap:(CGFloat)gap
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = CHWhiteColor;
        
        self.bgButtonArray = [NSMutableArray array];
        self.titleArray = [NSMutableArray array];
        self.valueArray = [NSMutableArray array];
        self.arrowArray = [NSMutableArray array];
        self.lineArray = [NSMutableArray array];
        
        self.gap = gap;
                
        [self setupView];
        
        self.cellHeight = CHSetView_LabelHeight + CHSetView_SGap + CHSetView_LineHeight + self.gap;
        
        self.frame = frame;
    }
    
    return self;
}

- (void)setupView
{
    UILabel *titleLable = [[UILabel alloc]init];
    titleLable.text = CH_Localized(@"Live_Set");
    titleLable.font = CHFont12;
    titleLable.textColor = CHColor_6D7278;
    titleLable.textAlignment  = NSTextAlignmentCenter;
    self.titleLable = titleLable;
    
    [self addSubview:titleLable];
 
    for (int i = 0; i<2; i++)
    {
        UIButton *button = [[UIButton alloc]init];
        button.tag = i+100;
        [button addTarget:self action:@selector(arrowButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.font = CHFont12;
        titleLabel.textColor = CHColor_6D7278;
        titleLabel.textAlignment  = NSTextAlignmentLeft;
        [self addSubview:titleLabel];
        
        UILabel *valueLable = [[UILabel alloc]init];
        valueLable.font = CHFont12;
        valueLable.textColor = CHColor_6D7278;
        valueLable.textAlignment  = NSTextAlignmentRight;
        [self addSubview:valueLable];
        
        if (!i)
        {
            titleLabel.text = CH_Localized(@"Live_Set_Resolution");
            self.resolutionLable = valueLable;
        }
        else
        {
            titleLabel.text = CH_Localized(@"Live_Set_Rate");
            self.rateLable = valueLable;
        }
        
        UIButton *arrowButton = [[UIButton alloc]init];
        [arrowButton setImage:[UIImage imageNamed:@"live_setNextArrow"] forState:UIControlStateNormal];
        [self addSubview:arrowButton];
        arrowButton.userInteractionEnabled = NO;
        
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = [CHColor_D8D8D8 ch_changeAlpha:0.4];
        [self addSubview:lineView];
        
        [self.bgButtonArray addObject:button];
        [self.titleArray addObject:titleLabel];
        [self.valueArray addObject:valueLable];
        [self.arrowArray addObject:arrowButton];
        [self.lineArray addObject:lineView];
    }
}
    
- (void)setFrame:(CGRect)frame
{
    self.titleLable.frame = CGRectMake(0, 0, frame.size.width, 45);
        
    for (int i = 0; i<self.titleArray.count; i++)
    {
        UIButton *bgButton = self.bgButtonArray[i];
        bgButton.frame = CGRectMake(0, self.titleLable.ch_height + self.gap + i *self.cellHeight, self.ch_width, self.cellHeight);
        
        UILabel *nameLabel = self.titleArray[i];
        nameLabel.frame = CGRectMake(leftMargin, self.titleLable.ch_height + self.gap + i *self.cellHeight , 100, CHSetView_LabelHeight);
        
        UIButton *arrowButton = self.arrowArray[i];
        arrowButton.frame = CGRectMake(frame.size.width - leftMargin - self.cellHeight + 5, nameLabel.ch_originY - self.gap, self.cellHeight, self.cellHeight-1);
        
        UILabel *valueLable = self.valueArray[i];
        valueLable.frame = CGRectMake(leftMargin, nameLabel.ch_originY, 100, CHSetView_LabelHeight);
        valueLable.ch_right = arrowButton.ch_left - 5;
        
        UIView *lineLable = self.lineArray[i];
        lineLable.frame = CGRectMake(leftMargin, nameLabel.ch_bottom + CHSetView_SGap, frame.size.width - 2 * leftMargin, CHSetView_LineHeight);
        
        if (i == self.titleArray.count - 1)
        {
            frame.size.height = lineLable.ch_bottom + 40.0f;
        }
    }
    
    [super setFrame:frame];
}

- (void)setResolutionString:(NSString *)resolutionString
{
    _resolutionString = resolutionString;
    self.resolutionLable.text = resolutionString;
}

- (void)setRateString:(NSString *)rateString
{
    _rateString = rateString;
    self.rateLable.text = rateString;
}


- (void)arrowButtonClick:(UIButton *)sender
{
    if (_setArrowButtonClick)
    {
        _setArrowButtonClick(sender);
    }
}

@end
