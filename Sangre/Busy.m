//  BusyViewController.m
//  Sangre
//
//  Created by Bharat Mediratta on 2/16/15.
//  Copyright (c) 2015 Menalto. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "Busy.h"


@implementation Busy {
    UIView* mOverlay;
    UIActivityIndicatorView *mSpinner;
    UIView* mParentView;
}

- (id) init:(UIView*)parentView {
    self = [super init];
    mParentView = parentView;
    mOverlay = [[UIView alloc] init];
    mOverlay.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    mSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [mOverlay addSubview:mSpinner];
    [mParentView addSubview:mOverlay];
    return self;
}

- (void) start {
    mOverlay.frame = mParentView.frame;
    mSpinner.center = mOverlay.center;
    [mSpinner startAnimating];
}

- (void) stop {
    mOverlay.frame = CGRectMake(0, 0, 0, 0);
    [mSpinner stopAnimating];
}
@end
