//
//  LaTerceraTV-MouseTableViewController.m
//  La Tercera
//
//  Created by Mario Alejandro on 17-10-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "LaTerceraTV-MouseTableViewController.h"
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

#define categorySlug @"Mouse"

@interface LaTerceraTV_MouseTableViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation LaTerceraTV_MouseTableViewController
@synthesize laTerceraTVMouseArray;
@synthesize tableView;
@synthesize categoryId;

static NSString * const reuseIdentifierGrande = @"collectionViewGrande";
static NSString * const reuseIdentifierBanner = @"collectionViewBanner";
static NSString * const reuseIdentifierVideo = @"videoTableViewCell";

//New Pagination code
int currentPageNumberTVMouse ;
BOOL isPageRefreshingLaTerceraTVMouse =  false;
BOOL firstTimeLaTerceraTVMouse = false;

NSArray *bannersLaTerceraTVMouse= nil;

BOOL _isScrollingLaTerceraTVMouse;
int numeroPaginasTVMouse;
NSString *dayTVMouse;
NSString *monthTVMouse;
NSString *yearTVMouse;
NSString *storyBoardNameTVMouse;

- (void)viewDidLoad {
    [super viewDidLoad];
    SessionManager *sesion = [SessionManager session];
    storyBoardNameTVMouse = sesion.storyBoardName;
    
    for (ContentType *contenido in sesion.categoryList) {
        if([contenido.contentSlug isEqualToString:categorySlug])
            self.categoryId = contenido.contentId;
        NSLog(@"Category Slug: %@ and categoryId:%d",contenido.contentSlug,contenido.contentId);
    }
    
    NSLog(@" El nombre del storyboard es: %@", storyBoardNameTVMouse);
    NSLog(@"CategoryId: %d", self.categoryId);
    __weak  LaTerceraTV_MouseTableViewController *weakSelf = self;
    laTerceraTVMouseArray = [[NSMutableArray alloc] init];
    
    bannersLaTerceraTVMouse = [NSArray arrayWithObjects:@"/124506296/La_Tercera_com/La_Tercera_com_APP/LaTerceraTVMouse_300x250-A", @"/124506296/La_Tercera_com/La_Tercera_com_APP/LaTerceraTVMouse_300x250-B", @"/124506296/La_Tercera_com/La_Tercera_com_APP/LaTerceraTVMouse_300x250-C", @"/124506296/La_Tercera_com/La_Tercera_com_APP/LaTerceraTVMouse_300x250-D", @"/124506296/La_Tercera_com/La_Tercera_com_APP/LaTerceraTVMouse_300x250-E", nil];
    
    //Celda Grande
    UINib *cellNib ;
    
    if([storyBoardNameTVMouse isEqualToString:@"LaTerceraStoryboard-iPhone4"] || [storyBoardNameTVMouse isEqualToString:@"LaTerceraStoryboard-iPhone5"]){
        cellNib = [UINib nibWithNibName:@"CollectionViewCellGrande4-5" bundle: nil];
        [self.tableView registerNib:cellNib  forCellReuseIdentifier:@"collectionViewGrande4-5"];
        
    }else{
        
        cellNib = [UINib nibWithNibName:@"CollectionViewCellGrande" bundle: nil];
        [self.tableView registerNib:cellNib  forCellReuseIdentifier:reuseIdentifierGrande];
    }
    
    UINib *cellNib4 = [UINib nibWithNibName:@"CollectionViewCellBanner" bundle: nil];
    
    [self.tableView registerNib:cellNib4  forCellReuseIdentifier:reuseIdentifierBanner];
    
    currentPageNumberTVMouse = 1;
    firstTimeLaTerceraTVMouse = true;
    
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
    isPageRefreshingLaTerceraTVMouse = NO;
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
    return self.laTerceraTVMouseArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"videoTableViewCell";
    NSArray *nib;
    Video *video = (Video*)[laTerceraTVMouseArray objectAtIndex:indexPath.row ];
    //CollectionViewCellBanner *celdaBanner = (CollectionViewCellBanner*)[self.tableView dequeueReusableCellWithIdentifier:reuseIdentifierBanner];
    
    VideoTableViewCell *cell = (VideoTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        if([storyBoardNameTVMouse isEqualToString:@"LaTerceraStoryboard-iPhone4"] || [storyBoardNameTVMouse isEqualToString:@"LaTerceraStoryboard-iPhone5"]){
            nib = [[NSBundle mainBundle] loadNibNamed:@"VideoTableViewCell4-5" owner:self options:nil];
        }else{
            
            nib = [[NSBundle mainBundle] loadNibNamed:@"VideoTableViewCell" owner:self options:nil];
        }
        cell = [nib objectAtIndex:0];
        
        cell.labelTituloVideo.text = video.title;
        cell.labelSummary.text = video.summary;
        cell.rudoVideoUrl = video.link;
        // NSLog(@"Video URL: %@",video.imagenThumbString);
        cell.imageViewThumb.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:video.imagenThumbString]]];

        
        return cell;
        
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    VideoTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.rudoPlayer.alpha = 1;
    cell.rudoPlayer.userInteractionEnabled = YES;
    [cell loadBanner];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 438;
}




