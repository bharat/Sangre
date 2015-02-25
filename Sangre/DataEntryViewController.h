//
//  DataEntryViewController.h
//  Sangre
//
//  Created by Bharat Mediratta on 2/13/15.
//  Copyright (c) 2015 Menalto. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "Backend.h"
#include "BusyViewController.h"

@interface DataEntryViewController : BusyViewController
- (IBAction)addBgValue:(id)sender;
@property (retain, nonatomic) IBOutlet UITextField *bgValue;
@end

