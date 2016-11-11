//
//  EventosViewController.m
//  La Tercera
//
//  Created by Mario Alejandro Ramos on 26-04-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "EventosViewController.h"
#import "SessionManager.h"

@implementation EventosViewController

BOOL sidebarMenuOpenEventos;

- (void)viewDidLoad {
    [super viewDidLoad];
    //Creamos el singleton
    SessionManager *sesion = [SessionManager session];
    
    sidebarMenuOpenEventos = NO;
    SWRevealViewController *revealViewController = self.revealViewController;
    self.revealViewController.delegate = self;
    sesion.leftSlideMenu = revealViewController;
    [_menuButton addTarget:sesion.leftSlideMenu action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    UITapGestureRecognizer *tap = [self.revealViewController tapGestureRecognizer];
    tap.delegate = self;
    
    [self.view addGestureRecognizer:tap];
    [self.revealViewController tapGestureRecognizer].enabled = NO;


}

- (void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position
{
    if(position == FrontViewPositionLeft) {
        NSLog(@"Wastouy en sidebar = no");
        //self.view.userInteractionEnabled = YES;
        sidebarMenuOpenEventos = NO;
        [self.revealViewController tapGestureRecognizer].enabled = NO;
        
    } else {
        NSLog(@"Wastouy en sidebar = si");
        
        //self.view.userInteractionEnabled = NO;
        sidebarMenuOpenEventos = YES;
        [self.revealViewController tapGestureRecognizer].enabled = YES;
        
    }
}

- (void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position
{
    if(position == FrontViewPositionLeft) {
        //self.view.userInteractionEnabled = YES;
        sidebarMenuOpenEventos = NO;
    } else {
        //self.view.userInteractionEnabled = NO;
        sidebarMenuOpenEventos = YES;
    }
}


@end
