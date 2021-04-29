//
//  CHLiveModel.h
//  CloudHub Active
//
//  Created by 马迪 on 2021/4/20.
//

#import <Foundation/Foundation.h>
#import "CHBeautySetModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface CHLiveModel : NSObject

/// name
@property (nonatomic, copy) NSString *liveName;

/// channelId
@property (nonatomic, copy) NSString *channelId;

/// number
@property (nonatomic, assign) NSInteger memberNum;

/// isMirror
@property (nonatomic, assign) NSInteger isMirror;

/// beauty
@property (nonatomic, strong) CHBeautySetModel *beautySetModel;

/// resolution
@property (nonatomic, copy) NSString *resolution;

/// resolution Width
@property (nonatomic, assign) NSUInteger videowidth;
/// resolution Height
@property (nonatomic, assign) NSUInteger videoheight;

/// rate
@property (nonatomic, assign) NSInteger rate;

@end

NS_ASSUME_NONNULL_END
