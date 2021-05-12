//
//  CHVideoView.m
//  CloudHub
//
//  Created by jiang deng on 2021/1/29.
//  Copyright 2019 The CloudHub project authors. All Rights Reserved.

#import "CHVideoView.h"

@interface CHVideoView ()

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIView *coverView;

@property (nonatomic, strong) UILabel *nickNameLabel;
@property (nonatomic, strong) UIImageView *volumeImageView;

@property (nonatomic, strong) UIButton *removeButton;

@property (nonatomic, assign) NSUInteger volumeStep;

@end

@implementation CHVideoView

- (void)dealloc
{
    [self.roomUser removeObserver:self forKeyPath:@"volume"];
    [self.roomUser removeObserver:self forKeyPath:@"muteAudio"];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = CHColor_40424A;
        
        UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:bgImageView];
        bgImageView.image = [UIImage imageNamed:@"icon_videoClose"];
        bgImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.bgImageView = bgImageView;
        
        if (self.ch_width > CHUI_SCREEN_WIDTH * 0.5)
        {
            bgImageView.frame = CGRectMake(self.ch_width * (1 - 0.2) * 0.5, self.ch_height * (1 - 0.2) *0.5, self.ch_width * 0.2, self.ch_height * 0.2);
        }
        
        UIView *contentView = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:contentView];
        contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        contentView.backgroundColor = UIColor.clearColor;
        self.contentView = contentView;

        UIView *coverView = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:coverView];
        coverView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        coverView.backgroundColor = UIColor.clearColor;
        self.coverView = coverView;
        coverView.layer.borderWidth = 2.0f;
        coverView.layer.borderColor = [UIColor ch_colorWithHex:0x666666 alpha:0.3].CGColor;
        
        self.nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 24)];
        self.nickNameLabel.backgroundColor = [UIColor clearColor];
        self.nickNameLabel.font = [UIFont systemFontOfSize:14.0f];
        self.nickNameLabel.textColor = UIColor.whiteColor;
        self.nickNameLabel.adjustsFontSizeToFitWidth = YES;
        self.nickNameLabel.minimumScaleFactor = 0.3f;
        self.nickNameLabel.hidden = NO;
        [self.coverView addSubview:self.nickNameLabel];

        self.volumeImageView = [[UIImageView alloc] init];
        self.volumeImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.coverView addSubview:self.volumeImageView];
        self.volumeImageView.image = [UIImage imageNamed:@"videoView_sound_no_skin"];

        self.volumeStep = 0;
        
        UIButton *removeButton = [[UIButton alloc]init];
        [removeButton setImage:[UIImage imageNamed:@"video_remove"] forState:UIControlStateNormal];
        [removeButton addTarget:self action:@selector(removeButtonClick) forControlEvents:UIControlEventTouchUpInside];
        removeButton.hidden = YES;
        self.removeButton = removeButton;
        [self.coverView addSubview:removeButton];
        
        UITapGestureRecognizer *click = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAction:)];
        click.numberOfTapsRequired = 1;
        [self addGestureRecognizer:click];
    }
    
    return self;
}

- (void)removeButtonClick
{
    if ([self.delegate respondsToSelector:@selector(clickRemoveButtonToCloseVideoView:)])
    {
        [self.delegate clickRemoveButtonToCloseVideoView:self];
    }
}

