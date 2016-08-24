//
//  FavoritoDetailViewController.h
//  La Tercera
//
//  Created by Mario Alejandro on 22-08-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoritoDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *titulo;
@property (weak, nonatomic) IBOutlet UILabel *summary;
@property (weak, nonatomic) IBOutlet UIImageView *imagenNews;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (retain,nonatomic) NSString * tituloCategoria;
@property (weak, nonatomic) IBOutlet UILabel *labelFecha;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *labelCat;
@property (weak, nonatomic) IBOutlet UILabel *labelAutor;

@property (weak, nonatomic) IBOutlet UIImageView *upperSeparador;
@property (weak, nonatomic) IBOutlet UIImageView *lowerSeparador;
@property int idArticulo;

@property (retain, nonatomic) NSString *newsTitle;
@property (retain, nonatomic) NSString *newsSummary;
@property (retain, nonatomic) UIImage *newsImage;
@property (retain, nonatomic) NSString *newsCategory;
@property (retain, nonatomic) NSString *newsDate;
@property (retain, nonatomic) NSString *newsAuthor;
@property (retain, nonatomic) NSString *newsContent;

@end
