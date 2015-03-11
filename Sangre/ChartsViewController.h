//
//  ChartsViewController.h
//  Sangre
//
//  Created by Bharat Mediratta on 2/25/15.
//  Copyright (c) 2015 Menalto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusyViewController.h"

@interface ChartsViewController : BusyViewController <UIScrollViewDelegate>
- (IBAction)pageDidScroll:(id)sender;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;
@end

