//
//  ClubViewController.m
//  La Tercera
//
//  Created by diseno on 09-03-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "ClubViewController.h"
#import "ConnectionManager.h"
#import "Benefit.h"
#import "CategoriasTableViewCell.h"
#import "CategoriaViewController.h"
#import "SessionManager.h"
#import "SWRevealViewController.h"
#import "SVProgressHUD.h"
#import "UsarBeneficioNoLogueado.h"
#import "Tools.h"
#import "Category.h"
#import "LCBannerView.h"
#import "DetalleBeneficioViewController.h"

const int catSabores = 3;
const int catInfantil = 7;
const int catTiempoLibre = 5;
const int catVidaSana = 8;
const int catServicios = 4;

@interface ClubViewController () <LCBannerViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *menuButtonClub;
@property (nonatomic, weak) LCBannerView *bannerView1;
@end

@implementation ClubViewController
@synthesize categoryItemsArray,starredItemsArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestLocation];
    
    [_scrollViewBanner setAlpha:0.0];
    //[self loadCategories];
    // Do any additional setup after loading the view.
    
    NSLog(@"Club View Controller loaded and fonts are: %@",[UIFont familyNames]);
    
    //Creamos el singleton
  
    /*
    SWRevealViewController *revealViewController2 = self.revealViewController;
    if (revealViewController2) {
        [_menuButtonClub
         addTarget:revealViewController2 action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    }else{
        SWRevealViewController *revealViewController3 = [[SWRevealViewController alloc] init];
        [_menuButtonClub
         addTarget:revealViewController3 action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addGestureRecognizer: self.revealViewController.panGestureRecognizer];

    }
     */
    //Creamos el singleton
    SessionManager *sesion = [SessionManager session];
    
    SWRevealViewController *revealViewController = sesion.leftSlideMenu;
    revealViewController.delegate = self.revealViewController;
    if (revealViewController) {
        [_menuButtonClub
         addTarget:revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addGestureRecognizer: revealViewController.panGestureRecognizer];
    }
    UITapGestureRecognizer *tap = [revealViewController tapGestureRecognizer];
    tap.delegate = self;
    
    [self.view addGestureRecognizer:tap];
    
    
    // Do any additional setup after loading the view.
  [self loadStarredBenefits];
}

/**
 This method will manage the click event on the banner

 @param bannerView Will receive the BannerView Object to get elements inside
 @param index      The index of the banner object taht is presented actually in the view
 */
- (void)bannerView:(LCBannerView *)bannerView didClickedImageIndex:(NSInteger)index {
    
    Benefit *beneficio = (Benefit*) bannerView.benefitsArray[(int)index];
    NSLog(@"Aca el lonyi apretó el beneficio %p at index: %d, de titulo: %@ y de id beneficio: %d", bannerView, (int)index, beneficio.title, beneficio.idBen);
    
    DetalleBeneficioViewController *detalleBeneficio = [self.storyboard instantiateViewControllerWithIdentifier:@"detalleBeneficioViewController"];

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
    detalleBeneficio.benefitAddress = @"";
    detalleBeneficio.benefitDiscount= beneficio.desclabel;
    detalleBeneficio.benefitDescription = beneficio.summary;
    detalleBeneficio.benefitId = beneficio.idBen;
    [beneficio logDescription];

    [self.navigationController pushViewController: detalleBeneficio animated:YES];
    
}

//
//- (void)bannerView:(LCBannerView *)bannerView didScrollToIndex:(NSInteger)index {
//
//    NSLog(@"Delegate: Scrolled in %p to index: %d", bannerView, (int)index);
//}

