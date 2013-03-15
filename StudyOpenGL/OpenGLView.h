//
//  OpenGLView.h
//  StudyOpenGL
//
//  Created by yuzhou on 13-3-14.
//  Copyright (c) 2013年 witmob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import "CC3GLMatrix.h"

@interface OpenGLView : UIView
{
    CAEAGLLayer *_eaglLayer;
    EAGLContext *_context;
    GLuint _colorRenderBuffer;
    
    GLuint _positionSlot;
    GLuint _colorSlot;
    
    GLuint _projectionUniform;
    GLuint _modelViewUniform;
    
    float _currentRotation;
    
    GLuint _depthRenderBuffer;
}
@end
