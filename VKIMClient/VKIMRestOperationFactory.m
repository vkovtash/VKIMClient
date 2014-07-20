//
//  VKIMRestOperationFactory.m
//  VKIMClient
//
//  Created by Vlad Kovtash (v.kovtash@gmail.com) on 13.03.13.
//  Copyright (c) 2013 Vlad Kovtash. All rights reserved.
//

#import "VKIMRestOperationFactory.h"
#import <RestKit/RestKit.h>
#import "VKIMContactData+stringsMapping.h"

NSString *const VKIMResponseSessionKey = @"session";
NSString *const VKIMResponseMultipleMessagesKey = @"messages";
NSString *const VKIMResponseMultipleContactsKey = @"contacts";
NSString *const VKIMResponseMultipleMucsKey = @"mucs";
NSString *const VKIMResponseContactKey = @"contact";
NSString *const VKIMResponseMucKey = @"muc";
NSString *const VKIMResponseErrorKey = @"error";

static NSString *const kNormalMessageRequestName = @"normalMessage";
static NSString *const kMucMessageRequestName = @"mucMessage";

@interface VKIMRestOperationFactory()
@property (strong,nonatomic) RKObjectManager *manager;
@end

@implementation VKIMRestOperationFactory

- (NSURL *) baseURL{
    return self.manager.baseURL;
}

#pragma mark - Descriptors
- (RKResponseDescriptor *) sessionResponseDescriptor{
    static RKResponseDescriptor *sessionResponseDescriptor = nil;
    if (sessionResponseDescriptor == nil) {
        RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[VKIMSessionData class]];
        [mapping addAttributeMappingsFromDictionary:@{
                                                      @"token": @"token",
                                                      @"session_id": @"sessionID",
                                                      @"jid": @"jid"
                                                      }];
        sessionResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping
                                                                                 method:RKRequestMethodAny
                                                                            pathPattern:nil
                                                                                keyPath:VKIMResponseSessionKey
                                                                            statusCodes:RKStatusCodeIndexSetForClass\
                                     (RKStatusCodeClassSuccessful)];
    }
    return sessionResponseDescriptor;
}

- (RKResponseDescriptor *) contactsResponseDescriptor{
    static RKResponseDescriptor *contactsResponseDescriptor = nil;
    if (contactsResponseDescriptor == nil) {
        RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[VKIMContactData class]];
        [mapping addAttributeMappingsFromDictionary:@{
                                                      @"id": @"contactID",
                                                      @"jid": @"jid",
                                                      @"name": @"name",
                                                      @"groups": @"groups",
                                                      @"show":@"show",
                                                      @"status":@"status",
                                                      @"authorization":@"authorization",
                                                      @"event_id":@"eventID",
                                                      @"read_offset":@"readOffset",
                                                      @"history_offset":@"historyOffset"
                                                      }];
        contactsResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping
                                                                                  method:RKRequestMethodAny
                                                                             pathPattern:nil
                                                                                 keyPath:VKIMResponseMultipleContactsKey
                                                                             statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    }
    return contactsResponseDescriptor;
}

- (RKResponseDescriptor *) mucsResponseDescriptor{
    static RKResponseDescriptor *mucsResponseDescriptor = nil;
    if (mucsResponseDescriptor == nil) {
        RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[VKIMMucData class]];
        [mapping addAttributeMappingsFromDictionary:@{
         @"id": @"mucID",
         @"jid": @"jid",
         @"event_id":@"eventID",
         @"read_offset":@"readOffset"
         }];
        mucsResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping
                                                                                  method:RKRequestMethodAny
                                                                             pathPattern:nil
                                                                                 keyPath:VKIMResponseMultipleMucsKey
                                                                             statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    }
    return mucsResponseDescriptor;
}

- (RKResponseDescriptor *) messagesResponseDescriptor{
    static RKResponseDescriptor *messagesResponseDescriptor = nil;
    if (messagesResponseDescriptor == nil) {
        RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[VKIMMessageData class]];
        [mapping addAttributeMappingsFromDictionary:@{
                                                      @"event_id": @"eventID",
                                                      @"sort_id":@"sortID",
                                                      @"message_id":@"messageID",
                                                      @"text": @"text",
                                                      @"inbound": @"inbound",
                                                      @"delivered":@"delivered",
                                                      @"contact_id":@"contactID",
                                                      @"timestamp":@"timestamp"
                                                      }];
        messagesResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping
                                                                                  method:RKRequestMethodAny
                                                                             pathPattern:nil
                                                                                 keyPath:VKIMResponseMultipleMessagesKey
                                                                             statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    }
    return messagesResponseDescriptor;
}

