//
//  SCChatTableViewCell.m
//  CloudHub
//
//  Created by 马迪 on 2019/11/7.
//  Copyright 2019 The CloudHub project authors. All Rights Reserved.
//

#import "SCTextMessageCell.h"

#define ChatViewWidth 284

#define CellHeight 20

@interface SCTextMessageCell()

//@property (nonatomic, strong) UILabel *nickNameLab;

//@property (nonatomic, strong) UIImageView * bubbleView;
@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) UILabel * msgLab;

@end

@implementation SCTextMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = UIColor.clearColor;
        
        [self setupView];
    }
    
    return self;
}

- (void)setupView
{
    UIView * backView = [[UIView alloc] init];
    backView.backgroundColor = [CHBlackColor ch_changeAlpha:0.5];;
    backView.layer.cornerRadius = CellHeight * 0.5f;;
    self.backView = backView;
    [self.contentView addSubview:backView];
    
    UILabel * msgLab = [[UILabel alloc]init];
    msgLab.font = [UIFont systemFontOfSize:12.0f];
    msgLab.numberOfLines = 0;
    msgLab.textColor = CHWhiteColor;
    msgLab.textAlignment = NSTextAlignmentLeft;;
    self.msgLab = msgLab;
    [self.contentView addSubview:msgLab];
    
}
- (void)setModel:(CHChatMessageModel *)model
{
    _model = model;
    
    NSString *string = [NSString stringWithFormat:@"%@：%@",model.sendUser.nickName,model.message];
    
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc]initWithString:string attributes:@{NSFontAttributeName:CHFont12,NSForegroundColorAttributeName:CHWhiteColor}];
    [attributedString addAttributes:@{NSFontAttributeName:CHFont12,NSForegroundColorAttributeName:CHColor_24D3EE} range:NSMakeRange(0, model.sendUser.nickName.length + 1)];
    
    self.msgLab.attributedText = attributedString;

    if (!model.messageSize.width && [string ch_isNotEmpty])
    {
        model.messageSize = [string ch_sizeToFitWidth:self.ch_width - 2 * 10 withFont:[UIFont systemFontOfSize:12]];
    }
    
    self.backView.frame = CGRectMake(0, 0, model.messageSize.width + 2 * 10 , model.messageSize.height + 10);
    self.msgLab.frame = CGRectMake(10, 0, model.messageSize.width, model.messageSize.height);
    
    self.backView.ch_centerY = self.ch_height * 0.5f;
    self.msgLab.ch_centerY = self.backView.ch_height * 0.5f;
}

@end
