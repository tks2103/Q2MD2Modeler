//
//  AppDelegate.h
//  Q2MD2Modeler
//
//  Created by Tanoy Sinha on 10/3/12.
//  Copyright (c) 2012 Tanoy Sinha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import "Q2Scene.h"
#import "Q2SceneController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, GLKViewControllerDelegate, GLKViewDelegate>
{
    Q2Scene *scene;
}

@property (strong, nonatomic) UIWindow *window;

#pragma mark GLKViewControllerDelegate
- (void)glkViewControllerUpdate:(GLKViewController *)controller;

#pragma mark GLKViewDelegate
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect;

@end