-(void)requestLocation {
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    
    //self.locationManager.distanceFilter  = 1000.0f;
    
    // Check for iOS 8 Vs earlier version like iOS7.Otherwise code will
    // crash on ios 7
    if ([locationManager respondsToSelector:@selector
         (requestAlwaysAuthorization)]) {
        [locationManager requestAlwaysAuthorization];
    }
    
    CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];
    
   // if (authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse) {
    if (authorizationStatus == kCLAuthorizationStatusAuthorizedAlways) {
        NSLog(@"Autorizado");
        
        CLLocation *location = [locationManager location];
        CLLocationCoordinate2D coordinate = [location coordinate];
        
        NSString *str=[[NSString alloc] initWithFormat:@" latitude:%f longitude:%f",coordinate.latitude,coordinate.longitude];
        NSLog(@"%@",str);
        SessionManager *sesion = [SessionManager session];
        sesion.userLocation = location;
        
        
    }else{
        [locationManager requestAlwaysAuthorization];
    }
}

-(void)loadData {
    NSLog(@"LOAD DATA ");
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    if (![Tools isLocationServiceEnabled]) {
        [Tools showLocationServicesErrorByType:@"locationServicesDisabledError"];
        [SVProgressHUD dismiss];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
    }
    else {
        if (![Tools isNetworkAvailable]) {
            [Tools showNetworkError];
            [SVProgressHUD dismiss];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
        }
        else {
            NSLog(@"LOAD DATA OKKKKK");
            [locationManager stopUpdatingLocation];
            
        }
    }
}

-(void)loadCategories{
    
    NSLog(@"Load categories");
    // IMPORTANT - Only update the UI on the main thread
    [SVProgressHUD showWithStatus:@"Obteniendo beneficios disponibles" maskType:SVProgressHUDMaskTypeClear];
    
    ConnectionManager *connectionManager = [[ConnectionManager alloc]init];
    BOOL estaConectado = [connectionManager verifyConnection];
    NSLog(@"Verificando conexión: %d",estaConectado);
    [connectionManager getMainCategories:^(BOOL success, NSArray *arrayJson, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!success) {
                NSLog(@"Error obteniendo datos! %@ %@", error, [error localizedDescription]);
            } else {
                [self reloadMainCategoriesDataFromService:arrayJson];
            }
        });
    }];
    
}


-(void)loadBenefits{
    
    NSLog(@"Load categories");
    
    ConnectionManager *connectionManager = [[ConnectionManager alloc]init];
    BOOL estaConectado = [connectionManager verifyConnection];
    NSLog(@"Verificando conexión: %d",estaConectado);
    [connectionManager getBenefits:^(BOOL success, NSArray *arrayJson, NSError *error) {
        // IMPORTANT - Only update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!success) {
                NSLog(@"Error obteniendo datos! %@ %@", error, [error localizedDescription]);
            } else {
                [self reloadBenefitsDataFromService:arrayJson];
            }
        });
    }];
    
}

-(void)loadCommerces{
    
    NSLog(@"Load Comerces");
    
    ConnectionManager *connectionManager = [[ConnectionManager alloc]init];
    BOOL estaConectado = [connectionManager verifyConnection];
    NSLog(@"Verificando conexión: %d",estaConectado);
    [connectionManager getCommerces:^(BOOL success, NSArray *arrayJson, NSError *error) {
        // IMPORTANT - Only update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!success) {
                NSLog(@"Error obteniendo datos! %@ %@", error, [error localizedDescription]);
            } else {
                [self reloadCommercesDataFromService:arrayJson];
            }
        });
    }];
    
}

-(void)loadPaper{
    
    NSLog(@"Load Paper");
    
    ConnectionManager *connectionManager = [[ConnectionManager alloc]init];
    BOOL estaConectado = [connectionManager verifyConnection];
    NSLog(@"Verificando conexión: %d",estaConectado);
    [connectionManager getDigitalPaper:^(BOOL success, NSArray *arrayJson, NSError *error) {
        // IMPORTANT - Only update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!success) {
                NSLog(@"Error obteniendo datos! %@ %@", error, [error localizedDescription]);
            } else {
                [self reloadCommercesDataFromService:arrayJson];
            }
        });
    }];
    
}