- (RKResponseDescriptor *) errorResponseDescriptor{
    static RKResponseDescriptor *errorResponseDescriptor = nil;
    if (errorResponseDescriptor == nil) {
        RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[VKIMErrorData class]];
        [mapping addAttributeMappingsFromDictionary:@{
                                                      @"code": @"code"
                                                      }];
        
        // status codes in range 400-599
        NSRange errorCodesRange;
        errorCodesRange.location = 400;
        errorCodesRange.length = 200;
        
        NSIndexSet *errorCodesIndexSet = [[NSIndexSet alloc] initWithIndexesInRange:errorCodesRange];
        
        errorResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping
                                                                               method:RKRequestMethodAny
                                                                          pathPattern:nil
                                                                              keyPath:VKIMResponseErrorKey
                                                                          statusCodes:errorCodesIndexSet];
    }
    return errorResponseDescriptor;
}

- (RKRequestDescriptor *) messagesRequestDescriptor{
    static RKRequestDescriptor *messagesRequestDescriptor = nil;
    if (messagesRequestDescriptor == nil) {
        RKObjectMapping *mapping = [RKObjectMapping requestMapping];
        [mapping addAttributeMappingsFromDictionary:@{
                                                      @"text": @"text",
                                                      }];
        messagesRequestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:mapping
                                                                          objectClass:[VKIMMessageData class]
                                                                          rootKeyPath:VKIMResponseMultipleMessagesKey
                                                                               method:RKRequestMethodAny];
    }
    
    return messagesRequestDescriptor;
}

- (RKRequestDescriptor *) contactUpdateRequestDescriptor{
    static RKRequestDescriptor *contactUpdateRequestDescriptor = nil;
    if (contactUpdateRequestDescriptor == nil) {
        RKObjectMapping *mapping = [RKObjectMapping requestMapping];
        [mapping addAttributeMappingsFromDictionary:@{
                                                      @"contactID": @"id",
                                                      @"name":@"name",
                                                      @"groups": @"groups",
                                                      @"readOffset":@"read_offset",
                                                      @"historyOffset":@"history_offset",
                                                      @"jid":@"jid",
                                                      @"authorization":@"authorization"
                                                      }];
        contactUpdateRequestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:mapping
                                                                               objectClass:[VKIMContactData class]
                                                                               rootKeyPath:VKIMResponseContactKey
                                                                                    method:RKRequestMethodAny];
    }
    
    return contactUpdateRequestDescriptor;
}

- (RKRequestDescriptor *) mucUpdateRequestDescriptor{
    static RKRequestDescriptor *mucUpdateRequestDescriptor = nil;
    if (mucUpdateRequestDescriptor == nil) {
        RKObjectMapping *mapping = [RKObjectMapping requestMapping];
        [mapping addAttributeMappingsFromDictionary:@{
         @"mucID": @"id",
         @"readOffset":@"read_offset",
         @"jid":@"jid",
         }];
        mucUpdateRequestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:mapping
                                                                               objectClass:[VKIMMucData class]
                                                                               rootKeyPath:VKIMResponseMucKey
                                                                                    method:RKRequestMethodAny];
    }
    
    return mucUpdateRequestDescriptor;
}

#pragma mark - Private methods

- (NSError *) createError:(NSError *) error{
    NSError *returnedError = error;
    if ([error.domain isEqualToString:RKErrorDomain]) {
        VKIMErrorData *errorDescription = [[error.userInfo objectForKey:RKObjectMapperErrorObjectsKey] lastObject];
        returnedError = [errorDescription makeError];
    }
    
    return returnedError;
}

- (NSString *) authValueForToken:(NSString *) token{
    return [NSString stringWithFormat:@"Bearer %@",token];
}

