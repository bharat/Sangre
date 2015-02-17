//
//  Backend.h
//  Sangre
//
//  Created by Bharat Mediratta on 2/13/15.
//  Copyright (c) 2015 Menalto. All rights reserved.
//

#ifndef Sangre_Backend_h
#define Sangre_Backend_h
#import "GDataSpreadsheet.h"
#import "GTMOAuth2ViewControllerTouch.h"

@interface BackendRow: NSObject
-(NSString*) title;
-(NSString*) content;
@end

@interface Backend : NSObject
+(id) singleton;
-(void)setAuthentication:(GTMOAuth2Authentication*)auth;
-(UIViewController*)getAuthenticationViewController;
-(BOOL)isAuthenticated;

-(NSInteger) count;
-(BackendRow*) rowAt:(NSInteger)index;

-(void) loadEvents:(void(^)(BOOL))callback;
-(void) addBgValue:(NSString*)bgValue andThen:(void(^)(BOOL))callback;
@end

#endif