-(void)loadStores{
    
    NSLog(@"Load Stores");
    
    ConnectionManager *connectionManager = [[ConnectionManager alloc]init];
    BOOL estaConectado = [connectionManager verifyConnection];
    NSLog(@"Verificando conexión: %d",estaConectado);
    [connectionManager getStores:^(BOOL success, NSArray *arrayJson, NSError *error) {
        // IMPORTANT - Only update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!success) {
                NSLog(@"Error obteniendo datos! %@ %@", error, [error localizedDescription]);
            } else {
                [self reloadStoresDataFromService:arrayJson];
            }
        });
    }];
}

-(void) reloadMainCategoriesDataFromService:(NSArray*)arrayJson{
    NSLog(@"  reload Main categories   ");
    categoryItemsArray = [[NSMutableArray alloc] init];
    
    for (id object in arrayJson){
        
        if ([object objectForKey:@"category_parent"] == [NSNull null]) {
            
            id title = [object objectForKey:@"title"];
            id idCat = [object objectForKey:@"id"];
            id benefits = [object objectForKey:@"benefits"];
            id url = [object objectForKey:@"url"];
            
            UIImage *imagenDestacada = nil;
            if([object objectForKey:@"starred_image"] != [NSNull null]){
                NSString *imagenDestacadaEncoded = [object objectForKey:@"starred_image"] ;
                //Creating the data from your base64String
                
                //Now data is decoded. You can convert them to UIImage
                imagenDestacada = [self decodeBase64ToImage:imagenDestacadaEncoded];
            }
            
            Categoria *categoria = [[Categoria alloc] init ];
            
            
            categoria.title = title;
            categoria.idCat = idCat;
            categoria.url = url;
            
            
            categoria.imagenDestacada = imagenDestacada;
            // NSLog(@"Categoría: %@ , id: %@, url: %@, imagenDesatacada: %@ ",title,idCat,url, imagenDestacada);
            
            
            NSMutableArray* categoryBenefitsArray = [[NSMutableArray alloc] init];
            
            for (id benefit in benefits){
                
                id titleBen = [benefit objectForKey:@"title"];
                id idBen = [benefit objectForKey:@"id"] ;
                id linkBen = [benefit objectForKey:@"url"] ;
                id summaryBen = [benefit objectForKey:@"summary"] ;
                id benefitLabelBen = [benefit objectForKey:@"benefit_label"] ;
                
                
                Benefit *beneficio = [[Benefit alloc] init];
                beneficio.idBen = [idBen intValue];
                beneficio.title = titleBen;
                beneficio.url = linkBen;
                beneficio.summary= summaryBen;
                beneficio.desclabel = benefitLabelBen;
                
                
                if([benefit objectForKey:@"image"] != [NSNull null]){
                    UIImage *imagenBeneficio = nil;
                    NSString *imagenBen = [benefit objectForKey:@"image"] ;
                    NSArray * arr = [imagenBen componentsSeparatedByString:@","];
                    
                    //Now data is decoded. You can convert them to UIImage
                    imagenBeneficio = [self decodeBase64ToImage:[arr lastObject]];
                    beneficio.imagenNormal = imagenBeneficio;
                    
                }
                
                [categoryBenefitsArray addObject:beneficio];
            }
            
            categoria.arrayBenefits = categoryBenefitsArray;
            [categoryItemsArray addObject:categoria];
            [SVProgressHUD dismiss];
        }
        
    }
    
    NSLog(@" ******* RELOAD DATA TABLEEE ****** ----------------------");
}

-(void) reloadSubCategoriesDataFromService:(NSArray*)arrayJson{
    
    NSLog(@"     ");
    NSLog(@" ******* LISTADO DE SUB-CATEGORÍAS PRINCIPALES ****** ----------------------");
    
    for (id object in arrayJson){
        if ([object objectForKey:@"category_parent"] != [NSNull null]) {
            
            id title = [object objectForKey:@"title"];
            id idCat = [object objectForKey:@"id"];
            NSLog(@"Categoría: %@ , id: %@",title,idCat);
            
        }
    }
    NSLog(@"--------------------- ******* RELOAD DATA TABLEEE ****** ----------------------");
}

