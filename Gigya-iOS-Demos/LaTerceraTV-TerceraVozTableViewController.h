//
//  LaTerceraTVTerceraVoz-TerceraVozTableViewController.h
//  La Tercera
//
//  Created by Mario Alejandro on 16-10-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LaTerceraTV_TerceraVozTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>{
    NSMutableArray *laTerceraTVTerceraVozArray;
}
@property (nonatomic, retain) NSMutableArray *laTerceraTVTerceraVozArray;
@property int categoryId;

@end
