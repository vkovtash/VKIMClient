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

- (void) startWithJID:(NSString *) jid
             Password:(NSString *) password
               Server:(NSString *) server
            pushToken:(NSString *) pushToken
              Success:(void(^)(VKIMSessionData *session)) successBlock
              Failure:(void(^)(NSError *error)) failureBlock;

- (void) restoreWithID:(NSString *) sesionID
                 token:(NSString *) token
               Success:(void(^)(VKIMSessionData *session)) successBlock
               Failure:(void(^)(NSError *error)) failureBlock
               inQueue:(NSOperationQueue *) queue;

- (void) getSessionData:(VKIMSessionData *) session
            WithSuccess:(void(^)(VKIMSessionData *session)) successBlock
                Failure:(void(^)(NSError *error)) failureBlock
                inQueue:(NSOperationQueue *) queue;

- (void) close:(VKIMSessionData *) session
   WithSuccess:(void(^)(VKIMSessionData *session)) successBlock
       Failure:(void(^)(NSError *error)) failureBlock;

- (void) getContactsData:(VKIMSessionData *) session
              WithOffset:(NSUInteger) offset
                 Success:(void(^)(NSArray *contacts)) successBlock
                 Failure:(void(^)(NSError *error)) failureBlock
                 inQueue:(NSOperationQueue *) queue;

- (void) getMessages:(VKIMSessionData *) session
          WithOffset:(NSUInteger) offset
             Success:(void(^)(NSArray *messages)) successBlock
             Failure:(void(^)(NSError *error)) failureBlock
             inQueue:(NSOperationQueue *) queue;

- (void) getFeed:(VKIMSessionData *) session
      WithOffset:(NSUInteger) offset
         Success:(void(^)(NSDictionary *feed)) successBlock
         Failure:(void(^)(NSError *error)) failureBlock
         inQueue:(NSOperationQueue *) queue;

- (void) pollFeed:(VKIMSessionData *) session
       WithOffset:(NSUInteger) offset
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

- (void) updateMucData:(VKIMMucData *) mucData
           WithSuccess:(void(^)(VKIMMucData *mucData)) successBlock
               Failure:(void(^)(VKIMMucData *mucData, NSError *error)) failureBlock
               inQueue:(NSOperationQueue *) queue;

- (void) addMuc:(VKIMMucData *) mucData
    WithSuccess:(void(^)(VKIMMucData *mucData)) successBlock
        Failure:(void(^)(VKIMMucData *mucData, NSError *error)) failureBlock
        inQueue:(NSOperationQueue *) queue;

- (void) deleteMuc:(VKIMMucData *) mucData
       WithSuccess:(void(^)(VKIMMucData *mucData)) successBlock
           Failure:(void(^)(VKIMMucData *mucData, NSError *error)) failureBlock
           inQueue:(NSOperationQueue *) queue;


- (id) initWithStateCode:(VKIMSessionStateCode) stateCode OperationFactory:(VKIMAbstractOperationFactory *) operationFactory;
@end
