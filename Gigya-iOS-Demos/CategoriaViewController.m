//
//  CategoriaViewController.m
//  La Tercera
//
//  Created by diseno on 14-03-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "CategoriaViewController.h"
#import "InfantilTableViewController.h"

@interface CategoriaViewController ()



@end

@implementation CategoriaViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    
    [self loadCategory];
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




- (IBAction)tiempoLibreClicked:(id)sender {
}
- (IBAction)serviciosClicked:(id)sender {
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

    
}

#pragma mark - Menu Categories
- (IBAction)infantilClicked:(id)sender {
    NSLog(@"Infantil clicked");
    self.categoryName = @"infantil";
    [self loadCategory];
}

#pragma mark - Load Categories
- (void)loadCategory {
    
    if ([self.categoryName  isEqual: @"infantil"]) {
        NSLog(@"Cargando Categoría: %@",_categoryName);
        
        InfantilTableViewController *viewController1 = //
        [self.storyboard instantiateViewControllerWithIdentifier:@"infantilTableView"];
        viewController1.view.frame = self.containerView.bounds;
        
        [viewController1 willMoveToParentViewController:self];
        [self.containerView addSubview:viewController1.view];
        [self addChildViewController:viewController1];
        [viewController1 didMoveToParentViewController:self];
        
    }
    
}

@end
