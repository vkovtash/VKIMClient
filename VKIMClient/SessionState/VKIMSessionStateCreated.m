//
//  VKIMSessionStateCreated.m
//  SecurIM
//
//  Created by kovtash on 22.04.13.
//  Copyright (c) 2013 unact. All rights reserved.
//

#import "VKIMSessionStateCreated.h"

@implementation VKIMSessionStateCreated

- (void) startWithJID:(NSString *) jid
             Password:(NSString *) password
               Server:(NSString *) server
            pushToken:(NSString *) pushToken
              Success:(void(^)(VKIMSessionData *session)) successBlock
              Failure:(void(^)(NSError *error)) failureBlock{

    NSOperation *operation = [self.operationFactory
                          sessionStartOperationWithJID:jid
                          Password:password
                          Server:server
                          pushToken:pushToken
                          Success:successBlock
                          Failure:failureBlock];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [operation start];
    });
}

- (void) restoreWithID:(NSString *) sessionID
                 token:(NSString *) token
               Success:(void(^)(VKIMSessionData *session)) successBlock
               Failure:(void(^)(NSError *error)) failureBlock
               inQueue:(NSOperationQueue *) queue;{
    VKIMSessionData *session = [[VKIMSessionData alloc] init];
    session.sessionID = sessionID;
    session.token = token;
    
    NSOperation *operation = [self.operationFactory
                              sessionGetOperation:session
                              WithSuccess:^(VKIMSessionData *restoredSession){
                                  restoredSession.token = session.token;
                                  successBlock ? successBlock(restoredSession) : nil;
                              }
                              Failure:^(VKIMSessionData *sessionData, NSError *error){
                                  failureBlock ? failureBlock(error) : nil;
                              }];
    [queue addOperation:operation];
}

@end
