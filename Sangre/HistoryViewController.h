//
//  HistoryViewController.h
//  Sangre
//
//  Created by Bharat Mediratta on 2/13/15.
//  Copyright (c) 2015 Menalto. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "Backend.h"
#include "BusyViewController.h"

@interface HistoryViewController : BusyViewController <UITableViewDelegate, UITableViewDataSource>
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@end

