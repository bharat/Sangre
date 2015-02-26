//
//  ChartsViewController.m
//  Sangre
//
//  Created by Bharat Mediratta on 2/25/15.
//  Copyright (c) 2015 Menalto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChartsViewController.h"

const NSString* kChartURL = @"https://docs.google.com/spreadsheets/d/1SCVZzclIEYrSohgpmg5oy4WXWW0P8-3eZnOjRL_dyWc/pubchart?oid=265302356&format=image";

@implementation ChartsViewController

- (void)loadImage {
    [self startBeingBusy];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
        // download the chart and set it in the imageView
        NSString* chartURL = [kChartURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSData* chartImageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:chartURL]];
        UIImage* image = [[UIImage alloc] initWithData:chartImageData];
        [chartImageData release];

        dispatch_async(dispatch_get_main_queue(), ^{
            // set the image view image to the appropriate size and image for the orientation
            self.imageView.image = image;
            self.imageView.frame = CGRectInset(self.view.bounds, 4, 4);
            [self stopBeingBusy];
        });
    });
}

- (void) viewDidAppear:(BOOL)animated {
    [self.navigationController.navigationBar.topItem setTitle:[self.tabBarItem title]];
    [self loadImage];
}
@end