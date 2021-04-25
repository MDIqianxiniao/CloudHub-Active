//
//  SCChatView.m
//  CloudHub
//
//  Created by 马迪 on 2019/11/6.
//  Copyright 2019 The CloudHub project authors. All Rights Reserved.
//

#import "SCChatView.h"
#import "SCTipsMessageCell.h"
#import "SCTextMessageCell.h"

#define BottomH ([UIDevice ch_isiPad] ? 70 : 50)

@interface SCChatView()
<
UITableViewDelegate,
UITableViewDataSource,
UITextFieldDelegate
>

@property(nonatomic,strong)UIImageView *bubbleView;

///Pop up the button in the input box
@property(nonatomic,strong)UIButton * textBtn;

@end

@implementation SCChatView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = UIColor.clearColor;
        
        self.SCChatTableView.frame = CGRectMake(0, 0, self.ch_width, self.ch_height);
        [self addSubview:self.SCChatTableView];
    }
    
    return self;
}

- (void)setSCMessageList:(NSMutableArray<CHChatMessageModel *> *)SCMessageList
{
    _SCMessageList = SCMessageList;
        
    [self.SCChatTableView reloadData];
    [self.SCChatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:SCMessageList.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.SCMessageList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CHChatMessageModel *model = _SCMessageList[indexPath.row];
    
    if (model.chatMessageType == CHChatMessageType_Tips)
    {
        SCTipsMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SCTipsMessageCell class]) forIndexPath:indexPath];
        cell.model = model;
        
        return cell;
    }
    else if (model.chatMessageType == CHChatMessageType_Text)
    {
        SCTextMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SCTextMessageCell class]) forIndexPath:indexPath];
        cell.model = model;

        return cell;
    }
    
    return [[UITableViewCell alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CHChatMessageModel * model = _SCMessageList[indexPath.row];
    
    if (model.chatMessageType == CHChatMessageType_Tips)
    {
        if (!model.cellHeight)
        {
            model.cellHeight = 25;
        }
        return model.cellHeight;
    }
    else if (model.chatMessageType == CHChatMessageType_Text)
    {
        if (!model.cellHeight)
        {
            if (!model.messageSize.width)
            {
                model.messageSize = [model.message ch_sizeToFitWidth:self.ch_width - 2 * 10 withFont:[UIFont systemFontOfSize:12]];
            }
            model.cellHeight = 10 + model.messageSize.height + 5;
        }
        return model.cellHeight;
    }
  
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self hiddenTheKeyBoard];
}

- (void)hiddenTheKeyBoard
{
    if (_clickViewToHiddenTheKeyBoard)
    {
        _clickViewToHiddenTheKeyBoard();
    }
}

- (UITableView *)SCChatTableView
{
    if (!_SCChatTableView)
    {
        self.SCChatTableView = [[UITableView alloc]initWithFrame:CGRectZero style: UITableViewStyleGrouped];
        
        self.SCChatTableView.delegate   = self;
        self.SCChatTableView.dataSource = self;
        self.SCChatTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        
        self.SCChatTableView.backgroundColor = [UIColor clearColor];
        self.SCChatTableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        self.SCChatTableView.showsHorizontalScrollIndicator = NO;
        self.SCChatTableView.estimatedRowHeight = 0;
        self.SCChatTableView.estimatedSectionHeaderHeight = 0;
        self.SCChatTableView.estimatedSectionFooterHeight = 0;
        
        [self.SCChatTableView registerClass:[SCTipsMessageCell class] forCellReuseIdentifier:NSStringFromClass([SCTipsMessageCell class])];
        [self.SCChatTableView registerClass:[SCTextMessageCell class] forCellReuseIdentifier:NSStringFromClass([SCTextMessageCell class])];
                    
        if (@available(iOS 11.0, *))
        {
            self.SCChatTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            self.SCChatTableView.insetsContentViewsToSafeArea = NO;
        }
    }
    
    return _SCChatTableView;
}
@end
