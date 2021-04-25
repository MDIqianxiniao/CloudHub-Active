//
//  CHCreatLiveView.h
//  CloudHub Active
//
//  Created by 马迪 on 2021/4/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CHCreatLiveView : UIView

@property (nonatomic, copy) NSString *liveNum;

@property (nonatomic, copy) void(^creatLiveViewButtonsClick)(UIButton *sender);

@end

NS_ASSUME_NONNULL_END
