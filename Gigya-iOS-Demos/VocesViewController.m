//
//  VocesViewController.m
//  La Tercera
//
//  Created by Mario Alejandro on 10-10-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "VocesViewController.h"
#import "SWRevealViewController.h"
#import "SessionManager.h"

@interface VocesViewController ()
@property (weak, nonatomic) IBOutlet UIButton *menuButton;

@end

@implementation VocesViewController
BOOL sidebarMenuOpen3;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    SessionManager *sesion = [SessionManager session];
    sidebarMenuOpen3 = NO;
    SWRevealViewController *revealViewController = sesion.leftSlideMenu;
    self.revealViewController.delegate = self;
    if (revealViewController) {
        [_menuButton
         addTarget:revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addGestureRecognizer: revealViewController.panGestureRecognizer];
    }
    UITapGestureRecognizer *tap = [revealViewController tapGestureRecognizer];
    tap.delegate = self;
    
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
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
        sidebarMenuOpen3 = NO;
        [self.revealViewController tapGestureRecognizer].enabled = NO;
        
    } else {
        //NSLog(@"Wastouy en sidebar = si");
        
        //self.view.userInteractionEnabled = NO;
        sidebarMenuOpen3 = YES;
        [self.revealViewController tapGestureRecognizer].enabled = YES;
        
    }
}

- (void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position
{
    if(position == FrontViewPositionLeft) {
        //self.view.userInteractionEnabled = YES;
        sidebarMenuOpen3 = NO;
    } else {
        //self.view.userInteractionEnabled = NO;
        sidebarMenuOpen3 = YES;
    }
}

@end
