//
//  NoticiasViewController.m
//  La Tercera
//
//  Created by diseno on 09-03-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "NoticiasViewController.h"
#import "SWRevealViewController.h"

@interface NoticiasViewController ()

@end

@implementation NoticiasViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)menuPressed:(id)sender {
    
            NSLog(@"presionado washoh vamosss");
    SWRevealViewController *revealViewController = nil;
    
    revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        NSLog(@"presionado washoh");
        [revealViewController revealViewController];
        [revealViewController revealToggleAnimated:YES];
        [self.view addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    }

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
