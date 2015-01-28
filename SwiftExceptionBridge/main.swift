//
//  main.swift
//  SwiftExceptionBridge
//
//  Created by Johannes Weiß on 28/01/2015.
//  Copyright (c) 2015 Johannes Weiß. All rights reserved.
//

import Foundation

func exceptionTrowingFunctionWithResult() -> NSTask {
    let t : NSTask = NSTask()
    t.launchPath = "/does/not/exist"
    t.launch() /* will throw exception */
    return t
}

func exceptionThrowingFunction() {
    exceptionTrowingFunctionWithResult()
}

func nonThrowingFunctionWithResult() -> NSString {
    return NSString(bytes: "works", length: 5, encoding: NSUTF8StringEncoding) ?? NSString()
}

func nonThrowingFunction() {
}

println("Hello, World!")
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

JFWSwiftExceptionBridge.swiftBridgeTry({
    nonThrowingFunction()
    },
    except: {
        print("[1b] EXCEPTION: \($0)\n")
    },
    finally: {
        () -> Void in
        print("[1b] FINALLY\n")
})


JFWSwiftExceptionBridge.swiftBridgeTry(exceptionThrowingFunction,
    except: {
        print("[2a] EXCEPTION: \($0)\n")
})

JFWSwiftExceptionBridge.swiftBridgeTry(nonThrowingFunction,
    except: {
        print("[2b] EXCEPTION: \($0)\n")
})


let roe_a = JFWSwiftExceptionBridge.swiftBridgeResultTry { () -> AnyObject! in
    exceptionTrowingFunctionWithResult()
}
print("[3a] RESULT OR EXCEPTION: \(roe_a)\n")
let roe_b = JFWSwiftExceptionBridge.swiftBridgeResultTry { () -> AnyObject! in
    nonThrowingFunctionWithResult()
}
print("[3b] RESULT OR EXCEPTION: \(roe_b)\n")

