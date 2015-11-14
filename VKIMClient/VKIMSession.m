//
//  VKIMSession.m
//  VKIMClient
//
//  Created by Vlad Kovtash (v.kovtash@gmail.com) on 22.04.13.
//  Copyright (c) 2013 Vlad Kovtash. All rights reserved.
//

#import "VKIMSession.h"
#import "VKIMSessionStateCreated.h"
#import "VKIMSessionStateActive.h"
#import "VKIMSessionStateNoOp.h"
#import "VKIMErrorData.h"

@interface VKIMSession()
@property (strong, nonatomic) VKIMSessionStateAbstract *stateDelegate;
@property (strong, nonatomic) VKIMSessionData *data;
@end

@implementation VKIMSession
@synthesize defaultQueue = _defaultQueue;
@synthesize operationFactory = _operationFactory;


#pragma mark - Public properties

- (NSOperationQueue *)defaultQueue {
    if (!_defaultQueue) {
        _defaultQueue = [[NSOperationQueue alloc] init];
    }
    return _defaultQueue;
}

- (NSString *)jid {
    return self.data.jid;
}

- (NSString *)token {
    return self.data.token;
}

- (NSString *)sessionID {
    return self.data.sessionID;
}

#pragma mark - Public methods

- (void)setData:(VKIMSessionData *)sessionData {
    _data = sessionData;
}

- (NSOperation *)startWithJID:(NSString *)jid
                     Password:(NSString *)password
                       Server:(NSString *)server
                    pushToken:(NSString *)pushToken
                      Success:(void(^)())successBlock
                      Failure:(void(^)(NSError *error))failureBlock {
    NSOperation *operation =
        [self.stateDelegate startWithJID:jid Password:password Server:server pushToken:pushToken Success:^(VKIMSessionData *session) {
            if (![self isKindOfClass:[VKIMSession class]]) {
                return;
            }
            
            if (session != nil) {
                self.data = session;
                [self setSessionState:VKIMSessionStateActiveCode];
                successBlock ? successBlock() : nil;
            }else{
                [self setSessionState:VKIMSessionStateCreatedCode];
                failureBlock ? failureBlock([VKIMErrorData sessionError]) : nil;
            }
        } Failure:^(NSError *error) {
            if (![self isKindOfClass:[VKIMSession class]]) {
                return;
            }
            [self setSessionState:VKIMSessionStateCreatedCode];
            failureBlock ? failureBlock(error) : nil;
        }];
    
    [self setSessionState:VKIMSessionStateStartingCode];
    return operation;
}

- (NSOperation *)restoreWithID:(NSString *)sessionID
                         token:(NSString *)token
                       Success:(void(^)())successBlock
                       Failure:(void(^)(NSError *error))failureBlock {
    VKIMSessionData *data = [[VKIMSessionData alloc] init];
    data.sessionID = sessionID;
    data.token = token;
    self.data = data;
    
    NSOperation *operation =
        [self.stateDelegate restoreWithID:sessionID token:token Success:^(VKIMSessionData *session) {
            if (![self isKindOfClass:[VKIMSession class]]) {
                return;
            }
            
            if (session != nil) {
                self.data = session;
                [self setSessionState:VKIMSessionStateActiveCode];
                successBlock ? successBlock() : nil;
            }else{
                [self setSessionState:VKIMSessionStateCreatedCode];
                failureBlock ? failureBlock([VKIMErrorData sessionError]) : nil;
            }
        } Failure:^(NSError *error) {
            if (![self isKindOfClass:[VKIMSession class]]) {
                return;
            }
            
            if (error.domain != VKIMErrorDomain) {
                [self setSessionState:VKIMSessionStateCreatedCode];
                [self restoreWithID:sessionID token:token Success:successBlock Failure:failureBlock];
            }
            else{
                [self setSessionState:VKIMSessionStateClosedCode];
                failureBlock ? failureBlock(error) : nil;
            }
        } inQueue:self.defaultQueue];
    
    [self setSessionState:VKIMSessionStateStartingCode];
    return operation;
}

