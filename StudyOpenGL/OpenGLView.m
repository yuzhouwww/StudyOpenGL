//
//  OpenGLView.m
//  StudyOpenGL
//
//  Created by yuzhou on 13-3-14.
//  Copyright (c) 2013年 witmob. All rights reserved.
//

#import "OpenGLView.h"

#define TEX_COORD_MAX 1

@implementation OpenGLView

typedef struct {
    float Position[3];
    float Color[4];
    float TexCoord[2];
    float Normal[3];
} Vertex;

//顶点数组，包含位置和颜色
const Vertex Vertices[] = {
    // Front
    {{1, -1, 0}, {1, 1, 1, 1}, {TEX_COORD_MAX, 0},{0,0,1}},
    {{1, 1, 0}, {1, 1, 1, 1}, {TEX_COORD_MAX, TEX_COORD_MAX},{0,0,1}},
    {{-1, 1, 0}, {1, 1, 1, 1}, {0, TEX_COORD_MAX},{0,0,1}},
    {{-1, -1, 0}, {1, 1, 1, 1}, {0, 0},{0,0,1}},
    // Back
    {{1, 1, -2}, {1, 1, 1, 1}, {TEX_COORD_MAX, 0},{0,0,-1}},
    {{-1, -1, -2}, {1, 1, 1, 1}, {0, TEX_COORD_MAX},{0,0,-1}},
    {{1, -1, -2}, {1, 1, 1, 1}, {1, TEX_COORD_MAX},{0,0,-1}},
    {{-1, 1, -2}, {1, 1, 1, 1}, {0, 0},{0,0,-1}},
    // Left
    {{-1, -1, 0}, {1, 1, 1, 1}, {TEX_COORD_MAX, 0},{-1,0,0}},
    {{-1, 1, 0}, {1, 1, 1, 1}, {TEX_COORD_MAX, TEX_COORD_MAX},{-1,0,0}},
    {{-1, 1, -2}, {1, 1, 1, 1}, {0, TEX_COORD_MAX},{-1,0,0}},
    {{-1, -1, -2}, {1, 1, 1, 1}, {0, 0},{-1,0,0}},
    // Right
    {{1, -1, -2}, {1, 1, 1, 1}, {TEX_COORD_MAX, 0},{1,0,0}},
    {{1, 1, -2}, {1, 1, 1, 1}, {TEX_COORD_MAX, TEX_COORD_MAX},{1,0,0}},
    {{1, 1, 0}, {1, 1, 1, 1}, {0, TEX_COORD_MAX},{1,0,0}},
    {{1, -1, 0}, {1, 1, 1, 1}, {0, 0},{1,0,0}},
    // Top
    {{1, 1, 0}, {1, 1, 1, 1}, {TEX_COORD_MAX, 0},{0,1,0}},
    {{1, 1, -2}, {1, 1, 1, 1}, {TEX_COORD_MAX, TEX_COORD_MAX},{0,1,0}},
    {{-1, 1, -2}, {1, 1, 1, 1}, {0, TEX_COORD_MAX},{0,1,0}},
    {{-1, 1, 0}, {1, 1, 1, 1}, {0, 0},{0,1,0}},
    // Bottom
    {{1, -1, -2}, {1, 1, 1, 1}, {TEX_COORD_MAX, 0},{0,-1,0}},
    {{1, -1, 0}, {1, 1, 1, 1}, {TEX_COORD_MAX, TEX_COORD_MAX},{0,-1,0}},
    {{-1, -1, 0}, {1, 1, 1, 1}, {0, TEX_COORD_MAX},{0,-1,0}},
    {{-1, -1, -2}, {1, 1, 1, 1}, {0, 0},{0,-1,0}}
};

//顶点序号数组
const GLubyte Indices[] = {
    // Front
    0, 1, 2,
    2, 3, 0,
    // Back
    4, 5, 6,
    4, 5, 7,
    // Left
    8, 9, 10,
    10, 11, 8,
    // Right
    12, 13, 14,
    14, 15, 12,
    // Top
    16, 17, 18,
    18, 19, 16,
    // Bottom
    20, 21, 22,
    22, 23, 20
};

const Vertex Vertices2[] = {
    {{0.5, -0.5, 1}, {1, 1, 1, 1}, {1, 1}},
    {{0.5, 0.5, 1}, {1, 1, 1, 1}, {1, 0}},
    {{-0.5, 0.5, 1}, {1, 1, 1, 1}, {0, 0}},
    {{-0.5, -0.5, 1}, {1, 1, 1, 1}, {0, 1}},
};

const GLubyte Indices2[] = {
    1, 0, 2, 3
};

