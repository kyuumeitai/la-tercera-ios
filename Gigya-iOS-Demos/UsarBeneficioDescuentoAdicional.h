//
//  UsarBeneficioDescuentoAdicional.h
//  La Tercera
//
//  Created by diseno on 21-03-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UsarBeneficioDescuentoAdicional : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *montoTextField;
@property (weak, nonatomic) IBOutlet UITextField *codigoComercioTextfield;
@property (weak, nonatomic) IBOutlet UITextField *emailTesting;

- (void)initWithIdBeneficio:(NSString*)_idBeneficio andSucursal:(NSString*)_idSucursal andCommerce:(NSString*)_idComercio;
@end
