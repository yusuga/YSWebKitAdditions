//
//  WebViewDelegator.m
//  YSWebKitAdditionsExample
//
//  Created by Yu Sugawara on 2014/09/29.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import "WebViewDelegator.h"
#import "WKWebView+YSWebKitAdditions.h"

@interface WebViewDelegator ()

@property (copy, nonatomic) WebViewDelegatorDidFinishNavigation didFinishNavigation;
@property (copy, nonatomic) WebViewDelegatorDidFailProvisionalNavigation didFailProvisionalNavigation;
@property (copy, nonatomic) WebViewDelegatorDidFailNavigation didFailNavigation;

@end

@implementation WebViewDelegator

- (instancetype)initWithWebView:(WKWebView*)webView
{
    if (self = [super init]) {
        webView.navigationDelegate = self;
//        webView.UIDelegate = self;
    }
    return self;
}

- (void)configureDelegationHandlersWithDidFinishNavigation:(WebViewDelegatorDidFinishNavigation)didFinishNavigation
                              didFailProvisionalNavigation:(WebViewDelegatorDidFailProvisionalNavigation)didFailProvisionalNavigation
                                         didFailNavigation:(WebViewDelegatorDidFailNavigation)didFailNavigation
{
    self.didFinishNavigation = didFinishNavigation;
    self.didFailProvisionalNavigation = didFailProvisionalNavigation;
    self.didFailNavigation = didFailNavigation;
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    DDLogDebug(@"%s", __func__);
    NSLog(@"navigationType: %@", ys_NSStringFromWKNavigationType(navigationAction.navigationType));
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    DDLogDebug(@"%s", __func__);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    DDLogDebug(@"%s", __func__);
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation
{
    DDLogDebug(@"%s", __func__);
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    DDLogDebug(@"%s", __func__);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    DDLogDebug(@"%s", __func__);
    if (self.didFinishNavigation) self.didFinishNavigation(webView, navigation);
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    DDLogError(@"%s", __func__);
    DDLogError(@"error: %@", error);
    if (self.didFailProvisionalNavigation) self.didFailProvisionalNavigation(webView, navigation, error);
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    DDLogError(@"%s", __func__);
    DDLogError(@"error: %@", error);
    if (self.didFailNavigation) self.didFailNavigation(webView, navigation, error);
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler
{
    DDLogDebug(@"%s", __func__);
}

#pragma mark - WKUIDelegate

- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    DDLogDebug(@"%s", __func__);
    WKWebView *subWebView = [[WKWebView alloc] initWithFrame:webView.bounds configuration:configuration];
    [webView addSubview:subWebView];
    return subWebView;
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)())completionHandler
{
    DDLogDebug(@"%s", __func__);
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler
{
    DDLogDebug(@"%s", __func__);
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString *))completionHandler
{
    DDLogDebug(@"%s", __func__);
}

@end
