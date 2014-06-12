//
//  Selfie.h
//  RestkitExample
//
//  Created by sah-fueled on 09/06/14.
//  Copyright (c) 2014 Fueled.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Selfie : NSManagedObject

@property (nonatomic, retain) NSString * caption;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * imageSize;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSNumber * isDeletedSelfie;
@property (nonatomic, retain) NSNumber * selfieId;
@property (nonatomic, retain) User *user;

@end
