//
//  MapViewController.m
//  CodeChallenge3
//
//  Created by Vik Denic on 10/16/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "MapViewController.h"
#import "DivvyBikeStation.h"
#import <MapKit/MapKit.h>

@interface MapViewController () <UIAlertViewDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property CLLocationManager *locationManager;
@property MKMapItem *userLocationMapItem;
@property MKMapItem *destinationLocationMapItem;
@property UIAlertView *alertView;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager requestWhenInUseAuthorization];

    [self.locationManager startUpdatingLocation];
    [self addNewAnnotation];
    [self.mapView showAnnotations:self.mapView.annotations animated:YES];

    self.alertView.delegate = self;
    self.locationManager.delegate = self;
    [self stationDirections];
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Do you even GPS, bro?");
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    for (CLLocation *location in locations) {
        if (location.verticalAccuracy < 1000 && location.horizontalAccuracy < 1000) {
            [self.locationManager stopUpdatingLocation];
            break;
        }
    }
}

- (void)addNewAnnotation
{
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];

    CLLocationCoordinate2D coord;
    coord.latitude = self.station.locationLatitude.doubleValue;
    coord.longitude = self.station.locationLongitude.doubleValue;

    annotation.title = self.station.stationName;
    annotation.coordinate = coord;
    [self.mapView addAnnotation:annotation];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if (annotation == mapView.userLocation)
    {
        return nil;
    }

    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MyPinID"];
    pin.canShowCallout = YES;
    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    pin.image = [UIImage imageNamed:@"bikeImage"];

    return pin;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self.alertView show];
}

- (void) stationDirections
{
    CLGeocoder *userGeocoder = [[CLGeocoder alloc] init];
    [userGeocoder reverseGeocodeLocation:self.locationManager.location completionHandler:^(NSArray *placemarks, NSError *error) {
        MKPlacemark *placemark = placemarks.firstObject;
        MKMapItem *userMapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
        self.userLocationMapItem = userMapItem;
    }];

    CLGeocoder *destinationGeocoder = [[CLGeocoder alloc] init];
    [destinationGeocoder reverseGeocodeLocation:self.locationManager.location completionHandler:^(NSArray *placemarks, NSError *error) {
        MKPlacemark *placemark = placemarks.firstObject;
        MKMapItem *destinationMapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
        self.destinationLocationMapItem = destinationMapItem;
    }];

    MKDirectionsRequest *directionsRequest = [[MKDirectionsRequest alloc] init];
    [directionsRequest setDestination:self.destinationLocationMapItem];
    [directionsRequest setSource:self.userLocationMapItem];
    MKDirections *stationDirection = [[MKDirections alloc] initWithRequest:directionsRequest];

}

- (void) showAlertView
{
    self.alertView.title = @"Directions to Station";

    [self.alertView show];
}
@end
