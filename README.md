SwiftExceptionBridge
===

Disclaimer
--

 - I am very happy Swift does not have exceptions, I much rather hope to see a later addition of [Computational Expressions][comp-expr] or so.
 - I do _not_ want to encourage you to use exceptions.
 - By default [exceptions leak memory when combined with ARC](http://clang.llvm.org/docs/AutomaticReferenceCounting.html#exceptions) (you can use `clang -fobjc-arc-exceptions`).
 - Unfortunately, there are times when you can't get around catching an exception (`NSTask`, `NSFileHandle`, KVO, ...) in Cocoa and currently Swift doesn't allow you to do so.
 - This is a quick prototype not ready for production probably.
 - This repo contains a full Xcode project including all the code (Swift and ObjC).
 
Proposed Workaround
--

The following [interface][header-file]

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

does allow you to use them from Swift ([full swift example][swift-sample]). Example:

A full try/catch/finally:

```
JFWSwiftExceptionBridge.swiftBridgeTry({
    exceptionThrowingFunction()
    },
    except: {
        print("CAUGHT EXCEPTION: \($0)\n")
        },
    finally: {
        () -> Void in
        print("FINALLY\n")
})
```

Try/catch only:

```
JFWSwiftExceptionBridge.swiftBridgeTry(exceptionThrowingFunction,
    except: {
        print("CAUGHT EXCEPTION: \($0)\n")
})
```

Or rather an `Either`-like type which wraps either the result (type `id`) as returned from the function or the exception if the function threw an exception:

```
let roe = JFWSwiftExceptionBridge.swiftBridgeResultTry { () -> AnyObject! in
    return exceptionTrowingFunctionWithResult()
}
print("RESULT OR EXCEPTION: \(roe)\n")
```

The output then looks either like

```
RESULT OR EXCEPTION: Result(works)
```

if it worked and the string `"works"` was returned, or like that


```
RESULT OR EXCEPTION: Exception(<DESCRIPTION OF EXCEPTION>)
```

if an exception appeared.


[header-file]: https://github.com/weissi/SwiftExceptionBridge/blob/master/SwiftExceptionBridge/JFWSwiftExceptionBridge.h
[swift-sample]: https://github.com/weissi/SwiftExceptionBridge/blob/master/SwiftExceptionBridge/main.swift
[comp-expr]: https://msdn.microsoft.com/en-us/library/dd233182.aspx



