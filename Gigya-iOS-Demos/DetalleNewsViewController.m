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
#import "Tools.h"
#import "GAI.h"
#import "GAIFields.h"
#import "GAITrackedViewController.h"
#import "GAIDictionaryBuilder.h"

@interface DetalleNewsViewController () <UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *labelFecha;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *labelCat;
@property (weak, nonatomic) IBOutlet UILabel *labelAutor;

@property (weak, nonatomic) IBOutlet UIImageView *upperSeparador;

@property (weak, nonatomic) IBOutlet UIImageView *lowerSeparador;


@property (weak, nonatomic) IBOutlet UIImageView *imageViewNews1;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewNews2;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewNews3;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewNews4;
@property (weak, nonatomic) IBOutlet UILabel *titleNews1;
@property (weak, nonatomic) IBOutlet UILabel *titleNews2;
@property (weak, nonatomic) IBOutlet UILabel *titleNews3;
@property (weak, nonatomic) IBOutlet UILabel *titleNews4;


@end

@implementation DetalleNewsViewController
@synthesize tituloCategoria;
@synthesize fetchedResultsController;
@synthesize idArticulo;
@synthesize idCategoria;
@synthesize relatedIdsArray;

int fontSize = 16;

NSString *slug = @"";
NSString *newsLink= @"";
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
    NSArray *noticias = [[NSArray alloc] init];
    
    [self loadRelatedArticles];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadRelatedArticles{
    
    NSLog(@"El articulo id es: %d",idArticulo);
    NSLog(@"Entonces el array de Noticias Relacionadas es: %@.",relatedIdsArray);
    
    for (int i = 0; i < relatedIdsArray.count; i++) {
        int randomInt1 = arc4random() % [relatedIdsArray count];
        int randomInt2 = arc4random() % [relatedIdsArray count];
        [relatedIdsArray exchangeObjectAtIndex:randomInt1 withObjectAtIndex:randomInt2];
    }
    
    int contando = 1;
    
    for (NSNumber *idArtTemp in relatedIdsArray) {
    if (contando >4)
        return;
    
        int idArtInt = [idArtTemp intValue];
        if (idArtInt == idArticulo ){
            NSLog(@" es el mesmiitoh ");
        }else{
            NSLog(@"Arituiclo temp:%d",idArtInt);
            ConnectionManager *connectionManager = [[ConnectionManager alloc]init];
            BOOL estaConectado = [connectionManager verifyConnection];
            NSLog(@"Verificando conexión: %d",estaConectado);
        
            [connectionManager getArticleWithId:^(BOOL success, NSArray *arrayJson, NSError *error){
            
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (!success) {
                    NSLog(@"Error obteniendo datos! %@ %@", error, [error localizedDescription]);
                    } else {
                    
                        [self loadRelatedArticleDataFromService:arrayJson andIndexNumber:contando ];
                 
                    }
                });
            }:idArtInt];
        
            contando++;
        }
    }
    
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

        //check if existe en favoritos
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"title == %@", _titulo.text]];
        
        NSError *error = nil;
        NSArray *results = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
        
        if([results count] > 0){
            //eliminar de favoritos
            for (NSManagedObject *managedObject in results) {
                [managedObjectContext deleteObject:managedObject];
            }
            
            if (![managedObjectContext save:&error]) {
                NSLog(@"No se pudo guardar! %@ %@", error, [error localizedDescription]);
            }else{
                [_btnFav setImage:[UIImage imageNamed:@"botonFavorito"] forState:UIControlStateNormal];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Eliminada de favoritos"
                                                                message:@"Ha eliminado esta notica de Favoritos."
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
        }else{
            // Create a new fav
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
            
            //agregar a favoritos
            NSError *error = nil;
            // Save the object to persistent store
            if (![managedObjectContext save:&error]) {
                NSLog(@"No se pudo guardar! %@ %@", error, [error localizedDescription]);
            }else{
                UIImage *btnImage = [UIImage imageNamed:@"botonFavoritoOn.png"];
                [_btnFav setImage:btnImage forState:UIControlStateNormal];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Añadida a favoritos"
                                                                message:@"Ha agregado esta notica a Favoritos."
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
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
       
        NSLog(@"Empezó lo wendy");
        //Es premium
        SessionManager *sesion = [SessionManager session];
        
        BOOL saveNewCat = [sesion saveMiSeleccionCategoryWithId:self.idCategoria andCategoryName:self.tituloCategoria];

        if(saveNewCat){
            [_btnCatFav setImage:[UIImage imageNamed:@"quitSelection"] forState:UIControlStateNormal];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"agregandoCategoriaAMiSeleccion" object:self];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Categoría añadida"
                                                        message:@"Ha agregado exitosamente esta categoría a 'Mi Selección'."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
            [alert show];
            
        }else{
            //delete categoría
            
            BOOL deleted = [sesion deleteMiSeleccionCategoryWithId:self.idCategoria andCategoryName:self.tituloCategoria];
            
            if(deleted){
                [_btnCatFav setImage:[UIImage imageNamed:@"AddToSelection"] forState:UIControlStateNormal];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Categoría eliminada"
                                                                message:@"Categoría eliminada correctamente."
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Categoría eliminada"
                                                                message:@"Problemas al eliminar categoría."
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
            

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


-(void) loadRelatedArticleDataFromService:(NSArray*)arrayJson andIndexNumber:(int)indice{
    
    NSDictionary *articleDict = (NSDictionary*)arrayJson;
    
    //NSLog(@"***** Print Related article: %@",arrayJson);
    
    if (indice == 1) {
        
        NSString *titulo = [[articleDict objectForKey:@"title"] stringByReplacingOccurrencesOfString: @"&#8220;" withString:@"“"];
        titulo = [titulo stringByReplacingOccurrencesOfString: @"&#8221;" withString:@"”"];
        
        
        _titleNews1.text= titulo;
        
        
        id urlImagen;
        
        if ([articleDict objectForKey:@"image_url"] == (id)[NSNull null]){
            urlImagen = @"https://placekitten.com/400/400";
        }else{
            urlImagen = [articleDict objectForKey:@"image_url"];
        }
        
        
        NSURL *url = [NSURL URLWithString:urlImagen];
        
        _imageViewNews1.image = [UIImage imageNamed:@"icn_default"];
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *image = [UIImage imageWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                _imageViewNews1.image = image;
                
                
                [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn
                                 animations:^{
                                     _imageViewNews1.alpha = 1;
                                     
                                 }
                                 completion:nil];
            });
        });

    }
    
    
    if (indice == 2) {
        
        NSString *titulo = [[articleDict objectForKey:@"title"] stringByReplacingOccurrencesOfString: @"&#8220;" withString:@"“"];
        titulo = [titulo stringByReplacingOccurrencesOfString: @"&#8221;" withString:@"”"];
        
        
        _titleNews2.text= titulo;
        
        
        id urlImagen;
        
        if ([articleDict objectForKey:@"image_url"] == (id)[NSNull null]){
            urlImagen = @"https://placekitten.com/400/400";
        }else{
            urlImagen = [articleDict objectForKey:@"image_url"];
        }
        
        
        NSURL *url = [NSURL URLWithString:urlImagen];
        
        _imageViewNews2.image = [UIImage imageNamed:@"icn_default"];
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *image = [UIImage imageWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                _imageViewNews2.image = image;
                
                
                [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn
                                 animations:^{
                                     _imageViewNews2.alpha = 1;
                                     
                                 }
                                 completion:nil];
            });
        });
        
    }
    
    if (indice == 3) {
        
        NSString *titulo = [[articleDict objectForKey:@"title"] stringByReplacingOccurrencesOfString: @"&#8220;" withString:@"“"];
        titulo = [titulo stringByReplacingOccurrencesOfString: @"&#8221;" withString:@"”"];
        
        
        _titleNews3.text= titulo;
        
        
        id urlImagen;
        
        if ([articleDict objectForKey:@"image_url"] == (id)[NSNull null]){
            urlImagen = @"https://placekitten.com/400/400";
        }else{
            urlImagen = [articleDict objectForKey:@"image_url"];
        }
        
        
        NSURL *url = [NSURL URLWithString:urlImagen];
        
        _imageViewNews3.image = [UIImage imageNamed:@"icn_default"];
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *image = [UIImage imageWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                _imageViewNews3.image = image;
                
                
                [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn
                                 animations:^{
                                     _imageViewNews3.alpha = 1;
                                     
                                 }
                                 completion:nil];
            });
        });
        
    }
    
    if (indice == 4) {
        
        NSString *titulo = [[articleDict objectForKey:@"title"] stringByReplacingOccurrencesOfString: @"&#8220;" withString:@"“"];
        titulo = [titulo stringByReplacingOccurrencesOfString: @"&#8221;" withString:@"”"];
        
        
        _titleNews1.text= titulo;
        
        
        id urlImagen;
        
        if ([articleDict objectForKey:@"image_url"] == (id)[NSNull null]){
            urlImagen = @"https://placekitten.com/400/400";
        }else{
            urlImagen = [articleDict objectForKey:@"image_url"];
        }
        
        
        NSURL *url = [NSURL URLWithString:urlImagen];
        
        _imageViewNews4.image = [UIImage imageNamed:@"icn_default"];
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *image = [UIImage imageWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                _imageViewNews4.image = image;
                
                
                [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn
                                 animations:^{
                                     _imageViewNews4.alpha = 1;
                                     
                                 }
                                 completion:nil];
            });
        });
        
    }
    
}


