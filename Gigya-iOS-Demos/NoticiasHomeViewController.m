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
#import "SWRevealViewController.h"
#import "SessionManager.h"
#import "ConnectionManager.h"
#import "UserProfile.h"
#import "Tools.h"

@interface NoticiasHomeViewController() <YSLContainerViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *menuButton;

@end

@implementation NoticiasHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLocalNotification];
    [self setupNewsCategories];
    
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController) {
        [_menuButton
         addTarget:revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        // [self.view addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    }
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

-(void) setupNewsCategories{
    
    // SetUp ViewControllers
    NewsCategoryInicioViewController *newsInicioVC = [self.storyboard instantiateViewControllerWithIdentifier:@"newsCategoryInicio"];
    newsInicioVC.title = @"Inicio";
    
    
    NewsCategoryPoliticaViewController *miSeleccionVC = [self.storyboard instantiateViewControllerWithIdentifier:@"newsCategoryPolitica"];
    miSeleccionVC.title = @"Mi Selección";
    
    NewsCategoryPoliticaViewController *newsPoliticaVC = [self.storyboard instantiateViewControllerWithIdentifier:@"newsCategoryPolitica"];
    newsPoliticaVC.title = @"Política";
    
    NewsCategoryPoliticaViewController *newsDeporteVC = [self.storyboard instantiateViewControllerWithIdentifier:@"newsCategoryPolitica"];
    newsDeporteVC.title = @"Deporte";
    
    
    
    // ContainerView
    //float statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    //float navigationHeight = self.navigationController.navigationBar.frame.size.height;
    float headerSpace = 5.0;
    YSLContainerViewController *containerVC = [[YSLContainerViewController alloc]initWithControllers:@[newsInicioVC,miSeleccionVC,newsPoliticaVC,newsDeporteVC]                                                                                        topBarHeight:headerSpace                                                                                parentViewController:self];
    
    containerVC.delegate = self;
    containerVC.menuItemFont = [UIFont fontWithName:@"PT-Sans" size:16];
    UIView *getView = (UIView*)[self.view viewWithTag:100];
    [getView addSubview:containerVC.view];


}

- (IBAction)menuPressed:(id)sender {
    
    //Creamos el singleton
    SessionManager *sesion = [SessionManager session];
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

- (void) setupLocalNotification{

    //Creamos el singleton
    SessionManager *sesion = [SessionManager session];
    
    NSLog(@"^^^^^^^^^^Descripción perfil: %@         ^^^^^^^^^^^",[sesion profileDescription]);

    [Tools showLocalInfoNotificationWithTitle:@"Info del perfil" andMessage:[sesion profileDescription]];
    //[Tools showLocalSuccessNotificationWithTitle:@"Erxito" andMessage:[sesion sessionDescription]];
    //[Tools showLocalErrorNotificationWithTitle:@"Cueck!" andMessage:@"Errorr"];
}


@end
