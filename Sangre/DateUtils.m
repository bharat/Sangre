//
//  DateUtils.m
//  Sangre
//
//  Created by Bharat Mediratta on 2/17/15.
//  Copyright (c) 2015 Menalto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DateUtils.h"

@implementation DateUtils

+ (NSDateFormatter*)formatter {
    static dispatch_once_t onceToken;
    static NSDateFormatter *formatter = nil;
    
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"MM/dd/yyyy HH:mm:ss";
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"America/Los_Angeles"]];
    });
                  
    return formatter;
}

+ (NSDate *)normalizeTimezone:(NSDate *)date {
    NSTimeZone *currentTimeZone = [NSTimeZone localTimeZone];
    NSTimeZone *pstTimeZone = [NSTimeZone timeZoneWithName:@"America/Los_Angeles"];
    
    NSInteger currentPstOffset = [currentTimeZone secondsFromGMTForDate:date];
    NSInteger pstOffset = [pstTimeZone secondsFromGMTForDate:date];
    NSTimeInterval delta = pstOffset - currentPstOffset;
    NSDate *pstDate = [[[NSDate alloc] initWithTimeInterval:delta sinceDate:date] autorelease];
    return pstDate;
}

+ (NSDate *)toDate:(NSString *)timestampString {
    return [self.formatter dateFromString:timestampString];
}

+ (NSString*)toString:(NSDate*)date {
    return [self.formatter stringFromDate:date];
}
@end