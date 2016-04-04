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


@interface ClubViewController () 
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@end

@implementation ClubViewController
@synthesize categoryItemsArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    

    // Do any additional setup after loading the view.
    //Creamos el singleton
    SingletonManager *singleton = [SingletonManager singletonManager];
    
    
    SWRevealViewController *revealViewController = self.revealViewController;
    singleton.leftSlideMenu = revealViewController;
  [_menuButton addTarget:singleton.leftSlideMenu action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
   // NSLog(@"Entonces el singleton es: %@",singleton.leftSlideMenu);
    // Do any additional setup after loading the view.
    
   [self loadCategories];
   //[self loadBenefits];
   //[self loadCommerces];
   //[self loadStores];
    
   
}



-(void)loadCategories{
    
    NSLog(@"Load categories");
    
    ConnectionManager *connectionManager = [[ConnectionManager alloc]init];
    BOOL estaConectado = [connectionManager verifyConnection];
    NSLog(@"Verificando conexión: %d",estaConectado);
    [connectionManager getMainCategories:^(BOOL success, NSArray *arrayJson, NSError *error) {
        // IMPORTANT - Only update the UI on the main thread
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
    NSLog(@"     ");
    NSLog(@" ******* LISTADO DE CATEGORÍAS PRINCIPALES ****** ");
    for (id object in arrayJson){
        //if ([object objectForKey:@"category_parent"] != [NSNull null]) {
            if ([object objectForKey:@"category_parent"] == [NSNull null]) {
      
            id title = [object objectForKey:@"title"];
            id idCat = [object objectForKey:@"id"];
            id benefits = [object objectForKey:@"benefits"];
            id url = [object objectForKey:@"url"];
                
                UIImage *imagenDestacada = nil;
                if([object objectForKey:@"starred_image"] != [NSNull null]){
                NSString *imagenDestacadaEncoded = [object objectForKey:@"starred_image"] ;
                    //Creating the data from your base64String
                    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imagenDestacadaEncoded]];
                    
                    //Now data is decoded. You can convert them to UIImage
                    imagenDestacada = [UIImage imageWithData:data];
                }
                
                categoryItemsArray = [[NSMutableArray alloc] init];
                Category *categoria = [[Category alloc] init ];

               
                categoria.title = title;
                categoria.idCat = idCat;
                categoria.url = url;
           
                
                categoria.imagenDestacada = imagenDestacada;
                 //NSLog(@"Categoría: %@ , id: %@, url: %@, imagenDesatacada: %@ ",title,idCat,url, imagenDestacada);
                
                
                NSMutableArray* categoryBenefitsArray = [[NSMutableArray alloc] init];
                
            for (id benefit in benefits){

                id titleBen = [benefit objectForKey:@"title"];
                id idBen = [benefit objectForKey:@"id"] ;
                id linkBen = [benefit objectForKey:@"url"] ;
                id summaryBen = [benefit objectForKey:@"summary"] ;
                id benefitLabelBen = [benefit objectForKey:@"benefit_label"] ;
                
                UIImage *imagenBeneficio = nil;
                if([benefit objectForKey:@"image"] != [NSNull null]){
                    NSString *imagenBen = [object objectForKey:@"imagen"] ;
                    //Creating the data from your base64String
                    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imagenBen]];
                    
                    //Now data is decoded. You can convert them to UIImage
                    imagenBeneficio = [UIImage imageWithData:data];
                }
                
                Benefit *beneficio = [[Benefit alloc] init];
                beneficio.idBen = idBen;
                beneficio.title = titleBen;
                beneficio.url = linkBen;
                beneficio.summary= summaryBen;
                beneficio.desclabel = benefitLabelBen;
                beneficio.imagen = imagenBeneficio;
                
                [categoryBenefitsArray addObject:beneficio];
            }
                
                /*
                for (Benefit *ben in categoryBenefitsArray)
                   [ben logDescription];
                */
           
                
                categoria.arrayBenefits = categoryBenefitsArray;
                [categoryItemsArray addObject:categoria];

            }
        for (Category *cat in categoryItemsArray)
            [cat logDescription];
        
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
        NSLog(@"Segue Infantil detected");
        CategoriaViewController *categoriaViewController= (CategoriaViewController*)segue.destinationViewController;
        categoriaViewController.categoryName = @"infantil";
        NSLog(@"CategoryName es: %@",categoriaViewController.categoryName);
    }
    
    if ([[segue identifier] isEqualToString:@"segueSabores"])
    {
        NSLog(@"Segue Sabores detected");
        CategoriaViewController *categoriaViewController= (CategoriaViewController*)segue.destinationViewController;
        categoriaViewController.categoryName = @"sabores";
        categoriaViewController.categoryId = 3;
        NSLog(@"CategoryName es: %@",categoriaViewController.categoryName);
    }
    
    if ([[segue identifier] isEqualToString:@"segueTiempoLibre"])
    {
        NSLog(@"Segue Tiempo Libre detected");
        CategoriaViewController *categoriaViewController= (CategoriaViewController*)segue.destinationViewController;
        categoriaViewController.categoryName = @"tiempoLibre";
        NSLog(@"CategoryName es: %@",categoriaViewController.categoryName);
    }
    
    if ([[segue identifier] isEqualToString:@"segueVidaSana"])
    {
        NSLog(@"Segue Vida Sana detected");
        CategoriaViewController *categoriaViewController= (CategoriaViewController*)segue.destinationViewController;
        categoriaViewController.categoryName = @"vidaSana";
        NSLog(@"CategoryName es: %@",categoriaViewController.categoryName);
    }
    
    if ([[segue identifier] isEqualToString:@"segueMastercard"])
    {
        NSLog(@"Segue Mastercard detected");
        CategoriaViewController *categoriaViewController= (CategoriaViewController*)segue.destinationViewController;
        categoriaViewController.categoryName = @"mastercard";
        NSLog(@"CategoryName es: %@",categoriaViewController.categoryName);
    }
    
    if ([[segue identifier] isEqualToString:@"segueServicios"])
    {
        NSLog(@"Segue Servicios detected");
        CategoriaViewController *categoriaViewController= (CategoriaViewController*)segue.destinationViewController;
        categoriaViewController.categoryName = @"servicios";
        NSLog(@"CategoryName es: %@",categoriaViewController.categoryName);
    }
    
    if ([[segue identifier] isEqualToString:@"segueTiendaClub"])
    {
        NSLog(@"Segue Tienda detected");
        CategoriaViewController *categoriaViewController= (CategoriaViewController*)segue.destinationViewController;
        categoriaViewController.categoryName = @"tienda";
        NSLog(@"CategoryName es: %@",categoriaViewController.categoryName);
    }
    
    if ([[segue identifier] isEqualToString:@"segueViajesClub"])
    {
        NSLog(@"Segue Viajes detected");
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
   // NSLog(@"current Index : %ld",(long)index);
    //NSLog(@"current controller : %@",controller);
    [controller viewWillAppear:YES];
}

- (IBAction)presedOtro:(id)sender {
    NSLog(@"pressed tro");
}


@end