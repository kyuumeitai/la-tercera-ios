//
//  ClubViewController.m
//  La Tercera
//
//  Created by diseno on 09-03-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "ClubViewController.h"
#import "ConnectionManager.h"
#import "Category.h"
#import "Benefit.h"
#import "CategoriasTableViewCell.h"
#import "CategoriaViewController.h"
#import "SingletonManager.h"
#import "SWRevealViewController.h"
#import "SVProgressHUD.h"


@interface ClubViewController () 
@property (weak, nonatomic) IBOutlet UIButton *menuButtonClub;
@end

@implementation ClubViewController
@synthesize categoryItemsArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestLocation];
   //[self loadCategories];
    // Do any additional setup after loading the view.
    //Creamos el singleton
    SingletonManager *singleton = [SingletonManager singletonManager];
    
    SWRevealViewController *revealViewController2 = self.revealViewController;
    if (revealViewController2) {
        NSLog(@"SI existe el reveeal");
        [_menuButtonClub
         addTarget:revealViewController2 action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        // [self.view addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    }else{
        SWRevealViewController *revealViewController3 = [[SWRevealViewController alloc] init];
        [_menuButtonClub
         addTarget:revealViewController3 action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        NSLog(@"No existe el reveeal");
        
    }
    
    
    // Do any additional setup after loading the view.
   
}



-(void)requestLocation {
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
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
        
        CLLocation *location = [locationManager location];
        CLLocationCoordinate2D coordinate = [location coordinate];
        
        NSString *str=[[NSString alloc] initWithFormat:@" latitude:%f longitude:%f",coordinate.latitude,coordinate.longitude];
        NSLog(@"%@",str);
        SingletonManager *singleton = [SingletonManager singletonManager];
        singleton.userLocation = location;

    }else{
        [locationManager requestWhenInUseAuthorization];
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
                
                Category *categoria = [[Category alloc] init ];

               
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
                beneficio.idBen = idBen;
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
        SingletonManager *singleton = [SingletonManager singletonManager];
        singleton.categoryList = categoryItemsArray;
        CategoriaViewController *categoriaViewController= (CategoriaViewController*)segue.destinationViewController;
        categoriaViewController.categoryName = @"infantil";
        NSLog(@"MI CategoryName es: %@",categoriaViewController.categoryName);
        //NSLog(@"LOS ITEMS ARRAY SON: %@",categoryItemsArray.description);
        categoriaViewController.categoryItemsArray = categoryItemsArray;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"idCat == %d", 8];
        NSArray *filteredArray = [categoryItemsArray filteredArrayUsingPredicate:predicate];
        
        Category* firstFoundObject = nil;
        firstFoundObject =  filteredArray.count > 0 ? filteredArray.firstObject : nil;
        categoriaViewController.category = firstFoundObject;
        NSLog(@"  obejtooo  Infantil cat : %@",firstFoundObject.description);
        categoriaViewController.categoryId = 8;
        categoriaViewController.category = firstFoundObject;
        categoriaViewController.categoryItemsArray = firstFoundObject.arrayBenefits;
        
        NSLog(@" El array de beneficios  Infantil es : %@", categoriaViewController.categoryItemsArray);

    }
    
    if ([[segue identifier] isEqualToString:@"segueSabores"])
    {
        NSLog(@"MI Segue Sabores detected");
        
        SingletonManager *singleton = [SingletonManager singletonManager];
        singleton.categoryList = categoryItemsArray;
        
        CategoriaViewController *categoriaViewController= (CategoriaViewController*)segue.destinationViewController;
        categoriaViewController.categoryName = @"sabores";
            NSLog(@"Mi CategoryName es: %@",categoriaViewController.categoryName);
        
        categoriaViewController.categoryItemsArray = categoryItemsArray;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"idCat == %d", 3];
        NSArray *filteredArray = [categoryItemsArray filteredArrayUsingPredicate:predicate];
        
        Category* firstFoundObject = nil;
        firstFoundObject =  filteredArray.count > 0 ? filteredArray.firstObject : nil;
        categoriaViewController.category = firstFoundObject;
        NSLog(@"  objetooo cat : %@",firstFoundObject);
        categoriaViewController.categoryId = 3;
        categoriaViewController.category = firstFoundObject;
        
    }
    
    if ([[segue identifier] isEqualToString:@"segueTiempoLibre"])
    {
        NSLog(@"Segue Tiempo Libre detected");
        SingletonManager *singleton = [SingletonManager singletonManager];
        singleton.categoryList = categoryItemsArray;
        
        CategoriaViewController *categoriaViewController= (CategoriaViewController*)segue.destinationViewController;
        categoriaViewController.categoryName = @"tiempoLibre";
        NSLog(@"CategoryName es: %@",categoriaViewController.categoryName);
        
        categoriaViewController.categoryItemsArray = categoryItemsArray;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"idCat == %d", 3];
        NSArray *filteredArray = [categoryItemsArray filteredArrayUsingPredicate:predicate];
        
        Category* firstFoundObject = nil;
        firstFoundObject =  filteredArray.count > 0 ? filteredArray.firstObject : nil;
        categoriaViewController.category = firstFoundObject;
        NSLog(@"  obejtooo cat : %@",firstFoundObject);
        categoriaViewController.categoryId = 3;
        categoriaViewController.category = firstFoundObject;
    }
    
    if ([[segue identifier] isEqualToString:@"segueVidaSana"])
    {
        NSLog(@"Segue Vida Sana detected");
        
        SingletonManager *singleton = [SingletonManager singletonManager];
        singleton.categoryList = categoryItemsArray;
        
        CategoriaViewController *categoriaViewController= (CategoriaViewController*)segue.destinationViewController;
        categoriaViewController.categoryName = @"vidaSana";
        NSLog(@"CategoryName es: %@",categoriaViewController.categoryName);
    }
    
    if ([[segue identifier] isEqualToString:@"segueMastercard"])
    {
        NSLog(@"Segue Mastercard detected");
        SingletonManager *singleton = [SingletonManager singletonManager];
        singleton.categoryList = categoryItemsArray;
        
        CategoriaViewController *categoriaViewController= (CategoriaViewController*)segue.destinationViewController;
        categoriaViewController.categoryName = @"mastercard";
        NSLog(@"CategoryName es: %@",categoriaViewController.categoryName);
    }
    
    if ([[segue identifier] isEqualToString:@"segueServicios"])
    {
        NSLog(@"Segue Servicios detected");
        SingletonManager *singleton = [SingletonManager singletonManager];
        singleton.categoryList = categoryItemsArray;
        
        CategoriaViewController *categoriaViewController= (CategoriaViewController*)segue.destinationViewController;
        categoriaViewController.categoryName = @"servicios";
        NSLog(@"CategoryName es: %@",categoriaViewController.categoryName);
    }
    
    if ([[segue identifier] isEqualToString:@"segueTiendaClub"])
    {
        NSLog(@"Segue Tienda detected");
        SingletonManager *singleton = [SingletonManager singletonManager];
        singleton.categoryList = categoryItemsArray;
        
        CategoriaViewController *categoriaViewController= (CategoriaViewController*)segue.destinationViewController;
        categoriaViewController.categoryName = @"tienda";
        NSLog(@"CategoryName es: %@",categoriaViewController.categoryName);
    }
    
    if ([[segue identifier] isEqualToString:@"segueViajesClub"])
    {
        NSLog(@"Segue Viajes detected");
        SingletonManager *singleton = [SingletonManager singletonManager];
        singleton.categoryList = categoryItemsArray;
        
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

@end