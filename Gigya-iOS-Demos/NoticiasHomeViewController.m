//
//  NoticiasHomeViewController.m
//  La Tercera
//
//  Created by Mario Alejandro Ramos on 23-03-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "NoticiasHomeViewController.h"
#import "YSLContainerViewController.h"
#import "NewsCategoryInicioViewController.h"
#import "NewsCategoryPoliticaViewController.h"
#import "NewsCategoryMundoViewController.h"
#import "NewsCategoryCulturaViewController.h"
#import "NewsCategoryNacionalViewController.h"
#import "NewsCategoryNegociosViewController.h"
#import "NewsCategoryTendenciasViewController.h"
#import "NewsCategoryElDeportivoViewController.h"
#import "NewsCategoryEntretencionViewController.h"
#import "MiSeleccionViewController.h"
#import "SWRevealViewController.h"
#import "SessionManager.h"
#import "ConnectionManager.h"
#import "UserProfile.h"
#import "Tools.h"
#import "ContentType.h"
#import "SVProgressHUD.h"

@interface NoticiasHomeViewController() <YSLContainerViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *menuButton;

@end

@implementation NoticiasHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   [self setupLocalNotification];
    [SVProgressHUD showWithStatus:@"Actualizando noticias" maskType:SVProgressHUDMaskTypeClear];

    [self loadContentHeadlines];
    SessionManager *sesion = [SessionManager session];

    
    SWRevealViewController *revealViewController = self.revealViewController;
    sesion.leftSlideMenu = revealViewController;
    if (revealViewController) {
        [_menuButton
         addTarget:revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
         [self.view addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    }
    UITapGestureRecognizer *tap = [revealViewController tapGestureRecognizer];
    tap.delegate = self;
    
    [self.view addGestureRecognizer:tap];
}

- (IBAction)logoutGigyaButtonAction:(id)sender {
    [Gigya logoutWithCompletionHandler:^(GSResponse *response, NSError *error) {
        //self.user = nil;
        if (error) {
            UIAlertView *alert;
            alert = [[UIAlertView alloc] initWithTitle:@"Salir de Gigya"
                                               message:[@"Hubo un problema saliendo de Gigya. Codigo error " stringByAppendingFormat:@"%d",response.errorCode]
                                              delegate:nil
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil];
            [alert show];
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) loadContentHeadlines{

    ConnectionManager *conexion = [[ConnectionManager alloc] init];
    
    BOOL estaConectado = [conexion verifyConnection];
    NSLog(@"Verificando conexión: %d",estaConectado);
    [conexion getAllCategories:^(BOOL success, NSArray *arrayJson, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!success) {
                NSLog(@"Error obteniendo datos! %@ %@", error, [error localizedDescription]);
                [SVProgressHUD dismiss];
            } else {
                [self setupNewsCategories:arrayJson];
            }
        });
    }];

}

-(void) setupNewsCategories: (NSArray*)arrayHeadlinesJson{
    
    
    // SetUp ViewControllers
    NewsCategoryInicioViewController *newsInicioVC = [self.storyboard instantiateViewControllerWithIdentifier:@"newsCategoryInicio"];
    
    NewsCategoryNacionalViewController *newsNacionalVC = [self.storyboard instantiateViewControllerWithIdentifier:@"newsCategoryNacional"];
    
    NewsCategoryPoliticaViewController *newsPoliticaVC = [self.storyboard instantiateViewControllerWithIdentifier:@"newsCategoryPolitica"];
    
    NewsCategoryMundoViewController *newsMundoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"newsCategoryMundo"];
    
    NewsCategoryTendenciasViewController *newsTendenciasVC = [self.storyboard instantiateViewControllerWithIdentifier:@"newsCategoryTendencias"];
    
    NewsCategoryNegociosViewController *newsNegociosVC = [self.storyboard instantiateViewControllerWithIdentifier:@"newsCategoryNegocios"];
    
    NewsCategoryElDeportivoViewController *newsElDeportivoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"newsCategoryElDeportivo"];
    
    NewsCategoryEntretencionViewController *newsEntretencionVC = [self.storyboard instantiateViewControllerWithIdentifier:@"newsCategoryEntretencion"];
    
    NewsCategoryCulturaViewController *newsCulturaVC = [self.storyboard instantiateViewControllerWithIdentifier:@"newsCategoryCultura"];
    
    
    SessionManager *sesion = [SessionManager session];

    for (NSDictionary *objeto in arrayHeadlinesJson) {
        ContentType *contenido = [[ContentType alloc]init];
        contenido.contentId = [[objeto valueForKey:@"id"] intValue] ;
        contenido.contentSlug = [objeto valueForKey:@"slug"] ;
        contenido.contentTitle = [objeto valueForKey:@"title"] ;
        [sesion.categoryList addObject:contenido];
        [contenido logDescription];
        
        NSString *slug = contenido.contentSlug ;

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
    }
    
    float headerSpace = 5.0;
    
    UserProfile *profile = [sesion getUserProfile];
    
    int profileLevel = profile.profileLevel;
    
    if(profileLevel == 2){
        MiSeleccionViewController *miSeleccion = [self.storyboard instantiateViewControllerWithIdentifier:@"newsMiSeleccion"];
        miSeleccion.title = @"Mi Selección";
            YSLContainerViewController *containerVC = [[YSLContainerViewController alloc]initWithControllers:@[newsInicioVC,miSeleccion,newsNacionalVC,newsPoliticaVC,newsMundoVC,newsTendenciasVC,newsNegociosVC, newsElDeportivoVC ,newsEntretencionVC ,newsCulturaVC]                                                                                        topBarHeight:headerSpace     parentViewController:self];
        containerVC.delegate = self;
        containerVC.menuItemFont = [UIFont fontWithName:@"PT-Sans" size:16];
        UIView *getView = (UIView*)[self.view viewWithTag:100];
        [getView addSubview:containerVC.view];
    }else{

        YSLContainerViewController *containerVC = [[YSLContainerViewController alloc]initWithControllers:@[newsInicioVC,newsNacionalVC,newsPoliticaVC,newsMundoVC,newsTendenciasVC,newsNegociosVC, newsElDeportivoVC ,newsEntretencionVC ,newsCulturaVC]                                                                                        topBarHeight:headerSpace     parentViewController:self];
        containerVC.delegate = self;
        containerVC.menuItemFont = [UIFont fontWithName:@"PT-Sans" size:16];
        UIView *getView = (UIView*)[self.view viewWithTag:100];
        [getView addSubview:containerVC.view];

    }
    


}

