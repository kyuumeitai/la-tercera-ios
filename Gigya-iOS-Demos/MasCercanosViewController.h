//
//  MasCercanosViewController.h
//  La Tercera
//
//  Created by diseno on 24-03-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "MapAnnotation.h"


@interface MasCercanosViewController : UIViewController <CLLocationManagerDelegate,MKMapViewDelegate >{
   
    MapAnnotation * annotation;
    CLLocationManager * locationManager;
    NSMutableArray * storeItemsArray;
    CLLocation        * userLocation;

}

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation        *userLocation;
@property (nonatomic, retain) NSMutableArray *storeItemsArray;

@end
