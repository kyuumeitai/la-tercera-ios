//
//  LaTerceraTV.m
//  La Tercera
//
//  Created by diseno on 07-04-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "TCMastercard.h"
#import "SessionManager.h"
#import "SWRevealViewController.h"
#import "SVProgressHUD.h"

@implementation TCMastercard
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SVProgressHUD show];
    //[self loadPaper];
    [SVProgressHUD setStatus:@"Cargando TC Mastercard"];
    // Do any additional setup after loading the view.
    //Creamos el singleton
    SessionManager *sesion = [SessionManager session];
    
    
    SWRevealViewController *revealViewController = self.revealViewController;
    sesion.leftSlideMenu = revealViewController;
    [_menuButton addTarget:sesion.leftSlideMenu action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addGestureRecognizer: self.revealViewController.panGestureRecognizer];

    
    [self loadWeb];
    // NSLog(@"Entonces el singleton es: %@",singleton.leftSlideMenu);
    // Do any additional setup after loading the view.
    
    //[self loadCategories];
    //[self loadBenefits];
    //[self loadCommerces];
    //[self loadStores];
    
}

-(void)loadWeb{
    
   // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://especiales.latercera.com/pruebas/newsite/index4.html"]];

    
    NSString *urlString = @"http://www.clublatercera.com/beneficios/17_2660.html";
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    _webViewLTtv.delegate = self;
    [_webViewLTtv loadRequest:urlRequest];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [SVProgressHUD dismiss];
}


@end
