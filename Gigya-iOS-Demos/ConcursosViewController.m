//
//  ConcursosViewController.m
//  La Tercera
//
//  Created by Mario Alejandro on 11-10-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "ConcursosViewController.h"
#import "SWRevealViewController.h"
#import "SessionManager.h"

@interface ConcursosViewController ()
@property (weak, nonatomic) IBOutlet UIButton *menuButtonConcursos;
@end

@implementation ConcursosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //Creamos el singleton
    SessionManager *sesion = [SessionManager session];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based applicaion, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