- (id)authenticatedObjectRequestOperationWithObject:(id)object
                                             method:(RKRequestMethod)method
                                               path:(NSString *)path
                                         parameters:(NSDictionary *)parameters
                                              token:(NSString *) token{
    RKObjectRequestOperation *operation = nil;
    NSMutableURLRequest *urlRequest = [self.manager requestWithObject:object
                                                               method:method
                                                                 path:path
                                                           parameters:parameters];
    
    [urlRequest setValue:[self authValueForToken:token] forHTTPHeaderField:@"Authorization"];
    operation = [self.manager objectRequestOperationWithRequest:urlRequest success:nil failure:nil];
    return operation;
}

- (id)authenticatedRequestOperationForObjectsAtPathForRelationship:(NSString *) relationship
                                                          ofObject:(id)object
                                                        parameters:(NSDictionary *)parameters
                                                             token:(NSString *) token{
    RKObjectRequestOperation *operation = nil;
    NSMutableURLRequest *urlRequest = [self.manager requestWithPathForRelationship:relationship
                                                                          ofObject:object
                                                                            method:RKRequestMethodGET
                                                                        parameters:parameters];
    [urlRequest setValue:[self authValueForToken:token] forHTTPHeaderField:@"Authorization"];
    operation = [self.manager objectRequestOperationWithRequest:urlRequest success:nil failure:nil];
    return operation;
}

- (id)authenticatedRequestWithPathForRouteNamed:(NSString *) routeName
                                         object:(id)object
                                     parameters:(NSDictionary *)parameters
                                          token:(NSString *) token{
    RKRequestMethod method;
    NSURL *url = [self.manager.router URLForRouteNamed:routeName method:&method object:object];
    return [self authenticatedObjectRequestOperationWithObject:object
                                                        method:method
                                                          path:[url relativeString]
                                                    parameters:parameters
                                                         token:token];
}

#pragma mark - Factory Methods

- (RKObjectRequestOperation *) sessionStartOperationWithJID:(NSString *) jid
                                                   Password:(NSString *) password
                                                     Server:(NSString *) server
                                                  pushToken:(NSString *) pushToken
                                                    Success:(void(^)(VKIMSessionData *session)) successBlock
                                                    Failure:(void(^)(NSError *error)) failureBlock{
    NSString *postString = [NSString stringWithFormat:@"jid=%@&password=%@&server=%@&client_id=%@",jid,password,server,self.clientID];
    if (pushToken != nil) {
        postString = [postString stringByAppendingFormat:@"&push_token=%@",pushToken];
    }
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[self.baseURL URLByAppendingPathComponent:@"start-session"]];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:urlRequest
                                                                        responseDescriptors:@[[self sessionResponseDescriptor],
                                                                                              [self errorResponseDescriptor]]];
    [operation
     setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result){
         if ([[result array] lastObject] != nil && [[[result array] lastObject] isKindOfClass:[VKIMSessionData class]]) {
             successBlock ? successBlock([[result array] lastObject]) : nil;
         }else{
             failureBlock ? failureBlock([VKIMErrorData sessionError]) : nil;
         }
     }
     failure:^(RKObjectRequestOperation *operation, NSError *error){
         NSError *returnedError = [self createError:error];
         failureBlock ? failureBlock(returnedError) : nil;
     }];
    
    return operation;
}

- (RKObjectRequestOperation *) sessionGetOperation:(VKIMSessionData *) session
                                       WithSuccess:(void(^)(VKIMSessionData *session)) successBlock
                                           Failure:(void(^)(VKIMSessionData *session, NSError *error)) failureBlock{
    
    RKObjectRequestOperation *operation = [self authenticatedObjectRequestOperationWithObject:session
                                                                                       method:RKRequestMethodGET
                                                                                         path:nil parameters:nil
                                                                                        token:session.token];
    [operation
     setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result){
         if ([[result array] lastObject] != nil && [[[result array] lastObject] isKindOfClass:[VKIMSessionData class]]) {
             successBlock ? successBlock([[result array] lastObject]) : nil;
         }else{
             failureBlock ? failureBlock(session,[VKIMErrorData sessionError]) : nil;
         }
     }
     failure:^(RKObjectRequestOperation *operation, NSError *error){
         NSError *returnedError = [self createError:error];
         failureBlock ? failureBlock(session,returnedError) : nil;
     }];
    return operation;
}

