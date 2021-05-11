//
//  CHBeautySetView.m
//  CloudHub Active
//
//  Created by 马迪 on 2021/4/23.
//

#import "CHBeautySetView.h"
#import "CHBeautyView.h"

#define CHBeautySetView_Gap             ([UIDevice ch_isiPad] ? 20.0f : 4.0f)

@interface CHBeautySetView ()

@property (nonatomic, assign) CGFloat gap;

@property (nonatomic, weak) UILabel *titleLable;

/// 美颜设置view
@property (nonatomic, weak) CHBeautyView *beautyView;

@end

@implementation CHBeautySetView


- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame itemGap:CHBeautySetView_Gap];
}

- (instancetype)initWithFrame:(CGRect)frame itemGap:(CGFloat)gap
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = CHWhiteColor;
        if (gap == 0)
        {
            gap = CHBeautySetView_Gap;
        }
        self.gap = gap;
        
        [self setupView];
        
        self.frame = frame;
    }
    
    return self;
}

- (void)setupView
{
    UILabel *titleLable = [[UILabel alloc]init];
    titleLable.text = CH_Localized(@"List_Popup_Mine");
    titleLable.font = CHFont12;
    titleLable.textColor = CHColor_6D7278;
    titleLable.textAlignment  = NSTextAlignmentCenter;
    self.titleLable = titleLable;
    [self addSubview:titleLable];
    
    CHBeautyView *beautyView = [[CHBeautyView alloc]initWithFrame:self.bounds itemGap:self.gap];
    [self addSubview:beautyView];
    self.beautyView = beautyView;
}

- (void)setBeautySetModel:(CHBeautySetModel *)beautySetModel
{
    _beautySetModel = beautySetModel;
    
    self.beautyView.beautySetModel = self.beautySetModel;
}

- (void)setFrame:(CGRect)frame
{
    self.titleLable.frame = CGRectMake(0, 0, frame.size.width, 45);
    
    self.beautyView.frame = CGRectMake(0, self.titleLable.ch_bottom, self.ch_width, self.ch_height);
    
    frame.size.height = self.beautyView.ch_bottom + 20;
    
    [super setFrame:frame];
}

- (void)beautyViewValueChange
{
    self.beautySetModel = self.beautyView.beautySetModel;
    
    if (_beautySetModelChange)
    {
        _beautySetModelChange();
    }
}

@end
