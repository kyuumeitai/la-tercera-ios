//
//  DetalleNewsViewController.h
//  La Tercera
//
//  Created by diseno on 14-06-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetalleNewsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *titulo;
@property (weak, nonatomic) IBOutlet UILabel *summary;
@property (weak, nonatomic) IBOutlet UIImageView *imagenNews;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (retain,nonatomic) NSString * tituloCategoria;

-(void)loadBenefitForBenefitId:(int)idArticle andCategory:(NSString*)categoria;
@end
