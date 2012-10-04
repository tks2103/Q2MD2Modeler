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

@interface Q2Sprite : NSObject {
    NSMutableData *vertexData;
    NSMutableData *triangleData;
    NSMutableData *vertexColorData;
    int num_xyz;
    int num_glcmds;
    int num_tris;
    const int *glcmds;
    triangle_t *triangles;
    float xrotation;
    float zrotation;
}

@property (readonly) GLKVector3 *vertices;
@property (readonly) GLKVector3 *fvertices;
@property (readonly) GLKVector4 *vertexColors;
@property (readonly) int numVertices;
@property (readonly) int numFVertices;
@property int num_xyz;
@property int num_tris;
@property int num_glcmds;
@property float xrotation;
@property float zrotation;

-(id) initWithFile:(NSString*)fileName;
-(void)readFile:(NSString*)fileName;
-(void)render;
-(void)update;

@end


