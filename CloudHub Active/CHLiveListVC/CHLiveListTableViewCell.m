//
//  CHLiveListTableViewCell.m
//  CloudHub Active
//
//  Created by 马迪 on 2021/4/20.
//

#import "CHLiveListTableViewCell.h"


@interface CHLiveListTableViewCell ()

@property (nonatomic, weak) UIView *bgView;

/// 直播名称
@property (nonatomic, weak) UILabel *liveTitleLable;

/// 用户数
@property (nonatomic, weak) UIButton *numberButton;

@end

@implementation CHLiveListTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    
    NSString *reuseIdentifier = NSStringFromClass([self class]);
    
    CHLiveListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell)
    {
        
        cell = [[CHLiveListTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
//        self.contentView.layer.cornerRadius = 6;
//        self.layer.masksToBounds = YES;
        self.backgroundColor = UIColor.clearColor;
        [self setupUI];
    }
    return self;
}

-(void)setupUI
{
    UIView *bgView = [[UIView alloc]initWithFrame:self.bounds];
    bgView.backgroundColor = CHWhiteColor;
    bgView.layer.cornerRadius = 6;
    [self.contentView addSubview:bgView];
    self.bgView = bgView;
    
    UILabel *liveTitleLable = [[UILabel alloc]init];
    liveTitleLable.font = CHFont12;
    [bgView addSubview:liveTitleLable];
    self.liveTitleLable = liveTitleLable;
    
    UIButton *numberButton = [[UIButton alloc]init];
    [numberButton setImage:[UIImage imageNamed:@"live_userList"] forState:UIControlStateNormal];
    [numberButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    numberButton.titleLabel.font = CHFont12;
    numberButton.userInteractionEnabled = NO;
    [bgView addSubview:numberButton];
    self.numberButton = numberButton;
    self.numberButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
    self.numberButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [self.numberButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(70);
    }];
    
    [self.liveTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self.numberButton.mas_left).mas_offset(-10);
    }];
    
}

- (void)setModel:(CHLiveModel *)model
{
    _model = model;
    
    self.liveTitleLable.text = model.liveName;
    
    [self.numberButton setTitle:[NSString stringWithFormat:@"%ld",(long)model.memberNum] forState:UIControlStateNormal];
}


@end
