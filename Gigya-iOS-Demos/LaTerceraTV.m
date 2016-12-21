//
//  LaTerceraTV.m
//  La Tercera
//
//  Created by BrUjO on 07-04-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "LaTerceraTV.h"
#import "LaTerceraTVHomeViewController.h"
#import "LaTerceraTVTerceraVozViewController.h"
#import "LaTerceraTVActualidadViewController.h"
#import "LaTerceraTVDebatesViewController.h"
#import "LaTerceraTVDeportesViewController.h"
#import "LaTerceraTVElDeportivoViewController.h"
#import "LaTerceraTVEnDirectoViewController.h"
#import "LaTerceraTVEntretencionViewController.h"
#import "LaTerceraTVMouseViewController.h"
#import "LaTerceraTVReportajesViewController.h"
#import "LaTerceraTVSeriesViewController.h"

#import "SessionManager.h"
#import "SWRevealViewController.h"
#import "SVProgressHUD.h"
#import "NewsCategoryInicioViewController.h"
#import "NewsCategoryPoliticaViewController.h"
#import "NewsCategoryMundoViewController.h"
#import "NewsCategoryCulturaViewController.h"
#import "NewsCategoryNacionalViewController.h"
#import "NewsCategoryNegociosViewController.h"
#import "NewsCategoryTendenciasViewController.h"
#import "NewsCategoryElDeportivoViewController.h"
#import "NewsCategoryEntretencionViewController.h"
#import "SWRevealViewController.h"
#import "ConnectionManager.h"
#import "UserProfile.h"
#import "Tools.h"
#import "ContentType.h"

@implementation LaTerceraTV

BOOL sidebarMenuOpen2;
- (void)viewDidLoad {
    [super viewDidLoad];

    //Creamos el singleton
    SessionManager *sesion = [SessionManager session];
    sidebarMenuOpen2 = NO;
    SWRevealViewController *revealViewController = self.revealViewController;
    self.revealViewController.delegate = self;
    sesion.leftSlideMenu = revealViewController;
    [_menuButton addTarget:sesion.leftSlideMenu action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    UITapGestureRecognizer *tap = [self.revealViewController tapGestureRecognizer];
    tap.delegate = self;
    
    [self.view addGestureRecognizer:tap];
    [self.revealViewController tapGestureRecognizer].enabled = NO;
    [self loadContentHeadlines];


}

-(void) loadContentHeadlines{
    
    ConnectionManager *conexion = [[ConnectionManager alloc] init];
    
    BOOL estaConectado = [conexion verifyConnection];
    NSLog(@"Verificando conexión: %d",estaConectado);
    [conexion getAllCategories:^(BOOL success, NSArray *arrayJson, NSError *error) {
        if (!success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"Error obteniendo datos! %@ %@", error, [error localizedDescription]);
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setupNewsCategories:arrayJson];
            });
        }
        
    }];
    
}

