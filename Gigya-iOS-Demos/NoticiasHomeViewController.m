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
#import "GAI.h"
#import "GAIFields.h"
#import "GAITrackedViewController.h"
#import "GAIDictionaryBuilder.h"

@interface NoticiasHomeViewController() <YSLContainerViewControllerDelegate, SWRevealViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *menuButton;

@end

@implementation NoticiasHomeViewController
BOOL sidebarMenuOpen ;

- (void)viewDidLoad {
    [super viewDidLoad];
    sidebarMenuOpen = NO;
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
        self.revealViewController.delegate = self;
        
    }
    UITapGestureRecognizer *tap = [self.revealViewController tapGestureRecognizer];
    tap.delegate = self;
    
    [self.view addGestureRecognizer:tap];
    [self.revealViewController tapGestureRecognizer].enabled = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadContentHeadlines)
                                                 name:@"updateNewsCategories"
                                               object:nil];

}

- (void)viewWillAppear:(BOOL)animated{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Noticias/home"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
    
    [super viewWillAppear:animated];
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
    
    NSMutableArray *arrayVC = [[NSMutableArray alloc]init];
    [arrayVC removeAllObjects];
    
    // SetUp ViewControllers
    //NewsCategoryInicioViewController *newsInicioVC = [self.storyboard instantiateViewControllerWithIdentifier:@"newsCategoryInicio"];
    
    NewsCategoryNacionalViewController *newsNacionalVC = [self.storyboard instantiateViewControllerWithIdentifier:@"newsCategoryNacional"];
    
    NewsCategoryPoliticaViewController *newsPoliticaVC = [self.storyboard instantiateViewControllerWithIdentifier:@"newsCategoryPolitica"];
    
    NewsCategoryMundoViewController *newsMundoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"newsCategoryMundo"];
    
    NewsCategoryTendenciasViewController *newsTendenciasVC = [self.storyboard instantiateViewControllerWithIdentifier:@"newsCategoryTendencias"];
    
    NewsCategoryNegociosViewController *newsNegociosVC = [self.storyboard instantiateViewControllerWithIdentifier:@"newsCategoryNegocios"];
    
    NewsCategoryElDeportivoViewController *newsElDeportivoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"newsCategoryElDeportivo"];
    
    NewsCategoryEntretencionViewController *newsEntretencionVC = [self.storyboard instantiateViewControllerWithIdentifier:@"newsCategoryEntretencion"];
    
    NewsCategoryCulturaViewController *newsCulturaVC = [self.storyboard instantiateViewControllerWithIdentifier:@"newsCategoryCultura"];
    
    
    SessionManager *sesion = [SessionManager session];
    [sesion.categoryList removeAllObjects];
    
    for (NSDictionary *objeto in arrayHeadlinesJson) {
        ContentType *contenido = [[ContentType alloc]init];
        contenido.contentId = [[objeto valueForKey:@"id"] intValue] ;
        contenido.contentSlug = [objeto valueForKey:@"slug"] ;
        contenido.contentTitle = [objeto valueForKey:@"title"] ;
        contenido.contentHeadType = @"";
        contenido.contentVisibility = [[objeto valueForKey:@"visibility"] boolValue];
        contenido.contentIsShow = FALSE;
        
        NSString *slug = contenido.contentSlug ;

        if([slug isEqualToString:@"home"]){
            NewsCategoryInicioViewController *newsInicioVC = [self.storyboard instantiateViewControllerWithIdentifier:@"newsCategoryInicio"];
            newsInicioVC.title = contenido.contentTitle;
            [arrayVC addObject:newsInicioVC];
            contenido.contentHeadType = @"inicio";
        } else if([slug isEqualToString:@"nacional"]){
            newsNacionalVC.title = contenido.contentTitle;
        } else if([slug isEqualToString:@"politica"]){
            newsPoliticaVC.title = contenido.contentTitle;
        } else if([slug isEqualToString:@"mundo"]){
            newsMundoVC.title = contenido.contentTitle;
        } else if([slug isEqualToString:@"tendencias"]){
            newsTendenciasVC.title = contenido.contentTitle;
        } else if([slug isEqualToString:@"negocios"]){
            newsNegociosVC.title = contenido.contentTitle;
        } else if([slug isEqualToString:@"el-deportivo"]){
            newsElDeportivoVC.title = contenido.contentTitle;
        } else if([slug isEqualToString:@"entretencion"]){
            newsEntretencionVC.title = contenido.contentTitle;
        } else if([slug isEqualToString:@"cultura"]){
            newsCulturaVC.title = contenido.contentTitle;
        } else {
            if (contenido.contentVisibility) {
                NewsCategoryInicioViewController *newsInicioVC = [self.storyboard instantiateViewControllerWithIdentifier:@"newsCategoryInicio"];
                newsInicioVC.title = contenido.contentTitle;
                newsInicioVC.categoryIdNoticiasInicio = contenido.contentId;
                [arrayVC addObject:newsInicioVC];
                contenido.contentHeadType = @"inicio";
            }
        }
        
        [sesion.categoryList addObject:contenido];
        [contenido logDescription];
    }
    
    float headerSpace = 5.0;
    
    UserProfile *profile = [sesion getUserProfile];
    
    int profileLevel = profile.profileLevel;
    //TODO: Make a selection from preferences
    if(profileLevel == 2){
        MiSeleccionViewController *miSeleccion = [self.storyboard instantiateViewControllerWithIdentifier:@"newsMiSeleccion"];
        miSeleccion.title = @"Mi Selección";
        
        [arrayVC addObject: miSeleccion];
        [arrayVC addObject: newsNacionalVC];
        [arrayVC addObject: newsPoliticaVC];
        [arrayVC addObject: newsMundoVC];
        [arrayVC addObject: newsTendenciasVC];
        [arrayVC addObject: newsNegociosVC];
        [arrayVC addObject: newsElDeportivoVC];
        [arrayVC addObject: newsEntretencionVC];
        [arrayVC addObject: newsCulturaVC];
        
        YSLContainerViewController *containerVC = [[YSLContainerViewController alloc]initWithControllers:arrayVC topBarHeight:headerSpace parentViewController:self];
        containerVC.delegate = self;
        containerVC.menuItemFont = [UIFont fontWithName:@"PT-Sans" size:16];
        UIView *getView = (UIView*)[self.view viewWithTag:100];
        [getView addSubview:containerVC.view];
    }else{
        
        [arrayVC addObject: newsNacionalVC];
        [arrayVC addObject: newsPoliticaVC];
        [arrayVC addObject: newsMundoVC];
        [arrayVC addObject: newsTendenciasVC];
        [arrayVC addObject: newsNegociosVC];
        [arrayVC addObject: newsElDeportivoVC];
        [arrayVC addObject: newsEntretencionVC];
        [arrayVC addObject: newsCulturaVC];

        YSLContainerViewController *containerVC = [[YSLContainerViewController alloc]initWithControllers:arrayVC topBarHeight:headerSpace parentViewController:self];
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
    if (perfil.status == false && sesion.isLogged && sesion.hasShownMailConfirmation == false){
        NSString *mensaje = [NSString stringWithFormat:@"Para completar el registro debe confirmar el email, se le ha enviado un mensaje a: %@",perfil.email];
        [Tools showLocalInfoNotificationWithTitle:@"Verifique su email" andMessage:mensaje];
        sesion.hasShownMailConfirmation = true;

    }
    
 

   // [Tools showLocalInfoNotificationWithTitle:@"Info del perfil" andMessage:[sesion profileDescription]];
    //[Tools showLocalSuccessNotificationWithTitle:@"Erxito" andMessage:[sesion sessionDescription]];
    //[Tools showLocalErrorNotificationWithTitle:@"Cueck!" andMessage:@"Errorr"];
}
- (void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position
{
    if(position == FrontViewPositionLeft) {
        NSLog(@"Wastouy en sidebar = no");
        //self.view.userInteractionEnabled = YES;
        sidebarMenuOpen = NO;
        [self.revealViewController tapGestureRecognizer].enabled = NO;

    } else {
        NSLog(@"Wastouy en sidebar = si");

        //self.view.userInteractionEnabled = NO;
        sidebarMenuOpen = YES;
          [self.revealViewController tapGestureRecognizer].enabled = YES;

    }
}

- (void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position
{
    if(position == FrontViewPositionLeft) {
        //self.view.userInteractionEnabled = YES;
        sidebarMenuOpen = NO;
    } else {
        //self.view.userInteractionEnabled = NO;
        sidebarMenuOpen = YES;
    }
}




@end
