//
//  ViewController.m
//  Sangre
//
//  Created by Bharat Mediratta on 2/13/15.
//  Copyright (c) 2015 Menalto. All rights reserved.
//

#import "HistoryViewController.h"
#import "Backend.h"
#import "DateUtils.h"
#import "Busy.h"

@implementation HistoryViewController {
    Backend* mBackend;
    Busy* mBusy;
}

#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    mBackend = [Backend singleton];
    mBusy = [[Busy alloc] init:self.tableView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [mBusy start];
    [mBackend loadEvents:^(BOOL success) {
        [[self tableView] reloadData];
        [self scrollToBottom];
        [mBusy stop];
    }];
    
    [self.navigationController.navigationBar.topItem setTitle:[self.tabBarItem title]];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.navigationController.navigationBar.topItem setRightBarButtonItem:nil animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [mBusy start];
        [[mBackend dateAtIndex:indexPath.section] deleteAtIndex:indexPath.row andThen:^(BOOL success) {
            if (success) {
                // Once we modify the data our existing feed is invalid so we need to reload all the data.
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                 withRowAnimation:UITableViewRowAnimationLeft];
                [mBackend loadEvents:^(BOOL success) {
                    [[self tableView] reloadData];
                }];
            }
            [mBusy stop];
        }];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [mBackend dateCount];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[mBackend dateAtIndex:section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[mBackend dateAtIndex:section] title];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"BloodGlucose";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    
    UILabel* timeLabel = (UILabel*)[cell viewWithTag:1];
    UILabel* bgLabel = (UILabel*)[cell viewWithTag:2];
    
    BackendEntry* row = [[mBackend dateAtIndex:indexPath.section] entryAtIndex:indexPath.row];
    [timeLabel setText:[DateUtils toTimeString:[row date]]];
    [bgLabel setText:[NSString stringWithFormat:@"%@ mg/dL", [row value]]];
    return cell;
}

#pragma mark NSObject

- (void)dealloc {
    [_tableView release];
    [super dealloc];
}

#pragma mark HistoryViewController

- (void) scrollToBottom {
    NSInteger lastSectionIndex = [mBackend dateCount] - 1;
    NSInteger lastRowIndex = [[mBackend dateAtIndex:lastSectionIndex] count] - 1;
    NSIndexPath* ipath = [NSIndexPath indexPathForRow:lastRowIndex inSection:lastSectionIndex];
    [[self tableView] scrollToRowAtIndexPath:ipath atScrollPosition: UITableViewScrollPositionTop animated: YES];
}
@end
