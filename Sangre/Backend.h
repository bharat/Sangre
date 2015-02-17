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

typedef NS_ENUM(NSUInteger, HistoryEntryType) {
    kBloodSugar
};

@interface BackendRow: NSObject
-(NSDate*) date;
-(HistoryEntryType) type;
-(NSInteger) value;
@end

@interface Backend : NSObject
+(id) singleton;
+(void)loadAuthenticationFromKeychain;

-(UIViewController*)getAuthenticationViewController;
-(BOOL)isAuthenticated;
-(void)setAuthentication:(GTMOAuth2Authentication*)auth;

-(NSInteger) count;
-(BackendRow*) rowAt:(NSInteger)index;

-(void) loadEvents:(void(^)(BOOL))callback;
-(void) addBgValue:(NSString*)bgValue andThen:(void(^)(BOOL))callback;
@end

#endif
