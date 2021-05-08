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
    CHLiveRoomFrontButton_Chat,
} CHLiveRoomFrontButton;

NS_ASSUME_NONNULL_BEGIN

@interface CHLiveRoomFrontView : UIView

@property (nonatomic, copy) NSString *nickName;

@property (nonatomic, assign) NSInteger userNum;

//@property (nonatomic, weak) UITextView *inputView;

@property (nonatomic, strong) NSMutableArray <CHChatMessageModel *> *messageList;

/// 当前用户是否上台
@property (nonatomic, assign) BOOL isUpStage;

@property (nonatomic, copy) void(^liveRoomFrontViewButtonsClick)(UIButton *button);


- (instancetype)initWithFrame:(CGRect)frame WithUserType:(CHUserRoleType)roleType;

@end

NS_ASSUME_NONNULL_END
