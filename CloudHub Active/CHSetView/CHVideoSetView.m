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

/// 标题的数组
@property(nonatomic,strong) NSMutableArray *titleArray;
/// 值label的数组
@property(nonatomic,strong) NSMutableArray *valueArray;
/// 箭头的数组
@property(nonatomic,strong) NSMutableArray *arrowArray;
/// 下划线的数组
@property(nonatomic,strong) NSMutableArray *lineArray;


@property (nonatomic, weak) UILabel *titleLable;

@property (nonatomic, assign) CGFloat gap;

@property (nonatomic, assign) CGFloat cellHeight;


@end

@implementation CHVideoSetView

- (instancetype)initWithFrame:(CGRect)frame itemGap:(CGFloat)gap
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [CHWhiteColor ch_changeAlpha:0.8];;
        
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
    titleLable.text = CH_Localized(@"live_set");
    titleLable.font = CHFont12;
    titleLable.textColor = CHColor_6D7278;
    titleLable.textAlignment  = NSTextAlignmentCenter;
    self.titleLable = titleLable;
    
    [self addSubview:titleLable];
 
    for (int i = 0; i<2; i++)
    {
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.text = CH_Localized(@"list_popup_mine");
        titleLabel.font = CHFont12;
        titleLabel.textColor = CHColor_6D7278;
        titleLabel.textAlignment  = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
        
        if (!i)
        {
            titleLabel.text = CH_Localized(@"live_set_resolution");
        }
        else
        {
            titleLabel.text = CH_Localized(@"live_set_rate");
        }
        
        UILabel *valueLable = [[UILabel alloc]init];
        valueLable.text = CH_Localized(@"live_set_resolution");
        valueLable.font = CHFont12;
        valueLable.textColor = CHColor_6D7278;
        valueLable.textAlignment  = NSTextAlignmentRight;
        [self addSubview:valueLable];
        
        UIButton *arrowButton = [[UIButton alloc]init];
        arrowButton.tag = i+100;
        [arrowButton setImage:[UIImage imageNamed:@"live_setNextArrow"] forState:UIControlStateNormal];
        [arrowButton addTarget:self action:@selector(arrowButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:arrowButton];
        
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = CHColor_6D7278;
        [self addSubview:lineView];
        
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
        UILabel *titleLabel = self.titleArray[i];
        titleLabel.frame = CGRectMake(leftMargin, self.titleLable.ch_height + i *self.cellHeight, 100, CHSetView_LabelHeight);
        
        UIButton *arrowButton = self.arrowArray[i];
        arrowButton.frame = CGRectMake(frame.size.width - leftMargin - CHSetView_LabelHeight - 5, titleLabel.ch_originY, CHSetView_LabelHeight, CHSetView_LabelHeight);
        
        UILabel *valueLable = self.valueArray[i];
        valueLable.frame = CGRectMake(leftMargin, self.titleLable.ch_height + i *self.cellHeight, 100, CHSetView_LabelHeight);
        valueLable.ch_right = arrowButton.ch_left - 5;
        
        UIView *lineLable = self.lineArray[i];
        lineLable.frame = CGRectMake(leftMargin, titleLabel.ch_bottom + CHSetView_SGap, frame.size.width - 2 * leftMargin, CHSetView_LineHeight);
        
        if (i == self.titleArray.count - 1)
        {
            frame.size.height = lineLable.ch_bottom + self.gap + 20.0f;
        }
    }
    
    [super setFrame:frame];
}

- (void)arrowButtonClick:(UIButton *)sender
{
    if (_setArrowButtonClick)
    {
        _setArrowButtonClick(sender);
    }
}

@end