-(void)loadHeadlinesWithCategory:(int)idCategory{
    NSLog(@"Load Headlines");
    
    __weak LaTerceraTV_MouseTableViewController *weakSelf = self;
    
    
    ConnectionManager *connectionManager = [[ConnectionManager alloc]init];
    BOOL estaConectado = [connectionManager verifyConnection];
    NSLog(@"Verificando conexión: %d",estaConectado);
    [connectionManager getHeadlinesForCategoryId:^(BOOL success, NSArray *arrayJson, NSError *error){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!success) {
                if (isPageRefreshingLaTerceraTVMouse == false){
                    
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
                    
                    isPageRefreshingLaTerceraTVMouse = YES;
                    
                }else{
                    
                    [self reloadHeadlinesDataFromArrayJson:arrayJson];
                    NSLog(@"********++++ Lista videos json: %@",arrayJson);
                }
            }
        });
    }:idCategory andPage:currentPageNumberTVMouse];
    
}


-(void) reloadHeadlinesDataFromArrayJson:(NSArray*)arrayJson{
    __weak LaTerceraTV_MouseTableViewController *weakSelf = self;
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
        
        NSString *imageThumb ;
        
        if (([dictTitular objectForKey:@"thumb_url"] == (id)[NSNull null]) || ([[dictTitular objectForKey:@"thumb_url"] isEqualToString:@""])){
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
        //NSLog(@"____ IMAGEN THUMBB: %@", imageThumb);
        video.imagenThumbString = imageThumb;
        video.link = linkVideo;
        
        NSLog(@"____ Numero de pagina: %d", currentPageNumberTVMouse);
        if (indice == currentPageNumberTVMouse*6 ){
            NSLog(@"____ currentPageNumberTVMouse*6: %d", currentPageNumberTVMouse*6);
            // [laTerceraTVMouseArray addObject:@"OBJETO"];
        }
        [video logDescription];
        
        [laTerceraTVMouseArray addObject:video];
    }
    
    //New code
    if (firstTimeLaTerceraTVMouse ==true){
        self.view.alpha = 0.0;
        [self.tableView reloadData];
        [UIView animateWithDuration:0.5
                         animations:^{ self.view.alpha = 1.0; /* Some fake chages */
                             
                         }
                         completion:^(BOOL finished)
         {
             //[SVProgressHUD dismiss];
         }];
        firstTimeLaTerceraTVMouse= false;
    }else{
        
        //[SVProgressHUD dismiss];
        isPageRefreshingLaTerceraTVMouse= NO;
        // [weakSelf.collectionView endUpdates];
        
        [self.tableView reloadData];
        [self.tableView layoutIfNeeded];
        [weakSelf.tableView.infiniteScrollingView stopAnimating];
        NSLog(@"LA cantidad es: %lu",(unsigned long)laTerceraTVMouseArray.count);
    }
    NSLog(@" ******* RELOAD DATA TABLEEE ****** ----------------------");
}



@end
