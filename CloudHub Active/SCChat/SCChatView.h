//
//  SCChatView.h
//  CloudHub
//
//  Created by 马迪 on 2019/11/6.
//  Copyright 2019 The CloudHub project authors. All Rights Reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCChatView : UIView

@property (nonatomic, strong) UITableView *chatTableView;

@property (nonatomic, strong) NSMutableArray <CHChatMessageModel *> *messageList;

@property (nonatomic, copy) void(^textBtnClick)(void);

@property (nonatomic, copy) void(^clickViewToHiddenTheKeyBoard)(void);


@end

NS_ASSUME_NONNULL_END
