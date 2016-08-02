//
//  LaTerceraTV.m
//  La Tercera
//
//  Created by diseno on 07-04-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "Tickets.h"
#import "SessionManager.h"
#import "SWRevealViewController.h"
#import "SVProgressHUD.h"

@implementation TicketsClub
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SVProgressHUD show];
    //[self loadPaper];
    [SVProgressHUD setStatus:@"Cargando Tickets Club"];
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
    
    NSString *urlString = @"http://tienda.clublatercera.com/tickets";
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    _webViewTickets.delegate = self;
    [_webViewTickets loadRequest:urlRequest];
    
}

- (IBAction)backPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [SVProgressHUD dismiss];
}


@end
