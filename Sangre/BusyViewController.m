//
//  BusyViewController.m
//  Sangre
//
//  Created by Bharat Mediratta on 2/16/15.
//  Copyright (c) 2015 Menalto. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "BusyViewController.h"

@implementation BusyViewController {
    UIView* mActivityOverlay;
    UIActivityIndicatorView* mActivityIndicator;
}

- (void) startBeingBusy {
    if (mActivityOverlay) {
        return;
    }

    mActivityOverlay = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    mActivityOverlay.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    mActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    mActivityIndicator.center = mActivityOverlay.center;
    [mActivityOverlay addSubview:mActivityIndicator];
    [mActivityIndicator startAnimating];
    [self.view addSubview:mActivityOverlay];
}

- (void) stopBeingBusy {
    if (mActivityOverlay) {
        [mActivityOverlay removeFromSuperview];
        [mActivityOverlay dealloc];
        mActivityOverlay = nil;
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self stopBeingBusy];
}
@end
