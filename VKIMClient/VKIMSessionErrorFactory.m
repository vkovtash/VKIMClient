//
//  VKIMSessionErrorFactory.m
//  VKIMClient
//
//  Created by Vlad Kovtash (v.kovtash@gmail.com) on 22.04.13.
//  Copyright (c) 2013 Vlad Kovtash. All rights reserved.
//

#import "VKIMSessionErrorFactory.h"

NSString *const VKIMSessionErrorDomain = @"VKIMSessionErrorDomain";

@implementation VKIMSessionErrorFactory
+ (NSError *) operationIsNotPermittedInCurentState{
    NSError *error = [[NSError alloc] initWithDomain:VKIMSessionErrorDomain
                                                code:VKIMSessionOperationIsNotPermittedInCurrentStateError
                                            userInfo:@{NSLocalizedDescriptionKey:@"Operation is not permitted in current state."}];
    return error;
}
@end
