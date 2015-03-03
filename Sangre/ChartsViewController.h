//
//  ChartsViewController.h
//  Sangre
//
//  Created by Bharat Mediratta on 2/25/15.
//  Copyright (c) 2015 Menalto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChartsViewController : UIViewController <UIScrollViewDelegate>
- (IBAction)pageDidScroll:(id)sender;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;
@end

