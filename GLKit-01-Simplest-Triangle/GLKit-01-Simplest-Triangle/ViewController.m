//
//  ViewController.m
//  GLKit-01-Simplest-Triangle
//
//  Created by Daniate on 2020/1/28.
//  Copyright © 2020 Daniate. All rights reserved.
//

#import "ViewController.h"

typedef struct Vertex {
    GLKVector3 position;
} Vertex;

@interface ViewController () {
    GLuint _vbo;
    Vertex _vertices[3];
}

@property (nonatomic, strong) GLKBaseEffect *effect;

@end

@implementation ViewController

- (void)dealloc {
    glDisableVertexAttribArray(GLKVertexAttribPosition);
    if (0 != _vbo) {
        glDeleteBuffers(1, &_vbo);
        _vbo = 0;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    GLKView *glView = (GLKView *)self.view;
    
    // 创建Context，并将其设置为当前的Context
    EAGLContext *glCtx = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    glView.context = glCtx;
    [EAGLContext setCurrentContext:glCtx];
    
    // 创建Effect，并对其进行配置
    self.effect = [[GLKBaseEffect alloc] init];
    self.effect.constantColor = GLKVector4Make(1.0f, 0.0f, 0.0f, 1.0f);
    
    // 生成并绑定VBO
    glGenBuffers(1, &_vbo);
    glBindBuffer(GL_ARRAY_BUFFER, _vbo);
    // 设置顶点数据
    _vertices[0].position = GLKVector3Make( 0.5f,  0.5f, 0.0f);
    _vertices[1].position = GLKVector3Make(-0.5f,  0.5f, 0.0f);
    _vertices[2].position = GLKVector3Make(-0.5f, -0.5f, 0.0f);
    glBufferData(GL_ARRAY_BUFFER, sizeof(_vertices), &_vertices, GL_STATIC_DRAW);
    // 启用指定的顶点属性
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    // 告知指定的顶点属性，该如何使用顶点数据
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), NULL + offsetof(Vertex, position));
    
    // 设置清除色，默认为黑色，也就是glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    // 使用清除色对颜色缓冲区进行清除，背景颜色将会变为清除色
    glClear(GL_COLOR_BUFFER_BIT);
    // 调用Effect的prepareToDraw方法
    [self.effect prepareToDraw];
    // 使用指定数量的顶点，绘制三角形
    glDrawArrays(GL_TRIANGLES, 0, 3);
}

@end
