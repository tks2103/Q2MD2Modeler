//
//  Q2Sprite.m
//  Q2MD2Modeler
//
//  Created by Tanoy Sinha on 10/3/12.
//  Copyright (c) 2012 Tanoy Sinha. All rights reserved.
//

#import "Q2Sprite.h"

const float vt[] = {
    -1.849518, 4.264053, 7.356142,
    -0.408870, 5.237117, 17.241039,
    10.636096, -6.739051, 14.717236,
    9.915772, -6.739051, 15.348186,
    7.914872, -6.215094, 12.403748,
    7.354621, -6.589349, 13.455334,
    7.914872, -6.215094, 12.403748,
    9.915772, -6.739051, 15.348186,
};



@implementation Q2Sprite

@synthesize num_xyz, num_glcmds, num_tris;

-(GLKVector3 *)vertices {
    if (vertexData == nil) {
        vertexData = [NSMutableData dataWithLength:sizeof(GLKVector3)*self.numVertices];
    }
    return [vertexData mutableBytes];
}

-(GLKVector3 *)fvertices {
    if (triangleData == nil) {
        triangleData = [NSMutableData dataWithLength:sizeof(GLKVector3)*self.numFVertices];
    }
    return [triangleData mutableBytes];
}

- (GLKVector4 *)vertexColors {
    if (vertexColorData == nil)
        vertexColorData = [NSMutableData dataWithLength:sizeof(GLKVector4)*self.numFVertices];
    return [vertexColorData mutableBytes];
}

-(int) numVertices {
    return num_xyz;
}

-(int) numFVertices {
    return num_tris * 3;
}

-(id)init {
    self = [super init];
    if (self) {
        num_xyz = 2;
    }
    return self;
}

-(id)initWithFile:(NSString *)fileName {
    self = [super init];
    if (self) {
        [self readFile:fileName];
        
    }
    return self;
}

-(void) readFile:(NSString *)fileName {
    NSData *rawData = [NSData dataWithContentsOfFile:fileName], *glData, *frameData, *triData;
    NSRange headerRange = {0, sizeof(md2_t)};
    md2_t header;
    
    header = *(md2_t *)[[rawData subdataWithRange:headerRange] bytes];
    
    num_xyz = header.num_xyz;
    num_glcmds = header.num_glcmds;
    num_tris = header.num_tris;
    
    NSRange frameRange = {header.ofs_frames, header.framesize};
    frameData = [rawData subdataWithRange:frameRange];
    NSRange glRange = {header.ofs_glcmds, header.num_glcmds * sizeof(int)};
    glData = [rawData subdataWithRange:glRange];
    NSRange triRange = {header.ofs_tris, header.num_tris* sizeof(triangle_t)};
    triData = [rawData subdataWithRange:triRange];
    
    FILE *fg;
    
    fg = fopen("/Users/tsinha/Downloads/q2mdl-storm/tris.md2", "r");
    fseek(fg, header.ofs_frames, SEEK_SET);
    
    triangles = (triangle_t *)[triData bytes];
    frame_t *frame = (frame_t*)[frameData bytes];
    
    //frame_t frame;
    
    //fread(&frame.scale, sizeof(vec3_t), 1, fg);
    //fread(&frame.translation, sizeof(vec3_t), 1, fg);
    //fread(&frame.name, sizeof(char), 16, fg);
    //fread(frame.vertex, sizeof(vertex_t), 357, fg);
    
    
    //NSLog(@"sizeof vertex_t %d", sizeof(vertex_t));
    
    //NSLog(@"scale: %f, %f, %f trans: %f, %f, %f", frame->scale[0], frame->scale[1], frame->scale[2], frame->translation[0], frame->translation[1], frame->translation[2]);
    
    for (int i = 0; i < num_xyz; i++) {
        
        //NSLog(@"unchanged: %d, %d, %d, %d", frame->vertex[i].v[0], frame->vertex[i].v[1], frame->vertex[i].v[2], frame->vertex[i].lightnormalindex);
        
        GLKVector3 temp = GLKVector3Make(frame->vertex[i].v[0] * frame->scale[0] + frame->translation[0],
                                         frame->vertex[i].v[1] * frame->scale[1] + frame->translation[1],
                                         frame->vertex[i].v[2] * frame->scale[2] + frame->translation[2]);
        //NSLog(@"changed: %f, %f, %f", temp.x, temp.y, temp.z);
        self.vertices[i] = temp;
    }
    
    //NSMutableData *tvData = [NSMutableData dataWithLength:sizeof(GLKVector3)*num_tris*3];
    //GLKVector3 *tvVerts = [tvData mutableBytes];
    
    for (int i =0; i < num_tris; i++) {
        self.fvertices[i*3] = self.vertices[triangles[i].vertex[0]];
        self.vertexColors[i*3] = GLKVector4Make(1, 0, 0, 1);
        //NSLog(@"vert1, %f, %f, %f", tvVerts[i*3].x, tvVerts[i*3].y, tvVerts[i*3].z);
        self.fvertices[i*3+1] = self.vertices[triangles[i].vertex[1]];
        self.vertexColors[i*3+1] = GLKVector4Make(0, 1, 0, 1);
        //NSLog(@"vert2, %f, %f, %f", tvVerts[i*3+1].x, tvVerts[i*3+1].y, tvVerts[i*3+1].z);
        self.fvertices[i*3+2] = self.vertices[triangles[i].vertex[2]];
        self.vertexColors[i*3+2] = GLKVector4Make(0, 0, 1, 1);
        //NSLog(@"vert3, %f, %f, %f", tvVerts[i*3+2].x, tvVerts[i*3+2].y, tvVerts[i*3+2].z);
    }
    
    
    
    glcmds = (const int*)[glData bytes];
}

