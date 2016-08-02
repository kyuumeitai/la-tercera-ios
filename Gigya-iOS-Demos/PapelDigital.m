//
//  PapelDigital.m
//  La Tercera
//
//  Created by diseno on 07-04-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "PapelDigital.h"
#import "SessionManager.h"
#import "SWRevealViewController.h"
#import "SVProgressHUD.h"

#import "CVLaTercera.h"
#import "CVEdicionEspecial.h"
#import "CVElDeportivo.h"
#import "CVNegocios.h"

#import "InfantilContainerVC.h"
#import "InfantilTableViewController.h"
#import "SaboresContainerVC.h"
#import "SaboresTableViewController.h"
#import "TiempoLibreContainerVC.h"
#import "TiempoLibreTableViewController.h"
#import "VidaSanaContainerVC.h"
#import "VidaSanaTableViewController.h"
#import "ServiciosContainerVC.h"
#import "ServiciosTableViewController.h"


@implementation PapelDigital

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //[SVProgressHUD show];
    //[self loadPaper];
    //[SVProgressHUD setStatus:@"Obteniendo categorías disponibles"];
    // Do any additional setup after loading the view.
   
    //Creamos el singleton sesión
    SessionManager *sesion = [SessionManager session];
    
    
    SWRevealViewController *revealViewController = self.revealViewController;
    sesion.leftSlideMenu = revealViewController;
    [_menuButton addTarget:sesion.leftSlideMenu action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addGestureRecognizer: self.revealViewController.panGestureRecognizer];

    
    [self setupNewsCategory];
    //[self loadWeb];
    // NSLog(@"Entonces el singleton es: %@",singleton.leftSlideMenu);
    // Do any additional setup after loading the view.
}

-(void) setupNewsCategory{
    NSLog(@"setup News categories");
    
    // SetUp ViewControllers
    CVLaTercera *newsLaTercera = [self.storyboard instantiateViewControllerWithIdentifier:@"newsSectionLaTercera"];
    newsLaTercera.title = @"La Tercera";
    
    CVEdicionEspecial *newsEdicionEspecial = [self.storyboard instantiateViewControllerWithIdentifier:@"newsSectionEdicionEspecial"];
    newsEdicionEspecial.title = @"Ed.Especial";
    
    CVElDeportivo *newsElDeportivo = [self.storyboard instantiateViewControllerWithIdentifier:@"newsSectionElDeportivo"];
    newsElDeportivo.title = @"El Deportivo";
    
    
    CVNegocios *newsNegocios = [self.storyboard instantiateViewControllerWithIdentifier:@"newsSectionNegocios"];
    newsNegocios.title = @"Negocios";
    
    
    // ContainerView
    //float statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    //float navigationHeight = self.navigationController.navigationBar.frame.size.height;
    float headerSpace = 5.0;
    YSLContainerViewController *containerVC = [[YSLContainerViewController alloc]initWithControllers:@[newsLaTercera,newsElDeportivo,newsEdicionEspecial,newsNegocios]    topBarHeight:headerSpace                                                                                parentViewController:self selectedIndex:0];
    
    containerVC.delegate = self;
    
    
    containerVC.menuItemFont = [UIFont fontWithName:@"PT-Sans" size:16];
    UIView *getView = (UIView*)[self.view viewWithTag:300];
    [getView addSubview:containerVC.view];
    
    
}

#pragma mark - Load Categories
#pragma mark -- YSLContainerViewControllerDelegate
- (void)containerViewItemIndex:(NSInteger)index currentController:(UIViewController *)controller
{
    NSLog(@"current Index : %ld",(long)index);
    NSLog(@"current controller : %@",controller);
    [controller viewWillAppear:YES];
}



@end
