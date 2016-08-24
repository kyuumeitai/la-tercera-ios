//
//  FavoritoDetailViewController.m
//  La Tercera
//
//  Created by Mario Alejandro on 22-08-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "FavoritoDetailViewController.h"
#import "Article.h"
#import "ConnectionManager.h"
#import "SessionManager.h"
#import "UserProfile.h"
#import "UsarBeneficioNoLogueado.h"


@interface FavoritoDetailViewController () <UIGestureRecognizerDelegate>



@end

@implementation FavoritoDetailViewController
@synthesize tituloCategoria;
@synthesize idArticulo;
@synthesize newsTitle, newsSummary, newsImage,newsCategory,newsDate,newsAuthor,newsContent;
int fontFavSize = 16;


NSString *textoContenidoFavorito = @"";

- (void)viewDidLoad {
    
    _upperSeparador.hidden = YES;
    _lowerSeparador.hidden = YES;
    UISwipeGestureRecognizer *gestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backButtonClicked:)];
    [gestureRecognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.navigationController.view addGestureRecognizer:gestureRecognizer];
    [super viewDidLoad];
    _titulo.text= @"";
    _labelCat.text = @"";
    _titulo.textAlignment = NSTextAlignmentJustified;
    _summary.text= @"";
    _summary.textAlignment = NSTextAlignmentJustified;
    _contentTextView.text= @"";
    
    _imagenNews.image = nil;
    
    _titulo.alpha = 0;
    _summary.alpha = 0;
    _contentTextView.alpha = 0;
    _contentTextView.textAlignment = NSTextAlignmentJustified;
    _imagenNews.alpha = 0;
    _labelFecha.alpha = 0;
   _labelAutor.alpha = 0;
    
    // Do any additional setup after loading the view.
    
    /*
    @property (retain, nonatomic) NSString *newsTitle;
    @property (retain, nonatomic) NSString *newsSummary;
    @property (retain, nonatomic) UIImage *newsImage;
    @property (retain, nonatomic) NSString *newsCategory;
    @property (retain, nonatomic) NSString *newsDate;
    @property (retain, nonatomic) NSString *newsAuthor;
    @property (retain, nonatomic) NSString *newsContent;
    */
    
    _titulo.text= self.newsTitle;
    _summary.text= self.newsSummary;
    _summary.numberOfLines = 0;
    
    
    _labelAutor.text = self.newsAuthor;
    _labelFecha.text = self.newsDate;
    
    textoContenidoFavorito = self.newsContent;
    
    NSString *finalDescription = [NSString stringWithFormat:@"<span style=\"font-family: PT Sans; font-size: %d\">%@</span>",fontFavSize,textoContenidoFavorito];
    
    
    NSAttributedString *attributedString = [[NSAttributedString alloc]
                                            initWithData: [finalDescription dataUsingEncoding:NSUnicodeStringEncoding]
                                            options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                            documentAttributes: nil
                                            error: nil
                                            ];
    
    _contentTextView.attributedText = attributedString;
    _imagenNews.image = self.newsImage;
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _titulo.alpha = 1;
                         _summary.alpha = 1;
                         _contentTextView.alpha = 1;
                         
                         _labelFecha.alpha = 1;
                         _labelAutor.alpha = 1;
                         _imagenNews.alpha = 1;
                         _upperSeparador.hidden = NO;
                         _lowerSeparador.hidden = NO;
                         
                     }
                     completion:nil];
    
    self.labelCat.text = self.newsCategory;
    
    [_summary sizeToFit];
    
    CGRect frame;
    frame = _contentTextView.frame;
    frame.size.height = [_contentTextView contentSize].height;
    _contentTextView.frame = frame;

}


- (IBAction)addToFavorite:(id)sender {
    
}

- (IBAction)selectionButtonPressed:(id)sender {
  
}

- (IBAction)decreaseTextSizePressed:(id)sender {
    
    NSLog(@"Disminuir Fuente Presionado");
    NSLog(@"FontSize: %d",fontFavSize);
    if (fontFavSize >16){
        
        fontFavSize--;
        NSLog(@"Nuevo FontSize: %d",fontFavSize);
        NSString *finalDescription = [NSString stringWithFormat:@"<span style=\"font-family: PT Sans; font-size: %d\">%@</span>",fontFavSize,textoContenidoFavorito];
        
        
        NSAttributedString *attributedString = [[NSAttributedString alloc]
                                                initWithData: [finalDescription dataUsingEncoding:NSUnicodeStringEncoding]
                                                options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                                documentAttributes: nil
                                                error: nil
                                                ];
        _contentTextView.attributedText = attributedString;
        
        [_contentTextView sizeToFit];
        [self.scrollView sizeToFit];
    }
}

- (IBAction)increaseTextSizePressed:(id)sender {
    NSLog(@"Aumentar Fuente Presionado");
    NSLog(@"FontSize: %d",fontFavSize);
    
    if (fontFavSize <24){
        
        fontFavSize++;
        NSLog(@"Nuevo FontFavSize: %d",fontFavSize);
        NSString *finalDescription = [NSString stringWithFormat:@"<span style=\"font-family: PT Sans; font-size: %d\">%@</span>",fontFavSize,textoContenidoFavorito];
        
        NSAttributedString *attributedString = [[NSAttributedString alloc]
                                                initWithData: [finalDescription dataUsingEncoding:NSUnicodeStringEncoding]
                                                options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                                documentAttributes: nil
                                                error: nil
                                                ];
        _contentTextView.attributedText = attributedString;
        
        [_contentTextView sizeToFit];
        [_labelCat sizeToFit];
        [self.scrollView sizeToFit];
    }
}

#pragma mark -->> Data Functions <<---



- (IBAction)backButtonClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}






@end