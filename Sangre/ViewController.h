//
//  ViewController.h
//  Sangre
//
//  Created by Bharat Mediratta on 2/13/15.
//  Copyright (c) 2015 Menalto. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "Backend.h"

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, BackendDelegate>
- (IBAction)uploadBg:(id)sender;
- (IBAction)cancel:(id)sender;
@property (retain, nonatomic) IBOutlet UITextField *bgValue;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *uploadSpinner;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *downloadSpinner;
@end

