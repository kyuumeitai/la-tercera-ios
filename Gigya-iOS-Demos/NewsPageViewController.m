//
//  NewsPageViewController.m
//  La Tercera
//
//  Created by diseno on 14-04-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "NewsPageViewController.h"
#import "UIImageView+AFNetworking.h"
#import "SVProgressHUD.h"

@implementation NewsPageViewController
/*
 Viene por defecto
@synthesize urlDetailPage;
@synthesize numeroPagina;
@synthesize totalPaginas;
@synthesize  categoria;
*/
-(void)viewDidLoad{
    
    NSLog(@"XXXXXXXX --  El url de la imagen es: %@, numero de pagina: %i de un total de %i",self.urlDetailPage,self.numeroPagina,self.totalPaginas);
 
    UISwipeGestureRecognizer *rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipeHandle:)];
    rightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [rightRecognizer setNumberOfTouchesRequired:1];
    
    [_newsPageImageView addGestureRecognizer:rightRecognizer];
    
    UISwipeGestureRecognizer *leftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeHandle:)];
    leftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [leftRecognizer setNumberOfTouchesRequired:1];
    
    [_newsPageImageView addGestureRecognizer:leftRecognizer];
    
    [SVProgressHUD show];
    NSString *mensajeHUD = [ NSString stringWithFormat:@"%@\nCargando página %i",self.categoria, self.numeroPagina];
    [SVProgressHUD setStatus:mensajeHUD];
    
    [self loadImage:UIViewAnimationOptionTransitionNone];
    
}

- (void) loadImage:(CATransition*)transition{

    //self.newsPageImageView.alpha = 0;
    
    NSString *urlImagen = self.urlDetailPage;
    NSURL *url = [NSURL URLWithString:urlImagen];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImage *placeholderImage = [UIImage imageNamed:@"placeholderNone"];
    
    [_newsPageImageView setImageWithURLRequest:request
                              placeholderImage:placeholderImage
                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                           _newsPageImageView.image = image;
                                           
                                            [UIView transitionWithView:_newsPageImageView duration:0.0 options:UIViewAnimationOptionTransitionNone animations:^{ [_newsPageImageView setAlpha:1.0]; } completion:nil];

                                          [self.scrollView.layer addAnimation:transition forKey:kCATransition];
                                           self.scrollView.minimumZoomScale = 1;
                                           self.scrollView.maximumZoomScale = 4.0;
                                           self.scrollView.contentSize =_newsPageImageView.frame.size;
                                           self.scrollView.delegate = self;
                                           
                                           [SVProgressHUD dismiss];
                                           
                                       } failure:nil];

}

- (void)rightSwipeHandle:(UISwipeGestureRecognizer*)gestureRecognizer
{
    NSLog(@"rightSwipeHandle");
    if(self.numeroPagina > 1){
        [self goRewind];
    }
    
}

- (void)leftSwipeHandle:(UISwipeGestureRecognizer*)gestureRecognizer
{
    NSLog(@"leftSwipeHandle");
    if(self.numeroPagina < self.totalPaginas){
        [self goForward];
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _newsPageImageView;
    
}

# pragma mark *** Move forward or rewind

-(void)goForward{
    
    int largoUrl = (int)[self.urlDetailPage length] ;
    int posicionEnUrl = largoUrl-7;
    NSRange range = NSMakeRange(posicionEnUrl,3);
    self.numeroPagina = self.numeroPagina+1;;
    NSString *nuevoNumeroPagina = [NSString stringWithFormat:@"%03d",self.numeroPagina];
    NSLog(@"nuevoNumeroPagina: %@",nuevoNumeroPagina);
   self.urlDetailPage = [self.urlDetailPage stringByReplacingCharactersInRange:range withString:nuevoNumeroPagina];
    NSLog(@"self.urlDetailPage: %@",self.urlDetailPage);
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    
    [self loadImage:transition];
    
}

-(void)goRewind{
    
    NSRange range = NSMakeRange(49,3);
    self.numeroPagina = self.numeroPagina-1;;
    NSString *nuevoNumeroPagina = [NSString stringWithFormat:@"%03d",self.numeroPagina];
    NSLog(@"nuevoNumeroPagina: %@",nuevoNumeroPagina);
    self.urlDetailPage = [self.urlDetailPage stringByReplacingCharactersInRange:range withString:nuevoNumeroPagina];
    NSLog(@"self.urlDetailPage: %@",self.urlDetailPage);
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    
    [self loadImage:transition];
    
}


- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
}

- (IBAction)closeButton:(id)sender {
    
    [self dismissViewControllerAnimated:self completion:nil];
}

@end
