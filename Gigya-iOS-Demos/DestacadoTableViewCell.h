//
//  DestacadoTableViewCell.h
//  La Tercera
//
//  Created by diseno on 15-03-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DestacadoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelTitulo;
@property (weak, nonatomic) IBOutlet UILabel *labelDescuento;
@property (weak, nonatomic) IBOutlet UILabel *labelSubtitulo;
@property (weak, nonatomic) IBOutlet UILabel *labelDistancia;
@property (weak, nonatomic) IBOutlet UIImageView *imageDestacada;

@end
