//
//  VKIMSessionStateAbstract.h
//  SecurIM
//
//  Created by kovtash on 22.04.13.
//  Copyright (c) 2013 Vlad Kovtash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VKIMSessionData.h"
#import "VKIMMessageData.h"
#import "VKIMContactData.h"
#import "VKIMAbstractOperationFactory.h"

typedef enum VKIMSessionStateCode {
    VKIMSessionStateCreatedCode,
    VKIMSessionStateStartingCode,
    VKIMSessionStateActiveCode,
    VKIMSessionStateClosingCode,
    VKIMSessionStateClosedCode
} VKIMSessionStateCode;

@interface VKIMSessionStateAbstract : NSObject
@property (readonly,nonatomic) VKIMAbstractOperationFactory *operationFactory;
@property (readonly,nonatomic) VKIMSessionStateCode stateCode;

- (NSOperation *)startWithJID:(NSString *)jid
                     Password:(NSString *)password
                       Server:(NSString *)server
                    pushToken:(NSString *)pushToken
                      Success:(void(^)(VKIMSessionData *session))successBlock
                      Failure:(void(^)(NSError *error))failureBlock;

- (NSOperation *)restoreWithID:(NSString *)sesionID
                         token:(NSString *)token
                       Success:(void(^)(VKIMSessionData *session))successBlock
                       Failure:(void(^)(NSError *error))failureBlock
                       inQueue:(NSOperationQueue *)queue;

- (NSOperation *)getSessionData:(VKIMSessionData *)session
                    WithSuccess:(void(^)(VKIMSessionData *session))successBlock
                        Failure:(void(^)(NSError *error))failureBlock
                        inQueue:(NSOperationQueue *)queue;

- (NSOperation *)close:(VKIMSessionData *)session
           WithSuccess:(void(^)(VKIMSessionData *session))successBlock
               Failure:(void(^)(NSError *error))failureBlock;

- (NSOperation *)getContactsData:(VKIMSessionData *)session
              WithOffset:(NSUInteger)offset
                 Success:(void(^)(NSArray *contacts))successBlock
                 Failure:(void(^)(NSError *error))failureBlock
                 inQueue:(NSOperationQueue *)queue;

- (NSOperation *)getMessages:(VKIMSessionData *)session
                  WithOffset:(NSUInteger)offset
                     Success:(void(^)(NSArray *messages))successBlock
                     Failure:(void(^)(NSError *error))failureBlock
                     inQueue:(NSOperationQueue *)queue;

- (NSOperation *)getFeed:(VKIMSessionData *)session
              WithOffset:(NSUInteger)offset
                 Success:(void(^)(NSDictionary *feed))successBlock
                 Failure:(void(^)(NSError *error))failureBlock
                 inQueue:(NSOperationQueue *) queue;

- (NSOperation *)pollFeed:(VKIMSessionData *)session
               WithOffset:(NSUInteger)offset
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
                           inQueue:(NSOperationQueue *) queue;

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


- (instancetype)initWithStateCode:(VKIMSessionStateCode)stateCode
                 OperationFactory:(VKIMAbstractOperationFactory *)operationFactory;
@end
