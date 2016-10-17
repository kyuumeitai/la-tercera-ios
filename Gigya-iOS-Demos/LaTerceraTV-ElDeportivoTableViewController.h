//
//  LaTerceraTV-ElDeportivoTableViewController.h
//  La Tercera
//
//  Created by Mario Alejandro on 17-10-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LaTerceraTV_ElDeportivoTableViewController : UITableViewController
<UITableViewDelegate, UITableViewDataSource>{
    NSMutableArray *laTerceraTVElDeportivoArray;
}
@property (nonatomic, retain) NSMutableArray *laTerceraTVElDeportivoArray;
@property int categoryId;

@end
