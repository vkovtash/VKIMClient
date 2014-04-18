//
//  VKIMMessageData.m
//  SecurIM
//
//  Created by kovtash on 11.03.13.
//  Copyright (c) 2013 Vlad Kovtash. All rights reserved.
//

#import "VKIMMessageData.h"

@implementation VKIMMessageData
- (NSDate *) messageDate{
    return [NSDate dateWithTimeIntervalSince1970:[self.timestamp integerValue]];
}

- (id) copyWithZone:(NSZone *)zone{    
    id copy = [[[self class] allocWithZone:zone] init];
    if (copy){
        [copy setText:[self.text copyWithZone:zone]];
        [copy setInbound:self.inbound];
        [copy setContact:self.contact];
        [copy setContactID:[self.contactID copyWithZone:zone]];
        [copy setEventID:self.eventID];
        [copy setTimestamp:self.timestamp];
    }
    return copy;
}

- (BOOL) isEqual:(id)object{
    if ([object isKindOfClass:[self class]]) {
        if (self.messageID && [object messageID]){
            return [self.messageID isEqualToString:[object messageID]];
        }
        else{
            return [self.contactID isEqualToString:[object contactID]]
            && [self.text isEqualToString:[object text]]
            && self.inbound == [object inbound];
        }
    }
    else {
        return NO;
    }
}
@end
