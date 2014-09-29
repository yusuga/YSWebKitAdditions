//
//  WKWebView+YSWebKitAdditions.h
//  YSWebKitAdditionsExample
//
//  Created by Yu Sugawara on 2014/09/29.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

@import WebKit;

typedef void(^YSWebKitAdditionsJavaScriptHTMLCompletion)(NSString *string);

typedef NS_ENUM(NSUInteger, YSWKWebViewOGPProperty) {
    YSWKWebViewOGPPropertyTitle,
    YSWKWebViewOGPPropertyType,
    YSWKWebViewOGPPropertyImage,
    YSWKWebViewOGPPropertyURL,
};

extern NSString *ys_NSStringFromWKNavigationType(WKNavigationType type);
extern UIWebViewNavigationType ys_UIWebViewNavigationTypeFromWKNavigationType(WKNavigationType type);

@interface WKWebView (YSWebKitAdditions)

/* HTML */
- (void)ys_htmlWithCompletion:(YSWebKitAdditionsJavaScriptHTMLCompletion)completion;
- (void)ys_htmlHeadWithCompletion:(YSWebKitAdditionsJavaScriptHTMLCompletion)completion;
- (void)ys_htmlBodyWithCompletion:(YSWebKitAdditionsJavaScriptHTMLCompletion)completion;

/* OGP */
- (void)ys_ogpForProperty:(YSWKWebViewOGPProperty)property
           withCompletion:(YSWebKitAdditionsJavaScriptHTMLCompletion)completion;

/* apple-touch-icon */
- (void)ys_appleTouchIconURLStringOfLinkTagWithCompletion:(YSWebKitAdditionsJavaScriptHTMLCompletion)completion;

/* Others */
- (void)ys_disableLongPressActionSheet;

@end
