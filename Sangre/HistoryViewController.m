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

@implementation HistoryViewController {
    Backend* mBackend;
}

#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    mBackend = [Backend singleton];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadEvents];
    [self.navigationController.navigationBar.topItem setTitle:[self.tabBarItem title]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [mBackend dateCount];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[mBackend dateAtIndex:section] count];
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[mBackend dateAtIndex:section] title];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 38.0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"BloodGlucose";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    UILabel* timeLabel = (UILabel*)[cell viewWithTag:1];
    UILabel* bgLabel = (UILabel*)[cell viewWithTag:2];
    
    BackendEntry* row = [[mBackend dateAtIndex:indexPath.section] entryAtIndex:indexPath.row];
    [timeLabel setText:[DateUtils toTimeString:[row date]]];
    [bgLabel setText:[row value]];
    return cell;
}

#pragma mark NSObject

- (void)dealloc {
    [_tableView release];
    [super dealloc];
}

#pragma mark HistoryViewController

- (void) loadEvents {
    [self startBeingBusy];
    [mBackend loadEvents:^(BOOL success) {
        [self eventsLoaded];
    }];
}

- (void) eventsLoaded {
    [[self tableView] reloadData];
    NSInteger lastSectionIndex = [mBackend dateCount] - 1;
    NSInteger lastRowIndex = [[mBackend dateAtIndex:lastSectionIndex] count] - 1;
    NSIndexPath* ipath = [NSIndexPath indexPathForRow:lastRowIndex inSection:lastSectionIndex];
    [[self tableView] scrollToRowAtIndexPath:ipath atScrollPosition: UITableViewScrollPositionTop animated: YES];
    [self stopBeingBusy];
}
@end
