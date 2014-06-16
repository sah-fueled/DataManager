//
//  TransientSelfie.h
//  RestkitExample
//
//  Created by sah-fueled on 16/06/14.
//  Copyright (c) 2014 Fueled.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TransientUser;
@interface TransientSelfie : NSObject

@property (nonatomic, retain) NSString * caption;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * imageSize;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, assign) BOOL  isDeletedSelfie;
@property (nonatomic, retain) NSNumber * selfieId;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) TransientUser *user;

@end