- (RKObjectRequestOperation *) sessionDeleteOperation:(VKIMSessionData *) session
                                          WithSuccess:(void(^)(VKIMSessionData *session)) successBlock
                                              Failure:(void(^)(VKIMSessionData *session, NSError *error)) failureBlock{
    RKObjectRequestOperation *operation = [self authenticatedObjectRequestOperationWithObject:session
                                                                                       method:RKRequestMethodDELETE
                                                                                         path:nil parameters:nil
                                                                                        token:session.token];
    [operation
     setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result){
         successBlock ? successBlock(session) : nil;
     }
     failure:^(RKObjectRequestOperation *operation, NSError *error){
         NSError *returnedError = [self createError:error];
         failureBlock ? failureBlock(session,returnedError) : nil;
     }];
    return operation;
}

- (RKObjectRequestOperation *) sessionContactsGetOperation:(VKIMSessionData *) session
                                                WithOffset:(NSUInteger) offset
                                                   Success:(void(^)(NSArray *contacts)) successBlock
                                                   Failure:(void(^)(VKIMSessionData *session, NSError *error)) failureBlock{
    RKObjectRequestOperation *operation = [self authenticatedRequestOperationForObjectsAtPathForRelationship:@"contacts"
                                                                                                    ofObject:session
                                                                                                  parameters:@{@"offset":[NSNumber numberWithInteger:offset]}
                                                                                                       token:session.token];
    [operation
     setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result){
         successBlock ? successBlock([result.dictionary objectForKey:VKIMResponseMultipleContactsKey]) : nil;
     }
     failure:^(RKObjectRequestOperation *operation, NSError *error){
         NSError *returnedError = [self createError:error];
         failureBlock ? failureBlock(session,returnedError) : nil;
     }];
    return operation;
}

- (RKObjectRequestOperation *) sessionMessagesGetOperation:(VKIMSessionData *) session
                                                WithOffset:(NSUInteger) offset
                                                   Success:(void(^)(NSArray *messages)) successBlock
                                                   Failure:(void(^)(VKIMSessionData *session, NSError *error)) failureBlock{
    RKObjectRequestOperation *operation = [self authenticatedRequestOperationForObjectsAtPathForRelationship:@"messages"
                                                                                                    ofObject:session
                                                                                                  parameters:@{@"offset":[NSNumber numberWithInteger:offset]}
                                                                                                       token:session.token];
    [operation
     setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result){
         successBlock ? successBlock([result.dictionary objectForKey:VKIMResponseMultipleMessagesKey]) : nil;
     }
     failure:^(RKObjectRequestOperation *operation, NSError *error){
         NSError *returnedError = [self createError:error];
         failureBlock ? failureBlock(session,returnedError) : nil;
     }];
    return operation;
}

- (RKObjectRequestOperation *) sessionFeedGetOperation:(VKIMSessionData *) session
                                            WithOffset:(NSUInteger) offset
                                               Success:(void(^)(NSDictionary *feed)) successBlock
                                               Failure:(void(^)(VKIMSessionData *session, NSError *error)) failureBlock{
    RKObjectRequestOperation *operation = [self authenticatedRequestOperationForObjectsAtPathForRelationship:@"feed"
                                                                                                    ofObject:session
                                                                                                  parameters:@{ @"offset":[NSNumber numberWithInteger:offset]}
                                                                                                       token:session.token];
    [operation
     setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result){
         successBlock ? successBlock(result.dictionary) : nil;
     }
     failure:^(RKObjectRequestOperation *operation, NSError *error){
         NSError *returnedError = [self createError:error];
         failureBlock ? failureBlock(session,returnedError) : nil;
     }];
    return operation;
}

- (RKObjectRequestOperation *) sessionFeedPollOperation:(VKIMSessionData *) session
                                             WithOffset:(NSUInteger) offset
                                                Success:(void(^)(NSDictionary *feed)) successBlock
                                                Failure:(void(^)(VKIMSessionData *session, NSError *error)) failureBlock{
    RKObjectRequestOperation *operation = [self authenticatedRequestOperationForObjectsAtPathForRelationship:@"feed"
                                                                                                    ofObject:session
                                                                                                  parameters:@{ @"offset":[NSNumber numberWithInteger:offset],
                                                                                                                @"wait":[NSNumber numberWithBool:YES]}
                                                                                                       token:session.token];
    [operation
     setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result){
         successBlock ? successBlock(result.dictionary) : nil;
     }
     failure:^(RKObjectRequestOperation *operation, NSError *error){
         NSError *returnedError = [self createError:error];
         failureBlock ? failureBlock(session,returnedError) : nil;
     }];
    return operation;
}