- (NSOperation *)closeWithSuccess:(void(^)())successBlock Failure:(void(^)(NSError *error))failureBlock {
    NSOperation *operation = [self.stateDelegate close:self.data WithSuccess:^(VKIMSessionData *session) {
        if (![self isKindOfClass:[VKIMSession class]]) {
            return;
        }
        
        [self setSessionState:VKIMSessionStateClosedCode];
        successBlock ? successBlock(session) : nil;
    } Failure:^(NSError *error) {
        if (![self isKindOfClass:[VKIMSession class]]) {
            return;
        }
        [self setSessionState:VKIMSessionStateActiveCode];
        failureBlock ? failureBlock(error) : nil;
    }];
    
    [self setSessionState:VKIMSessionStateClosingCode];
    return operation;
}

#pragma mark - Custom Queue methods

- (NSOperation *)getSessionDataWithSuccess:(void(^)(VKIMSessionData *session))successBlock
                                   Failure:(void(^)(NSError *error))failureBlock
                                   inQueue:(NSOperationQueue *)queue {
    
    __weak __typeof(&*self) weakSelf = self;
    return [self.stateDelegate getSessionData:self.data WithSuccess:successBlock Failure:^(NSError *error) {
        if ([weakSelf isKindOfClass:[VKIMSession class]]) {
            [weakSelf processResponseError:error];
        }
        failureBlock ? failureBlock(error) : nil;
    } inQueue:queue];
}

- (NSOperation *)getContactsWithOffset:(NSUInteger)offset
                               Success:(void(^)(NSArray *contacts))successBlock
                               Failure:(void(^)(NSError *error))failureBlock
                               inQueue:(NSOperationQueue *)queue {
    __weak __typeof(&*self) weakSelf = self;
    return [self.stateDelegate getContactsData:self.data WithOffset:offset Success:successBlock Failure:^(NSError *error) {
        if ([weakSelf isKindOfClass:[VKIMSession class]]) {
            [weakSelf processResponseError:error];
        }
        failureBlock ? failureBlock(error) : nil;
    } inQueue:queue];
}

- (NSOperation *)getMessagesWithOffset:(NSUInteger)offset
                               Success:(void(^)(NSArray *messages))successBlock
                               Failure:(void(^)(NSError *error))failureBlock
                               inQueue:(NSOperationQueue *)queue {
    __weak __typeof(&*self) weakSelf = self;
    return [self.stateDelegate getMessages:self.data WithOffset:offset Success:successBlock Failure:^(NSError *error) {
        if ([weakSelf isKindOfClass:[VKIMSession class]]) {
            [weakSelf processResponseError:error];
        }
        failureBlock ? failureBlock(error) : nil;
    } inQueue:queue];
}

- (NSOperation *)getFeedWithOffset:(NSUInteger)offset
                           Success:(void(^)(NSDictionary *feed))successBlock
                           Failure:(void(^)(NSError *error))failureBlock
                           inQueue:(NSOperationQueue *)queue {
    __weak __typeof(&*self) weakSelf = self;
    return [self.stateDelegate getFeed:self.data WithOffset:offset Success:successBlock Failure:^(NSError *error) {
        if ([weakSelf isKindOfClass:[VKIMSession class]]) {
            [weakSelf processResponseError:error];
        }
        failureBlock ? failureBlock(error) : nil;
    } inQueue:queue];
}

- (NSOperation *)pollFeedWithOffset:(NSUInteger)offset
                            Success:(void(^)(NSDictionary *feed))successBlock
                            Failure:(void(^)(NSError *error))failureBlock
                            inQueue:(NSOperationQueue *)queue {
    __weak __typeof(&*self) weakSelf = self;
    return [self.stateDelegate pollFeed:self.data WithOffset:offset Success:successBlock Failure:^(NSError *error) {
        if ([weakSelf isKindOfClass:[VKIMSession class]]) {
            [weakSelf processResponseError:error];
        }
        failureBlock ? failureBlock(error) : nil;
    } inQueue:queue];
}

