//
//  SCTipsMessageCell.m
//  CloudHub
//
//  Created by 马迪 on 2019/11/16.
//  Copyright 2019 The CloudHub project authors. All Rights Reserved.
//

#import "SCTipsMessageCell.h"

//Right chat view width
#define ChatViewWidth 284
#define CellHeight 20

@interface SCTipsMessageCell ()

@property (nonatomic, strong) UILabel *iMessageLabel;

@end

@implementation SCTipsMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupView];
    }
    
    return self;
}

- (void)setupView
{
    self.backView = [[UIView alloc] init];
    self.backView.backgroundColor = [CHBlackColor ch_changeAlpha:0.5];;
    self.backView.layer.cornerRadius = CellHeight * 0.5f;;
    [self.contentView addSubview:self.backView];
    
    self.iMessageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//    self.iMessageLabel.backgroundColor = UIColor.clearColor;
    self.iMessageLabel.textAlignment = NSTextAlignmentCenter;
//    self.iMessageLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    self.iMessageLabel.numberOfLines = 0;
    [self.iMessageLabel setFont:CHFont12];
    self.iMessageLabel.textColor = CHColor_24D3EE;
//    self.iMessageLabel.textColor = [UIColor ch_colorWithHex:0x1C1D20];
    [self.backView addSubview:self.iMessageLabel];
}

- (void)setModel:(CHChatMessageModel *)model
{
    _model = model;

    self.iMessageLabel.text = [NSString stringWithFormat:@"%@ %@",model.timeStr,model.message];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = 0.f;
    width = [self.iMessageLabel.text ch_sizeToFitWidth:ChatViewWidth - 20 withFont:[UIFont systemFontOfSize:12.0f]].width;
    self.backView.frame = CGRectMake((ChatViewWidth-width - 20)/2, 10, width + 20, 25);
    self.iMessageLabel.frame = CGRectMake(10, 0, width, 25);
}
@end
