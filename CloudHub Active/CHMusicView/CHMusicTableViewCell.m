//
//  CHMusicTableViewCell.m
//  CloudHub Active
//
//  Created by fzxm on 2021/4/25.
//

#import "CHMusicTableViewCell.h"

@interface CHMusicTableViewCell()

@property (nonatomic, strong) UIImageView *stateImgView;
@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation CHMusicTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.backgroundColor             = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupView];
    }
    return self;
}

//创建控件
- (void)setupView
{
    UIImageView *stateImgView = [[UIImageView alloc] init];
    self.stateImgView = stateImgView;
    [self.contentView addSubview:stateImgView];
   
    UILabel *titleLable = [[UILabel alloc]init];
    titleLable.font = CHFont12;
    titleLable.textColor = CHColor_6D7278;
    titleLable.textAlignment  = NSTextAlignmentLeft;
    self.titleLable = titleLable;
    [self.contentView addSubview:titleLable];
    
    UIView *lineView = [[UIView alloc] init];
    self.lineView = lineView;
    lineView.backgroundColor = [CHColor_D8D8D8 ch_changeAlpha:0.4];
    [self.contentView addSubview:lineView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.stateImgView.frame = CGRectMake(20.0f, 0, 30.0f, 30.0f);
    self.stateImgView.ch_centerY = self.ch_height*0.5f;
    
    self.titleLable.frame = CGRectMake(CGRectGetMaxX(self.stateImgView.frame)+5.0f, 0, 100.0f, 40.0f);
    self.titleLable.ch_centerY = self.stateImgView.ch_centerY;
    [self.titleLable ch_setLeft:self.stateImgView.ch_right + 5.0f right:self.ch_width - 20.0f];
    
    self.lineView.frame = CGRectMake(17.0f, self.ch_height-1.0f, self.ch_width - 17.0f - 17.0f, 1.0f);
}

- (void)setMusicModel:(CHMusicModel *)musicModel
{
    _musicModel = musicModel;
    self.titleLable.text = musicModel.name;
    if (musicModel.isPlay)
    {
        self.titleLable.textColor = CHColor_24D3EE;
        [self.stateImgView setImage:[UIImage imageNamed:@"music_play"]];
    }
    else
    {
        self.titleLable.textColor = CHColor_6D7278;
        [self.stateImgView setImage:[UIImage imageNamed:@"music_pause"]];
    }
}


- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
