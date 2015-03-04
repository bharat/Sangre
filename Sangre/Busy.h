//
//  BusyViewController.h
//  Sangre
//
//  Created by Bharat Mediratta on 2/13/15.
//  Copyright (c) 2015 Menalto. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BusyViewStyle) {
    BusyViewStyleRegular,
    BusyViewStyleSmallAndRounded
};

@interface Busy : NSObject
- (id) init:(UIView*)parentView;
- (id) init:(UIView*)parentView withStyle:(BusyViewStyle)style;
- (void) start;
- (void) stop;
@end

