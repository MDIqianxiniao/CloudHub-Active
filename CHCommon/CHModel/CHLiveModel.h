//
//  CHLiveModel.h
//  CloudHub Active
//
//  Created by 马迪 on 2021/4/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CHLiveModel : NSObject

/// name
@property (nonatomic, copy) NSString *liveName;

/// channelId
@property (nonatomic, copy) NSString *channelId;

/// 人数
@property (nonatomic, assign) NSInteger memberNum;


@end

NS_ASSUME_NONNULL_END
