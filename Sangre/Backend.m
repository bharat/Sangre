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
    NSObject* mFinishedObject;
}

- (void) setUpdateCallback:(NSObject*)finishedObject withSelector:(SEL)finishedSelector {
    mFinishedSelector = finishedSelector;
    mFinishedObject = finishedObject;
}


- (void) load {
    NSURL *eventsFeedURL = [NSURL URLWithString:@"https://spreadsheets.google.com/feeds/list/1SCVZzclIEYrSohgpmg5oy4WXWW0P8-3eZnOjRL_dyWc/2/public/full"];

    GDataServiceGoogleSpreadsheet *service = [self spreadsheetService];
    [service fetchFeedWithURL:eventsFeedURL
                    feedClass:[GDataFeedSpreadsheet class]
                     delegate:self
            didFinishSelector:@selector(feedTicket:finishedWithFeed:error:)];
}


- (void)updateUI {
    [mFinishedObject performSelector:mFinishedSelector];
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
    [self updateUI];
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
        
        [service setShouldCacheResponseData:YES];
        [service setServiceShouldFollowNextLinks:YES];
        [service setUserCredentialsWithUsername:@"bharatman" password:@""];
    }
    
    return service;
}


- (BackendRow *) rowAt:(NSInteger)index {
    GDataEntrySpreadsheet* row = [[mFeed entries] objectAtIndex:index];
    return [[BackendRow alloc] initWithTitle:[[row title] stringValue] andContent:[[row content] stringValue]];
}


- (NSInteger) count {
    if (mFeed) {
        return [[mFeed entries] count];
    }
    return 0;
}

-(void) addBgValue:(NSString*)bgValue {
    GDataEntrySpreadsheet* entry = [[GDataEntrySpreadsheet alloc] init];
    [entry setTitleWithString:@"1/1/2015 13:00"];
    [entry setContentWithString:[NSString stringWithFormat:@"bg, %@", bgValue]];

    [[self spreadsheetService] fetchEntryByInsertingEntry:entry
                                               forFeedURL:[[mFeed postLink] URL]
                                                 delegate:self
                                        didFinishSelector:@selector(feedTicket:finishedWithFeed:error:)];
}

@end

