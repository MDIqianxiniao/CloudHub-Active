//
//  CHChatInputView.h
//  CloudHub Active
//
//  Created by 马迪 on 2021/4/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CHChatInputView : UIView

@property (nonatomic, weak) UITextView *inputView;

@property (nonatomic, copy) void(^sendMessage)(NSString *message);

@end

NS_ASSUME_NONNULL_END
