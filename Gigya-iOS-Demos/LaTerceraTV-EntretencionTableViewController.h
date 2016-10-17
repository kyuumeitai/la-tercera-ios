//
//  LaTerceraTV-EntretencionTableViewController.h
//  La Tercera
//
//  Created by Mario Alejandro on 17-10-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LaTerceraTV_EntretencionTableViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource>{
    NSMutableArray *laTerceraTVEntretencionArray;
}
@property (nonatomic, retain) NSMutableArray *laTerceraTVEntretencionArray;
@property int categoryId;

@end