- (void)clickAction:(UITapGestureRecognizer *)tap
{
    // view click
    if ([self.delegate respondsToSelector:@selector(clickViewToControlWithVideoView:)])
    {
        [self.delegate clickViewToControlWithVideoView:self];
    }
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    CGFloat maxW = 25.0f;
    CGFloat minW = 7.0f;

    CGFloat height = self.ch_width*0.1f;
    if ([UIDevice ch_isiPad])
    {
        minW = 12.0f;
    }
    else
    {
        minW = 10.0f;
    }
    if (height < minW)
    {
        height = minW;
    }
    
    if (!self.isBigView)
    {
        self.nickNameLabel.frame = CGRectMake(4.0f, self.ch_height-4.0f-height, self.ch_width*0.6f, height);
    }
        
    CGFloat fontSize = height-5.0f;
    if ([UIDevice ch_isiPad])
    {
        maxW = 20.0f;
    }
    else
    {
        maxW = 16.0f;
    }
    
    if (fontSize<1)
    {
        fontSize = 1.0f;
    }
    else if (fontSize>maxW)
    {
        fontSize = maxW;
    }
    self.nickNameLabel.font = [UIFont systemFontOfSize:fontSize];
    
    if ([UIDevice ch_isiPad])
    {
        maxW = 55.0f;
        minW = 20;
    }
    else
    {
        maxW = 40;
        minW = 15;
    }
    
    CGFloat volumeImageWidth = height*5/3;
    if (volumeImageWidth > maxW)
    {
        volumeImageWidth = maxW;
    }
    else if (volumeImageWidth < minW)
    {
        volumeImageWidth = minW;
    }
    
    if (self.isBigView)
    {
        self.volumeImageView.frame = CGRectMake(4.0f, 60.0f, volumeImageWidth, volumeImageWidth);
        self.nickNameLabel.frame = CGRectMake(volumeImageWidth+10.0f, 60.0f, self.ch_width*0.4f, volumeImageWidth);
    }
    else
    {
        self.volumeImageView.frame = CGRectMake(self.ch_width-5-volumeImageWidth, self.ch_height-4-height, volumeImageWidth, height);
    }
    
    self.removeButton.frame = CGRectMake(self.ch_width - 22.0f, 0, 22.0f, 22.0f);
    
    CGRect imageFrame = CGRectMake(0, 0, self.ch_width*0.3f, self.ch_width*0.4f);
    self.bgImageView.frame = imageFrame;
    [self.bgImageView ch_centerInSuperView];
}

- (void)setCanRemove:(BOOL)canRemove
{
    _canRemove = canRemove;
    
    self.removeButton.hidden = !canRemove;
}

- (void)setIsBigView:(BOOL)isBigView
{
    _isBigView = isBigView;
    
    if (isBigView)
    {
        self.coverView.layer.borderWidth = 0;
        self.coverView.layer.borderColor = nil;
        self.volumeImageView.image = [UIImage imageNamed:@"videoView_bigsound_no_skin"];
    }
    else
    {
        self.volumeImageView.image = [UIImage imageNamed:@"videoView_sound_no_skin"];
    }
}

- (void)setRoomUser:(CHRoomUser *)roomUser
{
    [self.roomUser removeObserver:self forKeyPath:@"volume"];
    [self.roomUser removeObserver:self forKeyPath:@"muteAudio"];

    _roomUser = roomUser;
    
//    if (self.roomType == CHRoomUseTypeLiveRoom && roomUser.role == CHUserType_Anchor)
    if (roomUser.role == CHUserType_Anchor)
    {
        self.nickNameLabel.text = @"";
    }
    else
    {
        self.nickNameLabel.text = roomUser.nickName;
    }
    
    [self setVolume:roomUser.volume];
    [self setMuteAudio:roomUser.muteAudio];

    // volume
    [self.roomUser addObserver:self forKeyPath:@"volume" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    // mute
    [self.roomUser addObserver:self forKeyPath:@"muteAudio" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"volume"])
    {
        NSInteger oldValue = [change ch_intForKey:NSKeyValueChangeOldKey];
        NSInteger newValue = [change ch_intForKey:NSKeyValueChangeNewKey];
        
        if (oldValue != newValue)
        {
            [self setVolume:newValue];
        }
    }
    else if ([keyPath isEqualToString:@"muteAudio"])
    {
        BOOL oldValue = [change ch_boolForKey:NSKeyValueChangeOldKey];
        BOOL newValue = [change ch_boolForKey:NSKeyValueChangeNewKey];
        
        if (oldValue != newValue)
        {
            [self setMuteAudio:newValue];
        }
    }
}

- (void)setVolume:(NSUInteger)volume
{
    // Sound Volume 0 ～ 255

    CGFloat volumeScale = 255/3;
    
    // 4 step
    if (volume < 5)
    {
        self.volumeStep = 0;
    }
    else if (volume <= volumeScale)
    {
        self.volumeStep = 1;
    }
    else if (volume <= volumeScale*2)
    {
        self.volumeStep = 2;
    }
    else if (volume > volumeScale*2)
    {
        self.volumeStep = 3;
    }
}

