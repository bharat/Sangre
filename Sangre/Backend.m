//
//  Backend.m
//  Sangre
//
//  Created by Bharat Mediratta on 2/13/15.
//  Copyright (c) 2015 Menalto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Backend.h"
@import UIKit;

@implementation BackendRow {
    NSString* mTitle;
    NSString* mContent;
}

- (id) initWithTitle:(NSString*)title andContent:(NSString*)content {
    self = [super init];
    mTitle = title;
    mContent = content;
    return self;
}

- (NSString*) content {
    return mContent;
}

- (NSString*) title {
    return mTitle;
}
@end


@implementation Backend {
    GDataFeedSpreadsheet* mFeed;
    GTMOAuth2Authentication* mAuth;
}

NSString *kKeychainItemName = @"com.menalto.Sangre";
NSString *kMyClientID = @"336095338870-fqh5c3k8ug6772lcms8rmo07b0kqieh5.apps.googleusercontent.com";
NSString *kMyClientSecret = @"Pn2jFjL39S94ko0diFdb4z8_";
NSString *scope = @"https://spreadsheets.google.com/feeds";

+ (id) singleton {
    static Backend *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[self alloc] init];
    });
    return singleton;
}

+ (void) loadAuthenticationFromKeychain {
    GTMOAuth2Authentication* auth;
    auth = [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:kKeychainItemName
                                                                 clientID:kMyClientID
                                                             clientSecret:kMyClientSecret];
    [[Backend singleton] setAuthentication:auth];
}

- (BOOL) isAuthenticated {
    return mAuth && [mAuth canAuthorize];
}

- (UIViewController*) getAuthenticationViewController {
    // Authenticate for spreadsheet feeds using OAuth

    GTMOAuth2ViewControllerTouch* viewController = [GTMOAuth2ViewControllerTouch alloc];
    [viewController initWithScope:scope
                         clientID:kMyClientID
                     clientSecret:kMyClientSecret
                 keychainItemName:kKeychainItemName
                completionHandler:^(GTMOAuth2ViewControllerTouch *viewController, GTMOAuth2Authentication *auth, NSError *error) {
                    if (error) {
                        [[UIAlertView alloc] initWithTitle:@"auth error"
                                                   message:[error debugDescription]
                                                  delegate:self
                                         cancelButtonTitle:@"cancel"
                                         otherButtonTitles:@"ok", nil];
                    } else {
                        [[Backend singleton] setAuthentication:auth];
                    }
                }];
    [viewController autorelease];
    return viewController;
}

- (void) setAuthentication:(GTMOAuth2Authentication *)auth {
    [mAuth autorelease];
    mAuth = [auth retain];
}

- (void)setFeed:(GDataFeedSpreadsheet *)feed {
    [mFeed autorelease];
    mFeed = [feed retain];
}

- (GDataFeedSpreadsheet *)feed {
    return mFeed;
}

- (GDataServiceGoogleSpreadsheet *)spreadsheetService {
    static GDataServiceGoogleSpreadsheet* service = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        service = [[GDataServiceGoogleSpreadsheet alloc] init];
        
        [service setShouldCacheResponseData:NO];
        [service setServiceShouldFollowNextLinks:YES];
        [service setAuthorizer:mAuth];
    });
    
    return service;
}


- (BackendRow *) rowAt:(NSInteger)index {
    GDataEntrySpreadsheet* row = [[mFeed entries] objectAtIndex:index];
    return [[BackendRow alloc] initWithTitle:[[row title] stringValue]
                                  andContent:[[row content] stringValue]];
}


- (NSInteger) count {
    if (mFeed) {
        return [[mFeed entries] count];
    }
    return 0;
}

- (void) loadEvents:(void(^)(BOOL))callback {
    GDataServiceGoogleSpreadsheet *service = [self spreadsheetService];
    NSURL *eventsFeedURL = [NSURL URLWithString:@"https://spreadsheets.google.com/feeds/list/1SCVZzclIEYrSohgpmg5oy4WXWW0P8-3eZnOjRL_dyWc/2/private/full"];
    
    [service fetchFeedWithURL:eventsFeedURL
            completionHandler:^(GDataServiceTicket *ticket, GDataFeedBase *feed, NSError *error) {
                if (error) {
                    [[UIAlertView alloc] initWithTitle:@"feed error"
                                               message:[error debugDescription]
                                              delegate:self
                                     cancelButtonTitle:@"cancel"
                                     otherButtonTitles:@"ok", nil];
                    callback(YES);
                } else {
                    [self setFeed:(GDataFeedSpreadsheet*)feed];
                    callback(YES);
                }
            }
     ];
}

-(void) addBgValue:(NSString*)bgValue andThen:(void(^)(BOOL))callback {
    NSDate* now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM/dd/YYYY HH:MM:SS";
    
    // Convert the date to PST since that's what our spreadsheet expects
    NSTimeZone *currentTimeZone = [NSTimeZone localTimeZone];
    NSTimeZone *pstTimeZone = [NSTimeZone timeZoneWithName:@"America/Los_Angeles"];
    
    NSInteger currentPstOffset = [currentTimeZone secondsFromGMTForDate:now];
    NSInteger pstOffset = [pstTimeZone secondsFromGMTForDate:now];
    NSTimeInterval delta = pstOffset - currentPstOffset;
    NSDate *pstDate = [[[NSDate alloc] initWithTimeInterval:delta sinceDate:now] autorelease];
    
    GDataEntrySpreadsheetList *entry = [GDataEntrySpreadsheetList listEntry];
    GDataSpreadsheetCustomElement *obj1 =
        [GDataSpreadsheetCustomElement elementWithName:@"timestamp" stringValue:[formatter stringFromDate:pstDate]];
    GDataSpreadsheetCustomElement *obj2 =
        [GDataSpreadsheetCustomElement elementWithName:@"type" stringValue:@"bg"];
    GDataSpreadsheetCustomElement *obj3 =
        [GDataSpreadsheetCustomElement elementWithName:@"value" stringValue:bgValue];
    NSArray* array = [NSArray arrayWithObjects:obj1, obj2, obj3, nil];
    [entry setCustomElements:array];

    GDataServiceGoogleSpreadsheet* svc = [self spreadsheetService];
    [svc fetchEntryByInsertingEntry:entry
                         forFeedURL:[[mFeed postLink] URL]
                  completionHandler:^(GDataServiceTicket *ticket, GDataEntryBase *entry, NSError *error) {
                      if (error) {
                          [[UIAlertView alloc] initWithTitle:@"feed error"
                                                     message:[error debugDescription]
                                                    delegate:self
                                           cancelButtonTitle:@"cancel"
                                           otherButtonTitles:@"ok", nil];
                          callback(NO);
                      } else {
                          callback(YES);
                      }
                  }
     ];
}
@end

