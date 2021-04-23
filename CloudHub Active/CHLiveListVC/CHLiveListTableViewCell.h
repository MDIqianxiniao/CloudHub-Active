//
//  CHLiveListTableViewCell.h
//  CloudHub Active
//
//  Created by 马迪 on 2021/4/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CHLiveListTableViewCell : UITableViewCell

///
@property (nonatomic, strong) CHLiveModel *model;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
