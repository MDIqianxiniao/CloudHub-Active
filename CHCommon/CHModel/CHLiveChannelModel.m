//
//  CHLiveChannelModel.m
//  CloudHub Active
//
//  Created by 马迪 on 2021/4/20.
//

#import "CHLiveChannelModel.h"

@implementation CHLiveChannelModel

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.videowidth = 320;
        self.videoheight = 240;
        self.rate = 15;
    }
    
    return self;
}


@end
