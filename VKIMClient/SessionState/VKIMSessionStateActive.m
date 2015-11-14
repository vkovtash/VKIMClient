//
//  VKIMSessionStateActive.m
//  SecurIM
//
//  Created by kovtash on 22.04.13.
//  Copyright (c) 2013 Vlad Kovtash. All rights reserved.
//

#import "VKIMSessionStateActive.h"
#import "NSString+Emoji.h"

@implementation VKIMSessionStateActive

- (NSOperation *)close:(VKIMSessionData *)session
           WithSuccess:(void(^)(VKIMSessionData *session))successBlock
               Failure:(void(^)(NSError *error))failureBlock {
    NSOperation *operation =
        [self.operationFactory sessionDeleteOperation:session
                                          WithSuccess:successBlock
                                              Failure:^(VKIMSessionData *session, NSError * error)
    {
        failureBlock ? failureBlock(error) : nil;
    }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [operation start];
    });
    return operation;
}

- (NSOperation *)getSessionData:(VKIMSessionData *)session
            WithSuccess:(void(^)(VKIMSessionData *session))successBlock
                Failure:(void(^)(NSError *error))failureBlock
                inQueue:(NSOperationQueue *)queue {
    NSOperation *operation =
        [self.operationFactory sessionGetOperation:session
                                       WithSuccess:successBlock
                                           Failure:^(VKIMSessionData *session, NSError *error)
    {
        failureBlock(error);
    }];
    
    [queue addOperation:operation];
    return operation;
}

- (NSOperation *)getContactsData:(VKIMSessionData *)session
                      WithOffset:(NSUInteger)offset
                         Success:(void(^)(NSArray *contacts))successBlock
                         Failure:(void(^)(NSError *error))failureBlock
                         inQueue:(NSOperationQueue *)queue {
    NSOperation *operation =
        [self.operationFactory sessionContactsGetOperation:session
                                                WithOffset:offset
                                                   Success:successBlock
                                                   Failure:^(VKIMSessionData *session, NSError *error)
    {
        failureBlock(error);
    }];
    
    [queue addOperation:operation];
    return operation;
}

- (NSOperation *)getMessages:(VKIMSessionData *)session
                  WithOffset:(NSUInteger)offset
                     Success:(void(^)(NSArray *messages))successBlock
                     Failure:(void(^)(NSError *error))failureBlock
                     inQueue:(NSOperationQueue *)queue {
    NSOperation *operation =
        [self.operationFactory sessionMessagesGetOperation:session WithOffset:offset Success:^(NSArray *messages) {
            [self processInboundMessages:messages];
            successBlock(messages);
        } Failure:^(VKIMSessionData *session, NSError *error){
            failureBlock(error);
        }];
    
    [queue addOperation:operation];
    return operation;
}

- (NSOperation *)getFeed:(VKIMSessionData *)session
              WithOffset:(NSUInteger)offset
                 Success:(void(^)(NSDictionary *feed))successBlock
                 Failure:(void(^)(NSError *error))failureBlock
                 inQueue:(NSOperationQueue *)queue {
    NSOperation *operation =
        [self.operationFactory sessionFeedGetOperation:session WithOffset:offset Success:^(NSDictionary *feed) {
            [self processInboundMessages:[feed objectForKey:VKIMResponseMultipleMessagesKey]];
            successBlock(feed);
        } Failure:^(VKIMSessionData *session, NSError *error) {
            failureBlock(error);
        }];
    
    [queue addOperation:operation];
    return operation;
}

- (NSOperation *)pollFeed:(VKIMSessionData *)session
               WithOffset:(NSUInteger) offset
                  Success:(void(^)(NSDictionary *feed))successBlock
                  Failure:(void(^)(NSError *error))failureBlock
                  inQueue:(NSOperationQueue *)queue {
    NSOperation *operation =
        [self.operationFactory sessionFeedPollOperation:session WithOffset:offset Success:^(NSDictionary *feed) {
            [self processInboundMessages:[feed objectForKey:VKIMResponseMultipleMessagesKey]];
            successBlock(feed);
        } Failure:^(VKIMSessionData *session, NSError *error) {
            failureBlock(error);
        }];
    
    [queue addOperation:operation];
    return operation;
}

