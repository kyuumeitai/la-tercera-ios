//
//  LaTerceraTV-HomeTableViewController.m
//  La Tercera
//
//  Created by diseno on 11-08-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "LaTerceraTV-HomeTableViewController.h"
#import "ConnectionManager.h"
#import "CollectionViewCellGrande.h"
#import "CollectionViewCellBanner.h"
#import "VideoTableViewCell.h"
#import "NewspaperPage.h"
#import "NewsPageViewController.h"
#import "Tools.h"
#import "Video.h"
#import "DetalleNewsViewController.h"
#import "Article.h"
#import "UIImageView+AFNetworking.h"
#import "SessionManager.h"
#import "SVPullToRefresh.h"
#import "ContentType.h"
#import "BeneficioGeneralDestacadoTableViewCell.h"

#define categorySlug @"terceratv"

@interface LaTerceraTV_HomeTableViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation LaTerceraTV_HomeTableViewController
@synthesize laTerceraTVArray;
@synthesize tableView;
@synthesize categoryId;

static NSString * const reuseIdentifierGrande = @"collectionViewGrande";
static NSString * const reuseIdentifierBanner = @"collectionViewBanner";
static NSString * const reuseIdentifierVideo = @"videoTableViewCell";

//New Pagination code
int currentPageNumber ;
BOOL isPageRefreshingLaTerceraTV =  false;
BOOL firstTimeLaTerceraTV = false;

NSArray *bannersLaTerceraTV= nil;

BOOL _isScrollingLaTerceraTV;
int numeroPaginas;
NSString *day;
NSString *month;
NSString *year;
NSString *storyBoardName;

- (void)viewDidLoad {
    [super viewDidLoad];
    SessionManager *sesion = [SessionManager session];
    storyBoardName = sesion.storyBoardName;
    
    for (ContentType *contenido in sesion.categoryList) {
        if([contenido.contentSlug isEqualToString:categorySlug])
            self.categoryId = contenido.contentId;
    }
    
    NSLog(@" El nombre del storboard es: %@", storyBoardName);
    NSLog(@"CategoryId: %d", self.categoryId);
    __weak  LaTerceraTV_HomeTableViewController *weakSelf = self;
    laTerceraTVArray = [[NSMutableArray alloc] init];
    
    bannersLaTerceraTV = [NSArray arrayWithObjects:@"/124506296/La_Tercera_com/La_Tercera_com_APP/LaTerceraTV_300x250-A", @"/124506296/La_Tercera_com/La_Tercera_com_APP/LaTerceraTV_300x250-B", @"/124506296/La_Tercera_com/La_Tercera_com_APP/LaTerceraTV_300x250-C", @"/124506296/La_Tercera_com/La_Tercera_com_APP/LaTerceraTV_300x250-D", @"/124506296/La_Tercera_com/La_Tercera_com_APP/LaTerceraTV_300x250-E", nil];
    
    //Celda Grande
    UINib *cellNib ;
    
    if([storyBoardName isEqualToString:@"LaTerceraStoryboard-iPhone4"] || [storyBoardName isEqualToString:@"LaTerceraStoryboard-iPhone5"]){
        cellNib = [UINib nibWithNibName:@"CollectionViewCellGrande4-5" bundle: nil];
        [self.tableView registerNib:cellNib  forCellReuseIdentifier:@"collectionViewGrande4-5"];
        
    }else{
        
        cellNib = [UINib nibWithNibName:@"CollectionViewCellGrande" bundle: nil];
        [self.tableView registerNib:cellNib  forCellReuseIdentifier:reuseIdentifierGrande];
    }
    
    UINib *cellNib4 = [UINib nibWithNibName:@"CollectionViewCellBanner" bundle: nil];
    
    [self.tableView registerNib:cellNib4  forCellReuseIdentifier:reuseIdentifierBanner];
    
    currentPageNumber = 1;
    firstTimeLaTerceraTV = true;
    
    //[self.collectionView setAlpha:0.0];
    dispatch_async(dispatch_get_main_queue(), ^{
        // code here
        [self loadHeadlinesWithCategory:self.categoryId];
    });
    
    // setup infinite scrolling
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        //  [weakSelf loadMoreRows];
    }];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated{
    isPageRefreshingLaTerceraTV = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.laTerceraTVArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"videoTableViewCell";
    NSArray *nib;
    Video *video = (Video*)[laTerceraTVArray objectAtIndex:indexPath.row ];
        //CollectionViewCellBanner *celdaBanner = (CollectionViewCellBanner*)[self.tableView dequeueReusableCellWithIdentifier:reuseIdentifierBanner];
    
    VideoTableViewCell *cell = (VideoTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        if([storyBoardName isEqualToString:@"LaTerceraStoryboard-iPhone4"] || [storyBoardName isEqualToString:@"LaTerceraStoryboard-iPhone5"]){
            nib = [[NSBundle mainBundle] loadNibNamed:@"VideoTableViewCell" owner:self options:nil];
        }else{
            
            nib = [[NSBundle mainBundle] loadNibNamed:@"VideoTableViewCell" owner:self options:nil];
        }
        cell = [nib objectAtIndex:0];
        
        cell.labelTituloVideo.text = video.title;
        cell.labelSummary.text = video.summary;
        cell.rudoVideoUrl = video.link;
        [cell loadBanner];
        
        return cell;
        
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 438;
}




-(void)loadHeadlinesWithCategory:(int)idCategory{
    NSLog(@"Load Headlines");
    
    __weak LaTerceraTV_HomeTableViewController *weakSelf = self;
    
    
    ConnectionManager *connectionManager = [[ConnectionManager alloc]init];
    BOOL estaConectado = [connectionManager verifyConnection];
    NSLog(@"Verificando conexión: %d",estaConectado);
    [connectionManager getHeadlinesForCategoryId:^(BOOL success, NSArray *arrayJson, NSError *error){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!success) {
                if (isPageRefreshingLaTerceraTV == false){
                    
                    //[self errorDetectedWithNSError:error];
                }else{
                    //[self.collectionView reloadData];
                    //[self.collectionView layoutIfNeeded];
                    [weakSelf.tableView.infiniteScrollingView stopAnimating];
                }
                NSLog(@"Error obteniendo datos! %@ %@", error, [error localizedDescription]);
            }
            else {
                
                NSDictionary *tempDict = (NSDictionary*)arrayJson;
                id noData = [tempDict objectForKey:@"details"];
                
                if(noData){
                    
                    isPageRefreshingLaTerceraTV = YES;
                    
                }else{
                    
                    [self reloadHeadlinesDataFromArrayJson:arrayJson];
                    NSLog(@"********++++ Lista videos json: %@",arrayJson);
                }
            }
        });
    }:idCategory andPage:currentPageNumber];
    
}


