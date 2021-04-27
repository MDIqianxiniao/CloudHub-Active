//
//  CHLiveRoomFrontView.h
//  CloudHub Active
//
//  Created by 马迪 on 2021/4/25.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    CHLiveRoomFrontButton_userList,
    CHLiveRoomFrontButton_Back,
    CHLiveRoomFrontButton_Tools,
    CHLiveRoomFrontButton_Music,
    CHLiveRoomFrontButton_Beauty,
} CHLiveRoomFrontButton;

NS_ASSUME_NONNULL_BEGIN

@interface CHLiveRoomFrontView : UIView

@property (nonatomic, copy) NSString *nickName;

@property (nonatomic, strong) NSMutableArray *userList;

@property (nonatomic, weak) UITextView *inputView;

@property (nonatomic, strong) NSMutableArray <CHChatMessageModel *> *SCMessageList;

/// 当前用户是否上台
@property (nonatomic, assign) BOOL isUpStage;

@property (nonatomic, copy) void(^liveRoomFrontViewButtonsClick)(UIButton *button);

@property (nonatomic, copy) void(^sendMessage)(NSString *message);


- (instancetype)initWithFrame:(CGRect)frame WithUserType:(CHUserRoleType)roleType;

@end

NS_ASSUME_NONNULL_END
