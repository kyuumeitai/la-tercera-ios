//
//  CategoriaViewController.m
//  La Tercera
//
//  Created by diseno on 14-03-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "CategoriaViewController.h"


#import "YSLContainerViewController.h"

#import "InfantilContainerVC.h"
#import "InfantilTableViewController.h"
#import "SaboresContainerVC.h"
#import "SaboresTableViewController.h"
#import "TiempoLibreContainerVC.h"
#import "TiempoLibreTableViewController.h"
#import "VidaSanaContainerVC.h"
#import "VidaSanaTableViewController.h"
#import "MastercardContainerVC.h"
#import "MastercardTableViewController.h"
#import "ServiciosContainerVC.h"
#import "ServiciosTableViewController.h"
#import "TiendaClubContainerVC.h"
#import "TiendaClubTableViewController.h"
#import "ViajesClubContainerVC.h"
#import "ViajesClubTableViewController.h"


@interface CategoriaViewController ()<YSLContainerViewControllerDelegate>


@end

@implementation CategoriaViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    
    //[self loadCategory];
    [self setupClubCategories];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setupClubCategories{
    NSLog(@"setup Club categories");
    
    // SetUp ViewControllers
    SaboresContainerVC *clubSabores = [self.storyboard instantiateViewControllerWithIdentifier:@"clubCategorySabores"];
    clubSabores.title = @"Sabores";
    
    InfantilContainerVC *clubInfantil = [self.storyboard instantiateViewControllerWithIdentifier:@"clubCategoryInfantil"];
    clubInfantil.title = @"Infantil";
    
    TiempoLibreContainerVC *clubTiempoLibre = [self.storyboard instantiateViewControllerWithIdentifier:@"clubCategoryTiempoLibre"];
    clubTiempoLibre.title = @"Tiempo Libre";
    
    VidaSanaContainerVC *clubVidaSana = [self.storyboard instantiateViewControllerWithIdentifier:@"clubCategoryVidaSana"];
    clubVidaSana.title = @"Vida Sana";
    
    MastercardContainerVC *clubMastercard = [self.storyboard instantiateViewControllerWithIdentifier:@"clubCategoryMastercard"];
    clubMastercard.title = @"Mastercard";
    
    ServiciosContainerVC *clubServicios = [self.storyboard instantiateViewControllerWithIdentifier:@"clubCategoryServicios"];
    clubServicios.title = @"Servicios";
    
    TiendaClubContainerVC *clubTienda = [self.storyboard instantiateViewControllerWithIdentifier:@"clubCategoryTiendaClub"];
    clubTienda.title = @"Tienda";
    
    ViajesClubContainerVC *clubViajes = [self.storyboard instantiateViewControllerWithIdentifier:@"clubCategoryViajesClub"];
    clubViajes.title = @"Viajes";
    
    // ContainerView
    //float statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    //float navigationHeight = self.navigationController.navigationBar.frame.size.height;
    float headerSpace = 5.0;
    YSLContainerViewController *containerVC = [[YSLContainerViewController alloc]initWithControllers:@[clubSabores,clubInfantil,clubTiempoLibre,clubVidaSana,clubMastercard,clubServicios,clubTienda,clubViajes]                                                                                        topBarHeight:headerSpace                                                                                parentViewController:self];
    
    containerVC.delegate = self;
    
    containerVC.menuItemFont = [UIFont fontWithName:@"PT-Sans" size:16];
    UIView *getView = (UIView*)[self.view viewWithTag:200];
    [getView addSubview:containerVC.view];
    
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

    
}

#pragma mark - Menu Categories


#pragma mark - Load Categories
- (void)loadCategory {
    NSLog(@"----- LOAD CATEGORY -------");
    if ([self.categoryName  isEqual: @"infantil"]) {
        
        NSLog(@"Cargando Categoría: %@",_categoryName);
        //self.botonInfantil.selected = true;
        InfantilTableViewController *viewController1 = //
        [self.storyboard instantiateViewControllerWithIdentifier:@"infantilTableView"];
        viewController1.view.frame = self.containerView.bounds;
        
        [viewController1 willMoveToParentViewController:self];
        [self.containerView addSubview:viewController1.view];
        [self addChildViewController:viewController1];
        [viewController1 didMoveToParentViewController:self];
        
    }
    
    if ([self.categoryName  isEqual: @"sabores"]) {
        
        NSLog(@"Cargando Categoría: %@",_categoryName);
        //self.botonSabores.selected = true;
        /*
        InfantilTableViewController *viewController1 = //
        [self.storyboard instantiateViewControllerWithIdentifier:@"infantilTableView"];
        viewController1.view.frame = self.containerView.bounds;
        
        [viewController1 willMoveToParentViewController:self];
        [self.containerView addSubview:viewController1.view];
        [self addChildViewController:viewController1];
        [viewController1 didMoveToParentViewController:self];
        */
    }
}

#pragma mark - Load Categories
#pragma mark -- YSLContainerViewControllerDelegate
- (void)containerViewItemIndex:(NSInteger)index currentController:(UIViewController *)controller
{
    NSLog(@"current Index : %ld",(long)index);
    NSLog(@"current controller : %@",controller);
    [controller viewWillAppear:YES];
}

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
