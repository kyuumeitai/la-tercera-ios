//
//  MasCercanosViewController.m
//  La Tercera
//
//  Created by diseno on 24-03-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "MasCercanosViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "SVProgressHUD.h"
#import "Tools.h"

@implementation MasCercanosViewController
    CLLocationManager *locationManager;
    CLLocation  *userLocation;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self requestLocation];
}


    
    -(void)requestLocation {
        
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        
        //self.locationManager.distanceFilter  = 1000.0f;
        
        // Check for iOS 8 Vs earlier version like iOS7.Otherwise code will
        // crash on ios 7
        if ([locationManager respondsToSelector:@selector
             (requestWhenInUseAuthorization)]) {
            [locationManager requestWhenInUseAuthorization];
        }
        
        CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];
        
        if (authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse) {
            NSLog(@"Autorizado");
            locationManager .desiredAccuracy = kCLLocationAccuracyBestForNavigation;   // 2 kilometers - hope for accuracy within 2 km.
            //_locationManager .distanceFilter  = 100.0f;   // one kilometer - move this far to get another update
            [locationManager startUpdatingLocation];
            
            _mapView.showsUserLocation = YES;
            
            //[self loadData ];
        }else{
            [locationManager requestWhenInUseAuthorization];
        }
    }

#pragma mark - Data management
-(void)loadData {
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    if (![Tools isLocationServiceEnabled]) {
        [Tools showLocationServicesErrorByType:@"locationServicesDisabledError"];
        [SVProgressHUD dismiss];
    }
    else {
        if (![Tools isNetworkAvailable]) {
            [Tools showNetworkError];
            [SVProgressHUD dismiss];
        }
        else {
            NSLog(@"LOAD DATA OKKKKK");
            [self loadPlaces];
        }
    }
}

-(void)loadPlaces{
    
    [SVProgressHUD show];
    [SVProgressHUD setStatus:@"Obteniendo sucursales"];

            [self updateMyMap];
}

#pragma mark - MapView Methods

- (void)updateMyMap{
    
    NSLog(@"Llegue a updateMyMap");
    

    [locationManager stopUpdatingLocation];
    
    _mapView.delegate = self;
    
    MKMapRect zoomRect = MKMapRectNull;
    
    MKMapPoint annotationPoint = MKMapPointForCoordinate(userLocation.coordinate);
    MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
    if (MKMapRectIsNull(zoomRect)) {
        zoomRect = pointRect;
    }else{
        zoomRect = MKMapRectUnion(zoomRect, pointRect);
    }
    zoomRect = MKMapRectUnion(zoomRect, pointRect);
    
    [_mapView setVisibleMapRect:zoomRect edgePadding:UIEdgeInsetsMake(50, 50, 290, 290) animated:YES];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
       NSString *longuitud = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        NSString *latitud = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        NSLog(@"La latitud es:%@ y la longuitud: %@", latitud,longuitud);

    }
}


- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        //[self loadData ];
        
        locationManager .desiredAccuracy = kCLLocationAccuracyBestForNavigation;   // 2 kilometers - hope for accuracy within 2 km.
        locationManager .distanceFilter  = 5.0f;   // one kilometer - move this far to get another update
        [locationManager startUpdatingLocation];
        _mapView.showsUserLocation = YES;
        
        [self.mapView reloadInputViews];
    }
}


@end
