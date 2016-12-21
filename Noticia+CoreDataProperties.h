//
//  Noticia+CoreDataProperties.h
//  La Tercera
//
//  Created by Daniel López Monsalve on 18-12-16.
//  Copyright © 2016 Copesa. All rights reserved.
//

#import "Noticia+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Noticia (CoreDataProperties)

+ (NSFetchRequest<Noticia *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *author;
@property (nullable, nonatomic, copy) NSString *category;
@property (nullable, nonatomic, copy) NSString *content;
@property (nullable, nonatomic, copy) NSString *date;
@property (nullable, nonatomic, copy) NSNumber *idArticle;
@property (nullable, nonatomic, retain) NSData *imageLink;
@property (nullable, nonatomic, copy) NSString *summary;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *url;

@end

NS_ASSUME_NONNULL_END
