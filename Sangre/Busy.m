//  BusyViewController.m
//  Sangre
//
//  Created by Bharat Mediratta on 2/16/15.
//  Copyright (c) 2015 Menalto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#include "Busy.h"


@implementation Busy {
    UIView* mOverlay;
    UIActivityIndicatorView *mSpinner;
    UIView* mParentView;
    BusyViewStyle mStyle;
}

- (id) init:(UIView*)parentView {
    self = [super init];
    mParentView = parentView;
    mOverlay = [[UIView alloc] init];
    mOverlay.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    mSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [mOverlay addSubview:mSpinner];
    [mParentView addSubview:mOverlay];
    mStyle = BusyViewStyleRegular;
    return self;
}

- (id) init:(UIView *)parentView withStyle:(BusyViewStyle)style {
    self = [self init:parentView];
    mStyle = style;
    
    if (mStyle == BusyViewStyleSmallAndRounded) {
        mOverlay.layer.cornerRadius = 5;
        mOverlay.layer.masksToBounds = YES;
    }
    return self;
}

- (void) start {
    mOverlay.frame = mParentView.bounds;

    mOverlay.frame = CGRectInset(mOverlay.frame, 20, 20);
    
    /*
    if (mStyle == BusyViewStyleSmallAndRounded) {
        mOverlay.frame = mParentView.frame;
        mOverlay.center = mParentView.center;
    }
     */
    
    mSpinner.center = mOverlay.center;
    [mSpinner startAnimating];
}

- (void) stop {
    //mOverlay.frame = CGRectMake(0, 0, 0, 0);
    //[mSpinner stopAnimating];
}
@end
