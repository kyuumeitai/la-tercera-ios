//
//  InfantilTableViewController.m
//  La Tercera
//
//  Created by diseno on 15-03-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import  "InfantilTableViewController.h"
#import  "CategoriasTableViewCell.h"
#import  "DestacadoTableViewCell.h"
#import  "DetalleBeneficioViewController.h"
#import "Category.h"
#import "Benefit.h"
#import "SessionManager.h"
#import "ConnectionManager.h"
#import "SVProgressHUD.h"
#import "Tools.h"

@interface InfantilTableViewController ()

@end

@implementation InfantilTableViewController
NSMutableArray *listaCategorias2;
NSMutableArray *listaBeneficios2;
@synthesize benefitsItemsArray4;
- (void)viewDidLoad {
    [super viewDidLoad];
    SessionManager *sesion = [SessionManager session];
    listaCategorias2 = [[NSMutableArray alloc] init];
    listaCategorias2 = sesion.categoryList;
    //NSLog(@"La lista de categorias es: %@",listaCategorias2.description);
    
    [self loadBenefitsForCategoryId:43];
    
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
    return self.benefitsItemsArray4.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
static NSString *simpleTableIdentifier = @"ClubCategoryTableCell4";    
    NSArray *nib;
    
    if (indexPath.row==0) {
        DestacadoTableViewCell *cell = (DestacadoTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil)
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"DestacadoTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            Benefit *beneficio = [self.benefitsItemsArray4 objectAtIndex:0];
            
            cell.labelTitulo.text = beneficio.title;
            cell.labelSubtitulo.text = beneficio.summary;
            cell.labelDescuento.text = beneficio.desclabel;
            if((unsigned long)beneficio.desclabel.length >3)
                cell.labelDescuento.alpha = 0;
            
            //Get Image

            NSArray * arr = [beneficio.imagenNormalString componentsSeparatedByString:@","];
            UIImage *imagenBeneficio = nil;
            
            //Now data is decoded. You can convert them to UIImage
            imagenBeneficio = [Tools decodeBase64ToImage:[arr lastObject]];
            if(imagenBeneficio == nil)
                imagenBeneficio = [UIImage imageNamed:@"PlaceholderHeaderClub"];
            
            cell.imageDestacada.image = imagenBeneficio;


        }
        return cell;
    }else{
        
        CategoriasTableViewCell *cell = (CategoriasTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            
            nib = [[NSBundle mainBundle] loadNibNamed:@"CategoriasTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        Benefit *beneficio2 = [self.benefitsItemsArray4 objectAtIndex:indexPath.row];
        //[beneficio2 logDescription];
        
        cell.labelTitulo.text = beneficio2.title;
        cell.labelDescuento.text = beneficio2.desclabel;
        if((unsigned long)beneficio2.desclabel.length >3)
            cell.labelDescuento.alpha = 0;
        //Get Image
        NSArray * arr2 = [beneficio2.imagenNormalString componentsSeparatedByString:@","];
        UIImage *imagenBeneficio2 = nil;
        
        //Now data is decoded. You can convert them to UIImage
        imagenBeneficio2 = [Tools decodeBase64ToImage:[arr2 lastObject]];
        if(!imagenBeneficio2)
            imagenBeneficio2 = [UIImage imageNamed:@"PlaceholderHeaderClub"];
        cell.imageCategoria.image = imagenBeneficio2;
        
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
    Benefit *beneficio = [self.benefitsItemsArray4 objectAtIndex:indexPath.row];
    [detalleBeneficio loadBenefitForBenefitId:beneficio.idBen];
    //Get Image
    NSArray * arr = [beneficio.imagenNormalString componentsSeparatedByString:@","];
    UIImage *imagenBeneficio = nil;
    
    //Now data is decoded. You can convert them to UIImage
    imagenBeneficio = [Tools decodeBase64ToImage:[arr lastObject]];
    if(imagenBeneficio == nil)
        imagenBeneficio = [UIImage imageNamed:@"PlaceholderHeaderClub"];
    
    detalleBeneficio.benefitImage = imagenBeneficio;    detalleBeneficio.benefitTitle= beneficio.title;
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
                [self errorDetectedWithNSError:error];
            } else {
                [self reloadBenefitsDataFromService:arrayJson];
                // NSLog(@"Lista jhson: %@",arrayJson);
            }
        });
    }:idCategory];
}

-(void) reloadBenefitsDataFromService:(NSArray*)arrayJson{
    NSLog(@"  reload benefits Infantil ");
    self.benefitsItemsArray4 = [[NSMutableArray alloc] init];
    
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
            
            NSString *imagenBen = [benefit objectForKey:@"image"] ;
            beneficio.imagenNormalString = imagenBen;
        }
        
        [self.benefitsItemsArray4 addObject:beneficio];

    }
    self.view.alpha = 0.0;
    [self.tableView reloadData];
    [UIView animateWithDuration:0.5
                     animations:^{ self.view.alpha = 1.0; /* Some fake chages */
                         
                     }
                     completion:^(BOOL finished)
     {
         //[SVProgressHUD dismiss];
     }];
    NSLog(@" ******* RELOAD DATA TABLE Infantil ****** ----------------------");
}

//Error handler
-(void) errorDetectedWithNSError:(NSError*) error{
    
    NSLog(@"Error obteniendo datos! El error es:  %@", [error localizedDescription]);
    /*
    //Escondemos el loading
    [SVProgressHUD dismiss];
    
    //Damos explicaciones del caso
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Error obteniendo Datos"
                          message:@"Ha ocurrido un error al obtener los datos. Reintente más tarde."
                          delegate:nil //or self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
     */
}


@end
