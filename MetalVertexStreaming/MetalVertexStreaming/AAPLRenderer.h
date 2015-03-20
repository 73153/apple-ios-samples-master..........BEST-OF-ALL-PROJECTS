/*
 Copyright (C) 2014 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 
  Metal Renderer for Metal Vertex Streaming sample. Acts as the update and render delegate for the view controller and performs rendering. Renders a simple basic triangle with and updates the vertices every frame using a shared CPU/GPU memory buffer.
  
 */

#import "AAPLView.h"
#import "AAPLViewController.h"

#import <Metal/Metal.h>

@interface AAPLRenderer : NSObject <AAPLViewControllerDelegate, AAPLViewDelegate>

// renderer will create a default device at init time.
@property (nonatomic, readonly) id <MTLDevice> device;

// this value will cycle from 0 to g_max_inflight_buffers whenever a display completes ensuring renderer clients
// can synchronize between g_max_inflight_buffers count buffers, and thus avoiding a constant buffer from being overwritten between draws
@property (nonatomic, readonly) uint8_t constantDataBufferIndex;

//  These queries exist so the View can initialize a framebuffer that matches the expectations of the renderer
@property (nonatomic, readonly) MTLPixelFormat depthPixelFormat;
@property (nonatomic, readonly) MTLPixelFormat stencilPixelFormat;
@property (nonatomic, readonly) NSUInteger sampleCount;

// load all assets before triggering rendering
- (void)configure:(AAPLView *)view;

@end
