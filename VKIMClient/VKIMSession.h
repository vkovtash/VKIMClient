//
//  VKIMSession.h
//  VKIMClient
//
//  Created by Vlad Kovtash (v.kovtash@gmail.com) on 22.04.13.
//  Copyright (c) 2013 Vlad Kovtash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VKIMSessionErrorFactory.h"
#import "VKIMSessionStateAbstract.h"

@interface VKIMSession : NSObject
@property (readonly,nonatomic) VKIMAbstractOperationFactory *operationFactory;
@property (readonly,nonatomic) VKIMSessionStateCode stateCode;
@property (readonly,nonatomic) NSOperationQueue *defaultQueue;
@property (readonly,nonatomic) NSString *jid;
@property (readonly,nonatomic) NSString *token;
@property (readonly,nonatomic) NSString *sessionID;

- (void) setData:(VKIMSessionData *) sessionData;
- (VKIMSessionData *) data;

- (void) startWithJID:(NSString *) jid
             Password:(NSString *) password
               Server:(NSString *) server
            pushToken:(NSString *) pushToken
              Success:(void(^)()) successBlock
              Failure:(void(^)(NSError *error)) failureBlock;

- (void) restoreWithID:(NSString *) sesionID
                 token:(NSString *) token
               Success:(void(^)()) successBlock
               Failure:(void(^)(NSError *error)) failureBlock;

- (void) closeWithSuccess:(void(^)()) successBlock
                  Failure:(void(^)(NSError *error)) failureBlock;

- (void) getSessionDataWithSuccess:(void(^)(VKIMSessionData *session)) successBlock
                           Failure:(void(^)(NSError *error)) failureBlock
                           inQueue:(NSOperationQueue *) queue;

- (void) getContactsWithOffset:(NSUInteger) offset
                       Success:(void(^)(NSArray *contacts)) successBlock
                       Failure:(void(^)(NSError *error)) failureBlock
                       inQueue:(NSOperationQueue *) queue;

- (void) getMessagesWithOffset:(NSUInteger) offset
                       Success:(void(^)(NSArray *messages)) successBlock
                       Failure:(void(^)(NSError *error)) failureBlock
                       inQueue:(NSOperationQueue *) queue;

- (void) getFeedWithOffset:(NSUInteger) offset
                   Success:(void(^)(NSDictionary *feed)) successBlock
                   Failure:(void(^)(NSError *error)) failureBlock
                   inQueue:(NSOperationQueue *) queue;

- (void) pollFeedWithOffset:(NSUInteger) offset
                    Success:(void(^)(NSDictionary *feed)) successBlock
                    Failure:(void(^)(NSError *error)) failureBlock
                    inQueue:(NSOperationQueue *) queue;

- (void) sendMessage:(VKIMMessageData *) message
         WithSuccess:(void(^)(NSArray *messages)) successBlock
             Failure:(void(^)(VKIMMessageData *message, NSError *error)) failureBlock
             inQueue:(NSOperationQueue *) queue;

- (void) updateContactData:(VKIMContactData *) contactData
               WithSuccess:(void(^)(VKIMContactData *contactData)) successBlock
                   Failure:(void(^)(VKIMContactData *contactData, NSError *error)) failureBlock
                   inQueue:(NSOperationQueue *) queue;

- (void) addContact:(VKIMContactData *) contactData
        WithSuccess:(void(^)(VKIMContactData *contactData)) successBlock
            Failure:(void(^)(VKIMContactData *contactData, NSError *error)) failureBlock
            inQueue:(NSOperationQueue *) queue;

- (void) deleteContact:(VKIMContactData *) contactData
           WithSuccess:(void(^)(VKIMContactData *contactData)) successBlock
               Failure:(void(^)(VKIMContactData *contactData, NSError *error)) failureBlock
               inQueue:(NSOperationQueue *) queue;

- (void) getSessionDataWithSuccess:(void(^)(VKIMSessionData *session)) successBlock
                           Failure:(void(^)(NSError *error)) failureBlock;

- (void) getContactsWithOffset:(NSUInteger) offset
                       Success:(void(^)(NSArray *contacts)) successBlock
                       Failure:(void(^)(NSError *error)) failureBlock;

- (void) getMessagesWithOffset:(NSUInteger) offset
                       Success:(void(^)(NSArray *messages)) successBlock
                       Failure:(void(^)(NSError *error)) failureBlock;

- (void) getFeedWithOffset:(NSUInteger) offset
                   Success:(void(^)(NSDictionary *feed)) successBlock
                   Failure:(void(^)(NSError *error)) failureBlock;

- (void) pollFeedWithOffset:(NSUInteger) offset
                    Success:(void(^)(NSDictionary *feed)) successBlock
                    Failure:(void(^)(NSError *error)) failureBlock;

- (void) sendMessage:(VKIMMessageData *) message
         WithSuccess:(void(^)(NSArray *messages)) successBlock
             Failure:(void(^)(VKIMMessageData *message, NSError *error)) failureBlock;

- (void) updateContactData:(VKIMContactData *) contactData
               WithSuccess:(void(^)(VKIMContactData *contactData)) successBlock
                   Failure:(void(^)(VKIMContactData *contactData, NSError *error)) failureBlock;

- (void) addContact:(VKIMContactData *) contactData
        WithSuccess:(void(^)(VKIMContactData *contactData)) successBlock
            Failure:(void(^)(VKIMContactData *contactData, NSError *error)) failureBlock;

- (void) deleteContact:(VKIMContactData *) contactData
           WithSuccess:(void(^)(VKIMContactData *contactData)) successBlock
               Failure:(void(^)(VKIMContactData *contactData, NSError *error)) failureBlock;

- (void) applySessionState:(VKIMSessionStateCode) stateCode;

- (id) initWithOperationsFactory:(VKIMAbstractOperationFactory *) operationsFactory;
@end
