//
//  ChartsViewController.m
//  Sangre
//
//  Created by Bharat Mediratta on 2/25/15.
//  Copyright (c) 2015 Menalto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChartsViewController.h"

NSString* kChartURL = @"https://docs.google.com/spreadsheets/d/1SCVZzclIEYrSohgpmg5oy4WXWW0P8-3eZnOjRL_dyWc/pubchart?oid=265302356&format=image";

@implementation ChartsViewController

- (void)loadImage:(NSString *)chartURL {
    // download the chart and set it in the imageView
    chartURL = [chartURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSData* chartImageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:chartURL]];
    UIImage* image = [[UIImage alloc] initWithData:chartImageData];
    [chartImageData release];
    
    // set the image view image to the appropriate size and image for the orientation
    self.imageView.image = image;
    self.imageView.frame = CGRectInset(self.view.bounds, 4, 4);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadImage:kChartURL];
}

- (void) viewDidAppear:(BOOL)animated {
    [self.navigationController.navigationBar.topItem setTitle:[self.tabBarItem title]];
}

- (void)dealloc {
    [_imageView release];
    [super dealloc];
}
@end