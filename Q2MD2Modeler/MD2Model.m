//
//  MD2Model.m
//  Q2MD2Modeler
//
//  Created by Tanoy Sinha on 10/8/12.
//  Copyright (c) 2012 Tanoy Sinha. All rights reserved.
//

#import "MD2Model.h"

@implementation MD2Model

@synthesize header, frames, triangles, calculatedFrameVertices;

-(id) initWithFile:(NSString *)fileName {
    self = [super init];
    if (self) {
        [self loadFile:fileName];
        [self allocateMemory];
        [self generateVertices];
    }
    return self;
}

-(void) dealloc {
    for (int i = 0; i < header.num_frames; i++) {
        free(frames[i].vertices);
    }
    free(frames);
    free(triangles);
    free(baseVertices);
    free(calculatedFrameVertices);
}

-(void) loadFile:(NSString *)fileName {
    FILE *f;
    f = fopen([fileName cStringUsingEncoding:NSASCIIStringEncoding], "r");
    fread(&header, sizeof(md2_t), 1, f);
    
    triangles = (triangle_t *) malloc(sizeof(triangle_t)*header.num_triangles);
    frames = (frame_t *) malloc(sizeof(frame_t)*header.num_frames);
    
    fseek(f, header.offset_triangles, SEEK_SET);
    fread(triangles, sizeof(triangle_t), header.num_triangles, f);
    
    fseek(f, header.offset_frames, SEEK_SET);
    
    for (int i = 0; i < header.num_frames; i++) {
        frames[i].vertices = (vertex_t *) malloc(sizeof(vertex_t)*header.num_vertices);
        fread(&frames[i].scale, sizeof(GLKVector3), 1, f);
        fread(&frames[i].translation, sizeof(GLKVector3), 1, f);
        fread(&frames[i].name, sizeof(char), 16, f);
        fread(frames[i].vertices, sizeof(vertex_t), header.num_vertices, f);
    }
    
    fclose(f);
}

-(void) allocateMemory {
    calculatedFrameVertices = malloc(sizeof(GLKVector3) * header.num_triangles * 3 );
    baseVertices = malloc(sizeof(GLKVector3) * header.num_frames * header.num_vertices);
}

-(void) generateVertices {
    for (int i = 0 ; i < header.num_frames; i++) {
        GLKVector3 scale = frames[i].scale;
        GLKVector3 translation = frames[i].translation;
        for (int j = 0; j < header.num_vertices; j++) {
            baseVertices[i*header.num_vertices + j] = GLKVector3Make(frames[i].vertices[j].v[0] * scale.v[0] + translation.v[0],
                                                                     frames[i].vertices[j].v[1] * scale.v[1] + translation.v[1],
                                                                     frames[i].vertices[j].v[2] * scale.v[2] + translation.v[2]);
        }
    }
}

-(void) calculateFrameVerticesForFrame:(int)frameNum {
    int offset = frameNum * header.num_vertices;
    for (int i = 0; i < header.num_triangles; i++) {
        triangle_t tTri = triangles[i];
        calculatedFrameVertices[i*3]   = baseVertices[offset + tTri.vertex[0]];
        calculatedFrameVertices[i*3+1] = baseVertices[offset + tTri.vertex[1]];
        calculatedFrameVertices[i*3+2] = baseVertices[offset + tTri.vertex[2]];
    }
}

-(void) animateFrameVerticesForFrame:(int)frameNum withInterpolation:(float)interp {
    int offsetCurr = frameNum * header.num_vertices;
    int offsetNext = (frameNum + 1) * header.num_vertices;
    for (int i = 0; i < header.num_triangles; i++) {
        triangle_t tTri = triangles[i];
        
        GLKVector3 vCurr[3], vNext[3];
        vCurr[0] = baseVertices[offsetCurr + tTri.vertex[0]];
        vCurr[1] = baseVertices[offsetCurr + tTri.vertex[1]];
        vCurr[2] = baseVertices[offsetCurr + tTri.vertex[2]];
        
        vNext[0] = baseVertices[offsetNext + tTri.vertex[0]];
        vNext[1] = baseVertices[offsetNext + tTri.vertex[1]];
        vNext[2] = baseVertices[offsetNext + tTri.vertex[2]];
        
        calculatedFrameVertices[i*3]   = [self interpolateVertex:vCurr[0] with:vNext[0] atInterpolation:interp];
        calculatedFrameVertices[i*3+1] = [self interpolateVertex:vCurr[1] with:vNext[1] atInterpolation:interp];
        calculatedFrameVertices[i*3+2] = [self interpolateVertex:vCurr[2] with:vNext[2] atInterpolation:interp];
    }
}

-(GLKVector3) interpolateVertex:(GLKVector3)vCurr with:(GLKVector3)vNext atInterpolation:(float)interp {
    GLKVector3 v;
    
    v.v[0] = vCurr.v[0] + interp * (vNext.v[0] - vCurr.v[0]);
    v.v[1] = vCurr.v[1] + interp * (vNext.v[1] - vCurr.v[1]);
    v.v[2] = vCurr.v[2] + interp * (vNext.v[2] - vCurr.v[2]);
    
    return v;
}

@end
