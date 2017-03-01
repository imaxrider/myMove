//
//  NSObject+DistanceObject.h
//  myMove
//
//  Created by smartax on 8/31/15.
//  Copyright (c) 2015 Rachanon Kwampien. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DistanceObject : NSObject

+ (NSString *)stringifyDistance:(float)meters;
+ (NSString *)stringifySecondCount:(int)seconds usingLongFormat:(BOOL)longFormat;
+ (NSString *)stringifyAvgPaceFromDist:(float)meters overTime:(int)seconds;

@end
