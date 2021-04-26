//
//  CHMusicModel.h
//  CloudHub Active
//
//  Created by fzxm on 2021/4/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CHMusicModel : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) BOOL isPlay;
@property (nonatomic, strong) NSString *path;
@property (nonatomic, assign) NSInteger soundId;
@end

NS_ASSUME_NONNULL_END