-(void) loadArticleDataFromService:(NSArray*)arrayJson{
    
    NSDictionary *articleDict = (NSDictionary*)arrayJson;
    //NSLog(@"***** Print: %@",arrayJson);
    
    
    NSString * autor = [articleDict objectForKey:@"author"];
    NSString *titulo = [[articleDict objectForKey:@"title"] stringByReplacingOccurrencesOfString: @"&#8220;" withString:@"“"];
    titulo = [titulo stringByReplacingOccurrencesOfString: @"&#8221;" withString:@"”"];
    _titulo.text= titulo;
    _summary.text= [articleDict objectForKey:@"short_description"];
    slug = [articleDict objectForKey:@"slug"];

    _summary.numberOfLines = 0;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    NSString * originalDateString = [articleDict objectForKey:@"article_date"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    //[dateFormatter setDateStyle:NSDateFormatterLongStyle];
    NSDate *newsDate = [dateFormatter dateFromString:originalDateString];
     [dateFormatter setDateFormat:@"dd' de 'MMMM', 'yyyy' / 'HH:mm "];
    _labelAutor.text = autor;
    NSString *dateFinalText=[dateFormatter stringFromDate:newsDate];
    
    NSLog(@"Fecha es:%@", dateFinalText);
    _labelFecha.text = dateFinalText;
    
    // Fetch the devices from persistent data store
    NSArray *noticias = [[NSArray alloc] init];
    // Fetch the devices from persistent data store
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Noticia"];
    noticias = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    NSLog(@"noticias: %@",noticias);
    
    //check if existe en favoritos
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"title == %@", _titulo.text]];
    
    NSError *error = nil;
    NSArray *results = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if([results count] > 0){
        [_btnFav setImage:[UIImage imageNamed:@"botonFavoritoOn"] forState:UIControlStateNormal];
    }
    
    SessionManager *sesion = [SessionManager session];
    if([sesion existCategory:self.tituloCategoria]){
        [_btnCatFav setImage:[UIImage imageNamed:@"quitSelection"] forState:UIControlStateNormal];
    }
    
    NSString *value = [NSString stringWithFormat:@"Noticias/%@/%@", tituloCategoria, titulo];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:value];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
    
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
                                 self.bannerNewsDetailView.adUnitID = @"/124506296/La_Tercera_com/La_Tercera_com_APP/mi-seleccion_300x250-A";
                                 self.bannerNewsDetailView.rootViewController = self;
                                 [self.bannerNewsDetailView loadRequest:[DFPRequest request]];
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
- (IBAction)shareArticle:(id)sender {
    NSString *tituloNoticia = _titulo.text;
    newsLink = [NSString stringWithFormat:@"http://aniversario.latercera.com/%@",slug];

    [Tools shareText:tituloNoticia    andImage:nil  andUrl:[NSURL URLWithString:newsLink] forSelf:self];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Noticias/btn/compartir"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}


#pragma mark - Related News

- (void)updateArticle{
    
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
    
    [self loadRelatedArticles];

    
}


- (IBAction)tapRelatedNews1:(id)sender {
    NSLog(@"Click en related news 1");
    
    idArticulo = [relatedIdsArray[1] intValue] ;
    [self updateArticle];
    [self loadBenefitForBenefitId:idArticulo andCategory:tituloCategoria];
    [self.scrollView setContentOffset:
     CGPointMake(0, -self.scrollView.contentInset.top) animated:YES];
    [self.scrollView setContentOffset:
     CGPointMake(0, -self.scrollView.contentInset.top) animated:NO];
    [self loadBenefitForBenefitId:idArticulo andCategory:tituloCategoria];

}

- (IBAction)tapRelatedNews2:(id)sender {
    NSLog(@"Click en related news 2");
    idArticulo = [relatedIdsArray[2] intValue] ;
    [self updateArticle];
    [self loadBenefitForBenefitId:idArticulo andCategory:tituloCategoria];
    [self.scrollView setContentOffset:
     CGPointMake(0, -self.scrollView.contentInset.top) animated:YES];
    [self.scrollView setContentOffset:
     CGPointMake(0, -self.scrollView.contentInset.top) animated:NO];
    [self.scrollView layoutIfNeeded];
}

- (IBAction)tapRelatedNews3:(id)sender {
    NSLog(@"Click en related news 3");
    idArticulo = [relatedIdsArray[3] intValue] ;
    [self updateArticle];
    [self loadBenefitForBenefitId:idArticulo andCategory:tituloCategoria];
    [self.scrollView setContentOffset:
     CGPointMake(0, -self.scrollView.contentInset.top) animated:YES];
    [self.scrollView setContentOffset:
     CGPointMake(0, -self.scrollView.contentInset.top) animated:NO];
    [self.scrollView layoutIfNeeded];


}

- (IBAction)tapRelatedNews4:(id)sender {
    NSLog(@"Click en related news 4");
    idArticulo = [relatedIdsArray[4] intValue] ;
    [self updateArticle];
    [self loadBenefitForBenefitId:idArticulo andCategory:tituloCategoria];

    [self.scrollView setContentOffset:
     CGPointMake(0, -self.scrollView.contentInset.top) animated:YES];
    [self.scrollView setContentOffset:
     CGPointMake(0, -self.scrollView.contentInset.top) animated:NO];
    [self.scrollView layoutIfNeeded];

}



@end