-(void) render {
    GLKBaseEffect *effect = [[GLKBaseEffect alloc] init];
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    
    
    effect.transform.projectionMatrix = GLKMatrix4MakePerspective(45.0f, 2.0f/3.0f, 10.0f, 200.0f);
    //effect.transform.projectionMatrix = GLKMatrix4MakeOrtho(-60, 60, -40, 40, -1, 200);
    GLKMatrix4 rotationMatrix = GLKMatrix4Multiply(GLKMatrix4MakeXRotation(-M_PI/2), GLKMatrix4MakeZRotation(M_PI/2));
    //GLKMatrix4 rotationMatrix = GLKMatrix4Multiply(GLKMatrix4MakeZRotation(M_PI/2), GLKMatrix4MakeTranslation(0, 0, -100));
    //    rotationMatrix = GLKMatrix4Multiply(GLKMatrix4MakeYRotation(rotation), rotationMatrix);
    rotationMatrix = GLKMatrix4Multiply(GLKMatrix4MakeXRotation(xrotation), rotationMatrix);
    rotationMatrix = GLKMatrix4Multiply(GLKMatrix4MakeZRotation(zrotation), rotationMatrix);
    rotationMatrix = GLKMatrix4Multiply(GLKMatrix4MakeTranslation(0, 0, -100), rotationMatrix);
    
    effect.transform.modelviewMatrix = rotationMatrix;
    //effect.transform.modelviewMatrix = GLKMatrix4MakeTranslation(0, 0, -100);
    
    //    effect.transform.modelviewMatrix = GLKMatrix4Multiply(GLKMatrix4MakeTranslation(0, 0, -50), GLKMatrix4MakeYRotation(rotation) );
    
    
    [effect prepareToDraw];
    
    
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 0, self.fvertices);
    
    glEnableVertexAttribArray(GLKVertexAttribColor);
    glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, 0, self.vertexColors);
    
    glDrawArrays(GL_TRIANGLES, 0, self.numFVertices);
    //    glDrawArrays(GL_TRIANGLES, 0, 36);
    glDisableVertexAttribArray(GLKVertexAttribColor);
    glDisableVertexAttribArray(GLKVertexAttribPosition);
    //sleep(10);
    glDisable(GL_BLEND);
}

-(void) update {
    
    xrotation += M_PI / 96;
    if (xrotation >= 2 * M_PI) {
        xrotation -= 2 * M_PI;
    }
    zrotation += M_PI / 144;
    if (zrotation >= 2 * M_PI) {
        zrotation -= 2 * M_PI;
    }
    
}

@end


