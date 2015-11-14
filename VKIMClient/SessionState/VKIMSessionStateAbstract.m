//
//  VKIMSessionStateAbstract.m
//  SecurIM
//
//  Created by kovtash on 22.04.13.
//  Copyright (c) 2013 Vlad Kovtash. All rights reserved.
//

#import "VKIMSessionStateAbstract.h"
#import "VKIMSessionErrorFactory.h"

@implementation VKIMSessionStateAbstract

- (NSOperation *)startWithJID:(NSString *)jid
                      Password:(NSString *)password
                        Server:(NSString *)server
                     pushToken:(NSString *)pushToken
                       Success:(void(^)(VKIMSessionData *session))successBlock
                       Failure:(void(^)(NSError *error))failureBlock {
    failureBlock([VKIMSessionErrorFactory operationIsNotPermittedInCurentState]);
    return nil;
}

- (NSOperation *)restoreWithID:(NSString *)sesionID
                         token:(NSString *)token
                       Success:(void(^)(VKIMSessionData *session))successBlock
                       Failure:(void(^)(NSError *error))failureBlock
                       inQueue:(NSOperationQueue *)queue {
    failureBlock([VKIMSessionErrorFactory operationIsNotPermittedInCurentState]);
}

- (NSOperation *)getSessionData:(VKIMSessionData *)session
                    WithSuccess:(void(^)(VKIMSessionData *session))successBlock
                        Failure:(void(^)(NSError *error))failureBlock
                        inQueue:(NSOperationQueue *)queue {
    failureBlock([VKIMSessionErrorFactory operationIsNotPermittedInCurentState]);
    return nil;
}

- (NSOperation *)close:(VKIMSessionData *)session
            WithSuccess:(void(^)(VKIMSessionData *session))successBlock
                Failure:(void(^)(NSError *error))failureBlock {
    failureBlock([VKIMSessionErrorFactory operationIsNotPermittedInCurentState]);
    return nil;
}

- (NSOperation *)getContactsData:(VKIMSessionData *)session
                      WithOffset:(NSUInteger)offset
                         Success:(void(^)(NSArray *contacts))successBlock
                         Failure:(void(^)(NSError *error))failureBlock
                         inQueue:(NSOperationQueue *)queue {
    failureBlock([VKIMSessionErrorFactory operationIsNotPermittedInCurentState]);
    return nil;
}

- (NSOperation *)getMessages:(VKIMSessionData *)session
                  WithOffset:(NSUInteger)offset
                     Success:(void(^)(NSArray *messages))successBlock
                     Failure:(void(^)(NSError *error))failureBlock
                     inQueue:(NSOperationQueue *)queue {
    failureBlock([VKIMSessionErrorFactory operationIsNotPermittedInCurentState]);
    return nil;
}

- (NSOperation *)getFeed:(VKIMSessionData *)session
              WithOffset:(NSUInteger)offset
                 Success:(void(^)(NSDictionary *feed))successBlock
                 Failure:(void(^)(NSError *error))failureBlock
                 inQueue:(NSOperationQueue *)queue {
    failureBlock([VKIMSessionErrorFactory operationIsNotPermittedInCurentState]);
    return nil;
}

- (NSOperation *)pollFeed:(VKIMSessionData *)session
               WithOffset:(NSUInteger)offset
                  Success:(void(^)(NSDictionary *feed))successBlock
                  Failure:(void(^)(NSError *error))failureBlock
                  inQueue:(NSOperationQueue *)queue {
    failureBlock([VKIMSessionErrorFactory operationIsNotPermittedInCurentState]);
    return nil;
}

- (NSOperation *)sendMessage:(VKIMMessageData *)message
                  WithSuccess:(void(^)(NSArray *messages))successBlock
                      Failure:(void(^)(VKIMMessageData *message, NSError *error))failureBlock
                      inQueue:(NSOperationQueue *)queue {
    failureBlock(message, [VKIMSessionErrorFactory operationIsNotPermittedInCurentState]);
    return nil;
}

- (NSOperation *)updateContactData:(VKIMContactData *)contactData
                       WithSuccess:(void(^)(VKIMContactData *contactData))successBlock
                           Failure:(void(^)(VKIMContactData *contactData, NSError *error))failureBlock
                           inQueue:(NSOperationQueue *)queue {
    failureBlock(contactData, [VKIMSessionErrorFactory operationIsNotPermittedInCurentState]);
    return nil;
}

- (NSOperation *)addContact:(VKIMContactData *)contactData
        WithSuccess:(void(^)(VKIMContactData *contactData))successBlock
            Failure:(void(^)(VKIMContactData *contactData, NSError *error))failureBlock
            inQueue:(NSOperationQueue *)queue {
    failureBlock(contactData, [VKIMSessionErrorFactory operationIsNotPermittedInCurentState]);
    return nil;
}

- (NSOperation *)deleteContact:(VKIMContactData *)contactData
                   WithSuccess:(void(^)(VKIMContactData *contactData))successBlock
                       Failure:(void(^)(VKIMContactData *contactData, NSError *error))failureBlock
                       inQueue:(NSOperationQueue *)queue {
    failureBlock(contactData, [VKIMSessionErrorFactory operationIsNotPermittedInCurentState]);
    return nil;
}

- (NSOperation *)updateMucData:(VKIMMucData *)mucData
                   WithSuccess:(void(^)(VKIMMucData *mucData))successBlock
                       Failure:(void(^)(VKIMMucData *mucData, NSError *error))failureBlock
                       inQueue:(NSOperationQueue *)queue {
    failureBlock(mucData,[VKIMSessionErrorFactory operationIsNotPermittedInCurentState]);
    return nil;
}

- (NSOperation *)addMuc:(VKIMMucData *)mucData
    WithSuccess:(void(^)(VKIMMucData *mucData))successBlock
        Failure:(void(^)(VKIMMucData *mucData, NSError *error))failureBlock
        inQueue:(NSOperationQueue *)queue {
    failureBlock(mucData, [VKIMSessionErrorFactory operationIsNotPermittedInCurentState]);
    return nil;
}

- (NSOperation *)deleteMuc:(VKIMMucData *)mucData
               WithSuccess:(void(^)(VKIMMucData *mucData))successBlock
                   Failure:(void(^)(VKIMMucData *mucData, NSError *error))failureBlock
                   inQueue:(NSOperationQueue *)queue {
    failureBlock(mucData, [VKIMSessionErrorFactory operationIsNotPermittedInCurentState]);
    return nil;
}

- (instancetype)initWithStateCode:(VKIMSessionStateCode)stateCode
                 OperationFactory:(VKIMAbstractOperationFactory *)operationFactory {
    self = [super init];
    if (self) {
        _operationFactory = operationFactory;
        _stateCode = stateCode;
    }
    return self;
}

@end
