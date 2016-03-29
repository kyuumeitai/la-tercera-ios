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
#import "SingletonManager.h"
#define METERS_PER_MILE 1609.344
#define MapDistanceInMeters 600

@implementation MasCercanosViewController
    CLLocationManager *locationManager;
    CLLocation  *userLocation;
    SingletonManager *singleton;
@synthesize mapView = _mapView;
@synthesize locationManager      = _locationManager;
@synthesize userLocation         = _userLocation;
@synthesize storeItemsArray      = _storeItemsArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
        [self requestLocation];

    singleton = [SingletonManager singletonManager];
    
    _mapView.delegate = self;

   _mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

}

-(void)viewWillAppear:(BOOL)animated{
   
    
}

-(void)requestLocation {
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    
    //self.locationManager.distanceFilter  = 1000.0f;
    
    // Check for iOS 8 Vs earlier version like iOS7.Otherwise code will
    // crash on ios 7
    if ([self.locationManager respondsToSelector:@selector
         (requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];
    
    if (authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse) {
        NSLog(@"Autorizado");
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;   // 2 kilometers - hope for accuracy within 2 km.
        //_locationManager .distanceFilter  = 100.0f;   // one kilometer - move this far to get another update
        [self.locationManager startUpdatingLocation];
        
        _mapView.showsUserLocation = YES;
        
        [self loadData ];
    }else{
        [self.locationManager requestWhenInUseAuthorization];
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
    NSLog(@"LOAD PLACES");
    //[SVProgressHUD show];
    [SVProgressHUD setStatus:@"Obteniendo sucursales"];
    // Place a single pin

    _mapView.region = MKCoordinateRegionMakeWithDistance(_userLocation.coordinate,MapDistanceInMeters,MapDistanceInMeters);
    //[self updateMyMap];
}

#pragma mark - MapView Methods

- (void)updateMyMap{
    
    NSLog(@"Llegue a updateMyMap");
    

   // [locationManager stopUpdatingLocation];
    
    //_mapView.delegate = self;
   
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
   //
   singleton.userLocation = userLocation;
    userLocation = [locations lastObject];
    _mapView.centerCoordinate =
    userLocation.coordinate;

    
   NSLog(@"USER LOCATION : %@", userLocation);
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
