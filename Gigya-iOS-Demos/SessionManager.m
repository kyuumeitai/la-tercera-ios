//
//  Singleton.m
//  AppBaniosCercanos
//
//  Created by diseno on 24-02-16.
//
//

#import "SessionManager.h"

@implementation SessionManager

@synthesize profileCode;
@synthesize profileType;
@synthesize profileEmail;
@synthesize profileGigyaId;
@synthesize storyBoardName;
@synthesize userLocation;
@synthesize leftSlideMenu;
@synthesize width;
@synthesize categoryList;
@synthesize userProfile;
@synthesize isLogged;
@synthesize hasShownMailConfirmation;

#pragma mark Singleton Methods

+ (id)session{
    static SessionManager *session = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        session = [[self alloc] init];
    });
    return session;
}

- (id)init {
    if (self = [super init]) {
        
        storyBoardName =  @"MainStoryBoard";
        
        //Temp vars
        profileGigyaId =  @"noneId ";
        profileEmail = @"    - ";
        profileCode = -1;
        profileType = @"anonimo";
        //End temp vars
        
        userLocation = nil;
        leftSlideMenu = nil;
        
        categoryList = [[NSMutableArray alloc]init];
        
        userProfile = [[UserProfile alloc] init];
        userProfile.userProfileId = -1;
        userProfile.rut = @"";
        userProfile.name = @"";
        userProfile.lastName = @"";
        userProfile.email = @"";
        userProfile.status = false;
        userProfile.suscriber = false;
        userProfile.token = @"";
        userProfile.other_emails = [[NSMutableArray alloc]init];
        userProfile.gender = @"";
        userProfile.birthdate = @"";
        userProfile.profileType = @"anonimo";
        userProfile.profileLevel = 0;
        //userProfile.profileLevel = 2;
        userProfile.preferences = [[NSMutableArray alloc]init];
        userProfile.site = @"";
        userProfile.notificacionesClub = false;
        userProfile.notificacionesNoticias = false;
        userProfile.horario1 = false;
        userProfile.horario2 = false;
        userProfile.horario3 = false;
        userProfile.device = -1;

        width = 0;
        NSLog(@"Sesión iniciada");
    }
    return self;
}


-(NSString*)sessionDescription{
    
    NSString *mensaje = [NSString stringWithFormat:@" Está logueado: %d ,  Storyboard: %@  User ProfileId: %d y categoryList: %@  ", self.isLogged, self.storyBoardName, self.userProfile.userProfileId, self.categoryList];
    
    return mensaje;
    
}

-(NSString*)profileDescription{
    
    NSString *mensaje = [NSString stringWithFormat:@"Email %@ , Nombres: %@ %@, ProfileLevel: %d, es Suscriptor?: %d , ProfileType: %@  User status: %d   ", userProfile.email,userProfile.name, userProfile.lastName, userProfile.profileLevel , userProfile.suscriber, userProfile.profileType, userProfile.status];
    
    return mensaje;
    
}

-(void) resetUserProfile{
    
    NSLog(@"Reset user profile");
    SessionManager *sesion = [SessionManager session];
    sesion.isLogged = NO;
    //Temp vars
    profileGigyaId =  @"noneId ";
    profileEmail = @"    - ";
    profileCode = -1;
    profileType = @"anonimo";
    //End temp vars
    
    userLocation = nil;
    leftSlideMenu = nil;
    
    categoryList = [[NSMutableArray alloc]init];
    
    userProfile = [[UserProfile alloc] init];
    userProfile.userProfileId = -1;
    userProfile.rut = @"";
    userProfile.name = @"";
    userProfile.lastName = @"";
    userProfile.email = @"";
    userProfile.status = false;
    userProfile.suscriber = false;
    userProfile.token = @"";
    userProfile.other_emails = [[NSMutableArray alloc]init];
    userProfile.gender = @"";
    userProfile.birthdate = @"";
    userProfile.profileType = @"anonimo";
    userProfile.profileLevel = 0;
    userProfile.preferences = [[NSMutableArray alloc]init];
    userProfile.site = @"";
    userProfile.notificacionesClub = false;
    userProfile.notificacionesNoticias = false;
    userProfile.horario1 = false;
    userProfile.horario2 = false;
    userProfile.horario3 = false;
    userProfile.device = -1;
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogged"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
}

-(UserProfile *)getUserProfile{
    
    return userProfile;
    
}

-(BOOL)isRepeatedForSelectedCategory:(int)idCat{

    SessionManager *sesion = [SessionManager session];
    
    NSMutableArray *arreglo = (NSMutableArray*)[sesion getMiSeleccionArray];
    for (NSManagedObject *objeto in arreglo) {
        NSLog(@"Comparamos idCat: %d con: %d , que es: %@", idCat, [[objeto valueForKey:@"idCat"] intValue], [objeto valueForKey:@"nombreCat"]);
        int valor = [[objeto valueForKey:@"idCat"] intValue];
        
        if (idCat == valor) {
            
            return true;
            
        }
        
    }
    return false;
}

