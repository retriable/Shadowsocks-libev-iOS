//
//  SSLocalServerConfig.m
//  Shadowsocks-libev-iOS
//
//  Created by retriable on 2019/5/28.
//  Copyright © 2019 retriable. All rights reserved.
//

#import "SSLocalServerConfig.h"

@implementation SSLocalServerConfig


- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self=[self init];
    if (!self) return nil;
    self.remote_host=[aDecoder decodeObjectForKey:@"remote_host"];
    self.local_addr=[aDecoder decodeObjectForKey:@"local_addr"];
    self.method=[aDecoder decodeObjectForKey:@"method"];
    self.password=[aDecoder decodeObjectForKey:@"password"];
    self.remote_port=[aDecoder decodeIntForKey:@"remote_port"];
    self.local_port=[aDecoder decodeIntForKey:@"local_port"];
    self.timeout=[aDecoder decodeIntForKey:@"timeout"];
    self.acl=[aDecoder decodeObjectForKey:@"acl"];
    self.log=[aDecoder decodeObjectForKey:@"log"];
    self.fast_open=[aDecoder decodeIntForKey:@"fast_open"];
    self.mode=[aDecoder decodeIntForKey:@"mode"];
    self.mtu=[aDecoder decodeIntForKey:@"mtu"];
    self.mptcp=[aDecoder decodeIntForKey:@"mptcp"];
    self.verbose=[aDecoder decodeIntForKey:@"verbose"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.remote_host forKey:@"remote_host"];
    [aCoder encodeObject:self.local_addr forKey:@"local_addr"];
    [aCoder encodeObject:self.method forKey:@"method"];
    [aCoder encodeObject:self.password forKey:@"password"];
    [aCoder encodeInt:self.remote_port forKey:@"remote_port"];
    [aCoder encodeInt:self.local_port forKey:@"local_port"];
    [aCoder encodeInt:self.timeout forKey:@"timeout"];
    [aCoder encodeObject:self.acl forKey:@"acl"];
    [aCoder encodeObject:self.log forKey:@"log"];
    [aCoder encodeInt:self.fast_open forKey:@"fast_open"];
    [aCoder encodeInt:self.mode forKey:@"mode"];
    [aCoder encodeInt:self.mtu forKey:@"mtu"];
    [aCoder encodeInt:self.mptcp forKey:@"mptcp"];
    [aCoder encodeInt:self.verbose forKey:@"verbose"];
}

+ (BOOL)supportsSecureCoding{
    return YES;
}

@end