-(void) setupNewsCategories: (NSArray*)arrayHeadlinesJson{
    
    
    // SetUp ViewControllers
    //LaTerceraTVHomeViewController *ltTVHomeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"laTerceraTVHome"];
    
    //LaTerceraTVTerceraVozViewController *ltTVTerceraVozVC = [self.storyboard instantiateViewControllerWithIdentifier:@"laTerceraTVTerceraVoz"];

    LaTerceraTVActualidadViewController *ltTVActualidadVC = [self.storyboard instantiateViewControllerWithIdentifier:@"laTerceraTVActualidad"];

    LaTerceraTVDebatesViewController *ltTVDebatesVC = [self.storyboard instantiateViewControllerWithIdentifier:@"laTerceraTVDebates"];
    
    LaTerceraTVDebatesViewController *ltTVElDeportivoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"laTerceraTVElDeportivo"];
    
    LaTerceraTVDeportesViewController *ltTVDeportesVC = [self.storyboard instantiateViewControllerWithIdentifier:@"laTerceraTVDeportes"];
    
    LaTerceraTVEnDirectoViewController *ltTVEnDirectoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"laTerceraTVEnDirecto"];
    
    LaTerceraTVEntretencionViewController *ltTVEntretencionVC = [self.storyboard instantiateViewControllerWithIdentifier:@"laTerceraTVEntretencion"];
    
    LaTerceraTVMouseViewController *ltTVMouseVC = [self.storyboard instantiateViewControllerWithIdentifier:@"laTerceraTVMouse"];
    
    LaTerceraTVReportajesViewController *ltTVReportajesVC = [self.storyboard instantiateViewControllerWithIdentifier:@"laTerceraTVReportajes"];
    
    LaTerceraTVSeriesViewController *ltTVSeriesVC = [self.storyboard instantiateViewControllerWithIdentifier:@"laTerceraTVSeries"];

    SessionManager *sesion = [SessionManager session];
    
    for (NSDictionary *objeto in arrayHeadlinesJson) {
        ContentType *contenido = [[ContentType alloc]init];
        contenido.contentId = [[objeto valueForKey:@"id"] intValue] ;
        contenido.contentSlug = [objeto valueForKey:@"slug"] ;
        contenido.contentTitle = [objeto valueForKey:@"title"] ;
        [sesion.categoryList addObject:contenido];
        [contenido logDescription];
        
        NSString *slug = contenido.contentSlug ;
        
        /*if([slug isEqualToString:@"terceratv"]){
            ltTVHomeVC.title = contenido.contentTitle;
             ltTVHomeVC.title = @"Principal";
        }*/
        
        //if([slug isEqualToString:@"3a VOZ"]){
        //    ltTVTerceraVozVC.title = contenido.contentTitle;
        //}
        if([slug isEqualToString:@"Actualidad"]){
            ltTVActualidadVC.title = contenido.contentTitle;
        }
        
        if([slug isEqualToString:@"Debate LT"]){
            ltTVDebatesVC.title = contenido.contentTitle;
        }
        
        if([slug isEqualToString:@"Deportes"]){
            ltTVDeportesVC.title = contenido.contentTitle;
        }
        
        if([slug isEqualToString:@"El Deportivo"]){
            ltTVElDeportivoVC.title = contenido.contentTitle;
        }
        
        if([slug isEqualToString:@"En directo"]){
            ltTVEnDirectoVC.title = contenido.contentTitle;
        }
        
        if([slug isEqualToString:@"Entretencion"]){
            ltTVEntretencionVC.title = contenido.contentTitle;
        }
        
        if([slug isEqualToString:@"Entrevistas"]){
            ltTVReportajesVC.title = contenido.contentTitle;
        }
        
        if([slug isEqualToString:@"LT en Vivo"]){
            ltTVSeriesVC.title = contenido.contentTitle;
        }
        
        if([slug isEqualToString:@"Mouse"]){
            ltTVMouseVC.title = contenido.contentTitle;
        }
    }
    
    float headerSpace = 5.0;
    
       // YSLContainerViewController *containerVC = [[YSLContainerViewController alloc]initWithControllers:@[ltTVHomeVC,ltTVEnDirectoVC,ltTVEntretencionVC,ltTVMouseVC,ltTVReportajesVC,ltTVSeriesVC]                                                                                        topBarHeight:headerSpace     parentViewController:self];
  
   YSLContainerViewController *containerVC = [[YSLContainerViewController alloc]initWithControllers:@[ltTVActualidadVC,ltTVDebatesVC,ltTVDeportesVC,ltTVElDeportivoVC,ltTVEnDirectoVC,ltTVEntretencionVC,ltTVSeriesVC,ltTVReportajesVC,ltTVMouseVC]                                                                                        topBarHeight:headerSpace parentViewController:self];
    
    containerVC.delegate = self;
    containerVC.menuItemFont = [UIFont fontWithName:@"PT-Sans" size:16];
    UIView *getView = (UIView*)[self.view viewWithTag:100];
    [getView addSubview:containerVC.view];
    
}


-(void)loadWeb{
    
   // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://especiales.latercera.com/pruebas/newsite/index4.html"]];
    
    NSString *urlString = @"http://rudo.video/vod/b4vgIzYqFx";
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    _webViewLTtv.delegate = self;
    [_webViewLTtv loadRequest:urlRequest];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [SVProgressHUD dismiss];
}


#pragma mark -- YSLContainerViewControllerDelegate
- (void)containerViewItemIndex:(NSInteger)index currentController:(UIViewController *)controller
{
    NSLog(@"current Index : %ld",(long)index);
    NSLog(@"current controller : %@",controller);
    [controller viewWillAppear:YES];
}

- (IBAction)presedOtro:(id)sender {
    NSLog(@"pressed otro");
}

- (void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position
{
    if(position == FrontViewPositionLeft) {
        NSLog(@"Wastouy en sidebar = no");
        //self.view.userInteractionEnabled = YES;
        sidebarMenuOpen2 = NO;
        [self.revealViewController tapGestureRecognizer].enabled = NO;
        
    } else {
        NSLog(@"Wastouy en sidebar = si");
        
        //self.view.userInteractionEnabled = NO;
        sidebarMenuOpen2 = YES;
        [self.revealViewController tapGestureRecognizer].enabled = YES;
        
    }
}

- (void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position
{
    if(position == FrontViewPositionLeft) {
        //self.view.userInteractionEnabled = YES;
        sidebarMenuOpen2 = NO;
    } else {
        //self.view.userInteractionEnabled = NO;
        sidebarMenuOpen2 = YES;
    }
}

@end
