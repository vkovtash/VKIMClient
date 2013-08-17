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
@property (strong,nonatomic) VKIMSessionStateAbstract *stateDelegate;
@property (strong,nonatomic) VKIMSessionData *data;
@end

@implementation VKIMSession
@synthesize defaultQueue = _defaultQueue;
@synthesize operationFactory = _operationFactory;


#pragma mark - Publick properties

- (NSOperationQueue *) defaultQueue{
    if (!_defaultQueue) {
        _defaultQueue = [[NSOperationQueue alloc] init];
    }
    return _defaultQueue;
}

- (NSString *) jid{
    return self.data.jid;
}

- (NSString *) token{
    return self.data.token;
}

- (NSString *) sessionID{
    return self.data.sessionID;
}

#pragma mark - Publick methods
- (void) setData:(VKIMSessionData *) sessionData{
    _data = sessionData;
}

- (void) startWithJID:(NSString *) jid
             Password:(NSString *) password
               Server:(NSString *) server
            pushToken:(NSString *) pushToken
              Success:(void(^)()) successBlock
              Failure:(void(^)(NSError *error)) failureBlock{
    
    [self.stateDelegate startWithJID:jid
                            Password:password
                              Server:server
                           pushToken:pushToken
                             Success:^(VKIMSessionData *session) {
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
                             }
                             Failure:^(NSError *error){
                                 if (![self isKindOfClass:[VKIMSession class]]) {
                                     return;
                                 }
                                 [self setSessionState:VKIMSessionStateCreatedCode];
                                 failureBlock ? failureBlock(error) : nil;
                             }];
    [self setSessionState:VKIMSessionStateStartingCode];
}

- (void) restoreWithID:(NSString *) sessionID
                 token:(NSString *) token
               Success:(void(^)()) successBlock
               Failure:(void(^)(NSError *error)) failureBlock{
    
    VKIMSessionData *data = [[VKIMSessionData alloc] init];
    data.sessionID = sessionID;
    data.token = token;
    self.data = data;
    
    [self.stateDelegate restoreWithID:sessionID
                                token:token
                              Success:^(VKIMSessionData *session){
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
                              }
                              Failure:^(NSError *error){
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
                              }
                              inQueue:self.defaultQueue];
    
    [self setSessionState:VKIMSessionStateStartingCode];
}

- (void) closeWithSuccess:(void(^)()) successBlock
                  Failure:(void(^)(NSError *error)) failureBlock{
    [self.stateDelegate close:self.data
                  WithSuccess:^(VKIMSessionData *session) {
                      if (![self isKindOfClass:[VKIMSession class]]) {
                          return;
                      }
                      
                      [self setSessionState:VKIMSessionStateClosedCode];
                      successBlock ? successBlock(session) : nil;
                  }
                      Failure:^(NSError *error){
                          if (![self isKindOfClass:[VKIMSession class]]) {
                              return;
                          }
                          [self setSessionState:VKIMSessionStateActiveCode];
                          failureBlock ? failureBlock(error) : nil;
                      }];
    [self setSessionState:VKIMSessionStateClosingCode];
}

#pragma mark - Custom Queue methods

- (void) getSessionDataWithSuccess:(void(^)(VKIMSessionData *session)) successBlock
                           Failure:(void(^)(NSError *error)) failureBlock
                           inQueue:(NSOperationQueue *) queue{
    
    __weak __typeof(&*self) weakSelf = self;
    [self.stateDelegate getSessionData:self.data
                           WithSuccess:successBlock
                               Failure:^(NSError *error){
                                   if ([weakSelf isKindOfClass:[VKIMSession class]]) {
                                       [weakSelf processResponseError:error];
                                   }
                                   failureBlock ? failureBlock(error) : nil;
                               }
                               inQueue:queue];
}

- (void) getContactsWithOffset:(NSUInteger) offset
                       Success:(void(^)(NSArray *contacts)) successBlock
                       Failure:(void(^)(NSError *error)) failureBlock
                       inQueue:(NSOperationQueue *) queue{
    __weak __typeof(&*self) weakSelf = self;
    [self.stateDelegate getContactsData:self.data
                             WithOffset:offset
                                Success:successBlock
                                Failure:^(NSError *error){
                                    if ([weakSelf isKindOfClass:[VKIMSession class]]) {
                                        [weakSelf processResponseError:error];
                                    }
                                    failureBlock ? failureBlock(error) : nil;
                                }
                                inQueue:queue];
}

- (void) getMessagesWithOffset:(NSUInteger) offset
                       Success:(void(^)(NSArray *messages)) successBlock
                       Failure:(void(^)(NSError *error)) failureBlock
                       inQueue:(NSOperationQueue *) queue{
    __weak __typeof(&*self) weakSelf = self;
    [self.stateDelegate getMessages:self.data
                         WithOffset:offset
                            Success:successBlock
                            Failure:^(NSError *error){
                                if ([weakSelf isKindOfClass:[VKIMSession class]]) {
                                    [weakSelf processResponseError:error];
                                }
                                failureBlock ? failureBlock(error) : nil;
                            }
                            inQueue:queue];
}

