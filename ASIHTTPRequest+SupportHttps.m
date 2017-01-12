//
//  ASIHTTPRequest+SupportHttps.m
//  FanXing
//
//  Created by 梁慧聪 on 2017/1/12.
//  Copyright © 2017年 kugou. All rights reserved.
//

#import "ASIHTTPRequest+SupportHttps.h"
//#import <objc/objc.h>
//#import <objc/runtime.h>
@implementation ASIHTTPRequest (SupportHttps)

-(id)safePerformSelector:(SEL)aSelector{
    if ([self respondsToSelector:aSelector]) {
        return [self performSelector:aSelector];
    }
    return nil;
}
-(void)setReadStream:(NSInputStream *)readStream2{
    if(readStream) {
        CFRelease(readStream);
    }
    readStream = readStream2;
    
    if (readStream) {
        CFRetain(readStream);
        [self sslMaker];
    }
}
-(void)sslMaker{
    //假如不是证书验证的https
    if ([[[[self url] scheme] lowercaseString] isEqualToString:@"https"] && !clientCertificateIdentity) {
        //阻止进入ASI原来代码的的无证书SSL认证里面判断里面
        [self setValidatesSecureCertificate:YES];
        //同时阻止进入有证书验证
        [self setClientCertificateIdentity:nil];
        //数据读取流对象已经创建
        if (readStream) {
            //阻止成功后，添加SSL验证
            NSMutableDictionary *sslProperties = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                  [NSNumber numberWithBool:YES], kCFStreamSSLAllowsExpiredCertificates,
                                                  [NSNumber numberWithBool:YES], kCFStreamSSLAllowsAnyRoot,
                                                  [NSNumber numberWithBool:NO],  kCFStreamSSLValidatesCertificateChain,
                                                  kCFNull,kCFStreamSSLPeerName,
                                                  nil];
            //支持SSL验证
            [sslProperties setObject:(NSString *)(CFStringRef*)kCFStreamSocketSecurityLevelSSLv3 forKey:(NSString *)kCFStreamSSLLevel];
            CFReadStreamSetProperty((CFReadStreamRef)readStream,
                                    kCFStreamPropertySSLSettings,
                                    (CFTypeRef)sslProperties);
            [sslProperties release];
           
        }
    }
    //继续跑原来的代码
//    [self safePerformSelector:@selector(startRequestOri)];
}

//+(void)load{
//    //原方法
//    Method startRequest = class_getInstanceMethod([self class], @selector(startRequest));
//    //ssl认证方法
//    Method sslMaker = class_getInstanceMethod([self class], @selector(sslMaker));
//    //原方法IMP
//    IMP startRequestIMP = method_getImplementation(startRequest);
//    //原方法绑定在startRequestOri
//    class_addMethod([self class], @selector(startRequestOri), startRequestIMP, method_getTypeEncoding(startRequest));
//    IMP sslMakerIMP = method_getImplementation(sslMaker);
//    class_replaceMethod([self class], @selector(startRequest), sslMakerIMP, method_getTypeEncoding(startRequest));
//}
@end
