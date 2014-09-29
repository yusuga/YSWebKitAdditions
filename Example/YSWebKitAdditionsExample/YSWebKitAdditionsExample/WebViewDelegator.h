//
//  WebViewDelegator.h
//  YSWebKitAdditionsExample
//
//  Created by Yu Sugawara on 2014/09/29.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import <Foundation/Foundation.h>
@import WebKit;

typedef void(^WebViewDelegatorDidFinishNavigation)(WKWebView *webView, WKNavigation *navigation);
typedef void(^WebViewDelegatorDidFailProvisionalNavigation)(WKWebView *webView, WKNavigation *navigation, NSError *error);
typedef void(^WebViewDelegatorDidFailNavigation)(WKWebView *webView, WKNavigation *navigation, NSError *error);

@interface WebViewDelegator : NSObject <WKNavigationDelegate, WKUIDelegate>

- (instancetype)initWithWebView:(WKWebView*)webView;

- (void)configureDelegationHandlersWithDidFinishNavigation:(WebViewDelegatorDidFinishNavigation)didFinishNavigation
                              didFailProvisionalNavigation:(WebViewDelegatorDidFailProvisionalNavigation)didFailProvisionalNavigation
                                         didFailNavigation:(WebViewDelegatorDidFailNavigation)didFailNavigation;

@end
