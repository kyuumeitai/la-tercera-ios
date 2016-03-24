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
    
    ConnectionManager *connectionManager = [[ConnectionManager alloc]init];
    //BOOL estaConectado = [connectionManager verifyConnection];
    //NSLog(@"Verificando conección: %d",estaConectado);
    
    NSDictionary* responseDict = [connectionManager getMainCategories];
    [super viewDidLoad];
    

    // Do any additional setup after loading the view.
    //Creamos el singleton
    SingletonManager *singleton = [SingletonManager singletonManager];
    
    
    
    
    SWRevealViewController *revealViewController = self.revealViewController;
    singleton.leftSlideMenu = revealViewController;
    [_menuButton
     addTarget:singleton.leftSlideMenu action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    NSLog(@"Entoncs el singleton es: %@",singleton.leftSlideMenu);
    // Do any additional setup after loading the view.
  
    /*
    NSLog(@"    ------------ CATEGORIAS ------------");
    NSLog(@"    --------------------------------------");
    for (id objeto in responseDict) {
        if([objeto objectForKey:@"category_parent"] == (id)[NSNull null]){
            NSLog(@" Id Cat:%@       Categoría: %@. Link Categoria :%@ ", [objeto objectForKey:@"id"],[objeto objectForKey:@"title"], [objeto objectForKey:@"url"]);
            NSLog(@"    --------------------------------------");
        }
    }
    
*/
    
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