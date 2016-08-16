//
//  DetalleNewsViewController.m
//  La Tercera
//
//  Created by diseno on 14-06-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "DetalleNewsViewController.h"
#import "Article.h"
#import "ConnectionManager.h"

@interface DetalleNewsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelFecha;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *labelCat;



@end

@implementation DetalleNewsViewController
@synthesize tituloCategoria;
int fontSize = 16;


NSString *textoContenidoTemporal = @"";

- (void)viewDidLoad {
    
    [super viewDidLoad];
    _titulo.text= @"";
    //_labelCategoria.text = @"";
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
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)selectionButtonPressed:(id)sender {
}
- (IBAction)decreaseTextSizePressed:(id)sender {
    
    NSLog(@"Disminuir Fuente Presionado");
    NSLog(@"FontSize: %d",fontSize);
    if (fontSize >16){
       
        fontSize--;
        NSLog(@"Nuevo FontSize: %d",fontSize);
        NSString *finalDescription = [NSString stringWithFormat:@"<span style=\"font-family: PT Sans; font-size: %d\">%@</span>",fontSize,textoContenidoTemporal];
        
        
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
    NSLog(@"FontSize: %d",fontSize);

    if (fontSize <24){
        
        fontSize++;
        NSLog(@"Nuevo FontSize: %d",fontSize);
        NSString *finalDescription = [NSString stringWithFormat:@"<span style=\"font-family: PT Sans; font-size: %d\">%@</span>",fontSize,textoContenidoTemporal];
    
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

-(void)loadBenefitForBenefitId:(int)idArticle andCategory:(NSString*)categoria{
    
    NSLog(@"Load article for Id:%d",idArticle);
      NSLog(@"Titulo de categoria:%@",categoria);
    self.tituloCategoria = categoria;
    // IMPORTANT - Only update the UI on the main thread
    // [SVProgressHUD showWithStatus:@"Obteniendo beneficios disponibles" maskType:SVProgressHUDMaskTypeClear];
    
    ConnectionManager *connectionManager = [[ConnectionManager alloc]init];
    BOOL estaConectado = [connectionManager verifyConnection];
    NSLog(@"Verificando conexión: %d",estaConectado);

    [connectionManager getArticleWithId:^(BOOL success, NSArray *arrayJson, NSError *error){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!success) {
                NSLog(@"Error obteniendo datos! %@ %@", error, [error localizedDescription]);
            } else {
               [self loadArticleDataFromService:arrayJson];
            }
        });
    }:idArticle];
}

-(void) loadArticleDataFromService:(NSArray*)arrayJson{
    
    NSDictionary *articleDict = (NSDictionary*)arrayJson;
    NSLog(@"***** Print: %@",arrayJson);
    
    _titulo.text= [articleDict objectForKey:@"title"];
    _summary.text= [articleDict objectForKey:@"short_description"];
    _summary.numberOfLines = 0;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    NSString * originalDateString = [articleDict objectForKey:@"article_date"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    //[dateFormatter setDateStyle:NSDateFormatterLongStyle];
    NSDate *newsDate = [dateFormatter dateFromString:originalDateString];
     [dateFormatter setDateFormat:@"dd' de 'MMMM' del 'yyyy' / 'HH:mm' Hrs'"];

    NSString *dateFinalText=[dateFormatter stringFromDate:newsDate];
    
    NSLog(@"Fehca es:%@", dateFinalText);
    _labelFecha.text = dateFinalText;
    
   textoContenidoTemporal = [articleDict objectForKey:@"content"];
    NSString *finalDescription = [NSString stringWithFormat:@"<span style=\"font-family: PT Sans; font-size: %d\">%@</span>",fontSize,textoContenidoTemporal];


    NSAttributedString *attributedString = [[NSAttributedString alloc]
                                            initWithData: [finalDescription dataUsingEncoding:NSUnicodeStringEncoding]
                                            options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                            documentAttributes: nil
                                            error: nil
                                            ];
    _contentTextView.attributedText = attributedString;
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _titulo.alpha = 1;
                         _summary.alpha = 1;
                         _contentTextView.alpha = 1;
                         _imagenNews.alpha = 1;
                         _labelFecha.alpha = 1;
                         
                     }
                     completion:nil];
    id urlImagen;
    
    if ([articleDict objectForKey:@"image_url"] == (id)[NSNull null]){
        urlImagen = @"https://placekitten.com/400/400";
    }else{
        urlImagen = [articleDict objectForKey:@"image_url"];
    }
    
    
    NSURL *url = [NSURL URLWithString:urlImagen];
    
    _imagenNews.image = [UIImage imageNamed:@"icn_default"];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            _imagenNews.image = image;
        });  
    });
 
 [_contentTextView sizeToFit];
    self.labelCat.text = self.tituloCategoria;

 [_summary sizeToFit];
    
 [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, 5000)];
    //NSLog(@"A %f kms de distancia",distanceMeters);
}

- (IBAction)backButtonClicked:(UIButton *)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
