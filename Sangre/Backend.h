//
//  Backend.h
//  Sangre
//
//  Created by Bharat Mediratta on 2/13/15.
//  Copyright (c) 2015 Menalto. All rights reserved.
//

#ifndef Sangre_Backend_h
#define Sangre_Backend_h
#import "GData.h"

@interface BackendRow: NSObject
-(NSString*) title;
-(NSString*) content;
@end

@interface Backend : NSObject
-(NSInteger) count;
-(BackendRow*) rowAt:(NSInteger)index;
-(void) setUpdateCallback:(NSObject*)obj withSelector:(SEL)finishedSelector;
-(void) load;
-(void) addBgValue:(NSString*)bgValue;
@end

#endif
