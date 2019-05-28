//
//  SSLocalServerConfig.h
//  Shadowsocks-libev-iOS
//
//  Created by retriable on 2019/5/28.
//  Copyright © 2019 retriable. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SSLocalServerConfig : NSObject <NSSecureCoding>

/*  Required  */
@property (nonatomic,copy  ) NSString *remote_host;// hostname or ip of remote server
@property (nonatomic,copy  ) NSString *local_addr;// local ip to bind
@property (nonatomic,copy  ) NSString *method;// encryption method
@property (nonatomic,copy  ) NSString *password;// password of remote server
@property (nonatomic,assign) int      remote_port;// port number of remote server
@property (nonatomic,assign) int      local_port;// port number of local server
@property (nonatomic,assign) int      timeout;// connection timeout

/*  Optional, set NULL if not valid   */
@property (nonatomic,copy  ) NSString *acl;// file path to acl
@property (nonatomic,copy  ) NSString *log;// file path to log
@property (nonatomic,assign) int      fast_open;// enable tcp fast open
@property (nonatomic,assign) int      mode;// enable udp relay
@property (nonatomic,assign) int      mtu;// MTU of interface
@property (nonatomic,assign) int      mptcp;// enable multipath TCP
@property (nonatomic,assign) int      verbose;// verbose mode

@end

NS_ASSUME_NONNULL_END
