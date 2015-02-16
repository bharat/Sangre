//
//  ViewController.m
//  Sangre
//
//  Created by Bharat Mediratta on 2/13/15.
//  Copyright (c) 2015 Menalto. All rights reserved.
//

#import "HistoryViewController.h"
#import "Backend.h"

@implementation HistoryViewController {
    Backend* mBackend;
    UIView* mActivityOverlay;
    UIActivityIndicatorView* mActivityIndicator;
}

#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tabBarController setDelegate:self];
    mBackend = [Backend singleton];
    [self loadEvents];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [mBackend count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    BackendRow* row = [mBackend rowAt:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", [row title], [row content]];
    
    return cell;
}

#pragma mark UITabBarControllerDelegate

- (void)tabBarController:(UITabBarController *)tabBarController
    didSelectViewController:(UIViewController *) viewController {

    if(tabBarController.selectedIndex == 0) {
        HistoryViewController* historyViewController = (HistoryViewController*)viewController;
        [historyViewController loadEvents];
    }
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
    NSIndexPath* ipath = [NSIndexPath indexPathForRow:[mBackend count]-1 inSection:0];
    [[self tableView] scrollToRowAtIndexPath:ipath atScrollPosition: UITableViewScrollPositionTop animated: YES];
    [self stopBeingBusy];
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