-(void) reloadBenefitsDataFromService:(NSArray*)arrayJson{
    
    NSLog(@"     ");
    NSLog(@" ******* LISTADO DE BENEFICIOS PRINCIPALES ****** ----------------------");
    
    for (id object in arrayJson){
        
        
        id title = [object objectForKey:@"title"];
        id idCat = [object objectForKey:@"summary"];
        NSLog(@"titulo: %@ , resumen: %@",title,idCat);
        
    }
    
    NSLog(@"--------------------- ******* RELOAD DATA TABLEEE ****** ----------------------");
    
}

-(void) reloadCommercesDataFromService:(NSArray*)arrayJson{
    
    NSLog(@"     ");
    NSLog(@" ******* LISTADO DE COMERCIOS ****** ----------------------");
    
    for (id object in arrayJson){
        
        id idCom = [object objectForKey:@"id"];
        id title = [object objectForKey:@"title"];
        //id marker = [object objectForKey:@"marker"];
        NSLog(@"id: %@, titulo: %@  ",idCom,title );
        id stores = [object objectForKey:@"stores"];
        
        for (id store in stores){
            
            id idStore = [store objectForKey:@"id"];
            id title = [store objectForKey:@"title"];
            id region = [store objectForKey:@"region"];
            id city = [store objectForKey:@"city"];
            id address = [store objectForKey:@"address"];
            id geoLocation = [store objectForKey:@"geolocation"];
            
            NSLog(@"           Store id: %@ , titulo: %@, region: %@, city: %@, address: %@, geolocacion: %@",idStore,title,region,city,address,geoLocation);
        }
    }
    
    NSLog(@"--------------------- ******* RELOAD DATA TABLEEE ****** ----------------------");
}

