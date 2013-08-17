//
//  VKIMErrorData.m
//  SecurIM
//
//  Created by kovtash on 05.04.13.
//  Copyright (c) 2013 unact. All rights reserved.
//

#import "VKIMErrorData.h"

@implementation VKIMErrorData

NSString *const VKIMErrorDomain = @"VKIMErrorDomain";
NSString *const XMPPUpstreamAuthError = @"XMPPUpstreamAuthError";
NSString *const XMPPUpstreamConnectionError = @"XMPPUpstreamConnectionError";
NSString *const XMPPSessionError = @"XMPPSessionError";
NSString *const XMPPAuthError = @"XMPPAuthError";
NSString *const XMPPServiceParametersError = @"XMPPServiceParametersError";

- (NSError *) makeError{
    if ([self.code isEqualToString:XMPPUpstreamAuthError]) {
        return [NSError errorWithDomain:VKIMErrorDomain
                                   code:VKIMUpstreamAuthError
                               userInfo:@{NSLocalizedDescriptionKey:@"Incorrect JID or password"}];
    }
    else if ([self.code isEqualToString:XMPPUpstreamConnectionError]){
        return [NSError errorWithDomain:VKIMErrorDomain
                                   code:VKIMUpstreamConnectionError
                               userInfo:@{NSLocalizedDescriptionKey:@"Can't connect to the upstream XMPP server"}];
    }
    else if ([self.code isEqualToString:XMPPSessionError]){
        return [NSError errorWithDomain:VKIMErrorDomain
                                   code:VKIMSessionError
                               userInfo:@{NSLocalizedDescriptionKey:@"Session not found"}];
    }
    else if ([self.code isEqualToString:XMPPAuthError]){
        return [NSError errorWithDomain:VKIMErrorDomain
                                   code:VKIMSessionAuthError
                               userInfo:@{NSLocalizedDescriptionKey:@"Wrong session authorization data"}];
    }
    else if ([self.code isEqualToString:XMPPServiceParametersError]){
        return [NSError errorWithDomain:VKIMErrorDomain
                                   code:VKIMRequestParametersError
                               userInfo:@{NSLocalizedDescriptionKey:@"Wrong or empty request parameters"}];
    }
    else{
        return [NSError errorWithDomain:VKIMErrorDomain
                                   code:VKIMUnknownServerError
                               userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"Unknown server error %@",self.code]}];
    }
}

+ (NSError *) sessionError{
    VKIMErrorData *error = [[[self class] alloc] init];
    error.code = XMPPSessionError;
    return [error makeError];
}
@end
