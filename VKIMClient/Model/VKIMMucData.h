//
//  VKIMMucData.h
//  VKIMClientTest
//
//  Created by kovtash on 09.02.14.
//  Copyright (c) 2014 kovtash.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VKIMMessageData.h"

@class VKIMSessionData;

@interface VKIMMucData : NSObject <VKIMContactProtocol>
@property (strong,nonatomic) NSString *contactID;
@property (strong,nonatomic) NSString *jid;
@property (strong, nonatomic) NSString *name;
@property (nonatomic) NSUInteger readOffset;
@property (nonatomic) NSUInteger historyOffset;
@property (nonatomic) NSUInteger eventID;
@property (strong,nonatomic) VKIMSessionData *session;
@end