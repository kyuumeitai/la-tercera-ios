//
//  LaTerceraTV.m
//  La Tercera
//
//  Created by BrUjO on 07-04-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "LaTerceraTV.h"
#import "LaTerceraTVHomeViewController.h"
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
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[SVProgressHUD show];
    //[self loadPaper];
    //[SVProgressHUD setStatus:@"Actualizando contenido"];
    // Do any additional setup after loading the view.
    //Creamos el singleton
    SessionManager *sesion = [SessionManager session];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    sesion.leftSlideMenu = revealViewController;
    [_menuButton addTarget:sesion.leftSlideMenu action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    
    [self loadContentHeadlines];

    //[self loadWeb];
    // NSLog(@"Entonces el singleton es: %@",singleton.leftSlideMenu);
    // Do any additional setup after loading the view.
    
    //[self loadCategories];
    //[self loadBenefits];
    //[self loadCommerces];
    //[self loadStores];
    
}


-(void) loadContentHeadlines{
    
    ConnectionManager *conexion = [[ConnectionManager alloc] init];
    
    BOOL estaConectado = [conexion verifyConnection];
    NSLog(@"Verificando conexión: %d",estaConectado);
    [conexion getAllCategories:^(BOOL success, NSArray *arrayJson, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!success) {
                NSLog(@"Error obteniendo datos! %@ %@", error, [error localizedDescription]);
            } else {
                [self setupNewsCategories:arrayJson];
            }
        });
    }];
    
}

-(void) setupNewsCategories: (NSArray*)arrayHeadlinesJson{
    
    
    // SetUp ViewControllers
    LaTerceraTVHomeViewController *ltTVHomeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"laTerceraTVHome"];
    
    /*
    NewsCategoryInicioViewController *newsInicioVC = [self.storyboard instantiateViewControllerWithIdentifier:@"newsCategoryInicio"];
    
    NewsCategoryNacionalViewController *newsNacionalVC = [self.storyboard instantiateViewControllerWithIdentifier:@"newsCategoryNacional"];
    
    NewsCategoryPoliticaViewController *newsPoliticaVC = [self.storyboard instantiateViewControllerWithIdentifier:@"newsCategoryPolitica"];
    
    NewsCategoryMundoViewController *newsMundoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"newsCategoryMundo"];
    
    NewsCategoryTendenciasViewController *newsTendenciasVC = [self.storyboard instantiateViewControllerWithIdentifier:@"newsCategoryTendencias"];
    
    NewsCategoryNegociosViewController *newsNegociosVC = [self.storyboard instantiateViewControllerWithIdentifier:@"newsCategoryNegocios"];
    
    NewsCategoryElDeportivoViewController *newsElDeportivoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"newsCategoryElDeportivo"];
    
    NewsCategoryEntretencionViewController *newsEntretencionVC = [self.storyboard instantiateViewControllerWithIdentifier:@"newsCategoryEntretencion"];
    
    NewsCategoryCulturaViewController *newsCulturaVC = [self.storyboard instantiateViewControllerWithIdentifier:@"newsCategoryCultura"];
    */
    
    SessionManager *sesion = [SessionManager session];
    
    for (NSDictionary *objeto in arrayHeadlinesJson) {
        ContentType *contenido = [[ContentType alloc]init];
        contenido.contentId = [[objeto valueForKey:@"id"] intValue] ;
        contenido.contentSlug = [objeto valueForKey:@"slug"] ;
        contenido.contentTitle = [objeto valueForKey:@"title"] ;
        [sesion.categoryList addObject:contenido];
        [contenido logDescription];
        
        NSString *slug = contenido.contentSlug ;
        
        if([slug isEqualToString:@"terceratv"]){
            ltTVHomeVC.title = contenido.contentTitle;
        }
        
        /*
        if([slug isEqualToString:@"home"]){
            newsInicioVC.title = contenido.contentTitle;
        }
        if([slug isEqualToString:@"nacional"]){
            newsNacionalVC.title = contenido.contentTitle;
        }
        if([slug isEqualToString:@"politica"]){
            newsPoliticaVC.title = contenido.contentTitle;
        }
        if([slug isEqualToString:@"mundo"]){
            newsMundoVC.title = contenido.contentTitle;
        }
        if([slug isEqualToString:@"tendencias"]){
            newsTendenciasVC.title = contenido.contentTitle;
        }
        if([slug isEqualToString:@"negocios"]){
            newsNegociosVC.title = contenido.contentTitle;
        }
        if([slug isEqualToString:@"el-deportivo"]){
            newsElDeportivoVC.title = contenido.contentTitle;
        }
        if([slug isEqualToString:@"entretencion"]){
            newsEntretencionVC.title = contenido.contentTitle;
        }
        if([slug isEqualToString:@"cultura"]){
            newsCulturaVC.title = contenido.contentTitle;
        }
         */
    }
    
    float headerSpace = 5.0;
    YSLContainerViewController *containerVC = [[YSLContainerViewController alloc]initWithControllers:@[ltTVHomeVC]                                                                                        topBarHeight:headerSpace     parentViewController:self];
    
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


@end
