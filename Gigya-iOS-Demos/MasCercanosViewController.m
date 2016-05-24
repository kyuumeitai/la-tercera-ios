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
#import "CategoriasTableViewCell.h"
#define METERS_PER_MILE 1609.344
#define MapDistanceInMeters 800

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
@synthesize tableData      = _tableData;


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
    tableData = [[NSMutableArray alloc] init];

    
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
          [tableData addObject:store];
        
        [storeItemsArray addObject:store];
      

    }
    
    //NSLog(@"-- StoreItems cantidad = %lu",(unsigned long)storeItemsArray.count );
    [_mapView reloadInputViews];
    [_mapView removeAnnotations:_mapView.annotations];

    [self loadStoresPin];
    //NSLog(@"--------------------- ******* RELOAD DATA TABLEEE ****** ----------------------");
    [mapTableView reloadData];

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
    [SVProgressHUD show];
    [SVProgressHUD setStatus:@"Obteniendo sucursales"];
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
    [SVProgressHUD show];
    [SVProgressHUD setStatus:@"Obteniendo sucursales"];
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
    [SVProgressHUD show];
    [SVProgressHUD setStatus:@"Obteniendo sucursales"];
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
    [SVProgressHUD show];
    [SVProgressHUD setStatus:@"Obteniendo sucursales"];
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
    [SVProgressHUD show];
    [SVProgressHUD setStatus:@"Obteniendo sucursales"];
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
    [SVProgressHUD show];
    [SVProgressHUD setStatus:@"Obteniendo sucursales"];
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
    [SVProgressHUD show];
    [SVProgressHUD setStatus:@"Obteniendo sucursales"];
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
    [SVProgressHUD show];
    [SVProgressHUD setStatus:@"Obteniendo sucursales"];
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
    static NSString *simpleTableIdentifier = @"ClubCategoryTableCell1";
    NSArray *nib;
    
        CategoriasTableViewCell *cell = (CategoriasTableViewCell *)[mapTableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            
            nib = [[NSBundle mainBundle] loadNibNamed:@"CategoriasTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        Store *tiendita = [tableData objectAtIndex:indexPath.row];
        //[beneficio2 logDescription];
        
        cell.labelTitulo.text = tiendita.titleBenefit;
        cell.labelDescuento.text = tiendita.descText;
        if((unsigned long)tiendita.descText.length >3)
            cell.labelDescuento.alpha = 0;
        //Get Image
        NSArray * arr2 = [tiendita.imagenNormalString componentsSeparatedByString:@","];
        UIImage *imagenBeneficio = nil;
        
        //Now data is decoded. You can convert them to UIImage
        imagenBeneficio = [Tools decodeBase64ToImage:[arr2 lastObject]];
        if(!imagenBeneficio)
            imagenBeneficio = [UIImage imageNamed:@"PlaceholderHeaderClub"];
        cell.imageCategoria.image = imagenBeneficio;
        
        return cell;
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

        return 100.0;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = @"Listado de Beneficios Cercanos Asociados";
    }
    return sectionName;
}

@end
