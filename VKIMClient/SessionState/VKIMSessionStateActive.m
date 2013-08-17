//
//  VKIMSessionStateActive.m
//  SecurIM
//
//  Created by kovtash on 22.04.13.
//  Copyright (c) 2013 unact. All rights reserved.
//

#import "VKIMSessionStateActive.h"
#import "NSString+Emoji.h"

@implementation VKIMSessionStateActive

- (void) close:(VKIMSessionData *) session
   WithSuccess:(void(^)(VKIMSessionData *session)) successBlock
       Failure:(void(^)(NSError *error)) failureBlock{
    NSOperation *operation = [self.operationFactory
                              sessionDeleteOperation:session
                              WithSuccess:successBlock
                              Failure:^(VKIMSessionData *session, NSError * error){
                                  failureBlock ? failureBlock(error) : nil;
                              }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [operation start];
    });
}

- (void) getSessionData:(VKIMSessionData *) session
            WithSuccess:(void(^)(VKIMSessionData *session)) successBlock
                Failure:(void(^)(NSError *error)) failureBlock
                inQueue:(NSOperationQueue *) queue{
    NSOperation *operation = [self.operationFactory sessionGetOperation:session
                                                            WithSuccess:successBlock
                                                                Failure:^(VKIMSessionData *session, NSError *error){
                                                                    failureBlock(error);
                                                                }];
    [queue addOperation:operation];
}

- (void) getContactsData:(VKIMSessionData *) session
              WithOffset:(NSUInteger) offset
                 Success:(void(^)(NSArray *contacts)) successBlock
                 Failure:(void(^)(NSError *error)) failureBlock
                 inQueue:(NSOperationQueue *) queue{
    
    NSOperation *operation = [self.operationFactory sessionContactsGetOperation:session
                                                                     WithOffset:offset
                                                                        Success:successBlock
                                                                        Failure:^(VKIMSessionData *session, NSError *error){
                                                                            failureBlock(error);
                                                                        }];
    [queue addOperation:operation];
}

- (void) getMessages:(VKIMSessionData *) session
          WithOffset:(NSUInteger) offset
             Success:(void(^)(NSArray *messages)) successBlock
             Failure:(void(^)(NSError *error)) failureBlock
             inQueue:(NSOperationQueue *) queue{
    NSOperation *operation = [self.operationFactory
                              sessionMessagesGetOperation:session
                              WithOffset:offset
                              Success:^(NSArray *messages){
                                  [self processInboundMessages:messages];
                                  successBlock(messages);
                              }
                              Failure:^(VKIMSessionData *session, NSError *error){
                                  failureBlock(error);
                              }];
    [queue addOperation:operation];
}

- (void) getFeed:(VKIMSessionData *) session
      WithOffset:(NSUInteger) offset
         Success:(void(^)(NSDictionary *feed)) successBlock
         Failure:(void(^)(NSError *error)) failureBlock
         inQueue:(NSOperationQueue *) queue{
    NSOperation *operation = [self.operationFactory
                              sessionFeedGetOperation:session
                              WithOffset:offset
                              Success:^(NSDictionary *feed){
                                  [self processInboundMessages:[feed objectForKey:VKIMResponseMultipleMessagesKey]];
                                  successBlock(feed);
                              }
                              Failure:^(VKIMSessionData *session, NSError *error){
                                  failureBlock(error);
                              }];
    [queue addOperation:operation];
}

- (void) pollFeed:(VKIMSessionData *) session
       WithOffset:(NSUInteger) offset
          Success:(void(^)(NSDictionary *feed)) successBlock
          Failure:(void(^)(NSError *error)) failureBlock
          inQueue:(NSOperationQueue *) queue{
    NSOperation *operation = [self.operationFactory
                              sessionFeedPollOperation:session
                              WithOffset:offset
                              Success:^(NSDictionary *feed){
                                  [self processInboundMessages:[feed objectForKey:VKIMResponseMultipleMessagesKey]];
                                  successBlock(feed);
                              }
                              Failure:^(VKIMSessionData *session, NSError *error){
                                  failureBlock(error);
                              }];
    [queue addOperation:operation];
}

- (void) sendMessage:(VKIMMessageData *) message
         WithSuccess:(void(^)(NSArray *messages)) successBlock
             Failure:(void(^)(VKIMMessageData *message, NSError *error)) failureBlock
             inQueue:(NSOperationQueue *) queue{
    VKIMMessageData *processedMessage = [message copy];
    [self processOutboundMessage:processedMessage];
    NSOperation *operation = [self.operationFactory messageSendOperation:processedMessage
                                                             WithSuccess:^(NSArray *messages){
                                                                 [self processInboundMessages:messages];
                                                                 successBlock(messages);
                                                             }
                                                                 Failure:failureBlock];
    [queue addOperation:operation];
}

- (void) updateContactData:(VKIMContactData *) contactData
               WithSuccess:(void(^)(VKIMContactData *contactData)) successBlock
                   Failure:(void(^)(VKIMContactData *contactData, NSError *error)) failureBlock
                   inQueue:(NSOperationQueue *) queue;{
    NSOperation *operation = [self.operationFactory contactUpdateOperation:contactData
                                                               WithSuccess:successBlock
                                                                   Failure:failureBlock];
    
    [queue addOperation:operation];
}

- (void) addContact:(VKIMContactData *) contactData
        WithSuccess:(void(^)(VKIMContactData *contactData)) successBlock
            Failure:(void(^)(VKIMContactData *contactData, NSError *error)) failureBlock
            inQueue:(NSOperationQueue *) queue{
    NSOperation *operation = [self.operationFactory contactAddOperation:contactData
                                                               WithSuccess:successBlock
                                                                   Failure:failureBlock];
    
    [queue addOperation:operation];
}

- (void) deleteContact:(VKIMContactData *) contactData
           WithSuccess:(void(^)(VKIMContactData *contactData)) successBlock
               Failure:(void(^)(VKIMContactData *contactData, NSError *error)) failureBlock
               inQueue:(NSOperationQueue *) queue{
    NSOperation *operation = [self.operationFactory contactDeleteOperation:contactData
                                                            WithSuccess:successBlock
                                                                Failure:failureBlock];
    
    [queue addOperation:operation];
}

#pragma mark - PrivateMethods

- (void) processInboundMessages:(NSArray *) messages{
    for (VKIMMessageData *message in messages){
        [self processInboudMessage:message];
    }
}

- (void) processInboudMessage:(VKIMMessageData *)message{
    message.text = [message.text stringByReplacingEmojiCheatCodesWithUnicode];
}

- (void) processOutboundMessage:(VKIMMessageData *)message{
    message.text = [message.text stringByReplacingEmojiUnicodeWithCheatCodes];
}

@end
