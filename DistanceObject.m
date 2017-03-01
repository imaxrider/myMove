//
//  NSObject+DistanceObject.m
//  myMove
//
//  Created by smartax on 8/31/15.
//  Copyright (c) 2015 Rachanon Kwampien. All rights reserved.
//

#import "DistanceObject.h"

@implementation DistanceObject

static bool const isMetric = YES;
static float const disInKM = 1000;
static float const disInMile = 1609.344;
float  DistanceRT;
+ (NSString *)stringifyDistance:(float)length
{
    float unitDivider;
    NSString *unitName;
    
    
    // metric
    if (isMetric) {//เช็คหน่วย km และ mi
        unitName = @"km";
        unitDivider = disInKM;
         NSLog(@"KM : %f",disInKM);
        // U.S.
    } else {
        unitName = @"mi";
        // to get from meters to miles divide by this
        unitDivider = disInMile;
        NSLog(@"MI : %f",disInMile);
    }
    // NSLog(@"Face1 : %.2f", (meters / unitDivider));
   // PriceMeter = (meters / unitDivider);
    return [NSString stringWithFormat:@"%.2f", (length / unitDivider)];
}
+ (NSString *)stringifySecondCount:(int)seconds usingLongFormat:(BOOL)longFormat
{
    int remainingSeconds = seconds;
    int hours = remainingSeconds / 3600;
    remainingSeconds = remainingSeconds - hours * 3600;
    int minutes = remainingSeconds / 60;
    remainingSeconds = remainingSeconds - minutes * 60;
    
    if (longFormat) {
        if (hours > 0) {
            return [NSString stringWithFormat:@"%ihr %imin %isec", hours, minutes, remainingSeconds];
        } else if (minutes > 0) {
            return [NSString stringWithFormat:@"%imin %isec", minutes, remainingSeconds];
        } else {
            return [NSString stringWithFormat:@"%isec", remainingSeconds];
        }
    } else {
        if (hours > 0) {
            return [NSString stringWithFormat:@"%02i:%02i:%02i", hours, minutes, remainingSeconds];
        } else if (minutes > 0) {
            return [NSString stringWithFormat:@"%02i:%02i", minutes, remainingSeconds];
        } else {
            return [NSString stringWithFormat:@"00:%02i", remainingSeconds];
        }
    }
}
+ (NSString *)stringifyAvgPaceFromDist:(float)length overTime:(int)seconds
{
    if (seconds == 0 || length == 0) {
        return @"0";
    }
    
    float avgPaceSecMeters = seconds / length;
    
    float unitMultiplier;
    NSString *unitName;
    
    // metric
    if (isMetric) {
        unitName = @"min/km";
        unitMultiplier = disInKM;
        // U.S.
    } else {
        unitName = @"min/mi";
        unitMultiplier = disInMile;
    }
    
    int paceMin = (int) ((avgPaceSecMeters * unitMultiplier) / 60);
    int paceSec = (int) (avgPaceSecMeters * unitMultiplier - (paceMin*60));
    
    return [NSString stringWithFormat:@"%i:%02i %@", paceMin, paceSec, unitName];
}

@end