-(void) reloadStoresDataFromService:(NSArray*)arrayJson{
    
    NSLog(@"     ");
    NSLog(@" ******* LISTADO DE SUCURSALES ****** ----------------------");
    
    for (id store in arrayJson){
        
        
        id idStore = [store objectForKey:@"id"];
        id title = [store objectForKey:@"title"];
        id region = [store objectForKey:@"region"];
        id city = [store objectForKey:@"city"];
        id address = [store objectForKey:@"address"];
        id geoLocation = [store objectForKey:@"geolocation"];
        
        NSLog(@"           Store id: %@ , titulo: %@, region: %@, city: %@, address: %@, geolocacion: %@",idStore,title,region,city,address,geoLocation);
        
    }
    
    NSLog(@"--------------------- ******* RELOAD DATA TABLEEE ****** ----------------------");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"segueInfantil"])
    {
        NSLog(@"MI Segue Infantil detected");
        //SessionManager *sesion = [SessionManager session];
        //sesion.categoryList = categoryItemsArray;
        CategoriaViewController *categoriaViewController= (CategoriaViewController*)segue.destinationViewController;
        categoriaViewController.categoryName = @"infantil";
        NSLog(@"MI CategoryName es: %@",categoriaViewController.categoryName);
        //NSLog(@"LOS ITEMS ARRAY SON: %@",categoryItemsArray.description);
        categoriaViewController.categoryItemsArray = categoryItemsArray;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"idCat == %d", catInfantil];
        NSArray *filteredArray = [categoryItemsArray filteredArrayUsingPredicate:predicate];
        
        Categoria* firstFoundObject = nil;
        firstFoundObject =  filteredArray.count > 0 ? filteredArray.firstObject : nil;
        categoriaViewController.category = firstFoundObject;
        NSLog(@"  obejtooo  Infantil cat : %@",firstFoundObject.description);
        categoriaViewController.categoryId = catInfantil;
        categoriaViewController.category = firstFoundObject;
        categoriaViewController.categoryItemsArray = firstFoundObject.arrayBenefits;
        
        NSLog(@" El array de beneficios  Infantil es : %@", categoriaViewController.categoryItemsArray);
        
    }
    
    if ([[segue identifier] isEqualToString:@"segueSabores"])
    {
        NSLog(@"MI Segue Sabores detected");
        
        SessionManager *sesion = [SessionManager session];
        //sesion.categoryList = categoryItemsArray;
        
        CategoriaViewController *categoriaViewController= (CategoriaViewController*)segue.destinationViewController;
        categoriaViewController.categoryName = @"sabores";
        NSLog(@"Mi CategoryName es: %@",categoriaViewController.categoryName);
        
        categoriaViewController.categoryItemsArray = categoryItemsArray;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"idCat == %d", catSabores];
        NSArray *filteredArray = [categoryItemsArray filteredArrayUsingPredicate:predicate];
        
        Categoria* firstFoundObject = nil;
        firstFoundObject =  filteredArray.count > 0 ? filteredArray.firstObject : nil;
        categoriaViewController.category = firstFoundObject;
        NSLog(@"  objetooo cat : %@",firstFoundObject);
        categoriaViewController.categoryId = catSabores;
        categoriaViewController.category = firstFoundObject;
        
    }
    
    if ([[segue identifier] isEqualToString:@"segueTiempoLibre"])
    {
        NSLog(@"Segue Tiempo Libre detected");
        SessionManager *sesion = [SessionManager session];
        //sesion.categoryList = categoryItemsArray;
        
        CategoriaViewController *categoriaViewController= (CategoriaViewController*)segue.destinationViewController;
        categoriaViewController.categoryName = @"tiempoLibre";
        NSLog(@"CategoryName es: %@",categoriaViewController.categoryName);
        
        categoriaViewController.categoryItemsArray = categoryItemsArray;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"idCat == %d", catTiempoLibre];
        NSArray *filteredArray = [categoryItemsArray filteredArrayUsingPredicate:predicate];
        
        Categoria* firstFoundObject = nil;
        firstFoundObject =  filteredArray.count > 0 ? filteredArray.firstObject : nil;
        categoriaViewController.category = firstFoundObject;
        NSLog(@"  obejtooo cat : %@",firstFoundObject);
        categoriaViewController.categoryId = catTiempoLibre;
        categoriaViewController.category = firstFoundObject;
    }
    
    if ([[segue identifier] isEqualToString:@"segueVidaSana"])
    {
        NSLog(@"Segue Vida Sana detected");
        
        SessionManager *sesion = [SessionManager session];
        //sesion.categoryList = categoryItemsArray;
        
        CategoriaViewController *categoriaViewController= (CategoriaViewController*)segue.destinationViewController;
        categoriaViewController.categoryName = @"vidaSana";
        NSLog(@"CategoryName es: %@",categoriaViewController.categoryName);
    }
    
    if ([[segue identifier] isEqualToString:@"segueMastercard"])
    {
        NSLog(@"Segue Mastercard detected");
        SessionManager *sesion = [SessionManager session];
        //sesion.categoryList = categoryItemsArray;
        
        CategoriaViewController *categoriaViewController= (CategoriaViewController*)segue.destinationViewController;
        categoriaViewController.categoryName = @"mastercard";
        NSLog(@"CategoryName es: %@",categoriaViewController.categoryName);
    }
    
    if ([[segue identifier] isEqualToString:@"segueServicios"])
    {
        NSLog(@"Segue Servicios detected");
        SessionManager *sesion = [SessionManager session];
        //sesion.categoryList = categoryItemsArray;
        
        CategoriaViewController *categoriaViewController= (CategoriaViewController*)segue.destinationViewController;
        categoriaViewController.categoryName = @"servicios";
        NSLog(@"CategoryName es: %@",categoriaViewController.categoryName);
    }
    
    if ([[segue identifier] isEqualToString:@"segueTiendaClub"])
    {
        NSLog(@"Segue Tienda detected");
        SessionManager *sesion = [SessionManager session];
        //sesion.categoryList = categoryItemsArray;
        
        CategoriaViewController *categoriaViewController= (CategoriaViewController*)segue.destinationViewController;
        categoriaViewController.categoryName = @"tienda";
        NSLog(@"CategoryName es: %@",categoriaViewController.categoryName);
    }
    
    if ([[segue identifier] isEqualToString:@"segueViajesClub"])
    {
        NSLog(@"Segue Viajes detected");
        SessionManager *sesion = [SessionManager session];
        //sesion.categoryList = categoryItemsArray;
        
        CategoriaViewController *categoriaViewController= (CategoriaViewController*)segue.destinationViewController;
        categoriaViewController.categoryName = @"viajes";
        NSLog(@"CategoryName es: %@",categoriaViewController.categoryName);
    }
}

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Load Categories
#pragma mark -- YSLContainerViewControllerDelegate
- (void)containerViewItemIndex:(NSInteger)index currentController:(UIViewController *)controller
{
    NSLog(@"Original current Index : %ld",(long)index);
    NSLog(@"Original current controller : %@",controller);
    [controller viewWillAppear:YES];
}

