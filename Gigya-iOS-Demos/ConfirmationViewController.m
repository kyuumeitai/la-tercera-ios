//
//  ConfirmationViewController.m
//  La Tercera
//
//  Created by diseno on 27-04-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "ConfirmationViewController.h"

@interface ConfirmationViewController ()

@end

@implementation ConfirmationViewController

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
    
    [[[self presentingViewController] presentingViewController] dismissViewControllerAnimated:YES completion:nil];
/*
    [self dismissViewControllerAnimated:YES completion:^{

    [[self parentViewController] dismissViewControllerAnimated:YES completion:nil];

    }];
*/
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
