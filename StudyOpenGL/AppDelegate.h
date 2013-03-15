//
//  AppDelegate.h
//  StudyOpenGL
//
//  Created by yuzhou on 13-3-14.
//  Copyright (c) 2013年 witmob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpenGLView.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) OpenGLView *glView;

@end
