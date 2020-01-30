//
//  ViewController.m
//  GLKit-03-Transform
//
//  Created by Daniate on 2020/1/28.
//  Copyright © 2020 Daniate. All rights reserved.
//

#import "ViewController.h"

typedef struct Vertex {
    GLKVector3 position;
    GLKVector4 color;
} Vertex;

typedef NS_ENUM(NSUInteger, TransformFlag) {
    TransformFlagDefault,
    TransformFlagVertices,
    TransformFlagModelviewMatrix,
    TransformFlagProjectionMatrix,
    TransformFlagViewport,
    
    TransformFlagNum,
};

@interface ViewController () <UIPickerViewDataSource, UIPickerViewDelegate> {
    GLuint _vbo;
    Vertex _vertices[3];
}

@property (nonatomic, strong) GLKBaseEffect *effect;
@property (nonatomic, assign) TransformFlag transformFlag;

@property (nonatomic, weak) IBOutlet UITextField *textField;
@end

@implementation ViewController

- (void)dealloc {
    glDisableVertexAttribArray(GLKVertexAttribPosition);
    glDisableVertexAttribArray(GLKVertexAttribColor);
    if (0 != _vbo) {
        glDeleteBuffers(1, &_vbo);
        _vbo = 0;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIPickerView *pickerView = [[UIPickerView alloc] init];
    pickerView.dataSource = self;
    pickerView.delegate = self;
    self.textField.inputView = pickerView;
    [self.textField reloadInputViews];
    
    GLKView *glView = (GLKView *)self.view;
    
    // 创建Context，并将其设置为当前的Context
    EAGLContext *glCtx = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:glCtx];
    glView.context = glCtx;
    
    // 创建Effect，并对其进行配置
    self.effect = [[GLKBaseEffect alloc] init];
    // 默认情况下，transform中的modelviewMatrix与projectionMatrix，均为单位矩阵
    // 生成并绑定VBO
    glGenBuffers(1, &_vbo);
    glBindBuffer(GL_ARRAY_BUFFER, _vbo);
    // 设置顶点数据
    _vertices[0].color = GLKVector4Make(1.0f, 0.0f, 0.0f, 1.0f);
    _vertices[1].color = GLKVector4Make(0.0f, 1.0f, 0.0f, 1.0f);
    _vertices[2].color = GLKVector4Make(0.0f, 0.0f, 1.0f, 1.0f);
    [self _adjustPositionsIfNeeded:self.view.bounds.size];
    // 启用指定的顶点属性
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glEnableVertexAttribArray(GLKVertexAttribColor);
    // 告知指定的顶点属性，该如何使用顶点数据
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), NULL + offsetof(Vertex, position));
    glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), NULL + offsetof(Vertex, color));
    
    // 设置清除色，默认为黑色，也就是glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [self _adjustPositionsIfNeeded:size];
    [self _adjustModelviewMatrixIfNeeded:size];
}

#pragma mark - GLKViewDelegate
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    // 使用清除色对颜色缓冲区进行清除，背景颜色将会变为清除色
    glClear(GL_COLOR_BUFFER_BIT);
    
    [self _adjustModelviewMatrixIfNeeded:rect.size];
    [self _adjustProjectionMatrixIfNeeded:rect.size];
    [self _adjustViewportIfNeeded:rect.size];
    
    // 调用Effect的prepareToDraw方法
    [self.effect prepareToDraw];
    // 使用指定数量的顶点，绘制三角形
    glDrawArrays(GL_TRIANGLES, 0, 3);
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return TransformFlagNum;
}

#pragma mark - UIPickerViewDelegate
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (row) {
        case TransformFlagVertices:
            return @"修改顶点";
        case TransformFlagModelviewMatrix:
            return @"修改模型视图矩阵";
        case TransformFlagProjectionMatrix:
            return @"修改投影矩阵";
        case TransformFlagViewport:
            return @"修改视口";
        default:
            return @"使用默认值";
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.transformFlag = row;
    self.textField.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    [self.textField resignFirstResponder];
    
    [self _adjustPositionsIfNeeded:self.view.bounds.size];
}