- (RKObjectRequestOperation *) contactMessagesGetOperation:(VKIMContactData *) contact
                                               WithSuccess:(void(^)(NSArray *messages)) successBlock
                                                   Failure:(void(^)(VKIMContactData *contact, NSError *error)) failureBlock{
    RKObjectRequestOperation *operation = [self authenticatedRequestOperationForObjectsAtPathForRelationship:@"chat"
                                                                                                    ofObject:contact
                                                                                                  parameters:nil
                                                                                                       token:contact.session.token];
    [operation
     setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result){
         successBlock ? successBlock(result.array) : nil;
     }
     failure:^(RKObjectRequestOperation *operation, NSError *error){
         NSError *returnedError = [self createError:error];
         failureBlock ? failureBlock(contact,returnedError) : nil;
     }];
    return operation;
}

- (NSOperation *) contactUpdateOperation:(VKIMContactData *) contact
                             WithSuccess:(void(^)(VKIMContactData *contactData)) successBlock
                                 Failure:(void(^)(VKIMContactData *contact, NSError *error)) failureBlock{
    RKObjectRequestOperation *operation = [self authenticatedObjectRequestOperationWithObject:contact
                                                                                       method:RKRequestMethodPUT
                                                                                         path:nil parameters:nil
                                                                                        token:contact.session.token];
    
    [operation
     setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result){
         if ([[result array] lastObject] != nil && [[[result array] lastObject] isKindOfClass:[VKIMContactData class]]) {
             successBlock ? successBlock([[result array] lastObject]) : nil;
         }
     }
     failure:^(RKObjectRequestOperation *operation, NSError *error){
         NSError *returnedError = [self createError:error];
         failureBlock ? failureBlock(contact,returnedError) : nil;
     }];
    return operation;
}

- (NSOperation *) contactDeleteOperation:(VKIMContactData *) contact
                             WithSuccess:(void(^)(VKIMContactData *contactData)) successBlock
                                 Failure:(void(^)(VKIMContactData *contact, NSError *error)) failureBlock{
    RKObjectRequestOperation *operation = [self authenticatedObjectRequestOperationWithObject:contact
                                                                                       method:RKRequestMethodDELETE
                                                                                         path:nil parameters:nil
                                                                                        token:contact.session.token];
    [operation
     setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result){
         successBlock ? successBlock([[result array] lastObject]) : nil;
     }
     failure:^(RKObjectRequestOperation *operation, NSError *error){
         NSError *returnedError = [self createError:error];
         failureBlock ? failureBlock(contact,returnedError) : nil;
     }];
    return operation;
}

- (NSOperation *) contactAddOperation:(VKIMContactData *) contact
                          WithSuccess:(void(^)(VKIMContactData *contactData)) successBlock
                              Failure:(void(^)(VKIMContactData *contact, NSError *error)) failureBlock{
    RKObjectRequestOperation *operation = [self authenticatedObjectRequestOperationWithObject:contact
                                                                                       method:RKRequestMethodPOST
                                                                                         path:nil parameters:nil
                                                                                        token:contact.session.token];
    
    [operation
     setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result){
         if ([[result array] lastObject] != nil && [[[result array] lastObject] isKindOfClass:[VKIMContactData class]]) {
             successBlock ? successBlock([[result array] lastObject]) : nil;
         }
     }
     failure:^(RKObjectRequestOperation *operation, NSError *error){
         NSError *returnedError = [self createError:error];
         failureBlock ? failureBlock(contact,returnedError) : nil;
     }];
    return operation;
}

