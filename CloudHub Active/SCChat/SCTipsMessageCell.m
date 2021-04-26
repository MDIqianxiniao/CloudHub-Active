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
        self.backgroundColor = UIColor.clearColor;
        
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
    self.iMessageLabel.numberOfLines = 0;
    [self.iMessageLabel setFont:CHFont12];
    self.iMessageLabel.textColor = CHColor_24D3EE;
    [self.backView addSubview:self.iMessageLabel];
}

- (void)setModel:(CHChatMessageModel *)model
{
    _model = model;
    
    self.iMessageLabel.text = model.message;

    model.messageSize = [self.iMessageLabel.text ch_sizeToFitWidth:self.ch_width - 2 * 10 withFont:[UIFont systemFontOfSize:12.0f]];
    
    self.backView.frame = CGRectMake(0, 0, model.messageSize.width + 20, model.messageSize.height + 10);
    self.iMessageLabel.frame = CGRectMake(10, 0, model.messageSize.width, model.messageSize.height);
    
    self.backView.ch_centerY = self.ch_height * 0.5f;
    self.iMessageLabel.ch_centerY = self.backView.ch_height * 0.5f;
    
}


@end