- (void)setVolumeStep:(NSUInteger)volumeStep
{
    if (volumeStep == _volumeStep)
    {
        return;
    }
    
    _volumeStep = volumeStep;
    
    // 4 step
    if (self.isBigView)
    {
        switch (volumeStep)
        {
            case 1:
                self.volumeImageView.image = [UIImage imageNamed:@"videoView_bigsound_1_skin"];
                break;
                
            case 2:
                self.volumeImageView.image = [UIImage imageNamed:@"videoView_bigsound_2_skin"];
                break;
                
            case 3:
                self.volumeImageView.image = [UIImage imageNamed:@"videoView_bigsound_3_skin"];
                break;
                
            case 0:
            default:
                self.volumeImageView.image = [UIImage imageNamed:@"videoView_bigsound_no_skin"];
                break;
        }
    }
    else
    {
        switch (volumeStep)
        {
            case 1:
                self.volumeImageView.image = [UIImage imageNamed:@"videoView_sound_1_skin"];
                break;
                
            case 2:
                self.volumeImageView.image = [UIImage imageNamed:@"videoView_sound_2_skin"];
                break;
                
            case 3:
                self.volumeImageView.image = [UIImage imageNamed:@"videoView_sound_3_skin"];
                break;
                
            case 0:
            default:
                self.volumeImageView.image = [UIImage imageNamed:@"videoView_sound_no_skin"];
                break;
        }
    }
}

- (void)setMuteAudio:(BOOL)muteAudio
{
    if (self.isBigView)
    {
        if (muteAudio)
        {
            self.volumeImageView.image = [UIImage imageNamed:@"videoView_bigbeSilent_skin"];
        }
        else
        {
            self.volumeImageView.image = [UIImage imageNamed:@"videoView_bigsound_no_skin"];
        }
    }
    else
    {
        if (muteAudio)
        {
            self.volumeImageView.image = [UIImage imageNamed:@"videoView_beSilent_skin"];
        }
        else
        {
            self.volumeImageView.image = [UIImage imageNamed:@"videoView_sound_no_skin"];
        }
    }
    
    [self freshWithRoomUserProperty];
}

- (void)freshWithRoomUserProperty
{
    // audio device error code
    CHDeviceFaultType afail = self.roomUser.afail;
    switch (afail)
    {
        // none
        case CHDeviceFaultNone:
            break;
            
        // not found
        case CHDeviceFaultNotFind:
        {
            self.volumeImageView.image = [UIImage imageNamed:@"videoView_noMic_skin"];
        }
            break;
            
        // forbidden
        case CHDeviceFaultNotAuth:
        {
            self.volumeImageView.image = [UIImage imageNamed:@"videoView_disableMic_skin"];
        }
            break;
            
        // occupied
        case CHDeviceFaultOccupied:
        {
            self.volumeImageView.image = [UIImage imageNamed:@"videoView_occupyMic_skin"];
        }
            break;
            
        // open failed
        default:
        {
            self.volumeImageView.image = [UIImage imageNamed:@"videoView_unknownMic_skin"];
        }
            break;
    }
    
    /*
    // video device error code
    CHDeviceFaultType vfail = [self.roomUser getVideoVfailWithSourceId:self.sourceId];
    switch (vfail)
    {
        // none
        case CHDeviceFaultNone:
            self.bgImageView.image = [UIImage imageNamed:@"icon_videoClose"];
            break;
                
        // not found
        case CHDeviceFaultNotFind:
        {
            self.bgImageView.image = [UIImage imageNamed:@"videoView_noCamera_skin"];
        }
            break;
            
        // forbidden
        case CHDeviceFaultNotAuth:
        {
            self.bgImageView.image = [UIImage imageNamed:@"videoView_disableCamera_skin"];
        }
            break;
            
        // occupied
        case CHDeviceFaultOccupied:
        {
            self.bgImageView.image = [UIImage imageNamed:@"videoView_occupyCamera_skin"];
        }
            break;

        // open failed
        default:
        {
            self.bgImageView.image = [UIImage imageNamed:@"videoView_unknownCamera_skin"];
        }
            break;
    }
     */
}




@end