- (NSOperation *)sendMessage:(VKIMMessageData *)message
                 WithSuccess:(void(^)(NSArray *messages))successBlock
                     Failure:(void(^)(VKIMMessageData *message, NSError *error))failureBlock
                     inQueue:(NSOperationQueue *)queue {
    VKIMMessageData *processedMessage = [message copy];
    [self processOutboundMessage:processedMessage];
    
    NSOperation *operation =
        [self.operationFactory messageSendOperation:processedMessage WithSuccess:^(NSArray *messages) {
            [self processInboundMessages:messages];
            successBlock(messages);
        } Failure:failureBlock];
    
    [queue addOperation:operation];
    return operation;
}

- (NSOperation *)updateContactData:(VKIMContactData *)contactData
               WithSuccess:(void(^)(VKIMContactData *contactData))successBlock
                   Failure:(void(^)(VKIMContactData *contactData, NSError *error))failureBlock
                   inQueue:(NSOperationQueue *)queue {
    NSOperation *operation =
        [self.operationFactory contactUpdateOperation:contactData WithSuccess:successBlock Failure:failureBlock];
    
    [queue addOperation:operation];
    return operation;
}

- (NSOperation *)addContact:(VKIMContactData *)contactData
                WithSuccess:(void(^)(VKIMContactData *contactData))successBlock
                    Failure:(void(^)(VKIMContactData *contactData, NSError *error))failureBlock
                    inQueue:(NSOperationQueue *)queue {
    NSOperation *operation =
        [self.operationFactory contactAddOperation:contactData WithSuccess:successBlock Failure:failureBlock];
    
    [queue addOperation:operation];
    return operation;
}

- (NSOperation *)deleteContact:(VKIMContactData *)contactData
                   WithSuccess:(void(^)(VKIMContactData *contactData))successBlock
                       Failure:(void(^)(VKIMContactData *contactData, NSError *error))failureBlock
                       inQueue:(NSOperationQueue *)queue {
    NSOperation *operation =
        [self.operationFactory contactDeleteOperation:contactData WithSuccess:successBlock Failure:failureBlock];
    
    [queue addOperation:operation];
    return operation;
}

- (NSOperation *)updateMucData:(VKIMMucData *)mucData
                   WithSuccess:(void(^)(VKIMMucData *mucData))successBlock
                       Failure:(void(^)(VKIMMucData *mucData, NSError *error))failureBlock
                       inQueue:(NSOperationQueue *)queue {
    NSOperation *operation =
        [self.operationFactory mucUpdateOperation:mucData WithSuccess:successBlock Failure:failureBlock];
    
    [queue addOperation:operation];
    return operation;
}

- (NSOperation *)addMuc:(VKIMMucData *)mucData
            WithSuccess:(void(^)(VKIMMucData *mucData))successBlock
                Failure:(void(^)(VKIMMucData *mucData, NSError *error))failureBlock
                inQueue:(NSOperationQueue *)queue {
    NSOperation *operation =
        [self.operationFactory mucCreateOperation:mucData WithSuccess:successBlock Failure:failureBlock];
    
    [queue addOperation:operation];
    return operation;
}

- (NSOperation *)deleteMuc:(VKIMMucData *)mucData
               WithSuccess:(void(^)(VKIMMucData *mucData))successBlock
                   Failure:(void(^)(VKIMMucData *mucData, NSError *error))failureBlock
                   inQueue:(NSOperationQueue *)queue {
    NSOperation *operation =
        [self.operationFactory mucDeleteOperation:mucData WithSuccess:successBlock Failure:failureBlock];
    
    [queue addOperation:operation];
    return operation;
}

#pragma mark - PrivateMethods

- (void)processInboundMessages:(NSArray *)messages {
    for (VKIMMessageData *message in messages) {
        [self processInboudMessage:message];
    }
}

- (void)processInboudMessage:(VKIMMessageData *)message {
    message.text = [message.text stringByReplacingEmojiCheatCodesWithUnicode];
}

- (void)processOutboundMessage:(VKIMMessageData *)message {
    message.text = [message.text stringByReplacingEmojiUnicodeWithCheatCodes];
}

@end
