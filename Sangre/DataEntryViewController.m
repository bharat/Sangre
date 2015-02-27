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
}

#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    mBackend = [Backend singleton];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar.topItem setTitle:[self.tabBarItem title]];
}

#pragma mark NSObject

- (void)dealloc {
    [_bgValue release];
    [super dealloc];
}

#pragma mark DataEntryViewController

- (IBAction)addBgValue:(id)sender {
    NSInteger value = [[[self bgValue] text] intValue];
    if (value <= 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid entry"
                                                        message:@"Blood glucose entries must be a value greater than zero."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }

    [self startBeingBusy];
    [self.view endEditing:YES];
    [mBackend addBgValue:value
                 andThen:^(BOOL success){
                     [self stopBeingBusy];
                     [self switchToHistoryTab];
                 }
     ];
}

- (void) switchToHistoryTab {
    [self.tabBarController setSelectedIndex:0];
    [self.tabBarController.delegate tabBarController:self.tabBarController
                             didSelectViewController:[self.tabBarController.viewControllers
                                                      objectAtIndex:0]];
}
@end
