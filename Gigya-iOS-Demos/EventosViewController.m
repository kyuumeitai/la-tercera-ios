//
//  EventosViewController.m
//  La Tercera
//
//  Created by Mario Alejandro Ramos on 26-04-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "EventosViewController.h"
#import "SingletonManager.h"

@implementation EventosViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
       SingletonManager *singleton = [SingletonManager singletonManager];
     [_menuButton addTarget:singleton.leftSlideMenu action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
}

@end