- (IBAction)presedOtro:(id)sender {
    NSLog(@"pressed otro");
}


- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}

-(void)goLocationSet{
    if (firstTime == false){
        [self requestLocation];
        firstTime  = true;
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        //[self loadData ];
        
       // NSLog(@"Estoy acaaa en change status");
        locationManager .desiredAccuracy = kCLLocationAccuracyNearestTenMeters;   // 2 kilometers - hope for accuracy within 2 km.
        locationManager .distanceFilter  = 100.0f;   // one kilometer - move this far to get another update
        [locationManager startUpdatingLocation];
        
        [self goLocationSet];
        
    }
}


- (IBAction)ticketPressed:(id)sender {
    
    [Tools openSafariWithURL:@"http://tienda.clublatercera.com/tickets"];
}

- (IBAction)TiendaClubPressed:(id)sender {
    
    [Tools openSafariWithURL:@"http://tienda.clublatercera.cl/"];
}

- (IBAction)TCMastercardPressed:(id)sender {
    
    [Tools openSafariWithURL:@"http://www.clublatercera.com/categoria/mastercard/"];
}

- (IBAction)ViajesClubPressed:(id)sender {
    
    [Tools openSafariWithURL:@"http://www.viajesclublatercera.cl/"];
}

- (IBAction)VentasEspecialesPressed:(id)sender {
    
    [Tools openSafariWithURL:@"http://suscripcioneslt.latercera.com/"];
}



- (IBAction)identifyUser:(id)sender {

    UsarBeneficioNoLogueado *usarBeneficioNoLogueadoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"suscriberNeededScreen"];
    [usarBeneficioNoLogueadoViewController cancelButtonText:@"Volver a la noticia"];
    
    [self presentViewController:usarBeneficioNoLogueadoViewController animated:YES completion:nil];
}

# pragma Connecction Stuffs
-(void)loadStarredBenefits{
    
    NSLog(@"Load category benefits destacados");
    // IMPORTANT - Only update the UI on the main thread

    ConnectionManager *connectionManager = [[ConnectionManager alloc]init];
    BOOL estaConectado = [connectionManager verifyConnection];
    NSLog(@"Verificando conexión: %d",estaConectado);
    
    //for Paging purposes
    [connectionManager getStarredBenefits :^(BOOL success, NSArray *arrayJson, NSError *error){

                                    [self reloadStarredBenefitsDataFromService:arrayJson];
                    // NSLog(@"Lista jhson: %@",arrayJson);
    }];
}