-(BOOL)isFavoriteNewsWithArticleId:(int)idArticle{
    
    SessionManager *sesion = [SessionManager session];
    
    NSMutableArray *arreglo = (NSMutableArray*)[sesion getMyFavoritNewsArray];
    for (NSManagedObject *objeto in arreglo) {
        NSLog(@"Comparamos idCat: %d con: %d ", idArticle, [[objeto valueForKey:@"idArticle"] intValue]);
        int valor = [[objeto valueForKey:@"idArticle"] intValue];
        
        if (idArticle == valor) {
            
            return true;
            
        }
        
    }
    return false;
}

-(BOOL) saveMiSeleccionCategoryWithId:(int)idCat andCategoryName:(NSString*)categoryName{
    
    BOOL exitoso = false;

    if([self isRepeatedForSelectedCategory:idCat]){
            
            return false;
            
        }else{
            
            NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
            
            // Create a new selection category
            NSManagedObject *nuevaCategoriaSeleccion = [NSEntityDescription insertNewObjectForEntityForName:@"CategoriasSeleccion" inManagedObjectContext:managedObjectContext];
            
            [nuevaCategoriaSeleccion  setValue:categoryName forKey:@"nombreCat"];

            [nuevaCategoriaSeleccion  setValue:[NSNumber numberWithInt:idCat] forKey:@"idCat"];
            
            NSError *error = nil;
            // Save the object to persistent store
            if (![managedObjectContext save:&error]) {
                NSLog(@"No se pudo guardar! %@ %@", error, [error localizedDescription]);
                exitoso = false;
            }else{
                
                exitoso = true;
            }
            
        }
    

    return exitoso;
}

-(void) deleteMiSeleccionCategoryWithId:(int)idCat andCategoryName:(NSString*)categoryName{
    
    NSEntityDescription *productEntity=[NSEntityDescription entityForName:@"CategoriasSeleccion" inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *fetch=[[NSFetchRequest alloc] init];
    [fetch setEntity:productEntity];
    NSPredicate *p=[NSPredicate predicateWithFormat:@"idCat == %d && nombreCat == %@", idCat,categoryName];
    [fetch setPredicate:p];
    //... add sorts if you want them
    NSError *fetchError;
    NSError *error;
    NSArray *fetchedProducts=[self.managedObjectContext executeFetchRequest:fetch error:&fetchError];
    for (NSManagedObject *product in fetchedProducts) {
        NSLog(@"La categoria es: %@",product);
        [self.managedObjectContext deleteObject:product];
    }
    [self.managedObjectContext save:&error];

}

-(void) deleteNoticiaWithId:(int)idNoticia{
    
    NSEntityDescription *productEntity=[NSEntityDescription entityForName:@"Noticia" inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *fetch=[[NSFetchRequest alloc] init];
    [fetch setEntity:productEntity];
    NSPredicate *p=[NSPredicate predicateWithFormat:@"idArticle == %d", idNoticia];
    [fetch setPredicate:p];
    //... add sorts if you want them
    NSError *fetchError;
    NSError *error;
    NSArray *fetchedProducts=[self.managedObjectContext executeFetchRequest:fetch error:&fetchError];
    for (NSManagedObject *product in fetchedProducts) {
        NSLog(@"La noticia es: %@",product);
        [self.managedObjectContext deleteObject:product];
    }
    [self.managedObjectContext save:&error];
    
}



-(NSArray*) getMiSeleccionArray{
    
    NSArray *arraySeleccion = [[NSArray alloc] init];
    // Fetch the devices from persistent data store
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CategoriasSeleccion"];
    arraySeleccion = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    NSLog(@"El array seleccion es : %@",arraySeleccion);
    
    return arraySeleccion;
}

-(NSArray*) getMyFavoritNewsArray{
    
    NSArray *arraySeleccion = [[NSArray alloc] init];
    // Fetch the devices from persistent data store
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Noticia"];
    arraySeleccion = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    NSLog(@"El array de news es : %@",arraySeleccion);
    
    return arraySeleccion;
}

-(NSMutableArray*) getMiSeleccionCategoryIdsArray{
    
    NSMutableArray *arraySeleccionIds = [[NSMutableArray alloc] init];
    
    SessionManager *sesion = [SessionManager session];
    
    NSMutableArray *arreglo = (NSMutableArray*)[sesion getMiSeleccionArray];
    for (NSManagedObject *objeto in arreglo) {
        int valor = [[objeto valueForKey:@"idCat"] intValue];
        NSLog(@">>>>>>>***** Mi seleccion:  Id de categoria: %d /n",valor);

        [arraySeleccionIds addObject:[NSNumber numberWithInteger:valor]];
    }

    
    return arraySeleccionIds;
}

-(NSMutableArray*) getMiSeleccionCategoryTitlesArray{
    
    NSMutableArray *arraySeleccionTitles = [[NSMutableArray alloc] init];
    
    SessionManager *sesion = [SessionManager session];
    
    NSMutableArray *arreglo = (NSMutableArray*)[sesion getMiSeleccionArray];
    for (NSManagedObject *objeto in arreglo) {
        NSString * tituloCat = [objeto valueForKey:@"nombreCat"];
        NSLog(@">>>>>>>***** Mi seleccion:  Título de categoria: %@ /n",tituloCat);
        [arraySeleccionTitles addObject:tituloCat];
    }
    
    return arraySeleccionTitles;
}

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}



@end
