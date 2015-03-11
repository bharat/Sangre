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

@interface Page : NSObject
- (id) init:(const NSString*)urlString forParent:(UIView*)parent;
- (void) load:(void (^)(void))callback;
- (BOOL) isLoaded;
- (void) setFrame:(CGRect)frame;
@end

@implementation Page {
    NSURL* mURL;
    UIImageView* mView;
    UIView* mParent;
    CGRect mFrame;
    BOOL mLoaded;
}

- (id) init:(const NSString *)urlString forParent:(UIView *)parent{
    self = [super init];
    mLoaded = NO;
    mURL = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    mParent = parent;
    mView = [[UIImageView alloc] init];
    mView.contentMode = UIViewContentModeScaleAspectFit;
    [mParent addSubview:mView];

    return self;
}

- (void)setFrame:(CGRect)frame {
    mFrame = frame;
    mView.frame = CGRectOffset(CGRectInset(mFrame, 16, 16), -8, 8);
}

- (void)load:(void (^)(void))callback {
    if (mLoaded) {
        return;
    }

    // Load the image in the background
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
        NSData* chartImageData = [[NSData alloc] initWithContentsOfURL:mURL];
        UIImage* image = [[UIImage alloc] initWithData:chartImageData];

        // But switch to the main thread to add the image subview
        dispatch_async(dispatch_get_main_queue(), ^{
            [mView setImage:image];
            mLoaded = YES;
            callback();
        });
    });
}

- (BOOL)isLoaded {
    return mLoaded;
}
@end


@interface ChartsViewController ()
- (void)loadVisiblePages;
@end

@implementation ChartsViewController {
    NSMutableArray* mPages;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    mPages = [[NSMutableArray alloc] init];
    [mPages addObject:[[Page alloc] init:kDailyAverageUrl forParent:self.scrollView]];
    [mPages addObject:[[Page alloc] init:kHourlyAverageUrl forParent:self.scrollView]];

    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = [mPages count];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self resetSizes];
    [self loadVisiblePages];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar.topItem setTitle:[self.tabBarItem title]];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self resetSizes];
    [self loadVisiblePages];
}

- (void)resetSizes {
    CGSize size = self.scrollView.frame.size;
    self.scrollView.contentSize = CGSizeMake(size.width * [mPages count], size.height);

    for (int i = 0; i < mPages.count; i++) {
        Page* page = (Page*)[mPages objectAtIndex:i];
        CGRect targetFrame = self.scrollView.bounds;
        targetFrame.origin.x = targetFrame.size.width * i;
        targetFrame.origin.y = 0.0f;
        [page setFrame:targetFrame];
    }
}

- (void)loadVisiblePages {
    CGFloat pageWidth = self.scrollView.frame.size.width;
    NSInteger pageIndex = (NSInteger)floor((self.scrollView.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
    self.pageControl.currentPage = pageIndex;

    for (NSInteger i = pageIndex - 1; i <= pageIndex + 1; i++) {
        if (i < 0 || i >= [mPages count]) {
            continue;
        }
        Page* page = (Page*)[mPages objectAtIndex:i];
        if (![page isLoaded]) {
            [self startBeingBusy];
            [page load:^{
                [self stopBeingBusy];
            }];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self loadVisiblePages];
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
