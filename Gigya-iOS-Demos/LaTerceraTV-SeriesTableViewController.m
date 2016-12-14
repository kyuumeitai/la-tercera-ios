//
//  LaTerceraTV-SeriesTableViewController.m
//  La Tercera
//
//  Created by Mario Alejandro on 17-10-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "LaTerceraTV-SeriesTableViewController.h"
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
#import "VideoPlayerViewController.h"
#import "GAI.h"
#import "GAIFields.h"
#import "GAITrackedViewController.h"
#import "GAIDictionaryBuilder.h"

#define categorySlug @"Series"

@interface LaTerceraTV_SeriesTableViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation LaTerceraTV_SeriesTableViewController
@synthesize laTerceraTVSeriesArray;
@synthesize tableView;
@synthesize categoryId;

static NSString * const reuseIdentifierGrande = @"collectionViewGrande";
static NSString * const reuseIdentifierBanner = @"collectionViewBanner";
static NSString * const reuseIdentifierVideo = @"videoTableViewCell";

//New Pagination code
int currentPageNumberTVSeries ;
BOOL isPageRefreshingLaTerceraTVSeries =  false;
BOOL firstTimeLaTerceraTVSeries = false;

NSArray *bannersLaTerceraTVSeries= nil;

BOOL _isScrollingLaTerceraTVSeries;
int numeroPaginasTVSeries;
NSString *dayTVSeries;
NSString *monthTVSeries;
NSString *yearTVSeries;
NSString *storyBoardNameTVSeries;

- (void)viewDidLoad {
    [super viewDidLoad];
    SessionManager *sesion = [SessionManager session];
    storyBoardNameTVSeries = sesion.storyBoardName;
    
    for (ContentType *contenido in sesion.categoryList) {
        if([contenido.contentSlug isEqualToString:categorySlug])
            self.categoryId = contenido.contentId;
        NSLog(@"Category Slug: %@ and categoryId:%d",contenido.contentSlug,contenido.contentId);
    }
    
    NSLog(@" El nombre del storyboard es: %@", storyBoardNameTVSeries);
    NSLog(@"CategoryId: %d", self.categoryId);
    __weak  LaTerceraTV_SeriesTableViewController *weakSelf = self;
    laTerceraTVSeriesArray = [[NSMutableArray alloc] init];
    
    bannersLaTerceraTVSeries = [NSArray arrayWithObjects:@"/124506296/La_Tercera_com/La_Tercera_com_APP/LaTerceraTVSeries_300x250-A", @"/124506296/La_Tercera_com/La_Tercera_com_APP/LaTerceraTVSeries_300x250-B", @"/124506296/La_Tercera_com/La_Tercera_com_APP/LaTerceraTVSeries_300x250-C", @"/124506296/La_Tercera_com/La_Tercera_com_APP/LaTerceraTVSeries_300x250-D", @"/124506296/La_Tercera_com/La_Tercera_com_APP/LaTerceraTVSeries_300x250-E", nil];
    
    //Celda Grande
    UINib *cellNib ;
    
    if([storyBoardNameTVSeries isEqualToString:@"LaTerceraStoryboard-iPhone4"] || [storyBoardNameTVSeries isEqualToString:@"LaTerceraStoryboard-iPhone5"]){
        cellNib = [UINib nibWithNibName:@"CollectionViewCellGrande4-5" bundle: nil];
        [self.tableView registerNib:cellNib  forCellReuseIdentifier:@"collectionViewGrande4-5"];
        
    }else{
        
        cellNib = [UINib nibWithNibName:@"CollectionViewCellGrande" bundle: nil];
        [self.tableView registerNib:cellNib  forCellReuseIdentifier:reuseIdentifierGrande];
    }
    
    UINib *cellNib4 = [UINib nibWithNibName:@"CollectionViewCellBanner" bundle: nil];
    
    [self.tableView registerNib:cellNib4  forCellReuseIdentifier:reuseIdentifierBanner];
    
    currentPageNumberTVSeries = 1;
    firstTimeLaTerceraTVSeries = true;
    
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
    isPageRefreshingLaTerceraTVSeries = NO;
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"laterceraTV/series"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
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
    return self.laTerceraTVSeriesArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    static NSString *simpleTableIdentifier = @"videoTableViewCell";
    static NSString *simpleTableIdentifier45 = @"videoTableViewCell4-5";
    
    UINib *nib = [UINib nibWithNibName:@"VideoTableViewCell45" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:simpleTableIdentifier45];
    
    UINib *nib2 = [UINib nibWithNibName:@"VideoTableViewCell" bundle:nil];
    [self.tableView registerNib:nib2 forCellReuseIdentifier:simpleTableIdentifier];
    
    Video *video = (Video*)[laTerceraTVSeriesArray objectAtIndex:indexPath.row ];
    
    if([storyBoardNameTVSeries isEqualToString:@"LaTerceraStoryboard-iPhone4"] || [storyBoardNameTVSeries isEqualToString:@"LaTerceraStoryboard-iPhone5"]){
        
        VideoTableViewCell *cell  = (VideoTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier45];
        
        cell.labelTituloVideo.text = video.title;
        cell.labelSummary.text = video.summary;
        cell.rudoVideoUrl = video.link;

        // Load the image with an GCD block executed in another thread
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:video.imagenThumbString]];
            
            if (data) {
                UIImage *offersImage = [UIImage imageWithData:data];
                if (offersImage) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        VideoTableViewCell *updateCell = (VideoTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
                        updateCell.imageViewThumb.image  = offersImage;
                        
                    });
                }
            }
        });
        
        return cell;
        
    }else{
        
        VideoTableViewCell *cell  = (VideoTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        cell.labelTituloVideo.text = video.title;
        cell.labelSummary.text = video.summary;
        cell.rudoVideoUrl = video.link;
        // NSLog(@"Video URL: %@",video.imagenThumbString);
        // Load the image with an GCD block executed in another thread
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:video.imagenThumbString]];
            
            if (data) {
                UIImage *offersImage = [UIImage imageWithData:data];
                if (offersImage) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        VideoTableViewCell *updateCell = (VideoTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
                        updateCell.imageViewThumb.image  = offersImage;
                        
                    });
                }
            }
        });
        
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    VideoTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSString *url=cell.rudoVideoUrl;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyBoardNameTVSeries bundle: nil];
    VideoPlayerViewController *controller = (VideoPlayerViewController *)[storyboard instantiateViewControllerWithIdentifier: @"videoWebView"];
    controller.videoURL = url;
    Video *video = (Video*)[laTerceraTVSeriesArray objectAtIndex:indexPath.row ];
    controller.titulo = video.title;
    controller.seccion = @"3voz";
    [[self navigationController] pushViewController:controller animated:YES] ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 458;
}




