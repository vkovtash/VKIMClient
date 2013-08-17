//
//  VKIMAbstractOperationFactory.h
//  VKIMClient
//
//  Created by Vlad Kovtash (v.kovtash@gmail.com) on 10.04.13.
//  Copyright (c) 2013 Vlad Kovtash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VKIMSessionData.h"
#import "VKIMContactData.h"
#import "VKIMMessageData.h"
#import "VKIMErrorData.h"

extern NSString *const VKIMResponseSessionKey;
extern NSString *const VKIMResponseMultipleMessagesKey;
extern NSString *const VKIMResponseMultipleContactsKey;
extern NSString *const VKIMResponseContactKey;
extern NSString *const VKIMResponseErrorKey;


@interface VKIMAbstractOperationFactory : NSObject
@property (readonly,nonatomic) NSURL *baseURL;
@property (readonly,nonatomic) NSString *clientID;

- (id) initWithBaseURL:(NSURL *) baseURL;


- (NSOperation *) sessionStartOperationWithJID:(NSString *) jid
                                      Password:(NSString *) password
                                        Server:(NSString *) server
                                     pushToken:(NSString *) pushToken
                                       Success:(void(^)(VKIMSessionData *session)) successBlock
                                       Failure:(void(^)(NSError *error)) failureBlock;

- (NSOperation *) sessionGetOperation:(VKIMSessionData *) session
                          WithSuccess:(void(^)(VKIMSessionData *session)) successBlock
                              Failure:(void(^)(VKIMSessionData *session, NSError *error)) failureBlock;

- (NSOperation *) sessionDeleteOperation:(VKIMSessionData *) session
                             WithSuccess:(void(^)(VKIMSessionData *session)) successBlock
                                 Failure:(void(^)(VKIMSessionData *session, NSError *error)) failureBlock;

- (NSOperation *) sessionContactsGetOperation:(VKIMSessionData *) session
                                   WithOffset:(NSUInteger) offset
                                      Success:(void(^)(NSArray *contacts)) successBlock
                                      Failure:(void(^)(VKIMSessionData *session, NSError *error)) failureBlock;

- (NSOperation *) sessionMessagesGetOperation:(VKIMSessionData *) session
                                   WithOffset:(NSUInteger) offset
                                      Success:(void(^)(NSArray *messages)) successBlock
                                      Failure:(void(^)(VKIMSessionData *session, NSError *error)) failureBlock;

- (NSOperation *) sessionFeedGetOperation:(VKIMSessionData *) session
                               WithOffset:(NSUInteger) offset
                                  Success:(void(^)(NSDictionary *feed)) successBlock
                                  Failure:(void(^)(VKIMSessionData *session, NSError *error)) failureBlock;

- (NSOperation *) sessionFeedPollOperation:(VKIMSessionData *) session
                                WithOffset:(NSUInteger) offset
                                   Success:(void(^)(NSDictionary *feed)) successBlock
                                   Failure:(void(^)(VKIMSessionData *session, NSError *error)) failureBlock;

- (NSOperation *) contactMessagesGetOperation:(VKIMContactData *) contact
                                  WithSuccess:(void(^)(NSArray *messages)) successBlock
                                      Failure:(void(^)(VKIMContactData *contact, NSError *error)) failureBlock;

- (NSOperation *) contactUpdateOperation:(VKIMContactData *) contact
                             WithSuccess:(void(^)(VKIMContactData *contactData)) successBlock
                                 Failure:(void(^)(VKIMContactData *contact, NSError *error)) failureBlock;

- (NSOperation *) contactAddOperation:(VKIMContactData *) contact
                          WithSuccess:(void(^)(VKIMContactData *contactData)) successBlock
                              Failure:(void(^)(VKIMContactData *contact, NSError *error)) failureBlock;

- (NSOperation *) contactDeleteOperation:(VKIMContactData *) contact
                             WithSuccess:(void(^)(VKIMContactData *contactData)) successBlock
                                 Failure:(void(^)(VKIMContactData *contact, NSError *error)) failureBlock;

- (NSOperation *) messageSendOperation:(VKIMMessageData *) message
                           WithSuccess:(void(^)(NSArray *messages)) successBlock
                               Failure:(void(^)(VKIMMessageData *message, NSError *error)) failureBlock;
@end
