//
//  VKIMContactData+stringsMapping.m
//  SecurIM
//
//  Created by kovtash on 09.06.13.
//  Copyright (c) 2013 Vlad Kovtash. All rights reserved.
//

#import "VKIMContactData+stringsMapping.h"

@implementation VKIMContactData (show)
- (NSString *) show{
    switch (self.state) {
        case VKIMContactAvailable:
            return @"online";
            
        case VKIMContactAway:
            return @"away";
            
        case VKIMContactDND:
            return @"dnd";
            
        default:
            return @"offline";
    }
}

- (void) setShow:(NSString *)show{
    if ([show isEqualToString:@"online"] || [show isEqualToString:@"chat"]) {
        self.state = VKIMContactAvailable;
    }
    else if ([show isEqualToString:@"away"] || [show isEqualToString:@"xa"]){
        self.state = VKIMContactAway;
    }
    else if ([show isEqualToString:@"dnd"]){
        self.state = VKIMContactDND;
    }
    else {
        self.state = VKIMContactOffline;
    }
}

- (NSString *) authorization{
    switch (self.authState) {
        case VKIMContactAuthorizationNone:
            return @"none";
            
        case VKIMContactAuthorizationRequested:
            return @"requested";
            
        case VKIMContactAuthorizationGranted:
            return @"granted";
            
        default:
            return @"unknown";
    }
}

- (void) setAuthorization:(NSString *)authorization{
    if ([authorization isEqualToString:@"granted"]){
        self.authState = VKIMContactAuthorizationGranted;
    }
    else if ([authorization isEqualToString:@"requested"]) {
        self.authState = VKIMContactAuthorizationRequested;
    }
    else{
        self.authState = VKIMContactAuthorizationNone;
    }
}

@end
