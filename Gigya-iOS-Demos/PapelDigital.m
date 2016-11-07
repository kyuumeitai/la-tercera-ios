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
#import "PapelDigitalLaTerceraViewController.h"
#import "PapelDigitalNegociosViewController.h"

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
    
    [SVProgressHUD show];
    [SVProgressHUD setStatus:@"Cargando Papel Digital"];
    
    // Do any additional setup after loading the view.
    //Creamos el singleton
    SessionManager *sesion = [SessionManager session];
    
    
    SWRevealViewController *revealViewController = self.revealViewController;
    sesion.leftSlideMenu = revealViewController;
    [_menuButton addTarget:sesion.leftSlideMenu action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    
    
    [self loadWeb];
    // NSLog(@"Entonces el singleton es: %@",singleton.leftSlideMenu);
    // Do any additional setup after loading the view.
    
    //[self loadCategories];
    //[self loadBenefits];
    //[self loadCommerces];
    //[self loadStores];
    
}

-(void)loadWeb{
    
    // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://especiales.latercera.com/pruebas/newsite/index4.html"]];
    
    
    NSString *urlString = @"http://latercera.pressreader.com/la-tercera";
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    _webViewLTPapelDigital.delegate = self;
    [_webViewLTPapelDigital loadRequest:urlRequest];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSTimer *aTimer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(hideHUD) userInfo:nil repeats:YES];

    NSLog(@"A timer called %@",aTimer);
}

-(void)hideHUD{
    [SVProgressHUD dismiss];
}

@end
/*
- (void)viewDidLoad {
    
    [super viewDidLoad];
        [self setupNewsCategory];
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

    //PapelDigitalLaTerceraViewController *papelLaTercera = [self.storyboard instantiateViewControllerWithIdentifier:@"papelLaTercera"];
    //papelLaTercera.title = @"La Tercera";
    
    //PapelDigitalNegociosViewController *papelNegocios = [self.storyboard instantiateViewControllerWithIdentifier:@"papelNegocios"];
    //papelNegocios.title = @"Negocios";
    
    // ContainerView

    float headerSpace = 5.0;
   // YSLContainerViewController *containerVC = [[YSLContainerViewController alloc]initWithControllers:@[newsLaTercera,newsElDeportivo,newsEdicionEspecial,newsNegocios]    topBarHeight:headerSpace                                                                                parentViewController:self selectedIndex:0];
    YSLContainerViewController *containerPapelVC = [[YSLContainerViewController alloc]initWithControllers:@[newsLaTercera,newsNegocios,newsElDeportivo,newsEdicionEspecial]                                                                                        topBarHeight:headerSpace     parentViewController:self];
    
    containerPapelVC.delegate = self;
    
    
    containerPapelVC.menuItemFont = [UIFont fontWithName:@"PT-Sans" size:16];
    UIView *getView2 = (UIView*)[self.view viewWithTag:300];
    [getView2 addSubview:containerPapelVC.view];
    
    
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
 */
