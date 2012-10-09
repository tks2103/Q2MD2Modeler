//
//  MD2Model.h
//  Q2MD2Modeler
//
//  Created by Tanoy Sinha on 10/8/12.
//  Copyright (c) 2012 Tanoy Sinha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MD2Helper.h"

@interface MD2Model : NSObject {
    md2_t       header;
    frame_t*    frames;
    triangle_t* triangles;
    GLKVector3* baseVertices;
    GLKVector3* calculatedFrameVertices;
}

@property (readonly) md2_t          header;
@property (readonly) frame_t*       frames;
@property (readonly) triangle_t*    triangles;
@property (readonly) GLKVector3*    calculatedFrameVertices;

-(id) initWithFile:(NSString*) fileName;
-(void) loadFile:(NSString*) fileName;
-(void) generateVertices;
-(void) calculateFrameVerticesForFrame:(int)frameNum;
-(GLKVector3*) getVerticesForFrame:(int)frameNum;



@end
