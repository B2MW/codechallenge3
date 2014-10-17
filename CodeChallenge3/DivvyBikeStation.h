//
//  DivvyBikeStation.h
//  CodeChallenge3
//
//  Created by Bradley Walker on 10/17/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DivvyBikeStation : NSObject
@property NSNumber *id;
@property NSString *stationName;
@property NSNumber *totalDocks;
@property NSNumber *availableDocks;
@property NSNumber *locationLatitude;
@property NSNumber *locationLongitude;
@property NSString *statusValue;
@property NSString *streetAddress;

+(DivvyBikeStation *)createStation:(NSDictionary *)stationData;

@end
