//
//  SSLocalServer.h
//  Shadowsocks-libev-iOS
//
//  Created by retriable on 2019/5/28.
//  Copyright © 2019 retriable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSLocalServerConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface SSLocalServer : NSObject


- (void)startWithConfig:(SSLocalServerConfig*)config callback:(void(^)(NSError *error))callback;

- (void)stop;

@end

NS_ASSUME_NONNULL_END