- (void)setupVBOs {
    //绑定顶点和序号
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(Vertices), Vertices, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_indexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(Indices), Indices, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_vertexBuffer2);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer2);
    glBufferData(GL_ARRAY_BUFFER, sizeof(Vertices2), Vertices2, GL_STATIC_DRAW);

    glGenBuffers(1, &_indexBuffer2);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer2);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(Indices2), Indices2, GL_STATIC_DRAW);
}

- (GLuint)compileShader:(NSString*)shaderName withType:(GLenum)shaderType {
    
    // 1
    NSString* shaderPath = [[NSBundle mainBundle] pathForResource:shaderName
                                                           ofType:@"glsl"];
    NSError* error;
    NSString* shaderString = [NSString stringWithContentsOfFile:shaderPath
                                                       encoding:NSUTF8StringEncoding error:&error];
    if (!shaderString) {
        NSLog(@"Error loading shader: %@", error.localizedDescription);
        exit(1);
    }
    
    // 2
    GLuint shaderHandle = glCreateShader(shaderType);
    
    // 3
    const char* shaderStringUTF8 = [shaderString UTF8String];
    int shaderStringLength = [shaderString length];
    glShaderSource(shaderHandle, 1, &shaderStringUTF8, &shaderStringLength);
    
    // 4
    glCompileShader(shaderHandle);
    
    // 5
    GLint compileSuccess;
    glGetShaderiv(shaderHandle, GL_COMPILE_STATUS, &compileSuccess);
    if (compileSuccess == GL_FALSE) {
        GLchar messages[256];
        glGetShaderInfoLog(shaderHandle, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"%@", messageString);
        exit(1);
    }
    
    return shaderHandle;
    
}

- (void)compileShaders {
    
    // 1
    GLuint vertexShader = [self compileShader:@"SimpleVertex"
                                     withType:GL_VERTEX_SHADER];
    GLuint fragmentShader = [self compileShader:@"SimpleFragment"
                                       withType:GL_FRAGMENT_SHADER];
    
    // 2
    GLuint programHandle = glCreateProgram();
    glAttachShader(programHandle, vertexShader);
    glAttachShader(programHandle, fragmentShader);
    glLinkProgram(programHandle);
    
    printShaderInfoLog(vertexShader);
    printShaderInfoLog(fragmentShader);
    
    // 3
    GLint linkSuccess;
    glGetProgramiv(programHandle, GL_LINK_STATUS, &linkSuccess);
    if (linkSuccess == GL_FALSE) {
        GLchar messages[256];
        glGetProgramInfoLog(programHandle, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"%@", messageString);
        exit(1);
    }
    
    // 4
    glUseProgram(programHandle);
    
    // 5
    _positionSlot = glGetAttribLocation(programHandle, "Position");
    _colorSlot = glGetAttribLocation(programHandle, "SourceColor");
    _normalSlot = glGetAttribLocation(programHandle, "Normal");
    glEnableVertexAttribArray(_positionSlot);
    glEnableVertexAttribArray(_colorSlot);
    glEnableVertexAttribArray(_normalSlot);
    
    _projectionUniform = glGetUniformLocation(programHandle, "Projection");
    _modelViewUniform = glGetUniformLocation(programHandle, "Modelview");
    
    _texCoordSlot = glGetAttribLocation(programHandle, "TexCoordIn");
    glEnableVertexAttribArray(_texCoordSlot);
    _textureUniform = glGetUniformLocation(programHandle, "Texture");
}

void printShaderInfoLog(GLuint obj)
{
    int infologLength = 0;
    int charsWritten  = 0;
    char *infoLog;
    
    glGetShaderiv(obj, GL_INFO_LOG_LENGTH,&infologLength);
    
    if (infologLength > 0)
    {
        infoLog = (char *)malloc(infologLength);
        glGetShaderInfoLog(obj, infologLength, &charsWritten, infoLog);
        printf("%s\n",infoLog);
        free(infoLog);
    }
}

void printProgramInfoLog(GLuint obj)
{
    int infologLength = 0;
    int charsWritten  = 0;
    char *infoLog;
    
    glGetProgramiv(obj, GL_INFO_LOG_LENGTH,&infologLength);
    
    if (infologLength > 0)
    {
        infoLog = (char *)malloc(infologLength);
        glGetProgramInfoLog(obj, infologLength, &charsWritten, infoLog);
        printf("%s\n",infoLog);
        free(infoLog);
    }
}

- (GLuint)setupTexture:(NSString *)fileName
{
    CGImageRef spriteImage = [UIImage imageNamed:fileName].CGImage;
    if (!spriteImage) {
        NSLog(@"纹理图片不存在");
        exit(1);
    }
    size_t width = CGImageGetWidth(spriteImage);
    size_t height = CGImageGetHeight(spriteImage);
    GLubyte *spriteData = (GLubyte *)calloc(width*height*4, sizeof(GLubyte));
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4, CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);
    
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
    CGContextRelease(spriteContext);
    
    GLuint textureName;
    glGenTextures(1, &textureName);
    glBindTexture(GL_TEXTURE_2D, textureName);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    
    free(spriteData);
    return textureName;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupLayer];
        [self setupContext];
        [self setupDepthBuffer];
        [self setupRenderBuffer];
        [self setupFrameBuffer];
        [self compileShaders];
        [self setupVBOs];
        [self setupDisplayLink];
