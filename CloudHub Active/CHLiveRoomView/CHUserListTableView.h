//
//  CHUserListView.h
//  CloudHub Active
//
//  Created by 马迪 on 2021/4/27.
//

#import <UIKit/UIKit.h>
#import "CHRoomUser.h"

NS_ASSUME_NONNULL_BEGIN

@interface CHUserListTableView : UITableView

@property (nonatomic, strong, nullable) NSMutableArray *userListArray;

@property (nonatomic, copy) void(^userListCellClick)(CHRoomUser *userModel);

@end

NS_ASSUME_NONNULL_END
