//
//  ChartsViewController.m
//  Sangre
//
//  Created by Bharat Mediratta on 2/25/15.
//  Copyright (c) 2015 Menalto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChartsViewController.h"

const NSString* kDailyAverageUrl = @"https://docs.google.com/spreadsheets/d/1SCVZzclIEYrSohgpmg5oy4WXWW0P8-3eZnOjRL_dyWc/pubchart?oid=265302356&format=image";

const NSString* kHourlyAverageUrl = @"https://docs.google.com/spreadsheets/d/1SCVZzclIEYrSohgpmg5oy4WXWW0P8-3eZnOjRL_dyWc/pubchart?oid=1308422647&format=image";


@interface ChartsViewController ()
@property (nonatomic, strong) NSArray *pageImageURLs;
@property (nonatomic, strong) NSMutableArray *pageViews;

- (void)loadVisiblePages;
- (void)loadPage:(NSInteger)page;
@end

@implementation ChartsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.pageImageURLs = [NSArray arrayWithObjects:
                          kDailyAverageUrl,
                          kHourlyAverageUrl,
                          nil];

    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = self.pageImageURLs.count;

    self.pageViews = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < self.pageImageURLs.count; ++i) {
        [self.pageViews addObject:[NSNull null]];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    CGSize size = self.scrollView.frame.size;
    self.scrollView.contentSize = CGSizeMake(size.width * self.pageImageURLs.count, size.height);

    [self loadVisiblePages];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    // After rotation, reset the UIScrollView's content size to the size of the frame, otherwise
    // the content size will be larger than the physical space and we'll wind up with both vertical
    // and horizontal scrolling.
    CGSize frame = self.scrollView.frame.size;
    self.scrollView.contentSize = CGSizeMake(frame.width * self.pageImageURLs.count, frame.height);

    for (UIView* view in [self.scrollView subviews]) {
        [view removeFromSuperview];
    }
    for (NSInteger i = 0; i < self.pageImageURLs.count; ++i) {
        [self.pageViews replaceObjectAtIndex:i withObject:[NSNull null]];
    }

    [self loadVisiblePages];
}

- (void)loadPage:(NSInteger)page {
    if (page < 0 || page >= self.pageImageURLs.count) {
        // outside of displayable range - ignore
        return;
    }

    UIView* pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull*)pageView == [NSNull null]) {
        // Replace the placeholder with an actual image
        CGRect targetFrame = self.scrollView.bounds;
        targetFrame.origin.x = targetFrame.size.width * page;
        targetFrame.origin.y = 0.0f;

        NSString* urlString = [self.pageImageURLs objectAtIndex:page];
        NSString* chartURL = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        // Load the image in the background
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
            NSData* chartImageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:chartURL]];
            UIImage* image = [[UIImage alloc] initWithData:chartImageData];

            // But switch to the main thread to add the image subview
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImageView *view = [[UIImageView alloc] initWithImage:image];
                view.contentMode = UIViewContentModeScaleAspectFit;
                view.frame = CGRectOffset(CGRectInset(targetFrame, 16, 0), -8, 0);

                [self.scrollView addSubview:view];
                [self.pageViews replaceObjectAtIndex:page withObject:view];
            });
        });

    }
}

- (void)loadVisiblePages {
    CGFloat pageWidth = self.scrollView.frame.size.width;
    NSInteger page = (NSInteger)floor((self.scrollView.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
    self.pageControl.currentPage = page;
    for (NSInteger i = page - 1; i <= page + 1; i++) {
        [self loadPage:i];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Load the pages that are now on screen
    [self loadVisiblePages];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar.topItem setTitle:[self.tabBarItem title]];
}

- (void)dealloc {
    [_pageControl release];
    [_scrollView release];
    [super dealloc];
}

- (IBAction)pageDidScroll:(id)sender {
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width * [[self pageControl] currentPage];
    frame.origin.y = 0;
    [self.scrollView scrollRectToVisible:frame animated:YES];
}
@end
