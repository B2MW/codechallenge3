//
//  DivvyBikeStation.m
//  CodeChallenge3
//
//  Created by Bradley Walker on 10/17/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "DivvyBikeStation.h"

@implementation DivvyBikeStation
+(DivvyBikeStation *)createStation:(NSDictionary *)stationData
{
    DivvyBikeStation *newStation = [DivvyBikeStation new];
    newStation.id = [stationData objectForKey:@"id"];
    newStation.stationName = [stationData objectForKey:@"stationName"];
    newStation.totalDocks = [stationData objectForKey:@"totalDocks"];
    newStation.availableDocks = [stationData objectForKey:@"availableDocks"];
    newStation.locationLatitude = [stationData objectForKey:@"latitude"];
    newStation.locationLongitude = [stationData objectForKey:@"longitude"];
    newStation.statusValue = [stationData objectForKey:@"statusValue"];
    newStation.streetAddress = [stationData objectForKey:@"location"];

    return newStation;
}
@end
