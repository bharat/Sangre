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
    [self loadEvents];
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


- (void) loadEvents {
    [[self downloadSpinner] startAnimating];
    [mBackend loadEvents];
}


- (void) eventsLoaded {
    [[self downloadSpinner] stopAnimating];
    [[self tableView] reloadData];
    NSIndexPath* ipath = [NSIndexPath indexPathForRow:[mBackend count]-1 inSection:0];
    [[self tableView] scrollToRowAtIndexPath:ipath atScrollPosition: UITableViewScrollPositionTop animated: YES];
}


- (void) bgValueAdded {
    [[self uploadSpinner] stopAnimating];
    [[self tabBarController] setSelectedIndex:0];
    [self loadEvents];
}


- (IBAction)uploadBg:(id)sender {
    [self.view endEditing:YES];
    [[self uploadSpinner] startAnimating];
    [mBackend addBgValue:[[self bgValue] text]];
}


- (IBAction)cancel:(id)sender {
    [self.view endEditing:YES];
    [[self tabBarController] setSelectedIndex:0];    
}


- (void)dealloc {
    [_tableView release];
    [_bgValue release];
    [_uploadSpinner release];
    [_downloadSpinner release];
    [super dealloc];
}


@end
