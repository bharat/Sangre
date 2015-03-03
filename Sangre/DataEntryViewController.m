//
//  DataEntryViewController.m
//  Sangre
//
//  Created by Bharat Mediratta on 2/13/15.
//  Copyright (c) 2015 Menalto. All rights reserved.
//

#import "DataEntryViewController.h"
#import "Backend.h"
#import "Busy.h"

@implementation DataEntryViewController {
    Backend* mBackend;
    Busy* mFormBusy;
}

#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    mBackend = [Backend singleton];
    mFormBusy = [[Busy alloc] init:self.view];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar.topItem setTitle:[self.tabBarItem title]];

    [[self bgValue] becomeFirstResponder];
}

#pragma mark NSObject

- (void)dealloc {
    [_bgValue release];
    [super dealloc];
}

#pragma mark DataEntryViewController

- (IBAction)addBgValue:(id)sender {
    NSInteger value = [[[self bgValue] text] intValue];
    if (value < 40 || value > 600) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid entry"
                                                        message:@"Blood glucose entries must be between 40 and 600"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }

    [mFormBusy start];
    [self.view endEditing:YES];
    [[self bgValue] setText:@""];
    [mBackend addBgValue:value
                 andThen:^(BOOL success){
                     [mFormBusy stop];
                     [self switchToHistoryTab];
                 }
     ];
}

- (IBAction)endEditing:(id)sender {
    [self.view endEditing:YES];
}


- (void) switchToHistoryTab {
    [self.tabBarController setSelectedIndex:0];
    [self.tabBarController.delegate tabBarController:self.tabBarController
                             didSelectViewController:[self.tabBarController.viewControllers
                                                      objectAtIndex:0]];
}
@end
