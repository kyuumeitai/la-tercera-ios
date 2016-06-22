//
//  TarjetaVirtual.h
//  La Tercera
//
//  Created by diseno on 22-06-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TarjetaVirtual : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageViewTarjetaVirtual;
-(void)cargaTarjetaWithImage:(UIImage*)imagen;
@end
