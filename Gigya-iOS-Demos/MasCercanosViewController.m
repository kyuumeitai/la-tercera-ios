//
//  MasCercanosViewController.m
//  La Tercera
//
//  Created by diseno on 24-03-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "MasCercanosViewController.h"
#import "ConnectionManager.h"
#import <CoreLocation/CoreLocation.h>
#import "SVProgressHUD.h"
#import "Store.h"
#import "Tools.h"
#import "SingletonManager.h"
#import "MapAnnotation.h"
#define METERS_PER_MILE 1609.344
#define MapDistanceInMeters 600

@implementation MasCercanosViewController

    CLLocationManager *locationManager;
    CLLocation  *userLocation;
    SingletonManager *singleton;
    bool firstTime;
int cuenta;

@synthesize mapView = _mapView;
@synthesize locationManager      = _locationManager;
@synthesize userLocation         = _userLocation;
@synthesize storeItemsArray      = _storeItemsArray;


- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self loadCategory];
    cuenta = 0;
    firstTime = true;
    // Do any additional setup after loading the view, typically from a nib.
        [self requestLocation];
    
    singleton = [SingletonManager singletonManager];
    
    _mapView.delegate = self;
    _mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

}

-(void)viewWillAppear:(BOOL)animated{
   
    [self todosClicked:nil];
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
        _locationManager .desiredAccuracy = kCLLocationAccuracyBestForNavigation;   // 2 kilometers - hope for accuracy within 2 km.
        //_locationManager .distanceFilter  = 100.0f;   // one kilometer - move this far to get another update
        [self.locationManager startUpdatingLocation];
        
        _mapView.showsUserLocation = YES;
        
        [self loadData ];
    }else{
        [self.locationManager requestWhenInUseAuthorization];
    }
}
#pragma mark ********  MAP VIEW METHODS ***********

-(void) loadStoresPin{
    for (Store *tienda in storeItemsArray) {
        
        // Add an annotation
        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        point.coordinate = tienda.storeLocation;
        point.title = tienda.storeDescription;
        point.subtitle = tienda.storeAddress;
        
        [self.mapView addAnnotation:point];
    }
     [SVProgressHUD dismiss];
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {
   
    NSLog(@"Finished map load");    // Place a single pin

   // [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(loadStoresPin) userInfo:nil repeats:NO];

_mapView.centerCoordinate =     userLocation.coordinate;
[locationManager stopUpdatingLocation];
}



- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation2
{
    
    //check annotation is not user location
    if([annotation2 isEqual:[_mapView userLocation]])
    {
        //bail
        return nil;
    }
    // create a proper annotation view, be lazy and don't use the reuse identifier
    MKAnnotationView *view = [[MKAnnotationView alloc] initWithAnnotation:annotation2
                                                          reuseIdentifier:@"identifier"];
    
    // create a disclosure button for map kit
    UIButton *disclosure = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    [disclosure addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                             action:@selector(openStoreDetail)]];
    view.rightCalloutAccessoryView = disclosure;

    view.canShowCallout = YES;
    
    UIImageView *houseIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"clublaterceraRojo.png"]];
    view.leftCalloutAccessoryView = houseIconView;

    view.enabled = YES;
    view.image = [UIImage imageNamed:@"IconoPin.png"];

    
    
    return view;
}


-(void)openStoreDetail{
    
    NSLog(@"Detail Opened");
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
    
    MKMapPoint annotationPoint = MKMapPointForCoordinate(_userLocation.coordinate);
    MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
    if (MKMapRectIsNull(zoomRect)) {
        zoomRect = pointRect;
    }else{
        zoomRect = MKMapRectUnion(zoomRect, pointRect);
    }
    zoomRect = MKMapRectUnion(zoomRect, pointRect);
    
    [_mapView setVisibleMapRect:zoomRect edgePadding:UIEdgeInsetsMake(10, 10, 10, 10) animated:YES];
}


