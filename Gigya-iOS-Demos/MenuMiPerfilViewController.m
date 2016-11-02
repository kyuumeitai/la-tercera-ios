//
//  MenuMiPerfilViewController.m
//  La Tercera
//
//  Created by diseno on 28-07-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "MenuMiPerfilViewController.h"
#import "SessionManager.h"
#import "SWRevealViewController.h"
@interface MenuMiPerfilViewController ()
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@end

@implementation MenuMiPerfilViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //Creamos el singleton
    SessionManager *sesion = [SessionManager session];
    
    SWRevealViewController *revealViewController = sesion.leftSlideMenu;
    revealViewController.delegate = self.revealViewController;
    if (revealViewController) {
        [_menuButton
         addTarget:revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
      [self.view addGestureRecognizer: revealViewController.panGestureRecognizer];
    }
    UITapGestureRecognizer *tap = [revealViewController tapGestureRecognizer];
    tap.delegate = self;
    
    [self.view addGestureRecognizer:tap];

    
    //Creamos el singleton sesión
    //SessionManager *sesion = [SessionManager session];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonClicked:(id)sender {
    NSLog(@"OK closing time BABY");
    //Creamos el singleton
    SessionManager *sesion = [SessionManager session];
     SWRevealViewController *revealViewController = sesion.leftSlideMenu;
    [revealViewController revealToggleAnimated:YES];
      // [self.navigationController popViewControllerAnimated:YES];
    
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