- (NSOperation *) mucCreateOperation:(VKIMMucData *) mucData
                         WithSuccess:(void(^)(VKIMMucData *mucData)) successBlock
                             Failure:(void(^)(VKIMMucData *mucData, NSError *error)) failureBlock{
    RKObjectRequestOperation *operation = [self authenticatedObjectRequestOperationWithObject:mucData
                                                                                       method:RKRequestMethodPOST
                                                                                         path:nil parameters:nil
                                                                                        token:mucData.session.token];
    
    [operation
     setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result){
         if ([[result array] lastObject] != nil && [[[result array] lastObject] isKindOfClass:[VKIMMucData class]]) {
             successBlock ? successBlock([[result array] lastObject]) : nil;
         }
     }
     failure:^(RKObjectRequestOperation *operation, NSError *error){
         NSError *returnedError = [self createError:error];
         failureBlock ? failureBlock(mucData, returnedError) : nil;
     }];
    return operation;
}

- (NSOperation *) mucUpdateOperation:(VKIMMucData *) mucData
                         WithSuccess:(void(^)(VKIMMucData *mucData)) successBlock
                             Failure:(void(^)(VKIMMucData *mucData, NSError *error)) failureBlock {
    RKObjectRequestOperation *operation = [self authenticatedObjectRequestOperationWithObject:mucData
                                                                                       method:RKRequestMethodPUT
                                                                                         path:nil parameters:nil
                                                                                        token:mucData.session.token];
    
    [operation
     setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result){
         if ([[result array] lastObject] != nil && [[[result array] lastObject] isKindOfClass:[VKIMMucData class]]) {
             successBlock ? successBlock([[result array] lastObject]) : nil;
         }
     }
     failure:^(RKObjectRequestOperation *operation, NSError *error){
         NSError *returnedError = [self createError:error];
         failureBlock ? failureBlock(mucData, returnedError) : nil;
     }];
    return operation;
}

- (NSOperation *) mucDeleteOperation:(VKIMMucData *) mucData
                         WithSuccess:(void(^)(VKIMMucData *mucData)) successBlock
                             Failure:(void(^)(VKIMMucData *mucData, NSError *error)) failureBlock {
    RKObjectRequestOperation *operation = [self authenticatedObjectRequestOperationWithObject:mucData
                                                                                       method:RKRequestMethodDELETE
                                                                                         path:nil parameters:nil
                                                                                        token:mucData.session.token];
    [operation
     setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result){
         successBlock ? successBlock([[result array] lastObject]) : nil;
     }
     failure:^(RKObjectRequestOperation *operation, NSError *error){
         NSError *returnedError = [self createError:error];
         failureBlock ? failureBlock(mucData, returnedError) : nil;
     }];
    return operation;
}

- (RKObjectRequestOperation *) messageSendOperation:(VKIMMessageData *) message
                                        WithSuccess:(void(^)(NSArray *messages)) successBlock
                                            Failure:(void(^)(VKIMMessageData *message, NSError *error)) failureBlock;{
    
    RKObjectRequestOperation *operation = nil;
    
    if ([message.contact isKindOfClass:[VKIMContactData class]]) {
        operation = [self authenticatedRequestWithPathForRouteNamed:kNormalMessageRequestName
                                                             object:message
                                                         parameters:nil
                                                              token:message.contact.session.token];
    }
    else if ([message.contact isKindOfClass:[VKIMContactData class]]) {
        operation = [self authenticatedRequestWithPathForRouteNamed:kMucMessageRequestName
                                                             object:message
                                                         parameters:nil
                                                              token:message.contact.session.token];
    }
    else {
        return nil;
    }
    
    [operation
     setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result){
         successBlock ? successBlock(result.array) : nil;
     }
     failure:^(RKObjectRequestOperation *operation, NSError *error){
         NSError *returnedError = [self createError:error];
         failureBlock ? failureBlock(message,returnedError) : nil;
     }];
    return operation;
}

