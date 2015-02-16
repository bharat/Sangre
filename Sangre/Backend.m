//
//  Backend.m
//  Sangre
//
//  Created by Bharat Mediratta on 2/13/15.
//  Copyright (c) 2015 Menalto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Backend.h"
#import "Private.h"
@import UIKit;

@implementation BackendRow
{
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
    SEL mFinishedSelector;
    id<BackendDelegate> mDelegate;
}


- (id) initWithDelegate:(id<BackendDelegate>)delegate {
    self = [super init];
    mDelegate = delegate;
    return self;
}


- (void) loadEvents {
    GDataServiceGoogleSpreadsheet *service = [self spreadsheetService];
    NSURL *eventsFeedURL = [NSURL URLWithString:@"https://spreadsheets.google.com/feeds/list/1SCVZzclIEYrSohgpmg5oy4WXWW0P8-3eZnOjRL_dyWc/2/private/full"];

    [service fetchFeedWithURL:eventsFeedURL
                    feedClass:[GDataFeedSpreadsheet class]
                     delegate:self
            didFinishSelector:@selector(feedTicket:finishedWithFeed:error:)];
}


- (void)feedTicket:(GDataServiceTicket *)ticket
  finishedWithFeed:(GDataFeedSpreadsheet *)feed
             error:(NSError *)error {
    
    [self setFeed:feed];
    if (error) {
        [[UIAlertView alloc] initWithTitle:@"feed error"
                                   message:[error debugDescription]
                                  delegate:self
                         cancelButtonTitle:@"cancel"
                         otherButtonTitles:@"ok", nil];
    }
    [mDelegate eventsLoaded];
}


- (void)setFeed:(GDataFeedSpreadsheet *)feed {
    [mFeed autorelease];
    mFeed = [feed retain];
}


- (GDataFeedSpreadsheet *)spreadsheetFeed {
    return mFeed;
}


- (GDataServiceGoogleSpreadsheet *)spreadsheetService {
    static GDataServiceGoogleSpreadsheet* service = nil;
    
    if (!service) {
        service = [[GDataServiceGoogleSpreadsheet alloc] init];
        
        [service setShouldCacheResponseData:NO];
        [service setServiceShouldFollowNextLinks:YES];
        [service setUserCredentialsWithUsername:@"bharatman" password:PASSWORD];
    }
    
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

-(void) addBgValue:(NSString*)bgValue {
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

    [[self spreadsheetService] fetchEntryByInsertingEntry:entry
                                               forFeedURL:[[mFeed postLink] URL]
                                                 delegate:self
                                        didFinishSelector:@selector(entryTicket:finishedWithFeed:error:)];
}

- (void)entryTicket:(GDataServiceTicket *)ticket
  finishedWithFeed:(GDataFeedSpreadsheet *)feed
             error:(NSError *)error {
    if (error) {
        [[UIAlertView alloc] initWithTitle:@"feed error"
                                   message:[error debugDescription]
                                  delegate:self
                         cancelButtonTitle:@"cancel"
                         otherButtonTitles:@"ok", nil];
    }
    [mDelegate bgValueAdded];
}

@end

