//
//  JFWSwiftExceptionBridge.h
//  SwiftExceptionBridge
//
//  Created by Johannes Weiß on 28/01/2015.
//  Copyright (c) 2015 Johannes Weiß. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JFWResultOrException : NSObject

- (BOOL)isSuccessful;
- (id)result;
- (NSException *)exception;

@end

@interface JFWSwiftExceptionBridge : NSObject

+ (void)swiftBridgeTry:(void(^)(void))tryBlock
                except:(void(^)(NSException *))exceptBlock
               finally:(void(^)(void))finallyBlock;

+ (void)swiftBridgeTry:(void(^)(void))tryBlock
                except:(void(^)(NSException *))exceptBlock;

+ (JFWResultOrException *)swiftBridgeResultTry:(id(^)(void))tryBlock;

@end