- (NSOperation *)sendMessage:(VKIMMessageData *)message
                 WithSuccess:(void(^)(NSArray *messages))successBlock
                     Failure:(void(^)(VKIMMessageData *message, NSError *error))failureBlock
                     inQueue:(NSOperationQueue *)queue {
    __weak __typeof(&*self) weakSelf = self;
    return [self.stateDelegate sendMessage:message WithSuccess:successBlock Failure:^(VKIMMessageData *message, NSError *error) {
        if ([weakSelf isKindOfClass:[VKIMSession class]]) {
            [weakSelf processResponseError:error];
        }
        failureBlock ? failureBlock(message,error) : nil;
    } inQueue:queue];
}

- (NSOperation *)updateContactData:(VKIMContactData *)contactData
                       WithSuccess:(void(^)(VKIMContactData *contactData))successBlock
                           Failure:(void(^)(VKIMContactData *contactData, NSError *error))failureBlock
                           inQueue:(NSOperationQueue *)queue {
    contactData.session = self.data;
    __weak __typeof(&*self) weakSelf = self;
    return [self.stateDelegate updateContactData:contactData
                                     WithSuccess:successBlock
                                         Failure:^(VKIMContactData *contactData, NSError *error)
    {
        if ([weakSelf isKindOfClass:[VKIMSession class]]) {
            [weakSelf processResponseError:error];
        }
        failureBlock ? failureBlock(contactData,error) : nil;
    } inQueue:queue];
}

- (NSOperation *)addContact:(VKIMContactData *)contactData
                WithSuccess:(void(^)(VKIMContactData *contactData))successBlock
                    Failure:(void(^)(VKIMContactData *contactData, NSError *error))failureBlock
                    inQueue:(NSOperationQueue *)queue {
    contactData.session = self.data;
    __weak __typeof(&*self) weakSelf = self;
    return [self.stateDelegate addContact:contactData
                              WithSuccess:successBlock
                                  Failure:^(VKIMContactData *contactData, NSError *error)
    {
        if ([weakSelf isKindOfClass:[VKIMSession class]]) {
            [weakSelf processResponseError:error];
        }
        failureBlock ? failureBlock(contactData,error) : nil;
    } inQueue:queue];
}

- (NSOperation *)deleteContact:(VKIMContactData *)contactData
                   WithSuccess:(void(^)(VKIMContactData *contactData))successBlock
                       Failure:(void(^)(VKIMContactData *contactData, NSError *error))failureBlock
                       inQueue:(NSOperationQueue *)queue {
    contactData.session = self.data;
    __weak __typeof(&*self) weakSelf = self;
    return [self.stateDelegate deleteContact:contactData
                                 WithSuccess:successBlock
                                     Failure:^(VKIMContactData *contactData, NSError *error)
    {
        if ([weakSelf isKindOfClass:[VKIMSession class]]) {
            [weakSelf processResponseError:error];
        }
        failureBlock ? failureBlock(contactData,error) : nil;
    } inQueue:queue];
}

- (NSOperation *)updateMucData:(VKIMMucData *)mucData
           WithSuccess:(void(^)(VKIMMucData *mucData))successBlock
               Failure:(void(^)(VKIMMucData *mucData, NSError *error))failureBlock
               inQueue:(NSOperationQueue *)queue {
    mucData.session = self.data;
    __weak __typeof(&*self) weakSelf = self;
    return [self.stateDelegate updateMucData:mucData
                                 WithSuccess:successBlock
                              Failure:^(VKIMMucData *contactData, NSError *error)
    {
        if ([weakSelf isKindOfClass:[VKIMSession class]]) {
            [weakSelf processResponseError:error];
        }
        failureBlock ? failureBlock(contactData,error) : nil;
    } inQueue:queue];
}

