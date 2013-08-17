//
//  VKIMSessionErrorFactory.h
//  VKIMClient
//
//  Created by Vlad Kovtash (v.kovtash@gmail.com) on 22.04.13.
//  Copyright (c) 2013 Vlad Kovtash. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const VKIMSessionErrorDomain;

typedef enum VKIMSessionErrorCodes{
    VKIMSessionOperationIsNotPermittedInCurrentStateError
} VKIMSessionErrorCodes;

@interface VKIMSessionErrorFactory : NSObject
+ (NSError *) operationIsNotPermittedInCurentState;
@end
