//
//  AjustesTableViewController.h
//  La Tercera
//
//  Created by diseno on 28-07-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownPicker.h"//;
#import "UIDownPicker.h"//;

@interface AjustesTableViewController : UITableViewController <UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UISwitch *notificacionesNoticia;
@property (weak, nonatomic) IBOutlet UISwitch *notificacionesClub;
@property (weak, nonatomic) IBOutlet UIButton *seccionesButton;

@end
