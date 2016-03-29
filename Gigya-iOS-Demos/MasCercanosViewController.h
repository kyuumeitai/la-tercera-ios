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
    CLLocationManager *locationManager;

}
@property (weak, nonatomic) IBOutlet MKMapView *mapView;


@end
