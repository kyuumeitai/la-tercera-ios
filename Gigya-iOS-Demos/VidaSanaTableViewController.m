//
//  SaboresTableViewController.m
//  La Tercera
//
//  Created by diseno on 15-03-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "VidaSanaTableViewController.h"
#import  "CategoriasTableViewCell.h"
#import  "DestacadoTableViewCell.h"
#import  "DetalleBeneficioViewController.h"
#import "Category.h"
#import "Benefit.h"
#import "SingletonManager.h"
#import "ConnectionManager.h"
#import "SVProgressHUD.h"
#import "Tools.h"

@interface VidaSanaTableViewController ()

@end

@implementation VidaSanaTableViewController
NSMutableArray *listaCategorias4;
NSMutableArray *listaBeneficios4;
@synthesize benefitsItemsArray2;
- (void)viewDidLoad {
    [super viewDidLoad];
    //[self.tableView setContentS];
    SingletonManager *singleton = [SingletonManager singletonManager];
    listaCategorias4 = [[NSMutableArray alloc] init];
    listaCategorias4 = singleton.categoryList;
    //NSLog(@"La lista de categorias es: %@",listaCategorias4.description);
   [self loadBenefitsForCategoryId:29];
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
    return self.benefitsItemsArray2.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"BanioTableCell";
    
    
    
    /*MyManager *singleton = [MyManager sharedManager];
     NSString *storyBoardName = singleton.storyBoardName;
     
     
     if ([storyBoardName isEqualToString:@"MainStoryboard-iPhone4"] )
     nib = [[NSBundle mainBundle] loadNibNamed:@"BaniosTableViewCell-iPhone4" owner:self options:nil];
     if ([storyBoardName isEqualToString:@"MainStoryboard-iPhone5"] )
     nib = [[NSBundle mainBundle] loadNibNamed:@"BaniosTableViewCell-iPhone5" owner:self options:nil];
     if ([storyBoardName isEqualToString:@"MainStoryboard-iPhone6"] )
     nib = [[NSBundle mainBundle] loadNibNamed:@"BaniosTableViewCell-iPhone6" owner:self options:nil];
     if ([storyBoardName isEqualToString:@"MainStoryboard-iPhone6Plus"] )
     */
    NSArray *nib;
    
    if (indexPath.row==0) {
        DestacadoTableViewCell *cell = (DestacadoTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil)
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"DestacadoTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            Benefit *beneficio = [self.benefitsItemsArray2 objectAtIndex:0];
            
            cell.labelTitulo.text = beneficio.title;
            cell.labelSubtitulo.text = beneficio.summary;
            cell.labelDescuento.text = beneficio.desclabel;
            cell.labelDistancia.text = @"A 200 metros de su ubicación";
            cell.imageDestacada.image = beneficio.imagenNormal;
        }
        return cell;
    }else{
        
        CategoriasTableViewCell *cell = (CategoriasTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            
            nib = [[NSBundle mainBundle] loadNibNamed:@"CategoriasTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        Benefit *beneficio2 = [self.benefitsItemsArray2 objectAtIndex:indexPath.row];
        //[beneficio2 logDescription];
        
        cell.labelTitulo.text = beneficio2.title;
        cell.labelDescuento.text = beneficio2.desclabel;
        cell.labelDistancia.text = @"A 200 metros de su ubicación";
       // NSLog(@" Imagen beneficionormal: %@",beneficio2.imagenNormal);
        cell.imageCategoria.image =  beneficio2.imagenNormal;
        
        
        
        
        return cell;
    }
    
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 278.0;
    }
    else {
        return 100.0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    NSLog(@"DETECTED");
    
    
    DetalleBeneficioViewController *detalleBeneficio = [self.storyboard instantiateViewControllerWithIdentifier:@"detalleBeneficioViewController"];
    Benefit *beneficio = [self.benefitsItemsArray2 objectAtIndex:indexPath.row];
    detalleBeneficio.benefitImage = beneficio.imagenNormal;
    detalleBeneficio.benefitTitle= beneficio.title;
    detalleBeneficio.benefitAddress = @"A 200 metros de su ubicación";
    detalleBeneficio.benefitDiscount= beneficio.desclabel;
    detalleBeneficio.benefitDescription = beneficio.summary;
    detalleBeneficio.benefitId = beneficio.idBen;

    
    [self.navigationController pushViewController: detalleBeneficio animated:YES];
    
}

-(void)loadBenefitsForCategoryId:(int)idCategory{
    
    NSLog(@"Load category benefits");
    // IMPORTANT - Only update the UI on the main thread
    [SVProgressHUD showWithStatus:@"Obteniendo beneficios disponibles" maskType:SVProgressHUDMaskTypeClear];
    
    ConnectionManager *connectionManager = [[ConnectionManager alloc]init];
    BOOL estaConectado = [connectionManager verifyConnection];
    NSLog(@"Verificando conexión: %d",estaConectado);
    [connectionManager getBenefitsForCategoryId :^(BOOL success, NSArray *arrayJson, NSError *error){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!success) {
                NSLog(@"Error obteniendo datos! %@ %@", error, [error localizedDescription]);
            } else {
                [self reloadBenefitsDataFromService:arrayJson];
                // NSLog(@"Lista jhson: %@",arrayJson);
            }
        });
    }:idCategory];
    
}

-(void) reloadBenefitsDataFromService:(NSArray*)arrayJson{
    NSLog(@"  reload beenfits  ");
    self.benefitsItemsArray2 = [[NSMutableArray alloc] init];
    
    NSDictionary *tempDict = (NSDictionary*)arrayJson;
    id benefits = [tempDict objectForKey:@"benefits"];
    
    
    for (id benefit in benefits){
        
        id titleBen = [benefit objectForKey:@"title"];
        int idBen =[ [benefit objectForKey:@"id"] intValue];;
        id linkBen = [benefit objectForKey:@"url"] ;
        id summaryBen = [benefit objectForKey:@"summary"] ;
        id benefitLabelBen = [benefit objectForKey:@"benefit_label"] ;
        
        
        Benefit *beneficio = [[Benefit alloc] init];
        beneficio.idBen = idBen;
        beneficio.title = titleBen;
        beneficio.url = linkBen;
        beneficio.summary= summaryBen;
        beneficio.desclabel = benefitLabelBen;
        
        
        if([benefit objectForKey:@"image"] != [NSNull null]){
            UIImage *imagenBeneficio = nil;
            NSString *imagenBen = [benefit objectForKey:@"image"] ;
            NSArray * arr = [imagenBen componentsSeparatedByString:@","];
            
            //Now data is decoded. You can convert them to UIImage
            imagenBeneficio = [Tools decodeBase64ToImage:[arr lastObject]];
            if(imagenBeneficio){
                beneficio.imagenNormal = imagenBeneficio;
            }else{
                imagenBeneficio = [UIImage imageNamed:@"PlaceholderHeaderClub"];
            }
            beneficio.imagenNormal = imagenBeneficio;
        }
        
        [self.benefitsItemsArray2 addObject:beneficio];
        
        
       
    }
    self.view.alpha = 0.0;
    [self.tableView reloadData];
    [UIView animateWithDuration:0.5
                     animations:^{ self.view.alpha = 1.0;                          
                     }
                     completion:^(BOOL finished)
     {
         [SVProgressHUD dismiss];
     }];
    
    NSLog(@" ******* RELOAD DATA TABLEEE ****** ----------------------");
}
@end