#pragma mark - Load Categories
- (void)loadCategory:(int) idCategory {
   
    NSLog(@"hello category: %@",self.categoryName);
    [self loadStores:idCategory];
}


-(void)loadStores: (int) idCategory{
    
    NSLog(@"Load Stores");
    
    ConnectionManager *connectionManager = [[ConnectionManager alloc]init];
    //BOOL estaConectado = [connectionManager verifyConnection];
   // NSLog(@"Verificando conexión: %d",estaConectado);
    [connectionManager getStores:^(BOOL success, NSArray *arrayJson, NSError *error) {
        // IMPORTANT - Only update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!success) {
                NSLog(@"Error obteniendo datos! %@ %@", error, [error localizedDescription]);
            } else {
                [self reloadStoresDataFromService:arrayJson :idCategory];
               
            }
        });
    }];
}

-(void) reloadStoresDataFromService:(NSArray*)arrayJson :(int) idCategory{
   
    storeItemsArray = [[NSMutableArray alloc] init];
    
    NSLog(@"     ");
    NSLog(@" ******* LISTADO DE SUCURSALES ****** ----------------------");
    bool showEven = false;
    
    if (idCategory%2 == 0){
        NSLog(@" Par ");
        showEven = YES;
    }
    
    for (id store in arrayJson){
        
        
        int idStore =[ [store objectForKey:@"id"] intValue];
        id title = [store objectForKey:@"title"];
        id address = [store objectForKey:@"address"];
        id geoLocation = [store objectForKey:@"geocoords"];
        
        NSArray *coords = [NSArray arrayWithArray:geoLocation];
        
        CLLocationCoordinate2D storeLocation ;
        
        storeLocation.latitude =  [coords[0] doubleValue];
        storeLocation.longitude = [coords[1] doubleValue];
        
        NSLog(@"           Store id: %d , titulo: %@, address: %@, geolocacion: (%f,%f)",idStore,title,address,storeLocation.latitude, storeLocation.longitude);
        Store *store = [[Store alloc]init];
        store.idStore = idStore;
        store.storeDescription= title;
        store.storeAddress = address;
        store.storeLocation = storeLocation;
        
        if(showEven){
            NSLog(@"--Show Even--");
            if(idStore%2 == 0){
                NSLog(@"-- idStore --- : %i",idStore);
                [storeItemsArray addObject:store];
            }
        }else{
            if(idStore%2 != 0){
                 NSLog(@"-- idStore --- : %i",idStore);
                [storeItemsArray addObject:store];
            }
            
        }
        
    }
    
    NSLog(@"-- StoreItems cantidad = %lu",(unsigned long)storeItemsArray.count );
    [_mapView reloadInputViews];
    [_mapView removeAnnotations:_mapView.annotations];

    
    [self loadStoresPin];
    NSLog(@"--------------------- ******* RELOAD DATA TABLEEE ****** ----------------------");
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
  
    _mapView.delegate = self;
 [_mapView reloadInputViews];
 //  NSLog(@"USER LOCATION : %@", userLocation);
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        //[self loadData ];
        
        locationManager .desiredAccuracy = kCLLocationAccuracyNearestTenMeters;   // 2 kilometers - hope for accuracy within 2 km.
        locationManager .distanceFilter  = 100.0f;   // one kilometer - move this far to get another update
        [locationManager startUpdatingLocation];
        _mapView.showsUserLocation = YES;
        
        //[self.mapView reloadInputViews];
    }
}

#pragma mark - Menu Categories
- (IBAction)infantilClicked:(id)sender {
    NSLog(@"Infantil clicked");
    self.categoryName = @"infantil";
    
    self.botonInfantil.selected = YES;
    self.botonSabores.selected = NO;
    self.botonTiempoLibre.selected = NO;
    self.botonVidaSana.selected = NO;
    self.botonMasterCard.selected = NO;
    self.botonServicios.selected = NO;
    self.botonViajes.selected = NO;
    self.botonTodos.selected = NO;
    
    [self loadCategory:1];
}

