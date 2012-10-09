//
//  Q2Scene.m
//  Q2MD2Modeler
//
//  Created by Tanoy Sinha on 10/3/12.
//  Copyright (c) 2012 Tanoy Sinha. All rights reserved.
//

#import "Q2Scene.h"

@implementation Q2Scene

-(id) init {
    self = [super init];
    if (self) {
        //sprite = [[Q2Sprite alloc] initWithFile:@"/Users/tsinha/Downloads/q2mdl-storm/tris.md2"];
        sprite = [[Q2Sprite alloc] initWithFile:@"/Users/tsinha/Downloads/quake2/baseq2/players/male/w_railgun.md2"];
    }
    return self;
}

-(void) update {
    [sprite update];
}

-(void) render {
    glClearColor(0.7, 0.7, 0.7, 0.7);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    [sprite render];
}

@end
