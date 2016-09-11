//
//  MenuMiPerfilViewController.m
//  La Tercera
//
//  Created by diseno on 28-07-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "MenuMiPerfilViewController.h"
#import "SessionManager.h"

@interface MenuMiPerfilViewController ()

@end

@implementation MenuMiPerfilViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Creamos el singleton sesión
    SessionManager *sesion = [SessionManager session];
    
    
    SWRevealViewController *revealViewController = self.revealViewController;
    sesion.leftSlideMenu = revealViewController;
    [_menuButton addTarget:sesion.leftSlideMenu action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addGestureRecognizer: self.revealViewController.panGestureRecognizer];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonClicked:(id)sender {
    NSLog(@"OK closing time BABY");
       [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - Load Categories
#pragma mark -- YSLContainerViewControllerDelegate
- (void)containerViewItemIndex:(NSInteger)index currentController:(UIViewController *)controller
{
    NSLog(@"current Index : %ld",(long)index);
    NSLog(@"current controller : %@",controller);
    [controller viewWillAppear:YES];
}


@end
