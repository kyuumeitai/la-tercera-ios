//
//  FavoritosViewController.m
//  La Tercera
//
//  Created by BrUjO on 29-07-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "FavoritosViewController.h"

@interface FavoritosViewController ()

@end

@implementation FavoritosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backButtonPressed:(id)sender {

    [self.navigationController popViewControllerAnimated:YES];
}

@end
