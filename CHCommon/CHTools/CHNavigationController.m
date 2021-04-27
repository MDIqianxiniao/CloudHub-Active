//
//  CHNavigationController.m
//  CloudHub
//
//  Created by fzxm on 2021/2/24.
//  Copyright 2019 The CloudHub project authors. All Rights Reserved.
//

#import "CHNavigationController.h"

@interface CHNavigationController ()

@end

@implementation CHNavigationController

- (BOOL)shouldAutorotate
{
    return [self.topViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [self.topViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [self.topViewController preferredInterfaceOrientationForPresentation];
}

@end
