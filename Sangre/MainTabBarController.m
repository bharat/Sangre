//
//  MainTabBarController.m
//  Sangre
//
//  Created by Bharat Mediratta on 2/16/15.
//  Copyright (c) 2015 Menalto. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "MainTabBarController.h"
#include "Backend.h"

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Backend* backend = [Backend singleton];
    
    if (![backend isAuthenticated]) {
        UIViewController* authenticationViewController = [backend getAuthenticationViewController];
        [[self navigationController] pushViewController:authenticationViewController
                                               animated:YES];        
    }
}
@end
