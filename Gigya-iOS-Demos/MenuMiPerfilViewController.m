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
BOOL sidebarMenuOpenPerfil;
- (void)viewDidLoad {
    [super viewDidLoad];
    //Creamos el singleton
    SessionManager *sesion = [SessionManager session];
    
    sidebarMenuOpenPerfil = NO;
    SWRevealViewController *revealViewController = self.revealViewController;
    self.revealViewController.delegate = self;
    sesion.leftSlideMenu = revealViewController;
    [_menuButton addTarget:sesion.leftSlideMenu action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    UITapGestureRecognizer *tap = [self.revealViewController tapGestureRecognizer];
    tap.delegate = self;
    
    [self.view addGestureRecognizer:tap];
    [self.revealViewController tapGestureRecognizer].enabled = NO;


    
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
- (void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position
{
    if(position == FrontViewPositionLeft) {
        NSLog(@"Wastouy en sidebar = no");
        //self.view.userInteractionEnabled = YES;
        sidebarMenuOpenPerfil = NO;
        [self.revealViewController tapGestureRecognizer].enabled = NO;
        
    } else {
        NSLog(@"Wastouy en sidebar = si");
        
        //self.view.userInteractionEnabled = NO;
        sidebarMenuOpenPerfil = YES;
        [self.revealViewController tapGestureRecognizer].enabled = YES;
        
    }
}

- (void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position
{
    if(position == FrontViewPositionLeft) {
        //self.view.userInteractionEnabled = YES;
        sidebarMenuOpenPerfil = NO;
    } else {
        //self.view.userInteractionEnabled = NO;
        sidebarMenuOpenPerfil = YES;
    }
}




@end
