//
//  VKIMErrorData.h
//  SecurIM
//
//  Created by kovtash on 05.04.13.
//  Copyright (c) 2013 unact. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const VKIMErrorDomain;

typedef enum VKIMErrorCodes {
    VKIMUpstreamAuthError,
    VKIMUpstreamConnectionError,
    VKIMSessionError,
    VKIMSessionAuthError,
    VKIMRequestParametersError,
    VKIMUnknownServerError
} VKIMErrorCodes;

@interface VKIMErrorData : NSObject
@property (strong,nonatomic) NSString *code;

- (NSError *) makeError;
+ (NSError *) sessionError;
@end
