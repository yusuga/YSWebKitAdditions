//
//  main.m
//  YSWebKitAdditionsExample
//
//  Created by Yu Sugawara on 2014/09/29.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        [LumberjackLauncher launchStandardLoggers];
        [LumberjackLauncher setXcodeConsoleLogColorsWithErrorColor:[UIColor redColor]
                                                      warningColor:[UIColor yellowColor]
                                                         infoColor:[UIColor darkGrayColor]
                                                        debugColor:[UIColor greenColor]
                                                      verboseColor:nil];
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
