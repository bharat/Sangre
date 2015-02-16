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

#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    mBackend = [Backend singleton];
}

#pragma mark NSObject

- (void)dealloc {
    [_bgValue release];
    [super dealloc];
}

#pragma mark DataEntryViewController

- (IBAction)addBgValue:(id)sender {
    [self startBeingBusy];
    [self.view endEditing:YES];
    [mBackend addBgValue:[[self bgValue] text]
                 andThen:^(BOOL success){
                     [self bgValueAdded];
                 }
     ];
}

- (void) bgValueAdded {
    [self stopBeingBusy];
    [self switchToHistoryTab];
}


- (IBAction)cancel:(id)sender {
    [self.view endEditing:YES];
    [self switchToHistoryTab];
}


- (void) switchToHistoryTab {
    [self.tabBarController setSelectedIndex:0];
    [self.tabBarController.delegate tabBarController:self.tabBarController
                             didSelectViewController:[self.tabBarController.viewControllers
                                                      objectAtIndex:0]];
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
@end