-(void) reloadStarredBenefitsDataFromService:(NSArray*)arrayJson{
    

    //benefitsItemsArray5 = [[NSMutableArray alloc] init];
    self.starredItemsArray = [[NSMutableArray alloc]init];
    NSDictionary *tempDict = (NSDictionary*)arrayJson;
    
   // id benefits = [tempDict objectForKey:@"benefits"];
    int count = 0;
    for (id benefit in tempDict){
        
        id titleBen = [benefit objectForKey:@"title"];
        int idBen =[ [benefit objectForKey:@"id"] intValue];;
        //NSLog(@"idBen :%d",idBen);
        id linkBen = [benefit objectForKey:@"url"] ;
        id summaryBen = [benefit objectForKey:@"summary"] ;
        id benefitLabelBen = [benefit objectForKey:@"benefit_label"] ;
        
        Benefit *beneficio = [[Benefit alloc] init];
        beneficio.idBen = idBen;
        beneficio.title = titleBen;
        beneficio.url = linkBen;
        beneficio.summary= summaryBen;
        beneficio.desclabel = benefitLabelBen;
        
        if([benefit objectForKey:@"image"] != [NSNull null]){
            
            NSString *imagenBen = [benefit objectForKey:@"image"] ;
            beneficio.imagenNormalString = imagenBen;
        }
        
        //Definitions
        NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];

        //Get Image
        
        NSArray * arr = [beneficio.imagenNormalString componentsSeparatedByString:@","];
        UIImage *imagenBeneficio = nil;
        
        //Now data is decoded. You can convert them to UIImage
        imagenBeneficio = [Tools decodeBase64ToImage:[arr lastObject]];
        if(imagenBeneficio == nil)
            imagenBeneficio = [UIImage imageNamed:@"PlaceholderHeaderClub"];
        //Save Image to Directory
   
        /*
        [_bannerView1 addSubview:({
            
            UIImageView *imagenViewBeneficio = [[UIImageView alloc] initWithFrame:CGRectMake(0,  0, _scrollViewBanner.bounds.size.width, _scrollViewBanner.bounds.size.height)];
            imagenViewBeneficio.image = imagenBeneficio;
        imagenViewBeneficio;
        })];
        */
        
        beneficio.imagenNormal = imagenBeneficio;
        [beneficio logDescription];
        [self.starredItemsArray addObject:beneficio];
        
        }
    [self bannerSetup];


    
    NSLog(@" ******* RELOAD STARRED DATA TABLE Sabores ****** ----------------------");
}

//Error handler
-(void) errorDetectedWithNSError:(NSError*) error{
    
    NSLog(@"Error obteniendo datos! El error es:  %@", [error localizedDescription]);
    
    //Escondemos el loading
    [SVProgressHUD dismiss];
    
    //Damos explicaciones del caso
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Error obteniendo Datos"
                          message:@"Ha ocurrido un error al obtener los datos. Reintente más tarde."
                          delegate:nil //or self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
}

-(void) saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    if ([[extension lowercaseString] isEqualToString:@"png"]) {
        [UIImagePNGRepresentation(image) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]] options:NSAtomicWrite error:nil];
    } else if ([[extension lowercaseString] isEqualToString:@"jpg"] || [[extension lowercaseString] isEqualToString:@"jpeg"]) {
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:nil];
    } else {
        NSLog(@"Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", extension);
    }
}


- (UIImage *) getImageFromURL:(NSString *)fileURL {
    UIImage * result;
    
    NSData * img_data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:img_data];
    
    return result;
}

/**
 This stuff will add a LCViewBanner to manage the banner stuffs
 */
-(void)bannerSetup{
    
    [_scrollViewBanner addSubview:({
        
        LCBannerView *bannerView = [LCBannerView bannerViewWithFrame:CGRectMake(0, 0, _scrollViewBanner.bounds.size.width, _scrollViewBanner.bounds.size.height)
                                                            delegate:self
                                                       benefitsArray:self.starredItemsArray placeholderImageName:@"imagenDestacada" timeInterval:4 currentPageIndicatorTintColor:[UIColor whiteColor] pageIndicatorTintColor:[UIColor grayColor] ];
        bannerView.hidePageControl = YES;
        self.bannerView1 = bannerView;
        
        
    })];
    //fade in
    [UIView animateWithDuration:2.0f animations:^{
        
        [self.scrollViewBanner setAlpha:1.0f];
        
    } completion:nil];
    
}

@end
