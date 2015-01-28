SwiftExceptionBridge
===

Disclaimer
--

 - I am very happy Swift does not have exceptions
 - I do _not_ want to encourage you to use exceptions
 - Exceptions leak memory when combined with ARC (you can use `clang -fobjc-arc-exceptions`)
 - there are times when you can't get around catching an exception (`NSTask`, `NSFileHandle`, KVO, ...) and currently Swift doesn't allow you to catch exceptions
 
Proposed Workaround
--

The following interface

```
@interface JFWSwiftExceptionBridge : NSObject

+ (void)swiftBridgeTry:(void(^)(void))tryBlock
                except:(void(^)(NSException *))exceptBlock
               finally:(void(^)(void))finallyBlock;

+ (void)swiftBridgeTry:(void(^)(void))tryBlock
                except:(void(^)(NSException *))exceptBlock;

+ (JFWResultOrException *)swiftBridgeResultTry:(id(^)(void))tryBlock;

@end
```

does allow you to use them from Swift. Example:

A full try/catch/finally:

```
JFWSwiftExceptionBridge.swiftBridgeTry({
    exceptionThrowingFunction()
    },
    except: {
        print("[1a] EXCEPTION: \($0)\n")
        },
    finally: {
        () -> Void in
        print("[1a] FINALLY\n")
})
```

Try/catch only:

```
JFWSwiftExceptionBridge.swiftBridgeTry(exceptionThrowingFunction,
    except: {
        print("[2a] EXCEPTION: \($0)\n")
})
```

Or rather an `Either` like type which wraps either the result (type `id`) or the exception:

```
let roe_a = JFWSwiftExceptionBridge.swiftBridgeResultTry { () -> AnyObject! in
    exceptionTrowingFunctionWithResult()
}
```




