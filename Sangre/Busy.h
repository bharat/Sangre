//
//  BusyViewController.h
//  Sangre
//
//  Created by Bharat Mediratta on 2/13/15.
//  Copyright (c) 2015 Menalto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Busy : NSObject
- (id) init:(UIView*)parentView;
- (void) start;
- (void) stop;
@end

