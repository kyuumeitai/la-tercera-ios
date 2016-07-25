//
//  BeneficioGeneralDestacadoTableViewCell.h
//  La Tercera
//
//  Created by diseno on 25-07-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BeneficioGeneralDestacadoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelTitulo;
@property (weak, nonatomic) IBOutlet UILabel *labelDescuento;
@property (weak, nonatomic) IBOutlet UILabel *labelSubtitulo;
@property (weak, nonatomic) IBOutlet UIImageView *imageDestacada;
@end
