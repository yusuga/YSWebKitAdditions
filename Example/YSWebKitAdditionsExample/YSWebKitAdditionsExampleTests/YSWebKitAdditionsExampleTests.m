//
//  YSWebKitAdditionsExampleTests.m
//  YSWebKitAdditionsExampleTests
//
//  Created by Yu Sugawara on 2014/09/29.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "WKWebView+YSWebKitAdditions.h"
#import "WebViewDelegator.h"

@interface YSWebKitAdditionsExampleTests : XCTestCase <WKNavigationDelegate>

@property (nonatomic) WKWebView *webView;
@property (nonatomic) WebViewDelegator *delegator;

@end

@implementation YSWebKitAdditionsExampleTests

- (void)setUp
{
    [super setUp];
    [YSCocoaLumberjackHelper launchLogger];
    
    self.webView = [[WKWebView alloc] initWithFrame:[UIScreen mainScreen].bounds
                                      configuration:[[WKWebViewConfiguration alloc] init]];
    self.delegator = [[WebViewDelegator alloc] initWithWebView:self.webView];
}

- (void)tearDown
{
    [super tearDown];
}

#pragma mark - HTML

- (void)testHTML
{
    [self webViewWithRequestURLString:[self sampleURLString] process:^(WKWebView *webView, XCTestExpectation *subExpectation) {
        [webView ys_htmlWithCompletion:^(NSString *string) {
            XCTAssertTrue(string.length > 0);
            [subExpectation fulfill];
        }];
    }];
}

- (void)testHTMLHead
{
    [self webViewWithRequestURLString:[self sampleURLString] process:^(WKWebView *webView, XCTestExpectation *subExpectation) {
        [webView ys_htmlHeadWithCompletion:^(NSString *string) {
            XCTAssertTrue(string.length > 0);
            [subExpectation fulfill];
        }];
    }];
}

- (void)testHTMLBody
{
    [self webViewWithRequestURLString:[self sampleURLString] process:^(WKWebView *webView, XCTestExpectation *subExpectation) {
        [webView ys_htmlBodyWithCompletion:^(NSString *string) {
            XCTAssertTrue(string.length > 0);
            [subExpectation fulfill];
        }];
    }];
}
#pragma mark - OGP

- (void)testOGPTitle
{
    [self webViewWithRequestURLString:[self ogpURLString] process:^(WKWebView *webView, XCTestExpectation *subExpectation) {
        [webView ys_ogpForProperty:YSWKWebViewOGPPropertyTitle withCompletion:^(NSString *string) {
            XCTAssertTrue(string.length > 0);
            [subExpectation fulfill];
        }];
    }];
}

- (void)testOGPType
{
    [self webViewWithRequestURLString:[self ogpURLString] process:^(WKWebView *webView, XCTestExpectation *subExpectation) {
        [webView ys_ogpForProperty:YSWKWebViewOGPPropertyType withCompletion:^(NSString *string) {
            XCTAssertTrue(string.length > 0);
            [subExpectation fulfill];
        }];
    }];
}

- (void)testOGPImage
{
    [self webViewWithRequestURLString:[self ogpURLString] process:^(WKWebView *webView, XCTestExpectation *subExpectation) {
        [webView ys_ogpForProperty:YSWKWebViewOGPPropertyImage withCompletion:^(NSString *string) {
            XCTAssertTrue(string.length > 0);
            [subExpectation fulfill];
        }];
    }];
}

- (void)testOGPURL
{
    [self webViewWithRequestURLString:[self ogpURLString] process:^(WKWebView *webView, XCTestExpectation *subExpectation) {
        [webView ys_ogpForProperty:YSWKWebViewOGPPropertyURL withCompletion:^(NSString *string) {
            XCTAssertTrue(string.length > 0);
            [subExpectation fulfill];
        }];
    }];
}

#pragma mark - apple-touch-icon

- (void)testAppleTouchIconURL
{
    [self webViewWithRequestURLString:[self googleURLString] process:^(WKWebView *webView, XCTestExpectation *subExpectation) {
        [webView ys_appleTouchIconURLStringOfLinkTagWithCompletion:^(NSString *string) {
            XCTAssertTrue(string.length > 0);
            [subExpectation fulfill];
        }];
    }];
}

#pragma mark - Utility

- (void)webViewWithRequestURLString:(NSString*)urlStr process:(void(^)(WKWebView *webView, XCTestExpectation *subExpectation))process
{
    XCTestExpectation *expectation = [self expectationWithDescription:nil];
    XCTestExpectation *subExpectation = [self expectationWithDescription:nil];
    
    [self.delegator configureDelegationHandlersWithDidFinishNavigation:^(WKWebView *webView, WKNavigation *navigation) {
        process(webView, subExpectation);
        [expectation fulfill];
    } didFailProvisionalNavigation:^(WKWebView *webView, WKNavigation *navigation, NSError *error) {
        XCTFail(@"error: %@", error);
        [expectation fulfill];
    } didFailNavigation:^(WKWebView *webView, WKNavigation *navigation, NSError *error) {
        XCTFail(@"error: %@", error);
        [expectation fulfill];
    }];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    
    [self waitForExpectationsWithTimeout:10. handler:^(NSError *error) {
        XCTAssertNil(error, @"error: %@", error);
    }];
}

- (NSString*)sampleURLString
{
    return @"http://google.com";
}

- (NSString*)googleURLString
{
    return @"http://google.com";
}

- (NSString*)ogpURLString
{
    return @"http://samples.ogp.me/136756249803614";
}

@end
