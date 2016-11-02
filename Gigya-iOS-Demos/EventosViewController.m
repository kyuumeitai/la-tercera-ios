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
- (void)viewDidLoad {
    [super viewDidLoad];
    
    SessionManager *sesion = [SessionManager session];
    SWRevealViewController *revealViewController = self.revealViewController;
    sesion.leftSlideMenu = revealViewController;
    [_menuButton addTarget:sesion.leftSlideMenu action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    UITapGestureRecognizer *tap = [revealViewController tapGestureRecognizer];
    tap.delegate = self;
    
    [self.view addGestureRecognizer:tap];


}

@end
