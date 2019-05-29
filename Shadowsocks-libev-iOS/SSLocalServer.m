//
//  SSLocalServer.m
//  Shadowsocks-libev-iOS
//
//  Created by retriable on 2019/5/28.
//  Copyright © 2019 retriable. All rights reserved.
//

#import <pthread.h>

#import "shadowsocks.h"
#import "SSLocalServer.h"

@interface SSLocalServer ()
{
    pthread_t _thread;
}
@property (nonatomic,strong)SSLocalServerConfig *config;
@property (nonatomic,copy)void(^callback)(NSError *error);

@end

static void *p_ss_local_callback(int socks_fd, int udp_fd, void *data){
    SSLocalServer *server=(__bridge SSLocalServer*)data;
    if (server.callback) server.callback(nil);
    return NULL;
}

static void *p_start_ss_local_server(void *data){
    SSLocalServer *server=(__bridge SSLocalServer*)data;
    SSLocalServerConfig *config=server.config;
    profile_t profile;
    profile.remote_host=config.remote_host.UTF8String;
    profile.local_addr=config.local_addr.UTF8String;
    profile.method=config.method.UTF8String;
    profile.password=config.password.UTF8String;
    profile.remote_port=config.remote_port;
    profile.local_port=config.local_port;
    profile.timeout=config.timeout;
    profile.acl=config.acl.UTF8String;
    profile.log=config.log.UTF8String;
    profile.fast_open=config.fast_open;
    profile.mode=config.mode;
    profile.mtu=config.mtu;
    profile.mptcp=config.mptcp;
    profile.verbose=config.verbose;
    int res = start_ss_local_server_with_callback(profile,p_ss_local_callback,data);
    if (0==res) return NULL;
    if (server.callback) server.callback([NSError errorWithDomain:NSPOSIXErrorDomain code:res userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(@"fail to start ss local server", nil)}]);
    return NULL;
}

@implementation SSLocalServer

- (void)dealloc{
    [self stop];
}

- (void)startWithConfig:(SSLocalServerConfig*)config callback:(void(^)(NSError *error))callback{
    self.config   = config;
    self.callback = callback;
    int res=pthread_create(&_thread, NULL, start_ss_local_server, (__bridge void *)self);
    if (0==res) return;
    if (callback) callback([NSError errorWithDomain:NSPOSIXErrorDomain code:res userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(@"fail to create pthread", nil)}]);
}

- (void)stop{
   
    pthread_kill(_thread, 0);
}

@end
