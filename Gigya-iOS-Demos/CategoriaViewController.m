//
//  CategoriaViewController.m
//  La Tercera
//
//  Created by diseno on 14-03-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "CategoriaViewController.h"

@interface CategoriaViewController ()
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation CategoriaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)todosClicked:(id)sender {
    
    NSLog(@"Todos clicked");
}
- (IBAction)saboresClicked:(id)sender {
    NSLog(@"Sabores clicked");

}
- (IBAction)infantilClicked:(id)sender {
    NSLog(@"Infantol clicked");
    UIViewController *viewController1 = [self.storyboard instantiateViewControllerWithIdentifier:@"infantilTableView"];
    _containerView = nil;
    _containerView = viewController1.view;
}

- (IBAction)tiempoLibreClicked:(id)sender {
}
- (IBAction)serviciosClicked:(id)sender {
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
