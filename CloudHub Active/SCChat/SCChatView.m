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
        
        self.chatTableView.frame = CGRectMake(0, 0, self.ch_width, self.ch_height);
        [self addSubview:self.chatTableView];
    }
    
    return self;
}

- (void)setMessageList:(NSMutableArray<CHChatMessageModel *> *)messageList
{
    _messageList = messageList;
        
    [self.chatTableView reloadData];
    [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:messageList.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CHChatMessageModel *model = _messageList[indexPath.row];
    
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
    CHChatMessageModel * model = _messageList[indexPath.row];
    
    if (model.chatMessageType == CHChatMessageType_Tips)
    {
        if (!model.cellHeight)
        {
            model.messageSize = [model.message ch_sizeToFitWidth:self.ch_width - 2 * 10 withFont:[UIFont systemFontOfSize:12.0f]];
            
            model.cellHeight = 10 + model.messageSize.height + 5;
        }
        return model.cellHeight;
    }
    else if (model.chatMessageType == CHChatMessageType_Text)
    {
        if (!model.cellHeight)
        {
            if (!model.messageSize.width)
            {
                NSString *string = [NSString stringWithFormat:@"%@：%@",model.sendUser.nickName,model.message];
                
                model.messageSize = [string ch_sizeToFitWidth:self.ch_width - 2 * 10 withFont:[UIFont systemFontOfSize:12]];
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

- (UITableView *)chatTableView
{
    if (!_chatTableView)
    {
        self.chatTableView = [[UITableView alloc]initWithFrame:CGRectZero style: UITableViewStyleGrouped];
        
        self.chatTableView.delegate   = self;
        self.chatTableView.dataSource = self;
        self.chatTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        
        self.chatTableView.backgroundColor = [UIColor clearColor];
        self.chatTableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        self.chatTableView.showsHorizontalScrollIndicator = NO;
        self.chatTableView.showsVerticalScrollIndicator = NO;
        self.chatTableView.estimatedRowHeight = 0;
        self.chatTableView.estimatedSectionHeaderHeight = 0;
        self.chatTableView.estimatedSectionFooterHeight = 0;
        
        [self.chatTableView registerClass:[SCTipsMessageCell class] forCellReuseIdentifier:NSStringFromClass([SCTipsMessageCell class])];
        [self.chatTableView registerClass:[SCTextMessageCell class] forCellReuseIdentifier:NSStringFromClass([SCTextMessageCell class])];
                    
        if (@available(iOS 11.0, *))
        {
            self.chatTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            self.chatTableView.insetsContentViewsToSafeArea = NO;
        }
    }
    
    return _chatTableView;
}
@end