-(void)loadHeadlinesWithCategory:(int)idCategory{
    NSLog(@"Load Headlines");
    
    __weak LaTerceraTV_SeriesTableViewController *weakSelf = self;
    
    
    ConnectionManager *connectionManager = [[ConnectionManager alloc]init];
    BOOL estaConectado = [connectionManager verifyConnection];
    NSLog(@"Verificando conexión: %d",estaConectado);
    [connectionManager getHeadlinesForCategoryId:^(BOOL success, NSArray *arrayJson, NSError *error){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!success) {
                if (isPageRefreshingLaTerceraTVSeries == false){
                    
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
                    
                    isPageRefreshingLaTerceraTVSeries = YES;
                    
                }else{
                    
                    [self reloadHeadlinesDataFromArrayJson:arrayJson];
                    //NSLog(@"********++++ Lista videos json: %@",arrayJson);
                }
            }
        });
    }:idCategory andPage:currentPageNumberTVSeries];
    
}


-(void) reloadHeadlinesDataFromArrayJson:(NSArray*)arrayJson{
    __weak LaTerceraTV_SeriesTableViewController *weakSelf = self;
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
        NSString *title= [[dictTitular objectForKey:@"title"] stringByReplacingOccurrencesOfString: @"&#8220;" withString:@"“"];
        title = [title stringByReplacingOccurrencesOfString: @"&#8221;" withString:@"”"];
        id summary = [dictTitular objectForKey:@"short_description"];
        
        NSString *imageThumb ;
        imageThumb = [dictTitular objectForKey:@"thumb_url"];
        /*if (([dictTitular objectForKey:@"thumb_url"] == (id)[NSNull null]) || ([[dictTitular objectForKey:@"thumb_url"] isEqualToString:@""])){
         imageThumb = @"https://placekitten.com/200/200";
         }else{
         imageThumb = [dictTitular objectForKey:@"thumb_url"];
         }*/
        
        NSArray* arrayMedia= [dictTitular objectForKey:@"medias"];
        NSDictionary *media = (NSDictionary*) arrayMedia[0];
        id linkVideo = [media objectForKey:@"media_url"];
        
        
        
        Video *video = [[Video alloc] init];
        video.idVideo = [idArt intValue];
        video.title = title;
        video.summary = summary;
        //NSLog(@"____ IMAGEN THUMBB: %@", imageThumb);
        video.imagenThumbString = imageThumb;
        video.link = linkVideo;
        
        NSLog(@"____ Numero de pagina: %d", currentPageNumberTVSeries);
        if (indice == currentPageNumberTVSeries*6 ){
            NSLog(@"____ currentPageNumberTVSeries*6: %d", currentPageNumberTVSeries*6);
            // [laTerceraTVSeriesArray addObject:@"OBJETO"];
        }
        [video logDescription];
        
        [laTerceraTVSeriesArray addObject:video];
    }
    
    //New code
    if (firstTimeLaTerceraTVSeries ==true){
        self.view.alpha = 0.0;
        [self.tableView reloadData];
        [UIView animateWithDuration:0.5
                         animations:^{ self.view.alpha = 1.0; /* Some fake chages */
                             
                         }
                         completion:^(BOOL finished)
         {
             //[SVProgressHUD dismiss];
         }];
        firstTimeLaTerceraTVSeries= false;
    }else{
        
        //[SVProgressHUD dismiss];
        isPageRefreshingLaTerceraTVSeries= NO;
        // [weakSelf.collectionView endUpdates];
        
        [self.tableView reloadData];
        [self.tableView layoutIfNeeded];
        [weakSelf.tableView.infiniteScrollingView stopAnimating];
        NSLog(@"LA cantidad es: %lu",(unsigned long)laTerceraTVSeriesArray.count);
    }
    NSLog(@" ******* RELOAD DATA TABLEEE Series ****** ----------------------");
}



@end
