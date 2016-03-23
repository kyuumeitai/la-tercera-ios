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
#import "SingletonManager.h"

@interface NoticiasHomeViewController() <YSLContainerViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *menuButton;

@end

@implementation NoticiasHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNewsCategories];
    
    //Creamos el singleton
    SingletonManager *singleton = [SingletonManager singletonManager];
    
    /*
    if(singleton.leftSlideMenu == nil){
        NSLog(@"ENtre en singleton nulo");

        SWRevealViewController *revealViewController = self.revealViewController;
        singleton.leftSlideMenu = revealViewController;
        [_menuButton
         addTarget:singleton.leftSlideMenu action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        NSLog(@"ENtre en singleton exitente");
        [_menuButton removeTarget:nil
                           action:NULL
                 forControlEvents:UIControlEventAllEvents];
    [_menuButton
     addTarget:singleton.leftSlideMenu action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    }
    NSLog(@"Entoncs el singleton es: %@",singleton.leftSlideMenu);
 */
    // Do any additional setup after loading the view.
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
    newsPoliticaVC.title = @"Politica";
    
    // ContainerView
    //float statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    //float navigationHeight = self.navigationController.navigationBar.frame.size.height;
    float headerSpace = 5.0;
    YSLContainerViewController *containerVC = [[YSLContainerViewController alloc]initWithControllers:@[newsInicioVC,newsPoliticaVC,newsInicioVC,newsPoliticaVC,newsInicioVC,newsPoliticaVC,newsInicioVC,newsPoliticaVC]                                                                                        topBarHeight:headerSpace                                                                                parentViewController:self];
    
    containerVC.delegate = self;
    containerVC.menuItemFont = [UIFont fontWithName:@"PT-Sans" size:16];
    UIView *getView = (UIView*)[self.view viewWithTag:100];
    [getView addSubview:containerVC.view];


}

- (IBAction)menuPressed:(id)sender {
    
    NSLog(@"presionado washoh vamosss");
    //Creamos el singleton
    SingletonManager *singleton = [SingletonManager singletonManager];

    
    
        NSLog(@"presionado washoh, YA EXISTES");
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
    NSLog(@"pressed tro");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
