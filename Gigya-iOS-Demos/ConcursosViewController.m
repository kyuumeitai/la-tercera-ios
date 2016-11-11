//
//  ConcursosViewController.m
//  La Tercera
//
//  Created by Mario Alejandro on 11-10-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "ConcursosViewController.h"
#import "SWRevealViewController.h"
#import "SessionManager.h"

@interface ConcursosViewController ()
@property (weak, nonatomic) IBOutlet UIButton *menuButtonConcursos;
@end

@implementation ConcursosViewController
BOOL sidebarMenuOpenConcursos;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //Creamos el singleton
    //Creamos el singleton
    SessionManager *sesion = [SessionManager session];
    
    sidebarMenuOpenConcursos = NO;
    SWRevealViewController *revealViewController = self.revealViewController;
    self.revealViewController.delegate = self;
    sesion.leftSlideMenu = revealViewController;
    [_menuButtonConcursos addTarget:sesion.leftSlideMenu action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    UITapGestureRecognizer *tap = [self.revealViewController tapGestureRecognizer];
    tap.delegate = self;
    
    [self.view addGestureRecognizer:tap];
    [self.revealViewController tapGestureRecognizer].enabled = NO;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based applicaion, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position
{
    if(position == FrontViewPositionLeft) {
        NSLog(@"Wastouy en sidebar = no");
        //self.view.userInteractionEnabled = YES;
        sidebarMenuOpenConcursos = NO;
        [self.revealViewController tapGestureRecognizer].enabled = NO;
        
    } else {
        NSLog(@"Wastouy en sidebar = si");
        
        //self.view.userInteractionEnabled = NO;
        sidebarMenuOpenConcursos = YES;
        [self.revealViewController tapGestureRecognizer].enabled = YES;
        
    }
}

- (void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position
{
    if(position == FrontViewPositionLeft) {
        //self.view.userInteractionEnabled = YES;
        sidebarMenuOpenConcursos = NO;
    } else {
        //self.view.userInteractionEnabled = NO;
        sidebarMenuOpenConcursos = YES;
    }
}


@end
