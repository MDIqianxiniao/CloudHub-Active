//
//  CHLiveListTableView.h
//  CloudHub Active
//
//  Created by 马迪 on 2021/4/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CHLiveListTableView : UITableView

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, copy) void(^liveListCellClick)(NSIndexPath *index);

@end

NS_ASSUME_NONNULL_END
