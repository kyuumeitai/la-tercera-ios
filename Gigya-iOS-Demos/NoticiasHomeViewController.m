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
    [self setupFakeProfileData];
    [self setupNewsCategories];
    
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController) {
        [_menuButton
         addTarget:revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        // [self.view addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setupNewsCategories{
    
    // SetUp ViewControllers
    NewsCategoryInicioViewController *newsInicioVC = [self.storyboard instantiateViewControllerWithIdentifier:@"newsCategoryInicio"];
    newsInicioVC.title = @"Inicio";
    
    NewsCategoryPoliticaViewController *newsPoliticaVC = [self.storyboard instantiateViewControllerWithIdentifier:@"newsCategoryPolitica"];
    newsPoliticaVC.title = @"Política";
    
    
    // ContainerView
    //float statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    //float navigationHeight = self.navigationController.navigationBar.frame.size.height;
    float headerSpace = 5.0;
    YSLContainerViewController *containerVC = [[YSLContainerViewController alloc]initWithControllers:@[newsInicioVC,newsPoliticaVC]                                                                                        topBarHeight:headerSpace                                                                                parentViewController:self];
    
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

- (void) setupFakeProfileData{

    //Creamos el singleton
    SessionManager *sesion = [SessionManager session];
    NSLog(@"Profile - Data original: %@",[sesion description]);

    UserProfile * perfilUsuario = [sesion getUserProfile];
    
    perfilUsuario.status = true;
    
    
    NSLog(@"Fakeamos alguna data: %@",[sesion description]);

    [Tools showLocalInfoNotificationWithTitle:@"Info del perfil" andMessage:[sesion description]];
    [Tools showLocalSuccessNotificationWithTitle:@"Erxito" andMessage:@"Exitooooo"];
    [Tools showLocalErrorNotificationWithTitle:@"Cueck!" andMessage:@"Errorr"];
    [Tools showLocalUnknownNotificationWithTitle:@"Desconocemos" andMessage:@"No savemos na de nah"];
}


@end
