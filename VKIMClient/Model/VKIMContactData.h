//
//  VKIMContactData.h
//  SecurIM
//
//  Created by kovtash on 13.03.13.
//  Copyright (c) 2013 Vlad Kovtash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VKIMSessionData.h"

typedef enum VKIMContactState {
    VKIMContactAvailable,
    VKIMContactAway,
    VKIMContactDND,
    VKIMContactOffline,
} VKIMContactState;

typedef enum VKIMContactAuthorization {
    VKIMContactAuthorizationNone,
    VKIMContactAuthorizationRequested,
    VKIMContactAuthorizationGranted
} VKIMContactAuthorization;

@interface VKIMContactData : NSObject
@property (strong,nonatomic) NSString *contactID;
@property (strong,nonatomic) NSString *jid;
@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSArray *groups;
@property (strong,nonatomic) NSString *status;
@property (assign,nonatomic) VKIMContactState state;
@property (assign,nonatomic) VKIMContactAuthorization authState;
@property (nonatomic) NSUInteger historyOffset;
@property (nonatomic) NSUInteger readOffset;
@property (nonatomic) NSUInteger eventID;
@property (strong,nonatomic) VKIMSessionData *session;
@end