- (IBAction)todosClicked:(id)sender {
    NSLog(@"Todos clicked");
    
    self.categoryName = @"todos";
    
    self.botonTodos.selected = YES;
    self.botonSabores.selected = NO;
    self.botonInfantil.selected = NO;
    self.botonTiempoLibre.selected = NO;
    self.botonVidaSana.selected = NO;
    self.botonMasterCard.selected = NO;
    self.botonServicios.selected = NO;
    self.botonViajes.selected = NO;
    
    [self loadCategory:2];
    
}
- (IBAction)saboresClicked:(id)sender {
    NSLog(@"Sabores clicked");
    
    self.categoryName = @"sabores";
    
    self.botonSabores.selected = YES;
    self.botonTodos.selected = NO;
    self.botonInfantil.selected = NO;
    self.botonTiempoLibre.selected = NO;
    self.botonVidaSana.selected = NO;
    self.botonMasterCard.selected = NO;
    self.botonServicios.selected = NO;
    self.botonViajes.selected = NO;
    
    [self loadCategory:3];
}

- (IBAction)vidaSanaClicked:(id)sender {
    NSLog(@"Vida Sana clicked");
    
    self.categoryName = @"vidaSana";
    
    self.botonSabores.selected = NO;
    self.botonTodos.selected = NO;
    self.botonInfantil.selected = NO;
    self.botonTiempoLibre.selected = NO;
    self.botonVidaSana.selected = YES;
    self.botonMasterCard.selected = NO;
    self.botonServicios.selected = NO;
    self.botonViajes.selected = NO;
    
    [self loadCategory:4];
}

- (IBAction)tiempoLibreClicked:(id)sender {
    NSLog(@"Tiempo Libre clicked");
    
    self.categoryName = @"tiempoLibre";
    
    self.botonSabores.selected = NO;
    self.botonTodos.selected = NO;
    self.botonInfantil.selected = NO;
    self.botonTiempoLibre.selected = YES;
    self.botonVidaSana.selected = NO;
    self.botonMasterCard.selected = NO;
    self.botonServicios.selected = NO;
    self.botonViajes.selected = NO;
    
    [self loadCategory:5];
    
}
- (IBAction)serviciosClicked:(id)sender {
    NSLog(@"Servicios clicked");
    
    self.categoryName = @"servicios";
    
    self.botonSabores.selected = NO;
    self.botonTodos.selected = NO;
    self.botonInfantil.selected = NO;
    self.botonTiempoLibre.selected = NO;
    self.botonVidaSana.selected = NO;
    self.botonMasterCard.selected = NO;
    self.botonServicios.selected = YES;
    self.botonViajes.selected = NO;
    
    [self loadCategory:6];
}

- (IBAction)viajesClicked:(id)sender {
    NSLog(@"Viajes clicked");
    
    self.categoryName = @"viajes";
    
    self.botonSabores.selected = NO;
    self.botonTodos.selected = NO;
    self.botonInfantil.selected = NO;
    self.botonTiempoLibre.selected = NO;
    self.botonVidaSana.selected = NO;
    self.botonMasterCard.selected = NO;
    self.botonServicios.selected = NO;
    self.botonViajes.selected = YES;
    
    [self loadCategory:7];
}

- (IBAction)mastercardClicked:(id)sender {
    NSLog(@"Viajes clicked");
    
    self.categoryName = @"masterCard";
    
    self.botonSabores.selected = NO;
    self.botonTodos.selected = NO;
    self.botonInfantil.selected = NO;
    self.botonTiempoLibre.selected = NO;
    self.botonVidaSana.selected = NO;
    self.botonMasterCard.selected = YES;
    self.botonServicios.selected = NO;
    self.botonViajes.selected = NO;
    
    [self loadCategory:8];
}


@end
