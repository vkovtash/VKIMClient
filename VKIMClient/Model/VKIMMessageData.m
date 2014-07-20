//
//  VKIMMessageData.m
//  SecurIM
//
//  Created by kovtash on 11.03.13.
//  Copyright (c) 2013 Vlad Kovtash. All rights reserved.
//

#import "VKIMMessageData.h"

@interface VKIMMessageData()
@property (strong, nonatomic) id <VKIMContactProtocol> contact;
@end

@implementation VKIMMessageData

- (instancetype) initWithContact:(id) contact {
    if (![contact conformsToProtocol:@protocol(VKIMContactProtocol)]) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        _contact = contact;
    }
    return self;
}

- (NSDate *) messageDate{
    return [NSDate dateWithTimeIntervalSince1970:[self.timestamp integerValue]];
}

- (id) copyWithZone:(NSZone *)zone{    
    id copy = [[[self class] allocWithZone:zone] initWithContact:self.contact];
    if (copy){
        [copy setText:[self.text copyWithZone:zone]];
        [copy setContactID:self.contactID];
        [copy setInbound:self.inbound];
        [copy setEventID:self.eventID];
        [copy setTimestamp:self.timestamp];
    }
    return copy;
}

- (BOOL) isEqual:(id)object{
    if ([object isKindOfClass:[self class]]) {
        if (self.sortID && [object sortID]) {
            return self.sortID == [object sortID];
        }
        else if (self.messageID && [object messageID]){
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
