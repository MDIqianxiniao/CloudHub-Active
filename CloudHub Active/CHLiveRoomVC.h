//
//  CHLiveRoomVC.h
//  CloudHub Active
//
//  Created by 马迪 on 2021/4/25.
//

#import <UIKit/UIKit.h>
#import "CHSuperViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CHLiveRoomVC : CHSuperViewController

/// user list
@property (nonatomic, strong) NSMutableArray <CHRoomUser *> *userList;

@end

NS_ASSUME_NONNULL_END