//        [self render:nil];
        _floorTexture = [self setupTexture:@"head.jpg"];
        _fishTexture = [self setupTexture:@"item_powerup_fish.png"];
    }
    return self;
}

+ (Class)layerClass
{
    //使用CAEAGLLayer图层
    return [CAEAGLLayer class];
}

- (void)setupLayer
{
    //设置图层为不透明，提高性能
    _eaglLayer = (CAEAGLLayer *)self.layer;
    _eaglLayer.opaque = YES;
}

- (void)setupContext
{
    //创建用于绘制的上下文
    _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    if (_context == nil) {
        NSLog(@"EAGLContext init fail");
        exit(1);
    }
    if (![EAGLContext setCurrentContext:_context]) {
        NSLog(@"EAGLContext set context fail");
        exit(1);
    }
}

- (void)setupRenderBuffer
{
    //创建渲染缓冲区
    glGenRenderbuffers(1, &_colorRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eaglLayer];
}

- (void)setupDepthBuffer {
    glGenRenderbuffers(1, &_depthRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _depthRenderBuffer);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, self.frame.size.width, self.frame.size.height);
}

- (void)setupFrameBuffer
{
    //创建帧缓冲取
    GLuint frameBuffer;
    glGenFramebuffers(1, &frameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, frameBuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorRenderBuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _depthRenderBuffer);
}

- (void)render:(CADisplayLink*)displayLink
{
    //清理屏幕，并绘制
    glClearColor(50/255.0, 100/255.0, 150/255.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glEnable(GL_DEPTH_TEST);
    
    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
    glEnable(GL_BLEND);
    
    CC3GLMatrix *projection = [CC3GLMatrix matrix];
    float h =4.0f* self.frame.size.height / self.frame.size.width;
    [projection populateFromFrustumLeft:-2 andRight:2 andBottom:-h/2 andTop:h/2 andNear:4 andFar:10];
    glUniformMatrix4fv(_projectionUniform, 1, 0, projection.glMatrix);
    
    CC3GLMatrix *modelView = [CC3GLMatrix matrix];
    [modelView populateFromTranslation:CC3VectorMake(0*sin(CACurrentMediaTime()), 0, -7)];
    
    _currentRotation += displayLink.duration * 9;
    [modelView rotateBy:CC3VectorMake( _currentRotation*2, _currentRotation*3, _currentRotation)];
//    [modelView populateFromRotation:CC3VectorMake(_currentRotation, _currentRotation, _currentRotation)];
//    [modelView translateBy:CC3VectorMake(0*sin(CACurrentMediaTime()), 0, -4)];
    
    glUniformMatrix4fv(_modelViewUniform, 1, 0, modelView.glMatrix);
    
    // 1
    glViewport(0, 0, self.frame.size.width, self.frame.size.height);
    
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    
    // 2
    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE,
                          sizeof(Vertex), 0);
    glVertexAttribPointer(_colorSlot, 4, GL_FLOAT, GL_FALSE,
                          sizeof(Vertex), (GLvoid*) (sizeof(float) * 3));
    
    glVertexAttribPointer(_texCoordSlot, 2, GL_FLOAT, GL_FALSE,
                          sizeof(Vertex), (GLvoid*) (sizeof(float) *7));
    glVertexAttribPointer(_normalSlot, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) (sizeof(float) *9));
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, _floorTexture);
    glUniform1i(_textureUniform, 0);
    
    // 3
    glDrawElements(GL_TRIANGLES, sizeof(Indices)/sizeof(Indices[0]),
                   GL_UNSIGNED_BYTE, 0);
//
//    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer2);
//    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer2);
//    
//    glActiveTexture(GL_TEXTURE0);
//    glBindTexture(GL_TEXTURE_2D, _fishTexture);
//    glUniform1i(_textureUniform, 0);
//    
//    glUniformMatrix4fv(_modelViewUniform, 1, 0, modelView.glMatrix);
//    
//    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), 0);
//    glVertexAttribPointer(_colorSlot, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) (sizeof(float) *3));
//    glVertexAttribPointer(_texCoordSlot, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) (sizeof(float) *7));
//    
//    glDrawElements(GL_TRIANGLE_STRIP, sizeof(Indices2)/sizeof(Indices2[0]), GL_UNSIGNED_BYTE, 0);
    
    [_context presentRenderbuffer:GL_RENDERBUFFER];
}

- (void)setupDisplayLink {
    CADisplayLink* displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(render:)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

@end
