//
//  VKIMSessionStateAbstract.m
//  SecurIM
//
//  Created by kovtash on 22.04.13.
//  Copyright (c) 2013 unact. All rights reserved.
//

#import "VKIMSessionStateAbstract.h"
#import "VKIMSessionErrorFactory.h"

@implementation VKIMSessionStateAbstract
- (void) startWithJID:(NSString *) jid
                      Password:(NSString *) password
                        Server:(NSString *) server
                     pushToken:(NSString *) pushToken
                       Success:(void(^)(VKIMSessionData *session)) successBlock
                       Failure:(void(^)(NSError *error)) failureBlock{
    failureBlock([VKIMSessionErrorFactory operationIsNotPermittedInCurentState]);
}

- (void) restoreWithID:(NSString *) sesionID
                 token:(NSString *) token
               Success:(void(^)(VKIMSessionData *session)) successBlock
               Failure:(void(^)(NSError *error)) failureBlock
               inQueue:(NSOperationQueue *) queue;{
    failureBlock([VKIMSessionErrorFactory operationIsNotPermittedInCurentState]);
}

- (void) getSessionData:(VKIMSessionData *) session
                     WithSuccess:(void(^)(VKIMSessionData *session)) successBlock
                         Failure:(void(^)(NSError *error)) failureBlock
                         inQueue:(NSOperationQueue *) queue{
    failureBlock([VKIMSessionErrorFactory operationIsNotPermittedInCurentState]);
}

- (void) close:(VKIMSessionData *) session
            WithSuccess:(void(^)(VKIMSessionData *session)) successBlock
                Failure:(void(^)(NSError *error)) failureBlock{
    failureBlock([VKIMSessionErrorFactory operationIsNotPermittedInCurentState]);
}

- (void) getContactsData:(VKIMSessionData *) session
                       WithOffset:(NSUInteger) offset
                          Success:(void(^)(NSArray *contacts)) successBlock
                          Failure:(void(^)(NSError *error)) failureBlock
                          inQueue:(NSOperationQueue *) queue{
    failureBlock([VKIMSessionErrorFactory operationIsNotPermittedInCurentState]);
}

- (void) getMessages:(VKIMSessionData *) session
                   WithOffset:(NSUInteger) offset
                      Success:(void(^)(NSArray *messages)) successBlock
                      Failure:(void(^)(NSError *error)) failureBlock
                      inQueue:(NSOperationQueue *) queue{
    failureBlock([VKIMSessionErrorFactory operationIsNotPermittedInCurentState]);
}

- (void) getFeed:(VKIMSessionData *) session
               WithOffset:(NSUInteger) offset
                  Success:(void(^)(NSDictionary *feed)) successBlock
                  Failure:(void(^)(NSError *error)) failureBlock
                  inQueue:(NSOperationQueue *) queue{
    failureBlock([VKIMSessionErrorFactory operationIsNotPermittedInCurentState]);
}

- (void) pollFeed:(VKIMSessionData *) session
       WithOffset:(NSUInteger) offset
          Success:(void(^)(NSDictionary *feed)) successBlock
          Failure:(void(^)(NSError *error)) failureBlock
          inQueue:(NSOperationQueue *) queue{
    failureBlock([VKIMSessionErrorFactory operationIsNotPermittedInCurentState]);
}

- (void) sendMessage:(VKIMMessageData *) message
                  WithSuccess:(void(^)(NSArray *messages)) successBlock
                      Failure:(void(^)(VKIMMessageData *message, NSError *error)) failureBlock
                      inQueue:(NSOperationQueue *) queue{
    failureBlock(message,[VKIMSessionErrorFactory operationIsNotPermittedInCurentState]);
}

- (void) updateContactData:(VKIMContactData *) contactData
               WithSuccess:(void(^)(VKIMContactData *contactData)) successBlock
                   Failure:(void(^)(VKIMContactData *contactData, NSError *error)) failureBlock
                   inQueue:(NSOperationQueue *) queue{
    failureBlock(contactData,[VKIMSessionErrorFactory operationIsNotPermittedInCurentState]);
}

- (void) addContact:(VKIMContactData *) contactData
        WithSuccess:(void(^)(VKIMContactData *contactData)) successBlock
            Failure:(void(^)(VKIMContactData *contactData, NSError *error)) failureBlock
            inQueue:(NSOperationQueue *) queue{
    failureBlock(contactData,[VKIMSessionErrorFactory operationIsNotPermittedInCurentState]);
}

- (void) deleteContact:(VKIMContactData *) contactData
           WithSuccess:(void(^)(VKIMContactData *contactData)) successBlock
               Failure:(void(^)(VKIMContactData *contactData, NSError *error)) failureBlock
               inQueue:(NSOperationQueue *) queue{
    failureBlock(contactData,[VKIMSessionErrorFactory operationIsNotPermittedInCurentState]);
}

- (id) initWithStateCode:(VKIMSessionStateCode) stateCode OperationFactory:(VKIMAbstractOperationFactory *) operationFactory{
    self = [super init];
    if (self) {
        _operationFactory = operationFactory;
        _stateCode = stateCode;
    }
    return self;
}
@end
