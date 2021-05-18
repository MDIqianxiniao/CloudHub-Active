//
//  CHUsetListCell.h
//  CloudHub Active
//
//  Created by 马迪 on 2021/4/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CHUsetListCell : UITableViewCell

@property (nonatomic, strong) CHRoomUser *userModel;

@property (nonatomic, copy) void(^connectButtonClick)(void);

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
