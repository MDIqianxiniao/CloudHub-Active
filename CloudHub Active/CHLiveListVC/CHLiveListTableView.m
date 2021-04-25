//
//  CHLiveListTableView.m
//  CloudHub Active
//
//  Created by 马迪 on 2021/4/20.
//

#import "CHLiveListTableView.h"
#import "CHLiveListTableViewCell.h"


@interface CHLiveListTableView ()
<
    UITableViewDelegate,
    UITableViewDataSource
>




@end

@implementation CHLiveListTableView


- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style])
    {
        self.backgroundColor = UIColor.clearColor;
        self.dataSource = self;
        self.delegate = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.showsVerticalScrollIndicator = NO;
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CHLiveListTableViewCell *cell = [CHLiveListTableViewCell cellWithTableView:tableView];

    cell.model = self.dataArray[indexPath.section];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_liveListCellClick)
    {
        _liveListCellClick(indexPath);
    }
}
    
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc]init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0;
}



@end
