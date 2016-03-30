//
//  ClubViewController.m
//  La Tercera
//
//  Created by diseno on 09-03-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "ClubViewController.h"
#import "ConnectionManager.h"
#import "CategoriasTableViewCell.h"
#import "CategoriaViewController.h"
#import "SingletonManager.h"
#import "SWRevealViewController.h"

@interface ClubViewController ()
@property (weak, nonatomic) IBOutlet UIButton *menuButton;

@end

@implementation ClubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    // Do any additional setup after loading the view.
    //Creamos el singleton
    SingletonManager *singleton = [SingletonManager singletonManager];
    
    
    SWRevealViewController *revealViewController = self.revealViewController;
    singleton.leftSlideMenu = revealViewController;
    [_menuButton
     addTarget:singleton.leftSlideMenu action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    NSLog(@"Entonces el singleton es: %@",singleton.leftSlideMenu);
    // Do any additional setup after loading the view.
    
   [self loadCategories];
   [self loadBenefits];
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
               // [self reloadSubCategoriesDataFromService:arrayJson];
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
            //id childs = [object objectForKey:@"childs"];
            id url = [object objectForKey:@"url"];
                
            NSLog(@"Categoría: %@ , id: %@, url: %@ ",title,idCat,url);
                /*
            for (id child in childs){

                id titleSub = [child objectForKey:@"title"];
                id idCatSub = [child objectForKey:@"description"] ;
                id linkCatSub = [child objectForKey:@"url"] ;
                NSLog(@"           Subategoría: %@ , idSubCat: %@, idSubCat: %@",titleSub,idCatSub,linkCatSub);
            }
                */
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
        id marker = [object objectForKey:@"marker"];
        NSLog(@"id: %@, titulo: %@ , marker: %@",idCom,title,marker);
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
        NSLog(@"Segue Infantil detected");
        CategoriaViewController *categoriaViewController= (CategoriaViewController*)segue.destinationViewController;
        categoriaViewController.categoryName = @"sabores";
        NSLog(@"CategoryName es: %@",categoriaViewController.categoryName);
    }
}

#pragma mark - Load Categories


@end