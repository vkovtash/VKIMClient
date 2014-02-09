//
//  VKIMMucData.h
//  VKIMClientTest
//
//  Created by kovtash on 09.02.14.
//  Copyright (c) 2014 kovtash.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VKIMSessionData;

@interface VKIMMucData : NSObject
@property (strong,nonatomic) NSString *mucID;
@property (strong,nonatomic) NSString *jid;
@property (nonatomic) NSUInteger readOffset;
@property (nonatomic) NSUInteger eventID;
@property (strong,nonatomic) VKIMSessionData *session;
@end
