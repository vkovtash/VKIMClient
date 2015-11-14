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
@property (readonly, nonatomic) VKIMAbstractOperationFactory *operationFactory;
@property (readonly, nonatomic) VKIMSessionStateCode stateCode;
@property (readonly, nonatomic) NSOperationQueue *defaultQueue;
@property (readonly, nonatomic) NSString *jid;
@property (readonly, nonatomic) NSString *token;
@property (readonly, nonatomic) NSString *sessionID;

- (void)setData:(VKIMSessionData *)sessionData;
- (VKIMSessionData *)data;

- (NSOperation *)startWithJID:(NSString *)jid
                     Password:(NSString *)password
                       Server:(NSString *)server
                    pushToken:(NSString *)pushToken
                      Success:(void(^)())successBlock
                      Failure:(void(^)(NSError *error))failureBlock;

- (NSOperation *)restoreWithID:(NSString *)sesionID
                         token:(NSString *)token
                       Success:(void(^)())successBlock
                       Failure:(void(^)(NSError *error))failureBlock;

- (NSOperation *)closeWithSuccess:(void(^)())successBlock
                          Failure:(void(^)(NSError *error))failureBlock;

- (NSOperation *)getSessionDataWithSuccess:(void(^)(VKIMSessionData *session))successBlock
                                   Failure:(void(^)(NSError *error))failureBlock
                                   inQueue:(NSOperationQueue *)queue;

- (NSOperation *)getContactsWithOffset:(NSUInteger)offset
                               Success:(void(^)(NSArray *contacts))successBlock
                               Failure:(void(^)(NSError *error))failureBlock
                               inQueue:(NSOperationQueue *)queue;

- (NSOperation *)getMessagesWithOffset:(NSUInteger)offset
                               Success:(void(^)(NSArray *messages))successBlock
                               Failure:(void(^)(NSError *error))failureBlock
                               inQueue:(NSOperationQueue *)queue;

- (NSOperation *)getFeedWithOffset:(NSUInteger)offset
                           Success:(void(^)(NSDictionary *feed))successBlock
                           Failure:(void(^)(NSError *error))failureBlock
                           inQueue:(NSOperationQueue *)queue;

- (NSOperation *)pollFeedWithOffset:(NSUInteger)offset
                            Success:(void(^)(NSDictionary *feed))successBlock
                            Failure:(void(^)(NSError *error))failureBlock
                            inQueue:(NSOperationQueue *)queue;

- (NSOperation *)sendMessage:(VKIMMessageData *)message
                 WithSuccess:(void(^)(NSArray *messages))successBlock
                     Failure:(void(^)(VKIMMessageData *message, NSError *error))failureBlock
                     inQueue:(NSOperationQueue *)queue;

- (NSOperation *)updateContactData:(VKIMContactData *)contactData
                       WithSuccess:(void(^)(VKIMContactData *contactData))successBlock
                           Failure:(void(^)(VKIMContactData *contactData, NSError *error))failureBlock
                           inQueue:(NSOperationQueue *)queue;

- (NSOperation *)addContact:(VKIMContactData *)contactData
                WithSuccess:(void(^)(VKIMContactData *contactData))successBlock
                    Failure:(void(^)(VKIMContactData *contactData, NSError *error))failureBlock
                    inQueue:(NSOperationQueue *)queue;

- (NSOperation *)deleteContact:(VKIMContactData *)contactData
                   WithSuccess:(void(^)(VKIMContactData *contactData))successBlock
                       Failure:(void(^)(VKIMContactData *contactData, NSError *error))failureBlock
                       inQueue:(NSOperationQueue *)queue;

- (NSOperation *)updateMucData:(VKIMMucData *)mucData
                   WithSuccess:(void(^)(VKIMMucData *mucData))successBlock
                       Failure:(void(^)(VKIMMucData *mucData, NSError *error))failureBlock
                       inQueue:(NSOperationQueue *)queue;

- (NSOperation *)addMuc:(VKIMMucData *)mucData
            WithSuccess:(void(^)(VKIMMucData *mucData))successBlock
                Failure:(void(^)(VKIMMucData *mucData, NSError *error))failureBlock
                inQueue:(NSOperationQueue *)queue;

- (NSOperation *)deleteMuc:(VKIMMucData *)mucData
               WithSuccess:(void(^)(VKIMMucData *mucData))successBlock
                   Failure:(void(^)(VKIMMucData *mucData, NSError *error))failureBlock
                   inQueue:(NSOperationQueue *)queue;

- (NSOperation *)getSessionDataWithSuccess:(void(^)(VKIMSessionData *session))successBlock
                                   Failure:(void(^)(NSError *error))failureBlock;

- (NSOperation *)getContactsWithOffset:(NSUInteger)offset
                               Success:(void(^)(NSArray *contacts))successBlock
                               Failure:(void(^)(NSError *error))failureBlock;

- (NSOperation *)getMessagesWithOffset:(NSUInteger)offset
                               Success:(void(^)(NSArray *messages))successBlock
                               Failure:(void(^)(NSError *error))failureBlock;

- (NSOperation *)getFeedWithOffset:(NSUInteger)offset
                           Success:(void(^)(NSDictionary *feed))successBlock
                           Failure:(void(^)(NSError *error))failureBlock;

- (NSOperation *)pollFeedWithOffset:(NSUInteger)offset
                            Success:(void(^)(NSDictionary *feed))successBlock
                            Failure:(void(^)(NSError *error))failureBlock;

- (NSOperation *)sendMessage:(VKIMMessageData *)message
                 WithSuccess:(void(^)(NSArray *messages))successBlock
                     Failure:(void(^)(VKIMMessageData *message, NSError *error))failureBlock;

- (NSOperation *)updateContactData:(VKIMContactData *)contactData
                       WithSuccess:(void(^)(VKIMContactData *contactData))successBlock
                           Failure:(void(^)(VKIMContactData *contactData, NSError *error))failureBlock;

- (NSOperation *)addContact:(VKIMContactData *)contactData
                WithSuccess:(void(^)(VKIMContactData *contactData))successBlock
                    Failure:(void(^)(VKIMContactData *contactData, NSError *error))failureBlock;

- (NSOperation *)deleteContact:(VKIMContactData *)contactData
                   WithSuccess:(void(^)(VKIMContactData *contactData))successBlock
                       Failure:(void(^)(VKIMContactData *contactData, NSError *error))failureBlock;

- (NSOperation *)updateMucData:(VKIMMucData *)mucData
                   WithSuccess:(void(^)(VKIMMucData *mucData))successBlock
                       Failure:(void(^)(VKIMMucData *mucData, NSError *error))failureBlock;

- (NSOperation *)addMuc:(VKIMMucData *)mucData
            WithSuccess:(void(^)(VKIMMucData *mucData))successBlock
                Failure:(void(^)(VKIMMucData *mucData, NSError *error))failureBlock;

- (NSOperation *)deleteMuc:(VKIMMucData *)mucData
               WithSuccess:(void(^)(VKIMMucData *mucData))successBlock
                   Failure:(void(^)(VKIMMucData *mucData, NSError *error))failureBlock;

- (void)applySessionState:(VKIMSessionStateCode)stateCode;

- (instancetype)initWithOperationsFactory:(VKIMAbstractOperationFactory *)operationsFactory;
@end
