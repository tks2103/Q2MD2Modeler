//
//  Q2Sprite.h
//  Q2MD2Modeler
//
//  Created by Tanoy Sinha on 10/3/12.
//  Copyright (c) 2012 Tanoy Sinha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "MD2Helper.h"
#import "MD2Model.h"

@interface Q2Sprite : NSObject {
    NSMutableData *vertexColorData;
    int num_tris;
    float xrotation;
    float zrotation;
    
    MD2Model *model;
}
@property float xrotation;
@property float zrotation;

-(id) initWithFile:(NSString*)fileName;
-(void)render;
-(void)update;

@end


