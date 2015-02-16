//
//  DataEntryViewController.h
//  Sangre
//
//  Created by Bharat Mediratta on 2/13/15.
//  Copyright (c) 2015 Menalto. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "Backend.h"

@interface DataEntryViewController : UIViewController
- (IBAction)addBgValue:(id)sender;
- (IBAction)cancel:(id)sender;
@property (retain, nonatomic) IBOutlet UITextField *bgValue;
@end

