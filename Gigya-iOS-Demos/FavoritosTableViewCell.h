//
//  FavoritosTableViewCell.h
//  La Tercera
//
//  Created by Mario Alejandro on 21-08-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoritosTableViewCell : UITableViewCell

//@property (weak, nonatomic) IBOutlet UIImageView *imagenView;
@property (weak, nonatomic) IBOutlet UILabel *labelCategory;
@property (weak, nonatomic) IBOutlet UILabel *labelFecha;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;

@end
