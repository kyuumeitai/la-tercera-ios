//
//  LaTerceraTV.m
//  La Tercera
//
//  Created by diseno on 07-04-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "LaTerceraTV.h"
#import "SingletonManager.h"
#import "SWRevealViewController.h"
#import "SVProgressHUD.h"

@implementation LaTerceraTV
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SVProgressHUD show];
    //[self loadPaper];
    //[SVProgressHUD setStatus:@"Obteniendo categorías disponibles"];
    // Do any additional setup after loading the view.
    //Creamos el singleton
    SingletonManager *singleton = [SingletonManager singletonManager];
    
    
    SWRevealViewController *revealViewController = self.revealViewController;
    singleton.leftSlideMenu = revealViewController;
    [_menuButton addTarget:singleton.leftSlideMenu action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    [self loadWeb];
    // NSLog(@"Entonces el singleton es: %@",singleton.leftSlideMenu);
    // Do any additional setup after loading the view.
    
    //[self loadCategories];
    //[self loadBenefits];
    //[self loadCommerces];
    //[self loadStores];
    
}

-(void)loadWeb{
    
    NSString *urlString = @"http://www.laterceratv.cl/";
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    _webViewLTtv.delegate = self;
    [_webViewLTtv loadRequest:urlRequest];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [SVProgressHUD dismiss];
}


@end
