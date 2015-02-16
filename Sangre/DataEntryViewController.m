//
//  DataEntryViewController.m
//  Sangre
//
//  Created by Bharat Mediratta on 2/13/15.
//  Copyright (c) 2015 Menalto. All rights reserved.
//

#import "DataEntryViewController.h"
#import "Backend.h"

@implementation DataEntryViewController {
    Backend* mBackend;
    UIView* mActivityOverlay;
    UIActivityIndicatorView* mActivityIndicator;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    mBackend = [Backend singleton];
}

- (IBAction)addBgValue:(id)sender {
    [self.view endEditing:YES];
    [mBackend addBgValue:[[self bgValue] text]
                 andThen:^(BOOL success){
                     [self bgValueAdded];
                 }
     ];
}

- (void) bgValueAdded {
    [[self tabBarController] setSelectedIndex:0];
}


- (IBAction)cancel:(id)sender {
    [self.view endEditing:YES];
    [[self tabBarController] setSelectedIndex:0];
}


- (void) startBeingBusy {
    mActivityOverlay = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    mActivityOverlay.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    mActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    mActivityIndicator.center = mActivityOverlay.center;
    [mActivityOverlay addSubview:mActivityIndicator];
    [mActivityIndicator startAnimating];
    [self.view addSubview:mActivityOverlay];
}


- (void) stopBeingBusy {
    [mActivityOverlay removeFromSuperview];
    [mActivityOverlay dealloc];
}


- (void)dealloc {
    [_bgValue release];
    [super dealloc];
}
@end
