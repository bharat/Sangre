//
//  ChartsViewController.m
//  Sangre
//
//  Created by Bharat Mediratta on 2/25/15.
//  Copyright (c) 2015 Menalto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChartsViewController.h"

@implementation ChartsViewController {
    UIImageView* mChartImgView;
    UIImage* mChartImg;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self startBeingBusy];
    
    // add image view to mainview
    mChartImgView = [[UIImageView alloc] init];
    [mChartImgView setContentMode:UIViewContentModeScaleToFill];
    
    NSString* chartURL = @"https://docs.google.com/spreadsheets/d/1SCVZzclIEYrSohgpmg5oy4WXWW0P8-3eZnOjRL_dyWc/pubchart?oid=265302356&format=image";
    
    // append size of graph
    CGSize size = self.view.frame.size;
    NSString* dimensions = [NSString stringWithFormat:@"&chs=%dx%d", (int)size.width, (int)size.height];
    chartURL = [chartURL stringByAppendingString:dimensions];
    NSLog(@"%@", chartURL);
          
    // download the chart and set it in the imageView
    chartURL = [chartURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSData* chartImageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:chartURL]];
    mChartImg = [[UIImage alloc] initWithData:chartImageData];
    [chartImageData release];
    
    // set the image view image to the appropriate size and image for the orientation
    mChartImgView.image = mChartImg;
    mChartImgView.frame = [self.view frame];
    
    // add to view
    [self.view addSubview:mChartImgView];
    self.view.autoresizesSubviews = YES;
    [self stopBeingBusy];
}
@end