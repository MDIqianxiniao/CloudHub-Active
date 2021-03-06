//
//  CHImageTitleButtonView.m
//  YSAll
//
//  Created by jiang deng on 2020/6/1.
//  Copyright © 2020 YS. All rights reserved.
//

#import "CHImageTitleButtonView.h"

@interface CHImageTitleButtonView ()

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation CHImageTitleButtonView
@synthesize textSelectedColor = _textSelectedColor;
@synthesize textDisabledColor = _textDisabledColor;
@synthesize selectedText = _selectedText;
@synthesize disabledText = _disabledText;
@synthesize selectedImage = _selectedImage;
@synthesize disabledImage = _disabledImage;
@synthesize selectedAttributedText = _selectedAttributedText;
@synthesize disabledAttributedText = _disabledAttributedText;

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.textNormalColor = [UIColor whiteColor];
        //self.textSelectedColor = [UIColor whiteColor];
        //self.textDisabledColor = [UIColor colorWithWhite:0.7f alpha:1.0f];

        self.textFont = [UIFont systemFontOfSize:12.0f];
        
        self.textAlignment = NSTextAlignmentCenter;
        self.textAdjustsFontSizeToFitWidth = YES;
        self.textMinimumScaleFactor = 0.5f;

        self.imageTextGap = 2.0f;
        
        [self makeView];
    }
    
    return self;
}

