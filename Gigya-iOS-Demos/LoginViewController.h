//
//  LoginViewController.h
//  App La Tercera
//
//  Created by Mario Alejandro Ramos.
//  Multinet All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GigyaSDK/Gigya.h>

@interface LoginViewController : UIViewController <GSPluginViewDelegate, GSAccountsDelegate>

typedef enum {
    REGISTRO,
    LOGIN
} GigyaFormAction;

@end