- (NSOperation *)addMuc:(VKIMMucData *)mucData
            WithSuccess:(void(^)(VKIMMucData *mucData))successBlock
                Failure:(void(^)(VKIMMucData *mucData, NSError *error))failureBlock
                inQueue:(NSOperationQueue *) queue {
    mucData.session = self.data;
    __weak __typeof(&*self) weakSelf = self;
    return [self.stateDelegate addMuc:mucData
                          WithSuccess:successBlock
                              Failure:^(VKIMMucData *contactData, NSError *error)
    {
        if ([weakSelf isKindOfClass:[VKIMSession class]]) {
            [weakSelf processResponseError:error];
        }
        failureBlock ? failureBlock(contactData,error) : nil;
    } inQueue:queue];
}

- (NSOperation *)deleteMuc:(VKIMMucData *)mucData
               WithSuccess:(void(^)(VKIMMucData *mucData))successBlock
                   Failure:(void(^)(VKIMMucData *mucData, NSError *error))failureBlock
                   inQueue:(NSOperationQueue *)queue {
    __weak __typeof(&*self) weakSelf = self;
    return [self.stateDelegate deleteMuc:mucData
                             WithSuccess:successBlock
                                 Failure:^(VKIMMucData *contactData, NSError *error)
    {
        if ([weakSelf isKindOfClass:[VKIMSession class]]) {
            [weakSelf processResponseError:error];
        }
        failureBlock ? failureBlock(contactData,error) : nil;
    } inQueue:queue];
}

#pragma mark - Default Queue methods

- (NSOperation *)getSessionDataWithSuccess:(void(^)(VKIMSessionData *session))successBlock
                                   Failure:(void(^)(NSError *error))failureBlock {
    return [self getSessionDataWithSuccess:successBlock Failure:failureBlock inQueue:self.defaultQueue];
}

- (NSOperation *)getContactsWithOffset:(NSUInteger)offset
                               Success:(void(^)(NSArray *contacts))successBlock
                               Failure:(void(^)(NSError *error))failureBlock {
    return [self getContactsWithOffset:offset Success:successBlock Failure:failureBlock inQueue:self.defaultQueue];
}

- (NSOperation *)getMessagesWithOffset:(NSUInteger)offset
                               Success:(void(^)(NSArray *messages))successBlock
                               Failure:(void(^)(NSError *error))failureBlock {
    return [self getMessagesWithOffset:offset Success:successBlock Failure:failureBlock inQueue:self.defaultQueue];
}

- (NSOperation *)getFeedWithOffset:(NSUInteger)offset
                           Success:(void(^)(NSDictionary *feed))successBlock
                           Failure:(void(^)(NSError *error))failureBlock {
    return [self getFeedWithOffset:offset Success:successBlock Failure:failureBlock inQueue:self.defaultQueue];
}

- (NSOperation *)pollFeedWithOffset:(NSUInteger)offset
                            Success:(void(^)(NSDictionary *feed))successBlock
                            Failure:(void(^)(NSError *error))failureBlock {
    return [self pollFeedWithOffset:offset Success:successBlock Failure:failureBlock inQueue:self.defaultQueue];
}

- (NSOperation *)sendMessage:(VKIMMessageData *)message
                 WithSuccess:(void(^)(NSArray *messages))successBlock
                     Failure:(void(^)(VKIMMessageData *message, NSError *error))failureBlock {
    return [self sendMessage:message WithSuccess:successBlock Failure:failureBlock inQueue:self.defaultQueue];
}

- (NSOperation *)updateContactData:(VKIMContactData *)contactData
                       WithSuccess:(void(^)(VKIMContactData *contactData))successBlock
                           Failure:(void(^)(VKIMContactData *contactData, NSError *error))failureBlock {
    return [self updateContactData:contactData WithSuccess:successBlock Failure:failureBlock inQueue:self.defaultQueue];
}