- (IBAction)menuPressed:(id)sender {
    
    //Creamos el singleton
   // SessionManager *sesion = [SessionManager session];
   // [sender addTarget:self.revealViewController action:@selector(revealToogle:) forControlEvents:UIControlEventTouchUpInside];
       // singleton.leftSlideMenu = self.revealViewController;
        //[singleton.leftSlideMenu revealViewController];
        //[singleton.leftSlideMenu revealToggleAnimated:YES];
        //[self.view addGestureRecognizer: self.revealViewController.panGestureRecognizer];
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

/**
 Will show the subtle lccal notification
 */
- (void) setupLocalNotification{

    //Creamos el singleton
    SessionManager *sesion = [SessionManager session];
    UserProfile *perfil =  [sesion getUserProfile];
       NSLog(@"^^^^^^^^^^Descripción perfil: %@         ^^^^^^^^^^^",[sesion profileDescription]);
    if (perfil.status == false && sesion.isLogged){
        NSString *mensaje = [NSString stringWithFormat:@"Para completar el registro debe confirmar el email, se le ha enviado un mensaje a: %@",sesion.profileEmail];
        [Tools showLocalInfoNotificationWithTitle:@"Verifique su email" andMessage:mensaje];

    }
    
 

   // [Tools showLocalInfoNotificationWithTitle:@"Info del perfil" andMessage:[sesion profileDescription]];
    //[Tools showLocalSuccessNotificationWithTitle:@"Erxito" andMessage:[sesion sessionDescription]];
    //[Tools showLocalErrorNotificationWithTitle:@"Cueck!" andMessage:@"Errorr"];
}


@end
