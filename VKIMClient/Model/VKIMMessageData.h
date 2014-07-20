//
//  VKIMMessageData.h
//  SecurIM
//
//  Created by kovtash on 11.03.13.
//  Copyright (c) 2013 Vlad Kovtash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VKIMSessionData.h"

@class VKIMSession;
@protocol VKIMContactProtocol <NSObject>
@property (readonly, nonatomic) NSString *contactID;
@property (readonly, nonatomic) VKIMSessionData *session;
@end

@interface VKIMMessageData : NSObject
@property (strong, nonatomic) NSString *messageID;
@property (strong, nonatomic) NSString *text;
@property (assign, nonatomic) BOOL inbound;
@property (nonatomic) BOOL delivered;
@property (readonly, nonatomic) id <VKIMContactProtocol> contact;
@property (strong, nonatomic) NSString *contactID;
@property (nonatomic) NSUInteger eventID;
@property (nonatomic) NSUInteger sortID;
@property (nonatomic) NSNumber *timestamp;
@property (readonly, nonatomic) NSDate *messageDate;

- (instancetype) initWithContact:(id <VKIMContactProtocol>) contact;
@end