- (void) getFeedWithOffset:(NSUInteger) offset
                   Success:(void(^)(NSDictionary *feed)) successBlock
                   Failure:(void(^)(NSError *error)) failureBlock
                   inQueue:(NSOperationQueue *) queue{
    __weak __typeof(&*self) weakSelf = self;
    [self.stateDelegate getFeed:self.data
                     WithOffset:offset
                        Success:successBlock
                        Failure:^(NSError *error){
                            if ([weakSelf isKindOfClass:[VKIMSession class]]) {
                                [weakSelf processResponseError:error];
                            }
                            failureBlock ? failureBlock(error) : nil;
                        }
                        inQueue:queue];
}

- (void) pollFeedWithOffset:(NSUInteger) offset
                    Success:(void(^)(NSDictionary *feed)) successBlock
                    Failure:(void(^)(NSError *error)) failureBlock
                    inQueue:(NSOperationQueue *) queue{
    __weak __typeof(&*self) weakSelf = self;
    [self.stateDelegate pollFeed:self.data
                      WithOffset:offset
                         Success:successBlock
                         Failure:^(NSError *error){
                            if ([weakSelf isKindOfClass:[VKIMSession class]]) {
                                [weakSelf processResponseError:error];
                            }
                            failureBlock ? failureBlock(error) : nil;
                         }
                         inQueue:queue];
}

- (void) sendMessage:(VKIMMessageData *) message
         WithSuccess:(void(^)(NSArray *messages)) successBlock
             Failure:(void(^)(VKIMMessageData *message, NSError *error)) failureBlock
             inQueue:(NSOperationQueue *) queue{
    __weak __typeof(&*self) weakSelf = self;
    [self.stateDelegate sendMessage:message
                        WithSuccess:successBlock
                            Failure:^(VKIMMessageData *message, NSError *error){
                                if ([weakSelf isKindOfClass:[VKIMSession class]]) {
                                    [weakSelf processResponseError:error];
                                }
                                failureBlock ? failureBlock(message,error) : nil;
                            }
                            inQueue:queue];
}

- (void) updateContactData:(VKIMContactData *) contactData
               WithSuccess:(void(^)(VKIMContactData *contactData)) successBlock
                   Failure:(void(^)(VKIMContactData *contactData, NSError *error)) failureBlock
                   inQueue:(NSOperationQueue *) queue{
    contactData.session = self.data;
    __weak __typeof(&*self) weakSelf = self;
    [self.stateDelegate updateContactData:contactData
                        WithSuccess:successBlock
                            Failure:^(VKIMContactData *contactData, NSError *error){
                                if ([weakSelf isKindOfClass:[VKIMSession class]]) {
                                    [weakSelf processResponseError:error];
                                }
                                failureBlock ? failureBlock(contactData,error) : nil;
                            }
                            inQueue:queue];
}

- (void) addContact:(VKIMContactData *) contactData
        WithSuccess:(void(^)(VKIMContactData *contactData)) successBlock
            Failure:(void(^)(VKIMContactData *contactData, NSError *error)) failureBlock
            inQueue:(NSOperationQueue *) queue{
    contactData.session = self.data;
    __weak __typeof(&*self) weakSelf = self;
    [self.stateDelegate addContact:contactData
                        WithSuccess:successBlock
                            Failure:^(VKIMContactData *contactData, NSError *error){
                                if ([weakSelf isKindOfClass:[VKIMSession class]]) {
                                    [weakSelf processResponseError:error];
                                }
                                failureBlock ? failureBlock(contactData,error) : nil;
                            }
                            inQueue:queue];
}

- (void) deleteContact:(VKIMContactData *) contactData
           WithSuccess:(void(^)(VKIMContactData *contactData)) successBlock
               Failure:(void(^)(VKIMContactData *contactData, NSError *error)) failureBlock
               inQueue:(NSOperationQueue *) queue{
    contactData.session = self.data;
    __weak __typeof(&*self) weakSelf = self;
    [self.stateDelegate deleteContact:contactData
                          WithSuccess:successBlock
                              Failure:^(VKIMContactData *contactData, NSError *error){
                                  if ([weakSelf isKindOfClass:[VKIMSession class]]) {
                                      [weakSelf processResponseError:error];
                                  }
                                  failureBlock ? failureBlock(contactData,error) : nil;
                                  }
                              inQueue:queue];
}

#pragma mark - Default Queue methods

- (void) getSessionDataWithSuccess:(void(^)(VKIMSessionData *session)) successBlock
                           Failure:(void(^)(NSError *error)) failureBlock{
    [self getSessionDataWithSuccess:successBlock
                            Failure:failureBlock
                            inQueue:self.defaultQueue];
}

