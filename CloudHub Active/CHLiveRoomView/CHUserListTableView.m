//
//  CHUserListView.m
//  CloudHub Active
//
//  Created by 马迪 on 2021/4/27.
//

#import "CHUserListTableView.h"
#import "CHUsetListCell.h"

#define CellHeight 40
#define HeaderHeight 50
#define FooterHeight 30

@interface CHUserListTableView ()
<
    UITableViewDelegate,
    UITableViewDataSource
>

@end


@implementation CHUserListTableView


- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style])
    {
        self.backgroundColor = [CHWhiteColor ch_changeAlpha:0.9];;
        self.dataSource = self;
        self.delegate = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.userListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CHUsetListCell *cell = [CHUsetListCell cellWithTableView:tableView];

    cell.userModel = self.userListArray[indexPath.row];
    
    CHWeakSelf
    cell.connectButtonClick = ^(NSIndexPath * _Nonnull index) {
        
        CHRoomUser *user = weakSelf.userListArray[indexPath.row];
        
        if (user.role != CHUserType_Anchor)
        {
            if (self->_userListCellClick)
            {
                self->_userListCellClick(user);
            }
        }
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CellHeight;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = CH_Localized(@"Live_UserList_Tittle");
    titleLabel.textColor = CHColor_6D7278;
    titleLabel.font = CHFont12;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
//    titleLabel.backgroundColor = UIColor.yellowColor;
    
    return titleLabel;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HeaderHeight;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return FooterHeight;
}

- (void)setUserListArray:(NSMutableArray *)userListArray
{
    _userListArray = userListArray;
    
    [self reloadData];
    
    CGFloat height = HeaderHeight + userListArray.count *CellHeight +FooterHeight;
    
    self.frame = CGRectMake(0, CHUI_SCREEN_HEIGHT - height, self.ch_width, HeaderHeight + userListArray.count *CellHeight +FooterHeight);
}

@end