- (void)makeView
{
    self.backgroundColor = [UIColor clearColor];
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    view.userInteractionEnabled = NO;
    [self addSubview:view];
    self.contentView = view;

    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.userInteractionEnabled = NO;
    textLabel.hidden = YES;
    textLabel.textAlignment = self.textAlignment;
    textLabel.adjustsFontSizeToFitWidth = self.textAdjustsFontSizeToFitWidth;
    textLabel.minimumScaleFactor = self.textMinimumScaleFactor;
    [view addSubview:textLabel];
    self.textLabel = textLabel;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.hidden = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.userInteractionEnabled = NO;
    [view addSubview:imageView];
    self.imageView = imageView;    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    if (self.ch_width == 0 || self.ch_height == 0)
//    {
//        return;
//    }
    
    UIImage *image = self.normalImage;
    
    UIColor *textColor = self.textNormalColor;
    NSString *text = self.normalText;
    
    NSAttributedString *attributedText = self.normalAttributedText;
    
    if (!self.enabled)
    {
        image = self.disabledImage;
        
        textColor = self.textDisabledColor;
        text = self.disabledText;
        
        attributedText = self.disabledAttributedText;
    }
    else if (self.selected)
    {
        image = self.selectedImage;
        
        textColor = self.textSelectedColor;
        text = self.selectedText;
        
        attributedText = self.selectedAttributedText;
    }
    
    CGSize textSize = CGSizeZero;
    
    if (text || attributedText)
    {
        self.textLabel.hidden = NO;
        
        self.textLabel.textColor = textColor;
        self.textLabel.font = self.textFont;

        self.textLabel.textAlignment = self.textAlignment;
        self.textLabel.adjustsFontSizeToFitWidth = self.textAdjustsFontSizeToFitWidth;
        self.textLabel.minimumScaleFactor = self.textMinimumScaleFactor;
        
        if (text)
        {
            self.textLabel.text = text;
            textSize = [self.textLabel ch_labelSizeToFit:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        }
        else
        {
            self.textLabel.attributedText = attributedText;
            textSize = [self.textLabel ch_attribSizeToFit:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        }
    }
    else
    {
        self.textLabel.hidden = YES;
    }

    CGFloat imageHeight = 0;
    CGFloat imageWidth = 0;
    if (image)
    {
        self.imageView.hidden = NO;
        
        self.imageView.image = image;
        
        imageHeight = image.size.height;
        imageWidth = image.size.width;
    }
    else
    {
        self.imageView.hidden = YES;
    }
    
    CGFloat height = imageHeight + ceil(textSize.height) + self.imageTextGap;
    CGFloat width = MAX(imageWidth, self.ch_width - self.textGap*2.0f);

    self.contentView.ch_size = CGSizeMake(width, height);
    [self.contentView ch_centerInSuperView];
    
    if (self.type == CHImageTitleButtonView_ImageTop)
    {
        CGRect imageFrame = CGRectMake((width-imageWidth)*0.5f, 0, imageWidth, imageHeight);
        self.imageView.frame = imageFrame;
        CGRect textFrame = CGRectMake(self.textGap, imageHeight+self.imageTextGap, width, ceil(textSize.height));
        self.textLabel.frame = textFrame;
    }
    else
    {
        CGRect textFrame = CGRectMake(self.textGap, 0, width, ceil(textSize.height));
        self.textLabel.frame = textFrame;
        CGRect imageFrame = CGRectMake((width-imageWidth)*0.5f, ceil(textSize.height)+self.imageTextGap, imageWidth, imageHeight);
        self.imageView.frame = imageFrame;
    }
}


#pragma mark - setter / getter


- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    
    [self setNeedsLayout];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    [self setNeedsLayout];
}

- (void)setType:(CHImageTitleButtonViewType)type
{
    _type = type;
    
    [self setNeedsLayout];
}

- (void)setNormalImage:(UIImage *)normalImage
{
    _normalImage = normalImage;
    
    [self setNeedsLayout];
}

- (void)setSelectedImage:(UIImage *)selectedImage
{
    _selectedImage = selectedImage;
    
    [self setNeedsLayout];
}

- (UIImage *)selectedImage
{
    if (_selectedImage)
    {
        return _selectedImage;
    }
    
    return self.normalImage;
}

- (void)setDisabledImage:(UIImage *)disabledImage
{
    _disabledImage = disabledImage;
    
    [self setNeedsLayout];
}

- (UIImage *)disabledImage
{
    if (_disabledImage)
    {
        return _disabledImage;
    }
    
    return [self.normalImage ch_imageWithTintColor:self.textDisabledColor];
}

- (void)setNormalText:(NSString *)normalText
{
    _normalText = normalText;
    
    [self setNeedsLayout];
}

- (void)setSelectedText:(NSString *)selectedText
{
    _selectedText = selectedText;
    
    [self setNeedsLayout];
}

- (NSString *)selectedText
{
    if (_selectedText)
    {
        return _selectedText;
    }
    
    return self.normalText;
}

- (void)setDisabledText:(NSString *)disabledText
{
    _disabledText = disabledText;
    
    [self setNeedsLayout];
}

- (NSString *)disabledText
{
    if (_disabledText)
    {
        return _disabledText;
    }
    
    return self.normalText;
}

- (void)setTextFont:(UIFont *)textFont
{
    _textFont = textFont;
    
    [self setNeedsLayout];
}

- (void)setTextNormalColor:(UIColor *)textNormalColor
{
    _textNormalColor = textNormalColor;
    
    [self setNeedsLayout];
}

- (void)setTextSelectedColor:(UIColor *)textSelectedColor
{
    _textSelectedColor = textSelectedColor;
    
    [self setNeedsLayout];
}

- (UIColor *)textSelectedColor
{
    if (_textSelectedColor)
    {
        return _textSelectedColor;
    }
    
    return self.textNormalColor;
}

- (void)setTextDisabledColor:(UIColor *)textDisabledColor
{
    _textDisabledColor = textDisabledColor;
    
    [self setNeedsLayout];
}

- (UIColor *)textDisabledColor
{
    if (_textDisabledColor)
    {
        return _textDisabledColor;
    }
    
    return [UIColor ch_colorWithHex:0x888888];
}

- (void)setNormalAttributedText:(NSAttributedString *)normalAttributedText
{
    _normalAttributedText = normalAttributedText;
    
    [self setNeedsLayout];
}

- (void)setSelectedAttributedText:(NSAttributedString *)selectedAttributedText
{
    _selectedAttributedText = selectedAttributedText;
    
    [self setNeedsLayout];
}

- (NSAttributedString *)selectedAttributedText
{
    if (_selectedAttributedText)
    {
        return _selectedAttributedText;
    }
    
    return self.normalAttributedText;
}

-(void)setDisabledAttributedText:(NSAttributedString *)disabledAttributedText
{
    _disabledAttributedText = disabledAttributedText;
    
    [self setNeedsLayout];
}

- (NSAttributedString *)disabledAttributedText
{
    if (_disabledAttributedText)
    {
        return _disabledAttributedText;
    }
    
    return self.normalAttributedText;
}

- (void)setImageTextGap:(CGFloat)imageTextGap
{
    _imageTextGap = imageTextGap;
    
    [self setNeedsLayout];
}

- (void)setTextGap:(CGFloat)textGap
{
    _textGap = textGap;
    
    [self setNeedsLayout];
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    _textAlignment = textAlignment;
    
    [self setNeedsLayout];
}

- (void)setTextAdjustsFontSizeToFitWidth:(BOOL)textAdjustsFontSizeToFitWidth
{
    _textAdjustsFontSizeToFitWidth = textAdjustsFontSizeToFitWidth;

    [self setNeedsLayout];
}

- (void)setTextMinimumScaleFactor:(CGFloat)textMinimumScaleFactor
{
    _textMinimumScaleFactor = textMinimumScaleFactor;
    
    [self setNeedsLayout];
}

@end
