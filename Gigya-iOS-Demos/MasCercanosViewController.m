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
#import "MKMapView+ZoomLevel.h"
#import "DetalleBeneficioViewControllerFromMap.h"
#import "MKPointAnnotation_custom.h"
#import "YActionSheet.h"
#define METERS_PER_MILE 1609.344
#define MapDistanceInMeters 800

@implementation MasCercanosViewController
NSArray *tableData;

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
    cuenta = 0;
    firstTime = true;
    // Do any additional setup after loading the view, typically from a nib.
        [self requestLocation];
    
    singleton = [SingletonManager singletonManager];
    
    _mapView.delegate = self;
    _mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
     tableData = [NSArray arrayWithObjects:@"Egg Benedict", @"Mushroom Risotto", @"Full Breakfast", @"Hamburger", @"Ham and Egg Sandwich", @"Creme Brelee", @"White Chocolate Donut", @"Starbucks Coffee", @"Vegetable Curry", @"Instant Noodle with Egg", @"Noodle with BBQ Pork", @"Japanese Noodle with Pork", @"Green Tea", @"Thai Shrimp Cake", @"Angry Birds Cake", @"Ham and Cheese Panini", nil];

}

-(void)viewWillAppear:(BOOL)animated{
   
    [self todosClicked:nil];
}
- (IBAction)openFilter:(UIButton *)sender {
    YActionSheet *options = [[YActionSheet alloc] initWithTitle:@"Options"
                                            dismissButtonTitle:@"Title"
                                              otherButtonTitles:@[@"One", @"Two", @"Three", @"Four", @"Five"]                                           dismissOnSelect:NO];
    [options showInViewController:self withYActionSheetBlock:^(NSInteger buttonIndex, BOOL isCancel) {
        // Handle block completion
    }];
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

        [self loadData ];
    }else{
        [self.locationManager requestWhenInUseAuthorization];
    }
}
#pragma mark ********  MAP VIEW METHODS ***********

-(void) loadStoresPin{
    for (Store *tienda in storeItemsArray) {
        
        // Add an annotation
        MKPointAnnotation_custom *point = [[MKPointAnnotation_custom alloc] init];
        point.coordinate = tienda.storeLocation;
        point.title = tienda.storeDescription;
        point.subtitle = tienda.storeAddress;
        point.benefitId = tienda.idBenefit ;
        point.storeId = tienda.idStore ;
        point.normalImageString = tienda.imagenNormalString;
        point.benefitTitle = tienda.titleBenefit;
        point.DescText = tienda.descText;
        [self.mapView addAnnotation:point];
    }
     [SVProgressHUD dismiss];
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {
   
    NSLog(@"Finished map load");    // Place a single pin

   // [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(loadStoresPin) userInfo:nil repeats:NO];
    SingletonManager *singleton = [SingletonManager singletonManager];
    userLocation = singleton.userLocation;
    _mapView.centerCoordinate =     userLocation.coordinate;

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
    
   // [disclosure addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self                                                                           action:@selector(openStoreDetail:)] ];
    
    view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];

    view.rightCalloutAccessoryView = disclosure;

    view.canShowCallout = YES;
    
    UIImageView *houseIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"clublaterceraRojo.png"]];
    view.leftCalloutAccessoryView = houseIconView;

    view.enabled = YES;
    view.image = [UIImage imageNamed:@"IconoPin.png"];

    return view;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    //launch a new view upon touching the disclosure indicator
    NSLog(@"Detail Opened");
    int benefitId = ((MKPointAnnotation_custom*)view.annotation).benefitId;
    int storeId = ((MKPointAnnotation_custom*)view.annotation).storeId;
    NSString *normalImage = ((MKPointAnnotation_custom*)view.annotation).normalImageString;
    NSString *titleBen = ((MKPointAnnotation_custom*)view.annotation).benefitTitle;
    NSString *discBen = ((MKPointAnnotation_custom*)view.annotation).DescText;
    
    
    NSLog(@"el Id del beneficio es:%d y el id del Store es:%d",benefitId,storeId);
    
    
    //Party goes on
    DetalleBeneficioViewControllerFromMap *detalleBeneficio = [self.storyboard instantiateViewControllerWithIdentifier:@"detalleBeneficioViewController"];
    [detalleBeneficio loadBenefitForBenefitId:benefitId];
    
    //Get Image
    NSArray * arr = [normalImage componentsSeparatedByString:@","];
    UIImage *imagenBeneficio = nil;
    
    //Now data is decoded. You can convert them to UIImage
    imagenBeneficio = [Tools decodeBase64ToImage:[arr lastObject]];
    if(imagenBeneficio == nil)
        imagenBeneficio = [UIImage imageNamed:@"PlaceholderHeaderClub"];
    
    detalleBeneficio.benefitImage = imagenBeneficio;
    
    detalleBeneficio.benefitTitle= titleBen;
   // detalleBeneficio.benefitAddress = @"Nueva Providencia #283, Providencia, Santiago       A 200 metros de su ubicación";
    detalleBeneficio.benefitDiscount= discBen;
   // detalleBeneficio.benefitDescription = beneficio.summary;
    detalleBeneficio.benefitId = benefitId;
    // NSLog(@"ID beneficio es: %d",detalleBeneficio.benefitId);
    
    [self.navigationController pushViewController: detalleBeneficio animated:YES];

}

