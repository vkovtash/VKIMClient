//
//  VKIMSessionData.h
//  SecurIM
//
//  Created by kovtash on 13.03.13.
//  Copyright (c) 2013 Vlad Kovtash. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VKIMSessionData : NSObject
@property (strong,nonatomic) NSString *jid;
@property (strong,nonatomic) NSString *token;
@property (strong,nonatomic) NSString *sessionID;
@end
