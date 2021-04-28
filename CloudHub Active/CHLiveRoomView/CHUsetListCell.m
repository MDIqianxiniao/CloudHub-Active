//
//  CHUsetListCell.m
//  CloudHub Active
//
//  Created by 马迪 on 2021/4/27.
//

#import "CHUsetListCell.h"

#define NameLeftMargin 30
#define LineLeftMargin 20

@interface CHUsetListCell ()

@property(nonatomic, weak) UILabel *nameLable;

@property(nonatomic, weak) UIButton *connectButton;

@end

@implementation CHUsetListCell


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    NSString *reuseIdentifier = NSStringFromClass([self class]);
    
    CHUsetListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell)
    {
        cell = [[CHUsetListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.backgroundColor = UIColor.clearColor;
        [self setupUI];
    }
    
    return self;
}

-(void)setupUI
{
    UILabel *nameLable = [[UILabel alloc]init];
    nameLable.font = CHFont12;
    nameLable.textColor = CHColor_6D7278;
    [self.contentView addSubview:nameLable];
    self.nameLable = nameLable;
        
    UIButton *connectButton = [[UIButton alloc]init];
    [connectButton setBackgroundImage:[UIImage imageNamed:@"live_userList_connect"] forState:UIControlStateNormal];
    [connectButton setBackgroundImage:[UIImage imageNamed:@"live_userList_disconnect"] forState:UIControlStateSelected];
    [connectButton setTitle:CH_Localized(@"Live_UserList_Connect") forState:UIControlStateNormal];
    [connectButton setTitle:CH_Localized(@"Live_UserList_Disconnect") forState:UIControlStateSelected];
    [connectButton setTitleColor:CHColor_24D3EE forState:UIControlStateNormal];
    [connectButton setTitleColor:CHWhiteColor forState:UIControlStateSelected];
    connectButton.titleLabel.font = CHFont12;
    [connectButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:connectButton];
    self.connectButton = connectButton;
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = CHColor_6D7278;
    [self addSubview:lineView];
    
    [connectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-NameLeftMargin);
        make.width.mas_equalTo(58);
        make.height.mas_equalTo(22);
        make.centerY.mas_equalTo(self);
    }];
        
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(NameLeftMargin);
        make.right.mas_equalTo(connectButton.mas_left).mas_offset(-10);
        make.height.mas_equalTo(22);
        make.centerY.mas_equalTo(self);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(LineLeftMargin);
        make.right.mas_equalTo(-LineLeftMargin);
        make.height.mas_equalTo(1.0f);
        make.bottom.mas_equalTo(self);
    }];
}
    
- (void)setUserModel:(CHRoomUser *)userModel
{
    _userModel = userModel;
    
    self.nameLable.text = userModel.nickName;
    
    if (userModel.role == CHUserType_Anchor)
    {
        self.connectButton.hidden = YES;
    }
    else
    {
        self.connectButton.hidden = NO;
    }
    
    if (userModel.publishState)
    {
        self.nameLable.textColor = CHColor_24D3EE;
        self.connectButton.selected = YES;
    }
    else
    {
        self.nameLable.textColor = CHColor_6D7278;
        self.connectButton.selected = NO;
    }
}

- (void)buttonClick:(UIButton *)button
{
    if (_connectButtonClick)
    {
        _connectButtonClick(button);
    }
}

@end
