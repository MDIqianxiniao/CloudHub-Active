//
//  CHSetToolView.m
//  CloudHub Active
//
//  Created by 马迪 on 2021/4/26.
//

#import "CHSetToolView.h"
#import "CHImageTitleButtonView.h"

#define leftMargin  10
#define ButtonWidth  (self.ch_width - 2 * leftMargin)/4
#define ButtonHeight  60

@interface CHSetToolView ()

@property (nonatomic, assign) CHUserRoleType roleType;

@property (nonatomic, weak) CHImageTitleButtonView *linkMicButton;

@property (nonatomic, weak) CHImageTitleButtonView *cameraButton;

@property (nonatomic, weak) CHImageTitleButtonView *micButton;

@property (nonatomic, weak) CHImageTitleButtonView *switchCamButton;

@property (nonatomic, weak) CHImageTitleButtonView *setButton;

@end

@implementation CHSetToolView

- (instancetype)initWithFrame:(CGRect)frame  WithUserType:(CHUserRoleType)roleType;
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = CHWhiteColor;
        
        self.roleType = roleType;
        
        [self setupUI];
        
        self.frame = frame;
    }
    return self;
}

- (void)setupUI
{
    UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.ch_width, 70)];
    titleLable.text = CH_Localized(@"Live_Tools");
    titleLable.font = CHFont15;
    titleLable.textColor = CHColor_6D7278;
    titleLable.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:titleLable];
    
    
    CHImageTitleButtonView * cameraButton = [self creatButtonWithTitle:CH_Localized(@"Live_Tools_MuteCam") selectTitle:CH_Localized(@"Live_Tools_UnMuteCam") image:[UIImage imageNamed:@"live_tools_cameraOpen"] selectImage:[UIImage imageNamed:@"live_tools_cameraClose"]];
    cameraButton.tag = CHSetToolViewButton_Camera;
    self.cameraButton = cameraButton;
    
    CHImageTitleButtonView * micButton = [self creatButtonWithTitle:CH_Localized(@"Live_Tools_MuteMic") selectTitle:CH_Localized(@"Live_Tools_UnMuteMic") image:[UIImage imageNamed:@"live_tools_soundOpen"] selectImage:[UIImage imageNamed:@"live_tools_soundClose"]];
    micButton.tag = CHSetToolViewButton_Mic;
    self.micButton = micButton;
    
    CHImageTitleButtonView * switchCamButton = [self creatButtonWithTitle:CH_Localized(@"Live_Tools_SwitchCam") selectTitle:nil image:[UIImage imageNamed:@"live_tools_switchCamera"] selectImage:nil];
    switchCamButton.tag = CHSetToolViewButton_SwitchCam;
    self.switchCamButton = switchCamButton;
    
    CHImageTitleButtonView * setButton = [self creatButtonWithTitle:CH_Localized(@"Live_Tools_VideoSet") selectTitle:nil image:[UIImage imageNamed:@"live_tools_set"] selectImage:nil];
    setButton.tag = CHSetToolViewButton_VideoSet;
    self.setButton = setButton;
    
    if (self.roleType == CHUserType_Audience)
    {
        CHImageTitleButtonView * linkMicButton = [self creatButtonWithTitle:CH_Localized(@"Live_Tools_LinkMic") selectTitle:CH_Localized(@"Live_Tools_DisMiv") image:[UIImage imageNamed:@"live_tools_linkMic"] selectImage:[UIImage imageNamed:@"live_tools_disMic"]];
        linkMicButton.tag = CHSetToolViewButton_LinkMic;
        self.linkMicButton = linkMicButton;
        
        cameraButton.hidden = YES;
        micButton.hidden = YES;
        switchCamButton.hidden = YES;
        setButton.hidden = YES;
    }
}

///创建button
- (CHImageTitleButtonView *)creatButtonWithTitle:(NSString *)title selectTitle:(NSString *)selectTitle image:(UIImage *)image selectImage:(UIImage *)selectImage
{
    CHImageTitleButtonView * button = [[CHImageTitleButtonView alloc]init];
    button.userInteractionEnabled = YES;
    button.type = CHImageTitleButtonView_ImageTop;
    [button addTarget:self action:@selector(buttonsClick:) forControlEvents:UIControlEventTouchUpInside];
    button.textNormalColor = CHColor_6D7278;
    button.textFont= CHFont13;
    button.normalText = title;
    
    if (selectTitle.length)
    {
        button.selectedText = selectTitle;
    }
    
    button.normalImage = image;
    if (selectImage)
    {
        button.selectedImage = selectImage;
    }
    
    [self addSubview:button];
    return button;
}

- (void)setFrame:(CGRect)frame
{
    if (self.roleType == CHUserType_Audience)
    {
        self.linkMicButton.frame = CGRectMake(leftMargin, 70, ButtonWidth, ButtonHeight);
        self.cameraButton.frame = CGRectMake(leftMargin + ButtonWidth, 70, ButtonWidth, ButtonHeight);
        self.micButton.frame = CGRectMake(leftMargin + 2 * ButtonWidth, 70, ButtonWidth, ButtonHeight);
        self.switchCamButton.frame = CGRectMake(leftMargin + 3 * ButtonWidth, 70, ButtonWidth, ButtonHeight);
        self.setButton.frame = CGRectMake(leftMargin, self.switchCamButton.ch_bottom + 5, ButtonWidth, ButtonHeight);
        frame.size.height = self.setButton.ch_bottom + 20;
    }
    else
    {
        self.cameraButton.frame = CGRectMake(leftMargin, 70, ButtonWidth, ButtonHeight);
        self.micButton.frame = CGRectMake(leftMargin + ButtonWidth, 70, ButtonWidth, ButtonHeight);
        self.switchCamButton.frame = CGRectMake(leftMargin + 2 * ButtonWidth, 70, ButtonWidth, ButtonHeight);
        self.setButton.frame = CGRectMake(leftMargin + 3 * ButtonWidth, 70, ButtonWidth, ButtonHeight);
        frame.size.height = self.setButton.ch_bottom + 70;
    }
    
    [super setFrame:frame];
}

- (void)setIsUpStage:(BOOL)isUpStage
{
    _isUpStage = isUpStage;
    
    self.linkMicButton.selected = isUpStage;
    
    self.cameraButton.hidden = !isUpStage;
    self.micButton.hidden = !isUpStage;
    self.switchCamButton.hidden = !isUpStage;
    self.setButton.hidden = !isUpStage;
}

- (void)buttonsClick:(UIButton *)button
{
    if (_setToolViewButtonsClick)
    {
        _setToolViewButtonsClick(button);
    }
}


@end
