//
//  HistorialViewController.m
//  La Tercera
//
//  Created by BrUjO on 29-07-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "HistorialViewController.h"

@interface HistorialViewController ()

@end

@implementation HistorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

@end