- (void) getContactsWithOffset:(NSUInteger) offset
                       Success:(void(^)(NSArray *contacts)) successBlock
                       Failure:(void(^)(NSError *error)) failureBlock{
    [self getContactsWithOffset:offset
                        Success:successBlock
                        Failure:failureBlock
                        inQueue:self.defaultQueue];
}

- (void) getMessagesWithOffset:(NSUInteger) offset
                       Success:(void(^)(NSArray *messages)) successBlock
                       Failure:(void(^)(NSError *error)) failureBlock{
    [self getMessagesWithOffset:offset
                        Success:successBlock
                        Failure:failureBlock
                        inQueue:self.defaultQueue];
}

- (void) getFeedWithOffset:(NSUInteger) offset
                   Success:(void(^)(NSDictionary *feed)) successBlock
                   Failure:(void(^)(NSError *error)) failureBlock{
    [self getFeedWithOffset:offset
                    Success:successBlock
                    Failure:failureBlock
                    inQueue:self.defaultQueue];
}

- (void) pollFeedWithOffset:(NSUInteger) offset
                    Success:(void(^)(NSDictionary *feed)) successBlock
                    Failure:(void(^)(NSError *error)) failureBlock{
    [self pollFeedWithOffset:offset
                     Success:successBlock
                     Failure:failureBlock
                     inQueue:self.defaultQueue];
}

- (void) sendMessage:(VKIMMessageData *) message
         WithSuccess:(void(^)(NSArray *messages)) successBlock
             Failure:(void(^)(VKIMMessageData *message, NSError *error)) failureBlock{
    [self sendMessage:message
          WithSuccess:successBlock
              Failure:failureBlock
              inQueue:self.defaultQueue];
}

- (void) updateContactData:(VKIMContactData *) contactData
               WithSuccess:(void(^)(VKIMContactData *contactData)) successBlock
                   Failure:(void(^)(VKIMContactData *contactData, NSError *error)) failureBlock{
    [self updateContactData:contactData
                WithSuccess:successBlock
                    Failure:failureBlock
                    inQueue:self.defaultQueue];
}

- (void) addContact:(VKIMContactData *) contactData
        WithSuccess:(void(^)(VKIMContactData *contactData)) successBlock
            Failure:(void(^)(VKIMContactData *contactData, NSError *error)) failureBlock{
    [self addContact:contactData
         WithSuccess:successBlock
             Failure:failureBlock
             inQueue:self.defaultQueue];
}

- (void) deleteContact:(VKIMContactData *) contactData
           WithSuccess:(void(^)(VKIMContactData *contactData)) successBlock
               Failure:(void(^)(VKIMContactData *contactData, NSError *error)) failureBlock{
    [self deleteContact:contactData
            WithSuccess:successBlock
                Failure:failureBlock
                inQueue:self.defaultQueue];
}

- (void) applySessionState:(VKIMSessionStateCode) stateCode{
    
}

- (id) initWithOperationsFactory:(VKIMAbstractOperationFactory *) operationsFactory{
    self = [super init];
    if (self) {
        _operationFactory = operationsFactory;
        [self setSessionState:VKIMSessionStateCreatedCode];
    }
    
    return self;
}

#pragma mark - Private Methods
- (void) processResponseError:(NSError *) error{
    if ([error.domain isEqualToString:VKIMErrorDomain] &&
        (error.code == VKIMSessionError || error.code == VKIMSessionAuthError)) {
        [self setSessionState:VKIMSessionStateClosedCode];
    }
}

#pragma mark - Session state

- (VKIMSessionStateCode) stateCode{
    return self.stateDelegate.stateCode;
}

- (void) setSessionState:(VKIMSessionStateCode)stateCode{
    switch (stateCode) {
        case VKIMSessionStateCreatedCode:
            self.stateDelegate = [[VKIMSessionStateCreated alloc] initWithStateCode:stateCode
                                                                   OperationFactory:self.operationFactory];
            break;
            
        case VKIMSessionStateStartingCode:
            self.stateDelegate = [[VKIMSessionStateNoOp alloc] initWithStateCode:stateCode
                                                                OperationFactory:self.operationFactory];
            break;
            
        case VKIMSessionStateActiveCode:
            self.stateDelegate = [[VKIMSessionStateActive alloc] initWithStateCode:stateCode
                                                                  OperationFactory:self.operationFactory];
            break;
            
        case VKIMSessionStateClosingCode:
            self.stateDelegate = [[VKIMSessionStateNoOp alloc] initWithStateCode:stateCode
                                                                OperationFactory:self.operationFactory];
            break;
            
        case VKIMSessionStateClosedCode:
            [self.defaultQueue cancelAllOperations];
            self.stateDelegate = [[VKIMSessionStateNoOp alloc] initWithStateCode:stateCode
                                                                OperationFactory:self.operationFactory];
            break;
            
        default:
            break;
    }
    
    [self applySessionState:stateCode];
}

@end