/*
-(void)openStoreDetail:(id)sender{
    
    NSLog(@"Detail Opened");
    UIButton *btn = (UIButton *) sender.
    MKAnnotationView *av = (MKAnnotationView *)[btn superview];
    id<MKAnnotation> ann = av.annotation;
    NSLog(@"handlePinButtonTap: ann.title=%@", ann.title);

    DetalleBeneficioViewControllerFromMap *detalleBeneficio = [self.storyboard instantiateViewControllerWithIdentifier:@"detalleBeneficioViewController"];
    Benefit *beneficio = [self.benefitsItemsArray5 objectAtIndex:indexPath.row];
    [detalleBeneficio loadBenefitForBenefitId:beneficio.idBen];
    
    //Get Image
    NSArray * arr = [beneficio.imagenNormalString componentsSeparatedByString:@","];
    UIImage *imagenBeneficio = nil;
    
    //Now data is decoded. You can convert them to UIImage
    imagenBeneficio = [Tools decodeBase64ToImage:[arr lastObject]];
    if(imagenBeneficio == nil)
        imagenBeneficio = [UIImage imageNamed:@"PlaceholderHeaderClub"];
    
    detalleBeneficio.benefitImage = imagenBeneficio;
    
    detalleBeneficio.benefitTitle= beneficio.title;
    detalleBeneficio.benefitAddress = @"Nueva Providencia #283, Providencia, Santiago       A 200 metros de su ubicación";
    detalleBeneficio.benefitDiscount= beneficio.desclabel;
    detalleBeneficio.benefitDescription = beneficio.summary;
    detalleBeneficio.benefitId = beneficio.idBen;
    // NSLog(@"ID beneficio es: %d",detalleBeneficio.benefitId);
    
    [self.navigationController pushViewController: detalleBeneficio animated:YES];
 
}
*/

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
    SingletonManager *singleton = [SingletonManager singletonManager];
     _userLocation = singleton.userLocation;
    MKMapRect zoomRect = MKMapRectNull;
    _mapView.showsUserLocation = YES;

    MKMapPoint annotationPoint = MKMapPointForCoordinate(_userLocation.coordinate);
    MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
    if (MKMapRectIsNull(zoomRect)) {
        zoomRect = pointRect;
    }else{
        zoomRect = MKMapRectUnion(zoomRect, pointRect);
    }
    zoomRect = MKMapRectUnion(zoomRect, pointRect);
    
    CLLocationCoordinate2D coordenadaUser = CLLocationCoordinate2DMake(_userLocation.coordinate.latitude, _userLocation.coordinate.longitude);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:MKCoordinateRegionMakeWithDistance(coordenadaUser, 480, 480)];
    adjustedRegion.span.longitudeDelta  = 0.02;
    adjustedRegion.span.latitudeDelta  = 0.02;
    [self.mapView setRegion:adjustedRegion animated:YES];

    //NSLog(@"%f",adjustedRegion.span.latitudeDelta);
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
    [connectionManager getStoresAndBenefitsForCategoryId :^(BOOL success, NSArray *arrayJson, NSError *error){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!success) {
                NSLog(@"Error obteniendo datos! %@ %@", error, [error localizedDescription]);
            } else {
                [self reloadStoresDataFromService:arrayJson];
                // NSLog(@"Lista jhson: %@",arrayJson);
            }
        });
    }:idCategory];
}

-(void) reloadStoresDataFromService:(NSArray*)arrayJson{
   
    storeItemsArray = [[NSMutableArray alloc] init];
    
    NSLog(@"     ");
    NSLog(@" ******* LISTADO DE SUCURSALES ****** ----------------------");
    
    for (id store in arrayJson){
        
        int idStore =[ [store objectForKey:@"remote_id"] intValue];
       
        id address = [store objectForKey:@"address"];
        id geoLocation = [store objectForKey:@"geocoords"];
        NSArray *coords = [NSArray arrayWithArray:geoLocation];
        NSArray *benefitsArray = (NSArray*)[store objectForKey:@"benefits"];
        
         id title = [benefitsArray[0] objectForKey:@"title"];
        id discount = [benefitsArray[0] objectForKey:@"benefit_label"];
        int idBenefit = [[benefitsArray[0] objectForKey:@"id"] intValue];
        NSString *normalImageString = [benefitsArray[0] objectForKey:@"image"];
          NSString *newString ;
        NSRange range = [title rangeOfString:@":"];
        if (range.location == NSNotFound){
            newString = title;
        }else{
        newString = [title substringToIndex:range.location];
        //NSLog(@"%@",newString);
        }
        CLLocationCoordinate2D storeLocation ;
        
        storeLocation.latitude =  [coords[0] doubleValue];
        storeLocation.longitude = [coords[1] doubleValue];
        
        //NSLog(@"           Store id: %d , titulo: %@, address: %@, geolocacion: (%f,%f)",idStore,title,address,storeLocation.latitude, storeLocation.longitude);
        Store *store = [[Store alloc]init];
        store.idStore = idStore;
        store.titleBenefit = title;
        store.descText = discount;
        store.imagenNormalString = normalImageString;
        store.storeDescription= newString;
        store.storeAddress = address;
        store.storeLocation = storeLocation;
        store.idStore = idStore;
        store.idBenefit = idBenefit;
        
        //NSLog(@"-- idStore --- : %i",idStore);
        [storeItemsArray addObject:store];
    }
    
    //NSLog(@"-- StoreItems cantidad = %lu",(unsigned long)storeItemsArray.count );
    [_mapView reloadInputViews];
    [_mapView removeAnnotations:_mapView.annotations];

    [self loadStoresPin];
    //NSLog(@"--------------------- ******* RELOAD DATA TABLEEE ****** ----------------------");
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
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
    
    [self loadCategory:8];
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
    
    [self loadCategory:3];
    
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
    
    [self loadCategory:29];
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
    
    [self loadCategory:4];
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
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"el log de count: %lu",(unsigned long)[tableData count]);
    return [tableData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
    return cell;
}



@end
