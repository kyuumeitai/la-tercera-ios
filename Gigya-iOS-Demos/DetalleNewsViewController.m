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
#import "SessionManager.h"
#import "UserProfile.h"
#import "UsarBeneficioNoLogueado.h"


@interface DetalleNewsViewController () <UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *labelFecha;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *labelCat;
@property (weak, nonatomic) IBOutlet UILabel *labelAutor;

@property (weak, nonatomic) IBOutlet UIImageView *upperSeparador;

@property (weak, nonatomic) IBOutlet UIImageView *lowerSeparador;

@end

@implementation DetalleNewsViewController
@synthesize tituloCategoria;
@synthesize fetchedResultsController;
@synthesize idArticulo;
int fontSize = 16;


NSString *textoContenidoTemporal = @"";

- (void)viewDidLoad {
    
    _upperSeparador.hidden = YES;
    _lowerSeparador.hidden = YES;
       UISwipeGestureRecognizer *gestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backButtonClicked:)];
    [gestureRecognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.navigationController.view addGestureRecognizer:gestureRecognizer];
    [super viewDidLoad];
    _titulo.text= @"";
    //_labelCategoria.text = @"";
    _titulo.textAlignment = NSTextAlignmentJustified;
    _summary.text= @"";
    _summary.textAlignment = NSTextAlignmentJustified;
    _contentTextView.text= @"";
    
  //  self.managedObjectContext = managedObjectContext;
    _imagenNews.image = nil;
    
    _titulo.alpha = 0;
    _summary.alpha = 0;
    _contentTextView.alpha = 0;
    _contentTextView.textAlignment = NSTextAlignmentJustified;
    _imagenNews.alpha = 0;
    _labelFecha.alpha = 0;
    _labelAutor.alpha = 0;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}
- (IBAction)addToFavorite:(id)sender {
    
    int level = [self getUserType];
    
     if(level == 2){
    NSArray *noticias = [[NSArray alloc] init];
    // Fetch the devices from persistent data store
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Noticia"];
    noticias = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    NSLog(@"noticias: %@",noticias);
    
    // Create a new device
    NSManagedObject *nuevoFavorito = [NSEntityDescription insertNewObjectForEntityForName:@"Noticia" inManagedObjectContext:managedObjectContext];

    [nuevoFavorito  setValue:_titulo.text forKey:@"title"];
    [nuevoFavorito  setValue:_summary.text forKey:@"summary"];
    [nuevoFavorito  setValue:[NSNumber numberWithInt:idArticulo] forKey:@"idArticle"];
    [nuevoFavorito  setValue:_contentTextView.text forKey:@"content"];
     NSData *imageData = UIImagePNGRepresentation(_imagenNews.image);
    [nuevoFavorito  setValue:imageData forKey:@"imageLink"];
    [nuevoFavorito  setValue:_labelFecha.text forKey:@"date"];
    [nuevoFavorito  setValue:_labelAutor.text forKey:@"author"];
    [nuevoFavorito  setValue:tituloCategoria forKey:@"category"];
  
        NSManagedObjectContext *context = [self managedObjectContext];
         
         NSError *error = nil;
         // Save the object to persistent store
         if (![context save:&error]) {
             NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
         }else{
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Añadida a favoritos"
                                                             message:@"Ha agregado esta notica a Favoritos."
                                                            delegate:self
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
             [alert show];
         }
  
      }else{
         //ES flaite
         
         //suscriberNeededScreen
         NSLog(@"Sin permisos");
         UsarBeneficioNoLogueado *usarBeneficioNoLogueadoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"suscriberNeededScreen"];
         [usarBeneficioNoLogueadoViewController cancelButtonText:@"Volver a la noticia"];
         usarBeneficioNoLogueadoViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
         [self presentViewController:usarBeneficioNoLogueadoViewController animated:YES completion:nil];
     }

}

- (IBAction)selectionButtonPressed:(id)sender {
    
    int level = [self getUserType];
    if(level == 2){
        //Es premium
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Categoría añadida"
                                                        message:@"Ha agregado exitosamente esta categoría a 'Mi Selección'."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }else{
        //ES flaite
        
        //suscriberNeededScreen
        NSLog(@"Sin permisos");
        UsarBeneficioNoLogueado *usarBeneficioNoLogueadoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"suscriberNeededScreen"];
        [usarBeneficioNoLogueadoViewController cancelButtonText:@"Volver a la noticia"];
        usarBeneficioNoLogueadoViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self presentViewController:usarBeneficioNoLogueadoViewController animated:YES completion:nil];
    }
}

-(int) getUserType{

    SessionManager *sesion = [SessionManager session];
    UserProfile *profile = [sesion getUserProfile];
    
    int level = profile.profileLevel;

    return level;
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
    self.idArticulo = idArticle;
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
    
    
    NSString * autor = [articleDict objectForKey:@"author"];
    NSString *titulo = [[articleDict objectForKey:@"title"] stringByReplacingOccurrencesOfString: @"&#8220;" withString:@"“"];
    titulo = [titulo stringByReplacingOccurrencesOfString: @"&#8221;" withString:@"”"];
    _titulo.text= titulo;
    _summary.text= [articleDict objectForKey:@"short_description"];
    _summary.numberOfLines = 0;

    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    NSString * originalDateString = [articleDict objectForKey:@"article_date"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    //[dateFormatter setDateStyle:NSDateFormatterLongStyle];
    NSDate *newsDate = [dateFormatter dateFromString:originalDateString];
     [dateFormatter setDateFormat:@"dd' de 'MMMM', 'yyyy' / 'HH:mm "];
    _labelAutor.text = autor;
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
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _titulo.alpha = 1;
                         _summary.alpha = 1;
                         _contentTextView.alpha = 1;
                         
                         _labelFecha.alpha = 1;
                         _labelAutor.alpha = 1;
                         
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
            
            
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 _imagenNews.alpha = 1;
                                 _upperSeparador.hidden = NO;
                                 _lowerSeparador.hidden = NO;
                             }
                             completion:nil];
            
        });  
    });
 
 //[_contentTextView sizeToFit];
    self.labelCat.text = self.tituloCategoria;

 [_summary sizeToFit];
    
    CGRect frame;
    frame = _contentTextView.frame;
    frame.size.height = [_contentTextView contentSize].height;
    _contentTextView.frame = frame;
// [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, 5000)];
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
