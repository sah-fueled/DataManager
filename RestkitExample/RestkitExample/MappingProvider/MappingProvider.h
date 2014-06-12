//
//  MappingProvider.h
//  RestkitExample
//
//  Created by sah-fueled on 09/06/14.
//  Copyright (c) 2014 Fueled.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Restkit.h"

@class User;

@interface MappingProvider : NSObject

+ (RKObjectMapping *)userMapping;
+ (RKEntityMapping *)userMappingForStore:(RKManagedObjectStore *)store;
+ (RKEntityMapping *)selfieMappingForStore:(RKManagedObjectStore *)store;

@end
