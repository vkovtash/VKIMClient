//
//  VKIMAbstractOperationFactory.m
//  VKIMClient
//
//  Created by Vlad Kovtash (v.kovtash@gmail.com) on 10.04.13.
//  Copyright (c) 2013 Vlad Kovtash. All rights reserved.
//

#import "VKIMAbstractOperationFactory.h"

@implementation VKIMAbstractOperationFactory
@synthesize baseURL = _baseURL;

#pragma mark - Publick properties

- (NSURL *) baseURL{
    return _baseURL;
}

- (NSString *) clientID{
    NSString *clientID = nil;
    UIDevice *currentDevice = [UIDevice currentDevice];
    if ([currentDevice respondsToSelector:@selector(identifierForVendor)]){
        clientID = [currentDevice.identifierForVendor UUIDString];
    }
    return clientID;
}

#pragma mark - Init

- (id) initWithBaseURL:(NSURL *) baseURL{
    self = [self init];
    if (self) {
        _baseURL = baseURL;
    }
    return self;
}

#pragma mark - Factory methods

- (NSOperation *) sessionStartOperationWithJID:(NSString *) jid
                                      Password:(NSString *) password
                                        Server:(NSString *) server
                                     pushToken:(NSString *) pushToken
                                       Success:(void(^)(VKIMSessionData *session)) successBlock
                                       Failure:(void(^)(NSError *error)) failureBlock{
    return nil;
}

- (NSOperation *) sessionGetOperation:(VKIMSessionData *) session
                          WithSuccess:(void(^)(VKIMSessionData *session)) successBlock
                              Failure:(void(^)(VKIMSessionData *session, NSError *error)) failureBlock{
    return nil;
}

- (NSOperation *) sessionDeleteOperation:(VKIMSessionData *) session
                             WithSuccess:(void(^)(VKIMSessionData *session)) successBlock
                                 Failure:(void(^)(VKIMSessionData *session, NSError *error)) failureBlock{
    return nil;
}

- (NSOperation *) sessionContactsGetOperation:(VKIMSessionData *) session
                                   WithOffset:(NSUInteger) offset
                                      Success:(void(^)(NSArray *contacts)) successBlock
                                      Failure:(void(^)(VKIMSessionData *session, NSError *error)) failureBlock{
    return nil;
}

- (NSOperation *) sessionNotificationsGetOperation:(VKIMSessionData *) session
                                       WithSuccess:(void(^)()) successBlock
                                           Failure:(void(^)(VKIMSessionData *session, NSError *error)) failureBlock{
    return nil;
}

- (NSOperation *) sessionMessagesGetOperation:(VKIMSessionData *) session
                                   WithOffset:(NSUInteger) offset
                                      Success:(void(^)(NSArray *messages)) successBlock
                                      Failure:(void(^)(VKIMSessionData *session, NSError *error)) failureBlock{
    return nil;
}

- (NSOperation *) sessionFeedGetOperation:(VKIMSessionData *) session
                               WithOffset:(NSUInteger) offset
                                  Success:(void(^)(NSDictionary *feed)) successBlock
                                  Failure:(void(^)(VKIMSessionData *session, NSError *error)) failureBlock{
    return nil;
}

- (NSOperation *) sessionFeedPollOperation:(VKIMSessionData *) session
                                WithOffset:(NSUInteger) offset
                                   Success:(void(^)(NSDictionary *feed)) successBlock
                                   Failure:(void(^)(VKIMSessionData *session, NSError *error)) failureBlock{
    return nil;
}

- (NSOperation *) contactMessagesGetOperation:(VKIMContactData *) contact
                                  WithSuccess:(void(^)(NSArray *messages)) successBlock
                                      Failure:(void(^)(VKIMContactData *contact, NSError *error)) failureBlock{
    return nil;
}

- (NSOperation *) contactUpdateOperation:(VKIMContactData *) contact
                             WithSuccess:(void(^)(VKIMContactData *contact)) successBlock
                                 Failure:(void(^)(VKIMContactData *contact, NSError *error)) failureBlock{
    return nil;
}

- (NSOperation *) contactAddOperation:(VKIMContactData *) contact
                          WithSuccess:(void(^)(VKIMContactData *contactData)) successBlock
                              Failure:(void(^)(VKIMContactData *contact, NSError *error)) failureBlock{
    return nil;
}

- (NSOperation *) contactDeleteOperation:(VKIMContactData *) contact
                             WithSuccess:(void(^)(VKIMContactData *contactData)) successBlock
                                 Failure:(void(^)(VKIMContactData *contact, NSError *error)) failureBlock{
    return nil;
}

- (NSOperation *) messageSendOperation:(VKIMMessageData *) message
                           WithSuccess:(void(^)(NSArray *messages)) successBlock
                               Failure:(void(^)(VKIMMessageData *message, NSError *error)) failureBlock{
    return nil;
}
@end
