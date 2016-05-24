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


@interface MasCercanosViewController : UIViewController <CLLocationManagerDelegate,MKMapViewDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate, UISearchControllerDelegate >{
   
    MapAnnotation * annotation;
    NSMutableArray *tableData;
    NSArray *searchResults;

    __weak IBOutlet UITableView *mapTableView;
    CLLocationManager * locationManager;
    NSMutableArray * storeItemsArray;
    CLLocation        * userLocation;
    

}
@property (nonatomic, copy) NSString* categoryName;
@property BOOL searchControllerWasActive;
@property BOOL searchControllerSearchFieldWasFirstResponder;
@property (weak, nonatomic) IBOutlet UIButton *botonTodos;
@property (weak, nonatomic) IBOutlet UIButton *botonSabores;
@property (weak, nonatomic) IBOutlet UIButton *botonInfantil;
@property (weak, nonatomic) IBOutlet UIButton *botonTiempoLibre;
@property (weak, nonatomic) IBOutlet UIButton *botonVidaSana;
@property (weak, nonatomic) IBOutlet UIButton *botonMasterCard;
@property (weak, nonatomic) IBOutlet UIButton *botonServicios;
@property (weak, nonatomic) IBOutlet UIButton *botonViajes;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation        *userLocation;
@property (nonatomic, retain) NSMutableArray *storeItemsArray;
@property (nonatomic, retain) NSMutableArray *tableData;
@end
