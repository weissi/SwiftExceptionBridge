//
//  JFWSwiftExceptionBridge.m
//  SwiftExceptionBridge
//
//  Created by Johannes Weiß on 28/01/2015.
//  Copyright (c) 2015 Johannes Weiß. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JFWSwiftExceptionBridge.h"

@interface JFWResultOrException ()

@property (nonatomic, readonly, assign) BOOL success;
@property (nonatomic, readonly, strong) id result;
@property (nonatomic, readonly, strong) NSException *exception;

@end

@implementation JFWResultOrException

- (instancetype)init
{
    abort();
}

- (instancetype)initWithResult:(id)result exception:(NSException *)exception
{
    NSAssert(((result && !exception) || (!result && exception)), @"illegal values passed");
    if ((self = [super init])) {
        self->_success = !!result;
        self->_result = result;
        self->_exception = exception;
    }
    return self;
}

- (BOOL)isSuccessful
{
    return self.success;
}

- (NSString *)description
{
    if ([self isSuccessful]) {
        return [NSString stringWithFormat:@"Result(%@)", self.result];
    } else {
        return [NSString stringWithFormat:@"Exception(%@)", self.exception];
    }
}

@end

@implementation JFWSwiftExceptionBridge

+ (void)swiftBridgeTry:(void(^)(void))tryBlock
                except:(void(^)(NSException *))exceptBlock
               finally:(void(^)(void))finallyBlock
{
    @try {
        (tryBlock ?: ^() {})();
    }
    @catch (NSException *exception) {
        (exceptBlock ?: ^(NSException *e) {})(exception);
    }
    @finally {
        (finallyBlock ?: ^() {})();
    }
}

+ (void)swiftBridgeTry:(void(^)(void))tryBlock
                except:(void(^)(NSException *))exceptBlock
{
    [self swiftBridgeTry:tryBlock except:exceptBlock finally:nil];
}

+ (JFWResultOrException *)swiftBridgeResultTry:(id(^)(void))tryBlock
{
    __block JFWResultOrException *roe = nil;
    [self swiftBridgeTry:^{
        id result = tryBlock();
        roe = [[JFWResultOrException alloc] initWithResult:result exception:nil];
    }
                  except:^(NSException *ex) {
                      roe = [[JFWResultOrException alloc] initWithResult:nil exception:ex];

                  }];
    NSAssert(roe, @"BUG in JFWSwiftExceptionBridge: neither result nor exception");
    return roe;
}

@end
