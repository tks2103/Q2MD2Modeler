//
//  MD2Texture.m
//  Q2MD2Modeler
//
//  Created by Tanoy Sinha on 10/9/12.
//  Copyright (c) 2012 Tanoy Sinha. All rights reserved.
//

#import "MD2Texture.h"

@implementation MD2Texture

@synthesize name;

-(id) init {
    self = [super init];
    if (self) {
        FILE *f = fopen("/Users/tsinha/Downloads/q2mdl-storm/storm.pcx", "r");
        
        name = 1;
        
        fseek(f, 0, SEEK_END);
        int size = ftell(f);
        int palette_pos = size - 768;
        
        fseek(f, palette_pos, SEEK_SET);
        unsigned char palette[768];
        fread(&palette, 768, 1, f);
        
        fseek(f, 0, SEEK_SET);
        fread(&header, sizeof(pcx_header_t), 1, f);
        
        int xsize = header.window[2]-header.window[0]+1;
        int ysize = header.window[3]-header.window[1]+1;
        
        unsigned char pixels[xsize * ysize * header.nplanes];
        int rle_count = 0, rle_value = 0;
        
        for (int i = 0; i < ysize; i++) {
            int bytes = header.bytesperline * header.nplanes;
            unsigned char *buf = malloc(bytes);
            fread(buf, bytes, 1, f);
            for (int j = 0; j < bytes; j++) {
                if (rle_count == 0) {
                    if ((rle_value = *(buf++)) < 0xc0) {
                        rle_count = 1;
                    } else {
                        rle_count = rle_value - 0xc0;
                        rle_value = *(buf++);
                    }
                    //NSLog(@"Assigned new count and val, count: %d, val: %d, palette val: %d", rle_count, rle_value, palette[rle_value]);
                }
                rle_count--;
                
                pixels[i * ysize + j] = palette[rle_value];
                
                //NSLog(@"Iterated with val: %d. Remaining: %d, Palette val: %d", rle_value, rle_count, palette[rle_value]);
            }
            //free(buf);
        }
    }
    return self;
}

@end
