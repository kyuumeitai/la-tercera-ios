//
//  UsarBeneficioNoLogueado.h
//  La Tercera
//
//  Created by diseno on 21-03-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GigyaSDK/Gigya.h>

@interface UsarBeneficioNoLogueado : UIViewController <GSPluginViewDelegate, GSAccountsDelegate>
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

typedef enum {
    REGISTRO,
    LOGIN,
    INVALIDO
} GigyaFormAction;
- (void)cancelButtonText:(NSString*)texto;
@end
