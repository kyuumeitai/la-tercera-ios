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
@synthesize urlDetailPage;
@synthesize numeroPagina;
@synthesize  categoria;

-(void)viewDidLoad{
    
    NSLog(@"XXXXXXXX --  El url de la imagen es: %@",self.urlDetailPage);
    NSString *urlImagen = self.urlDetailPage;
    NSURL *url = [NSURL URLWithString:urlImagen];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImage *placeholderImage = [UIImage imageNamed:@"placeholder"];

    [SVProgressHUD show];
    
    //[self loadPaper];
    NSString *mensajeHUD = [ NSString stringWithFormat:@"%@\nCargando página %i",self.categoria, self.numeroPagina];
    [SVProgressHUD setStatus:mensajeHUD];
    
    [_newsPageImageView setImageWithURLRequest:request
                               placeholderImage:placeholderImage
                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                            _newsPageImageView.image = image;
                                            
                                            _newsPageImageView.frame = _scrollView.bounds;
                                            [_newsPageImageView setContentMode:UIViewContentModeScaleAspectFit];
                                            _scrollView.contentSize = CGSizeMake(_newsPageImageView.frame.size.width, _newsPageImageView.frame.size.height);
                                            _scrollView.maximumZoomScale = 4.0;
                                            _scrollView.minimumZoomScale = 1.0;
                                            _scrollView.delegate = self;
                                            
                                            [SVProgressHUD dismiss];
                                            
                                        } failure:nil];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)closeButton:(id)sender {
    
    [self dismissViewControllerAnimated:self completion:nil];
}

@end
