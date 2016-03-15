//
//  CategoriasViewController.m
//  La Tercera
//
//  Created by diseno on 15-03-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "CategoriasViewController.h"
#import "CategoriaViewController.h"
#import "InfantilTableViewController.h"

@interface CategoriasViewController ()

@end

@implementation CategoriasViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"segueInfantil"])
    {
        NSLog(@"Segue Infantil detected");
          CategoriaViewController *categoriaViewController= (CategoriaViewController*)segue.destinationViewController;
        categoriaViewController.categoryName = @"infantil";
        NSLog(@"CategoryName es: %@",categoriaViewController.categoryName);
    }
    
    if ([[segue identifier] isEqualToString:@"segueSabores"])
    {
        NSLog(@"Segue Infantil detected");
        CategoriaViewController *categoriaViewController= (CategoriaViewController*)segue.destinationViewController;
        categoriaViewController.categoryName = @"sabores";
        NSLog(@"CategoryName es: %@",categoriaViewController.categoryName);
    }
}

#pragma mark - Load Categories


@end