-(void) reloadHeadlinesDataFromArrayJson:(NSArray*)arrayJson{
    __weak LaTerceraTV_HomeTableViewController *weakSelf = self;
    NSLog(@"  reload headlines");
    NSDictionary *diccionarioTitulares = (NSDictionary*)arrayJson;
    //NSLog(@"  reload headlines array, is: %@ ",diccionarioTitulares);
    
    NSArray* arrayTitulares = [diccionarioTitulares objectForKey:@"articles"];
    //NSLog(@" El array de titulares, es: %@ ",arrayTitulares);
    
    
    int indice = 0;
    
    for (id titularTemp in arrayTitulares){
        indice ++;
        NSLog(@"El Indice es: %d ", indice);
        NSDictionary *dictTitular = (NSDictionary*) titularTemp;
        id idArt =  [dictTitular objectForKey:@"id"];
        id title = [dictTitular objectForKey:@"title"];
        id summary = [dictTitular objectForKey:@"short_description"];
        
        id imageThumb ;
        
        if ([dictTitular objectForKey:@"thumb_url"] == (id)[NSNull null]){
            imageThumb = @"https://placekitten.com/200/200";
        }else{
            imageThumb = [dictTitular objectForKey:@"thumb_url"];
        }
        
        NSArray* arrayMedia= [dictTitular objectForKey:@"medias"];
        NSDictionary *media = (NSDictionary*) arrayMedia[0];
        id linkVideo = [media objectForKey:@"media_url"];
        
        
        
        Video *video = [[Video alloc] init];
        video.idVideo = [idArt intValue];
        video.title = title;
        video.summary = summary;
        video.imagenThumbString = imageThumb;
        video.link = linkVideo;
        
        NSLog(@"____ Numero de pagina: %d", currentPageNumber);
        if (indice == currentPageNumber*6 ){
            NSLog(@"____ currentPageNumber*6: %d", currentPageNumber*6);
            // [laTerceraTVArray addObject:@"OBJETO"];
        }
        [video logDescription];
        
        [laTerceraTVArray addObject:video];
    }
    
    //New code
    if (firstTimeLaTerceraTV ==true){
        self.view.alpha = 0.0;
        [self.tableView reloadData];
        [UIView animateWithDuration:0.5
                         animations:^{ self.view.alpha = 1.0; /* Some fake chages */
                             
                         }
                         completion:^(BOOL finished)
         {
             //[SVProgressHUD dismiss];
         }];
        firstTimeLaTerceraTV= false;
    }else{
        
        //[SVProgressHUD dismiss];
        isPageRefreshingLaTerceraTV= NO;
        // [weakSelf.collectionView endUpdates];
        
        [self.tableView reloadData];
        [self.tableView layoutIfNeeded];
        [weakSelf.tableView.infiniteScrollingView stopAnimating];
        NSLog(@"LA cantidad es: %lu",(unsigned long)laTerceraTVArray.count);
    }
    NSLog(@" ******* RELOAD DATA TABLEEE ****** ----------------------");
}



@end