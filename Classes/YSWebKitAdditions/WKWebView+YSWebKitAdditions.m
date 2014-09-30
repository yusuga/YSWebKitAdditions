//
//  WKWebView+YSWebKitAdditions.m
//  YSWebKitAdditionsExample
//
//  Created by Yu Sugawara on 2014/09/29.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import "WKWebView+YSWebKitAdditions.h"
#import <YSCocoaLumberjackHelper/YSCocoaLumberjackHelper.h>

NSString *ys_NSStringFromWKNavigationType(WKNavigationType type)
{
    switch (type) {
        case WKNavigationTypeLinkActivated:
            return @"WKNavigationTypeLinkActivated";
        case WKNavigationTypeFormSubmitted:
            return @"WKNavigationTypeFormSubmitted";
        case WKNavigationTypeBackForward:
            return @"WKNavigationTypeBackForward";
        case WKNavigationTypeReload:
            return @"WKNavigationTypeReload";
        case WKNavigationTypeFormResubmitted:
            return @"WKNavigationTypeFormResubmitted";
        case WKNavigationTypeOther:
            return @"WKNavigationTypeOther";
        default:
            DDLogError(@"%s Unsupported type: %zd", __func__, type);
            return [NSString stringWithFormat:@"Unsupported WKNavigationType: %zd", type];
    }
}

UIWebViewNavigationType ys_UIWebViewNavigationTypeFromWKNavigationType(WKNavigationType type)
{
    switch (type) {
        case WKNavigationTypeLinkActivated:
            return UIWebViewNavigationTypeLinkClicked;
        case WKNavigationTypeFormSubmitted:
            return UIWebViewNavigationTypeFormSubmitted;
        case WKNavigationTypeBackForward:
            return UIWebViewNavigationTypeBackForward;
        case WKNavigationTypeReload:
            return UIWebViewNavigationTypeReload;
        case WKNavigationTypeFormResubmitted:
            return UIWebViewNavigationTypeFormResubmitted;
        default: DDLogError(@"%s, Unsupported type: %zd", __func__, type);
        case WKNavigationTypeOther:
            return UIWebViewNavigationTypeOther;
    }
}

@implementation WKWebView (YSWebKitAdditions)

#pragma mark - html

- (void)ys_htmlWithCompletion:(YSWebKitAdditionsJavaScriptHTMLCompletion)completion
{
    [self evaluateJavaScript:@"document.getElementsByTagName('html')[0].outerHTML" HTMLCompletionHandler:completion];
}

- (void)ys_htmlHeadWithCompletion:(YSWebKitAdditionsJavaScriptHTMLCompletion)completion
{
    [self evaluateJavaScript:@"document.head.innerHTML" HTMLCompletionHandler:completion];
}

- (void)ys_htmlBodyWithCompletion:(YSWebKitAdditionsJavaScriptHTMLCompletion)completion
{
    [self evaluateJavaScript:@"document.body.innerHTML" HTMLCompletionHandler:completion];
}

#pragma mark - OGP

/* http://ogp.me */

- (void)ys_ogpForProperty:(YSWKWebViewOGPProperty)property
           withCompletion:(YSWebKitAdditionsJavaScriptHTMLCompletion)completion
{
    NSString *propertyStr;
    switch (property) {
        case YSWKWebViewOGPPropertyTitle:
            propertyStr = @"og:title";
            break;
        case YSWKWebViewOGPPropertyType:
            propertyStr = @"og:type";
            break;
        case YSWKWebViewOGPPropertyImage:
            propertyStr = @"og:image";
            break;
        case YSWKWebViewOGPPropertyURL:
            propertyStr = @"og:url";
            break;
        default:
            NSAssert1(false, @"Unsupported property: %zd", property);
            return;
    }
    
    NSString *js = [NSString stringWithFormat:@""
                    "var metas = document.getElementsByTagName('meta');"
                    "for (i = 0; i < metas.length; i++) {"
                    "    if (metas[i].getAttribute(\"property\") == \"%@\") {"
                    "        metas[i].getAttribute(\"content\");"
                    "    }"
                    "}", propertyStr];
    
    return [self evaluateJavaScript:js HTMLCompletionHandler:completion];
}

/**
 apple-touch-icon
 https://developer.apple.com/library/ios/documentation/AppleApplications/Reference/SafariWebContent/ConfiguringWebApplications/ConfiguringWebApplications.html
 https://developer.apple.com/jp/devcenter/ios/library/documentation/userexperience/conceptual/mobilehig/WebClipIcons/WebClipIcons.html
 
 ex) http://google.com/
 <link href="/images/apple-touch-icon-120x120.png" rel="apple-touch-icon" sizes="120x120">
 <link href="/images/apple-touch-icon-114x114.png" rel="apple-touch-icon" sizes="114x114">
 <link href="/images/apple-touch-icon-57x57.png" rel="apple-touch-icon">
 */

- (void)ys_appleTouchIconURLStringOfLinkTagWithCompletion:(YSWebKitAdditionsJavaScriptHTMLCompletion)completion
{
    NSString *js = @""
    "var links = document.getElementsByTagName('link');"
    "var link, size;"
    "for (i = 0; i < links.length; i++) {"
    "   if (links[i].getAttribute(\"rel\").search(\"^apple-touch-icon[\\w]*\") != -1) {"
    "       var tempLink = links[i].getAttribute(\"href\");"
    "       var tempSize = links[i].getAttribute(\"sizes\");"
    "       if (tempSize) {"
    "           if (size) {"
    "               if (parseInt(size) < parseInt(tempSize)) {"
    "                   link = tempLink;"
    "                   size = tempSize;"
    "               }"
    "           } else {"
    "               link = tempLink;"
    "               size = tempSize;"
    "           }"
    "       } else if (!link) {"
    "           link = tempLink;"
    "       }"
    "   }"
    "}"
    "link;";
    
    [self evaluateJavaScript:js HTMLCompletionHandler:^(NSString *href) {
        NSURL *url = [NSURL URLWithString:href];
        if (href.length && url.host == nil) {
            NSString *baseURLStr = [NSString stringWithFormat:@"%@://%@", self.URL.scheme, self.URL.host];
            url = [NSURL URLWithString:[baseURLStr stringByAppendingPathComponent:href]];
            href = url.absoluteString;
        }
        if (completion) completion(href.length ? href : nil);
    }];
}

#pragma mark -

- (void)ys_disableLongPressActionSheet
{
    [self evaluateJavaScript:@"document.body.style.webkitTouchCallout = 'none'" completionHandler:^(id obj, NSError *error) {
        if (error) {
            NSLog(@"Error: %s, %@", __func__, error);
        }
    }];
}

#pragma mark - Utility

- (void)evaluateJavaScript:(NSString *)javaScriptString HTMLCompletionHandler:(YSWebKitAdditionsJavaScriptHTMLCompletion)completion
{
    [self evaluateJavaScript:javaScriptString completionHandler:^(NSString *str, NSError *error) {
        if (completion) completion(str.length && error == nil ? str : nil);
    }];
}

@end