- (NSOperation *)addContact:(VKIMContactData *)contactData
                WithSuccess:(void(^)(VKIMContactData *contactData))successBlock
                    Failure:(void(^)(VKIMContactData *contactData, NSError *error))failureBlock {
    return [self addContact:contactData WithSuccess:successBlock Failure:failureBlock inQueue:self.defaultQueue];
}

- (NSOperation *)deleteContact:(VKIMContactData *)contactData
                   WithSuccess:(void(^)(VKIMContactData *contactData))successBlock
                       Failure:(void(^)(VKIMContactData *contactData, NSError *error))failureBlock {
    return [self deleteContact:contactData WithSuccess:successBlock Failure:failureBlock inQueue:self.defaultQueue];
}

- (NSOperation *)updateMucData:(VKIMMucData *)mucData
                   WithSuccess:(void(^)(VKIMMucData *mucData))successBlock
                       Failure:(void(^)(VKIMMucData *mucData, NSError *error))failureBlock {
    return [self updateMucData:mucData WithSuccess:successBlock Failure:failureBlock inQueue:self.defaultQueue];
}

- (NSOperation *)addMuc:(VKIMMucData *)mucData
            WithSuccess:(void(^)(VKIMMucData *mucData))successBlock
                Failure:(void(^)(VKIMMucData *mucData, NSError *error))failureBlock {
    return [self addMuc:mucData WithSuccess:successBlock Failure:failureBlock inQueue:self.defaultQueue];
}

- (NSOperation *)deleteMuc:(VKIMMucData *)mucData
       WithSuccess:(void(^)(VKIMMucData *mucData))successBlock
           Failure:(void(^)(VKIMMucData *mucData, NSError *error))failureBlock {
    return [self deleteMuc:mucData WithSuccess:successBlock Failure:failureBlock inQueue:self.defaultQueue];
}

- (void)applySessionState:(VKIMSessionStateCode)stateCode {
    
}

- (instancetype)initWithOperationsFactory:(VKIMAbstractOperationFactory *)operationsFactory {
    self = [super init];
    if (self) {
        _operationFactory = operationsFactory;
        [self setSessionState:VKIMSessionStateCreatedCode];
    }
    
    return self;
}

#pragma mark - Private Methods

- (void)processResponseError:(NSError *)error {
    if ([error.domain isEqualToString:VKIMErrorDomain] &&
        (error.code == VKIMSessionError || error.code == VKIMSessionAuthError)) {
        [self setSessionState:VKIMSessionStateClosedCode];
    }
}

#pragma mark - Session state

- (VKIMSessionStateCode)stateCode {
    return self.stateDelegate.stateCode;
}

- (void)setSessionState:(VKIMSessionStateCode)stateCode {
    switch (stateCode) {
        case VKIMSessionStateCreatedCode:
            self.stateDelegate =
                [[VKIMSessionStateCreated alloc] initWithStateCode:stateCode OperationFactory:self.operationFactory];
            break;
            
        case VKIMSessionStateStartingCode:
            self.stateDelegate =
                [[VKIMSessionStateNoOp alloc] initWithStateCode:stateCode OperationFactory:self.operationFactory];
            break;
            
        case VKIMSessionStateActiveCode:
            self.stateDelegate =
                [[VKIMSessionStateActive alloc] initWithStateCode:stateCode OperationFactory:self.operationFactory];
            break;
            
        case VKIMSessionStateClosingCode:
            self.stateDelegate =
                [[VKIMSessionStateNoOp alloc] initWithStateCode:stateCode OperationFactory:self.operationFactory];
            break;
            
        case VKIMSessionStateClosedCode:
            [self.defaultQueue cancelAllOperations];
            self.stateDelegate =
                [[VKIMSessionStateNoOp alloc] initWithStateCode:stateCode OperationFactory:self.operationFactory];
            break;
            
        default:
            break;
    }
    
    [self applySessionState:stateCode];
}

@end
