//
//  ViewController.m
//  Sangre
//
//  Created by Bharat Mediratta on 2/13/15.
//  Copyright (c) 2015 Menalto. All rights reserved.
//

#import "ViewController.h"
#import "Backend.h"

@implementation ViewController
{
    Backend* mBackend;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    mBackend = [[Backend alloc] initWithDelegate:self];
    [mBackend loadEvents];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [mBackend count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    BackendRow* row = [mBackend rowAt:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", [row title], [row content]];
    
    return cell;
}


- (void) eventsLoaded {
    [[self tableView] reloadData];
}

- (void) bgValueAdded {
    [[self tableView] reloadData];
}


- (IBAction)uploadBg:(id)sender {
    [mBackend addBgValue:[[self bgValue] text]];
}


- (void)dealloc {
    [_tableView release];
    [_bgValue release];
    [super dealloc];
}


@end