#pragma mark - Private
- (void)_adjustPositionsIfNeeded:(CGSize)size {
    if (MIN(size.width, size.height) <= DBL_EPSILON) {
        return;
    }
    
    GLKVector3 p0 = GLKVector3Make( 0.5f,  0.5f, 0.0f);
    GLKVector3 p1 = GLKVector3Make(-0.5f,  0.5f, 0.0f);
    GLKVector3 p2 = GLKVector3Make(-0.5f, -0.5f, 0.0f);
    
    if (TransformFlagVertices == self.transformFlag) {
        _vertices[0].position = [self _adjustPosition:p0 size:size];
        _vertices[1].position = [self _adjustPosition:p1 size:size];
        _vertices[2].position = [self _adjustPosition:p2 size:size];
    } else {
        // reset to origin positions
        _vertices[0].position = p0;
        _vertices[1].position = p1;
        _vertices[2].position = p2;
    }
    
    glBufferData(GL_ARRAY_BUFFER, sizeof(_vertices), &_vertices, GL_STATIC_DRAW);
}

- (GLKVector3)_adjustPosition:(GLKVector3)position size:(CGSize)size {
    if (MIN(size.width, size.height) <= DBL_EPSILON) {
        return position;
    }
    float aspect = size.width / size.height;
    if (aspect < 1) {
        return GLKVector3Make(position.x, position.y * aspect, position.z);
    }
    return GLKVector3Make(position.x / aspect, position.y, position.z);
}

- (void)_adjustModelviewMatrixIfNeeded:(CGSize)size {
    if (MIN(size.width, size.height) <= DBL_EPSILON) {
        return;
    }
    if (TransformFlagModelviewMatrix == self.transformFlag) {
        float aspect = size.width / size.height;
        if (aspect < 1) {
            self.effect.transform.modelviewMatrix = GLKMatrix4Scale(GLKMatrix4Identity, 1, aspect, 1);
        } else {
            self.effect.transform.modelviewMatrix = GLKMatrix4Scale(GLKMatrix4Identity, 1 / aspect, 1, 1);
        }
    } else {
        // reset to default value
        self.effect.transform.modelviewMatrix = GLKMatrix4Identity;
    }
}

- (void)_adjustProjectionMatrixIfNeeded:(CGSize)size {
    if (MIN(size.width, size.height) <= DBL_EPSILON) {
        return;
    }
    if (TransformFlagProjectionMatrix == self.transformFlag) {
        float aspect = size.width / size.height;
        if (aspect < 1) {
            float bottom = -1 / aspect;
            float top = 1 / aspect;
            self.effect.transform.projectionMatrix = GLKMatrix4MakeOrtho(-1, 1, bottom, top, 1, -1);
        } else {
            float left = -1 * aspect;
            float right = 1 * aspect;
            self.effect.transform.projectionMatrix = GLKMatrix4MakeOrtho(left, right, -1, 1, 1, -1);
        }
    } else {
        // reset to default value
        self.effect.transform.projectionMatrix = GLKMatrix4Identity;
    }
}

- (void)_adjustViewportIfNeeded:(CGSize)size {
    if (MIN(size.width, size.height) <= DBL_EPSILON) {
        return;
    }
    UIScreen *screen = [UIScreen mainScreen];
    CGFloat scale = [screen respondsToSelector:@selector(nativeScale)] ? screen.nativeScale : screen.scale;
    CGFloat widthInPixel = size.width * scale;
    CGFloat heightInPixel = size.height * scale;
    
    if (TransformFlagViewport == self.transformFlag) {
        CGFloat wh = MIN(widthInPixel, heightInPixel);
        CGFloat x = (widthInPixel - wh) / 2;
        CGFloat y = (heightInPixel - wh) / 2;
        glViewport(x, y, wh , wh);
    } else {
        // reset to default value
        glViewport(0, 0, widthInPixel , heightInPixel);
    }
}

@end
