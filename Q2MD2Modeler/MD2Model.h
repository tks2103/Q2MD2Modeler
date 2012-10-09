//
//  MD2Model.h
//  Q2MD2Modeler
//
//  Created by Tanoy Sinha on 10/8/12.
//  Copyright (c) 2012 Tanoy Sinha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MD2Helper.h"
#import "MD2Texture.h"

@interface MD2Model : NSObject {
    md2_t               header;
    frame_t*            frames;
    triangle_t*         triangles;
    skin_t*             skins;
    texture_coord_t*    texture_coords;
    GLKVector3*         baseVertices;
    GLKVector3*         calculatedFrameVertices;
    GLKVector2*         calculatedTextureCoords;
    GLKTextureInfo*     texture;
}

@property (readonly) md2_t              header;
@property (readonly) frame_t*           frames;
@property (readonly) triangle_t*        triangles;
@property (readonly) skin_t*            skins;
@property (readonly) texture_coord_t*   texture_coords;
@property (readonly) GLKVector3*        calculatedFrameVertices;
@property (readonly) GLKVector2*        calculatedTextureCoords;
@property (readonly) GLKTextureInfo*    texture;

-(id) initWithFile:(NSString*) fileName;
-(void) loadFile:(NSString*) fileName;
-(void) allocateMemory;
-(void) generateVertices;
-(void) calculateFrameVerticesForFrame:(int)frameNum;
-(void) animateFrameVerticesForFrame:(int)frameNum withInterpolation:(float) interp;
-(GLKVector3) interpolateVertex:(GLKVector3) vCurr with:(GLKVector3) vNext atInterpolation:(float) interp;



@end