- (id) initWithBaseURL:(NSURL *) baseURL{
    self = [self init];
    
    if (self != nil) {
        _manager = [RKObjectManager managerWithBaseURL:baseURL];
        
        [self.manager setRequestSerializationMIMEType:RKMIMETypeJSON];
        [self.manager addResponseDescriptor:[self sessionResponseDescriptor]];
        [self.manager addResponseDescriptor:[self contactsResponseDescriptor]];
        [self.manager addResponseDescriptor:[self mucsResponseDescriptor]];
        [self.manager addResponseDescriptor:[self messagesResponseDescriptor]];
        [self.manager addResponseDescriptor:[self errorResponseDescriptor]];
        [self.manager addRequestDescriptor:[self messagesRequestDescriptor]];
        [self.manager addRequestDescriptor:[self contactUpdateRequestDescriptor]];
        [self.manager addRequestDescriptor:[self mucUpdateRequestDescriptor]];
        
        
        [self.manager.router.routeSet addRoute:[RKRoute routeWithClass:[VKIMSessionData class]
                                                           pathPattern:@"sessions/:sessionID"
                                                                method:RKRequestMethodGET]];
        [self.manager.router.routeSet addRoute:[RKRoute routeWithClass:[VKIMSessionData class]
                                                           pathPattern:@"sessions/:sessionID"
                                                                method:RKRequestMethodDELETE]];
        
        [self.manager.router.routeSet addRoute:[RKRoute routeWithName:kNormalMessageRequestName
                                                          pathPattern:@"sessions/:contact.session.sessionID/contacts/:contact.contactID/messages"
                                                               method:RKRequestMethodPOST]];
        [self.manager.router.routeSet addRoute:[RKRoute routeWithName:kMucMessageRequestName
                                                          pathPattern:@"sessions/:contact.session.sessionID/mucs/:contact.contactID/messages"
                                                               method:RKRequestMethodPOST]];
        
        [self.manager.router.routeSet addRoute:[RKRoute routeWithClass:[VKIMContactData class]
                                                           pathPattern:@"sessions/:session.sessionID/contacts/:contactID"
                                                                method:RKRequestMethodPUT]];
        [self.manager.router.routeSet addRoute:[RKRoute routeWithClass:[VKIMContactData class]
                                                           pathPattern:@"sessions/:session.sessionID/contacts/:contactID"
                                                                method:RKRequestMethodDELETE]];
        [self.manager.router.routeSet addRoute:[RKRoute routeWithClass:[VKIMContactData class]
                                                           pathPattern:@"sessions/:session.sessionID/contacts"
                                                                method:RKRequestMethodPOST]];
        
        
        [self.manager.router.routeSet addRoute:[RKRoute routeWithClass:[VKIMMucData class]
                                                           pathPattern:@"sessions/:session.sessionID/mucs/:mucID"
                                                                method:RKRequestMethodPUT]];
        [self.manager.router.routeSet addRoute:[RKRoute routeWithClass:[VKIMMucData class]
                                                           pathPattern:@"sessions/:session.sessionID/mucs/:mucID"
                                                                method:RKRequestMethodDELETE]];
        [self.manager.router.routeSet addRoute:[RKRoute routeWithClass:[VKIMMucData class]
                                                           pathPattern:@"sessions/:session.sessionID/mucs"
                                                                method:RKRequestMethodPOST]];
        
        
        [self.manager.router.routeSet addRoute:[RKRoute routeWithRelationshipName:@"messages"
                                                                      objectClass:[VKIMSessionData class]
                                                                      pathPattern:@"sessions/:sessionID/messages"
                                                                           method:RKRequestMethodGET]];
        [self.manager.router.routeSet addRoute:[RKRoute routeWithRelationshipName:@"contacts"
                                                                      objectClass:[VKIMSessionData class]
                                                                      pathPattern:@"sessions/:sessionID/contacts"
                                                                           method:RKRequestMethodGET]];
        [self.manager.router.routeSet addRoute:[RKRoute routeWithRelationshipName:@"mucs"
                                                                      objectClass:[VKIMSessionData class]
                                                                      pathPattern:@"sessions/:sessionID/mucs"
                                                                           method:RKRequestMethodGET]];
        [self.manager.router.routeSet addRoute:[RKRoute routeWithRelationshipName:@"feed"
                                                                      objectClass:[VKIMSessionData class]
                                                                      pathPattern:@"sessions/:sessionID/feed"
                                                                           method:RKRequestMethodGET]];
        [self.manager.router.routeSet addRoute:[RKRoute routeWithRelationshipName:@"chat"
                                                                      objectClass:[VKIMContactData class]
                                                                      pathPattern:@"sessions/:session.sessionID/contacts/:contactID/messages"
                                                                           method:RKRequestMethodGET]];
    }
    
    return self;
}

@end
