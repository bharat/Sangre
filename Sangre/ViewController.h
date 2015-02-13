//
//  ViewController.h
//  Sangre
//
//  Created by Bharat Mediratta on 2/13/15.
//  Copyright (c) 2015 Menalto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@end

