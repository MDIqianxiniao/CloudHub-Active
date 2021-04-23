//
//  CHResolutionView.h
//  CloudHub Active
//
//  Created by 马迪 on 2021/4/23.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    CHVideoSetViewType_Resolution,
    CHVideoSetViewType_Rate
} CHVideoSetViewType;

NS_ASSUME_NONNULL_BEGIN

@interface CHResolutionView : UIView

@property (nonatomic, copy) void(^resolutionViewButtonClick)(NSString * _Nullable value);

@property (nonatomic, copy) NSString *selectValue;

- (instancetype)initWithFrame:(CGRect)frame itemGap:(CGFloat)gap type:(CHVideoSetViewType)viewType withData:(NSArray *)dataArray;



@end

NS_ASSUME_NONNULL_END
