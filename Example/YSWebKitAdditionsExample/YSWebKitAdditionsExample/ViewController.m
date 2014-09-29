//
//  ViewController.m
//  YSWebKitAdditionsExample
//
//  Created by Yu Sugawara on 2014/09/29.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import "ViewController.h"
@import WebKit;
#import "WebViewDelegator.h"

@interface ViewController () <WKNavigationDelegate, WKUIDelegate>

@property (nonatomic) WKWebView *webView;
@property (nonatomic) WebViewDelegator *delegator;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.webView.allowsBackForwardNavigationGestures = YES;
    
    self.delegator = [[WebViewDelegator alloc] initWithWebView:self.webView];
    [self.delegator configureDelegationHandlersWithDidFinishNavigation:^(WKWebView *webView, WKNavigation *navigation) {
        NSLog(@"Finish navigation");
    } didFailProvisionalNavigation:^(WKWebView *webView, WKNavigation *navigation, NSError *error) {
        NSLog(@"Fail provisional navigation");
    } didFailNavigation:^(WKWebView *webView, WKNavigation *navigation, NSError *error) {
        NSLog(@"Fail navigation");
    }];
    
    NSString *urlStr = @"https://google.com";
//    urlStr = @"http://www.pori2.net/js/kihon/4.html";
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    
    [self.view addSubview:self.webView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
