//
//  TarjetaVirtual.m
//  La Tercera
//
//  Created by diseno on 22-06-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "TarjetaVirtual.h"

@interface TarjetaVirtual ()

@end

@implementation TarjetaVirtual

- (void)viewDidLoad {
    [super viewDidLoad];
 

    self.imageViewTarjetaVirtual.image = _virtualCardImage;
    // Do any additional setup after loading the view.
}

-(void)cargaTarjetaWithImage:(UIImage*)imagen{
    NSLog(@"Imagen acutalizada");
   self.imageViewTarjetaVirtual.image = imagen;
}

- (IBAction)backButtonPressed:(id)sender {
       [[[self presentingViewController] presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
