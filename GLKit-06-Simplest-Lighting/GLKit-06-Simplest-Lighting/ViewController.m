//
//  ViewController.m
//  GLKit-06-Simplest-Lighting
//
//  Created by Daniate on 2020/1/28.
//  Copyright © 2020 Daniate. All rights reserved.
//

#import "ViewController.h"

typedef struct Vertex {
    GLKVector3 position;
    GLKVector4 color;
    GLKVector2 texCoord;
    GLKVector3 normal;
} Vertex;

typedef NS_ENUM(NSUInteger, LightType) {
    LightTypeDirectional,
    LightTypePoint,
    LightTypeSpotlight,
    
    LightTypeNum,
};

typedef NS_ENUM(NSUInteger, TextureType) {
    TextureTypeCat,
    TextureTypeTile,
};

@interface ViewController () <UIPickerViewDataSource, UIPickerViewDelegate> {
    GLuint _vbo;
    Vertex _vertices[4];
}

@property (nonatomic, strong) GLKBaseEffect *effect;

@property (nonatomic, assign) TextureType textureType;
@property (nonatomic, assign) LightType lightType;

@property (nonatomic, weak) IBOutlet UITextField *textField;

@end

@implementation ViewController

- (void)dealloc {
    glDisableVertexAttribArray(GLKVertexAttribPosition);
    glDisableVertexAttribArray(GLKVertexAttribColor);
    glDisableVertexAttribArray(GLKVertexAttribTexCoord0);
    glDisableVertexAttribArray(GLKVertexAttribNormal);
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
    self.effect.texture2d0.enabled = GL_TRUE;
//    self.textureType = TextureTypeCat;
    self.textureType = TextureTypeTile;
    // GLKTextureEnvModeReplace 用纹理替换掉颜色，开启光照时，不要使用该值，否则，光照会失效
    // GLKTextureEnvModeModulate 纹理上的颜色乘上原来的颜色
//    self.effect.texture2d0.envMode = GLKTextureEnvModeReplace;
    
    self.effect.light0.enabled = GL_TRUE;
    self.effect.light0.specularColor = GLKVector4Make(1, 1, 1, 1);
    
    self.effect.material.specularColor = GLKVector4Make(1, 1, 1, 1);
    self.effect.material.ambientColor = GLKVector4Make(0.4, 0.4, 0.4, 1);
    self.effect.material.shininess = 1000;
    
    self.effect.lightingType = GLKLightingTypePerPixel;
    self.effect.lightModelAmbientColor = GLKVector4Make(0.8f, 0.8f, 0.8f, 1);
    
//    self.lightType = LightTypeDirectional;
//    self.lightType = LightTypePoint;
    self.lightType = LightTypeSpotlight;
    
    // 生成并绑定VBO
    glGenBuffers(1, &_vbo);
    glBindBuffer(GL_ARRAY_BUFFER, _vbo);
    // 设置顶点数据
    _vertices[0].position = GLKVector3Make( 0.5f,  0.5f, 0.0f);
    _vertices[1].position = GLKVector3Make(-0.5f,  0.5f, 0.0f);
    _vertices[2].position = GLKVector3Make(-0.5f, -0.5f, 0.0f);
    _vertices[3].position = GLKVector3Make( 0.5f, -0.5f, 0.0f);
    _vertices[0].color = GLKVector4Make(1.0f, 0.0f, 0.0f, 1.0f);
    _vertices[1].color = GLKVector4Make(0.0f, 1.0f, 0.0f, 1.0f);
    _vertices[2].color = GLKVector4Make(0.0f, 0.0f, 1.0f, 1.0f);
    _vertices[3].color = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
    _vertices[0].texCoord = GLKVector2Make(1, 1);
    _vertices[1].texCoord = GLKVector2Make(0, 1);
    _vertices[2].texCoord = GLKVector2Make(0, 0);
    _vertices[3].texCoord = GLKVector2Make(1, 0);
    _vertices[0].normal = GLKVector3Make(0.0f, 0.0f, 1.0f);
    _vertices[1].normal = GLKVector3Make(0.0f, 0.0f, 1.0f);
    _vertices[2].normal = GLKVector3Make(0.0f, 0.0f, 1.0f);
    _vertices[3].normal = GLKVector3Make(0.0f, 0.0f, 1.0f);
    glBufferData(GL_ARRAY_BUFFER, sizeof(_vertices), &_vertices, GL_STATIC_DRAW);
    // 启用指定的顶点属性
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glEnableVertexAttribArray(GLKVertexAttribColor);
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glEnableVertexAttribArray(GLKVertexAttribNormal);
    // 告知指定的顶点属性，该如何使用顶点数据
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), NULL + offsetof(Vertex, position));
    glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), NULL + offsetof(Vertex, color));
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), NULL + offsetof(Vertex, texCoord));
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), NULL + offsetof(Vertex, normal));
    
    // 设置清除色，默认为黑色，也就是glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTextureType:(TextureType)textureType {
    if (_textureType != textureType) {
        _textureType = textureType;
    }
    [self _updateTexture];
}

- (void)setLightType:(LightType)lightType {
    if (_lightType != lightType) {
        _lightType = lightType;
    }
    [self _updateLight];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return LightTypeNum;
}

#pragma mark - UIPickerViewDelegate
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (row) {
        case LightTypePoint:
            return @"点光源";
        case LightTypeSpotlight:
            return @"聚光灯";
        default: // LightTypeDirectional
            return @"方向光/平行光";
    }
};

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.lightType = row;
    self.textField.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    [self.textField resignFirstResponder];
}

#pragma mark - GLKViewDelegate
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    // 使用清除色对颜色缓冲区进行清除，背景颜色将会变为清除色
    glClear(GL_COLOR_BUFFER_BIT);
    
    [self _adjustModelviewMatrix];
    [self _adjustProjectionMatrixIfNeeded:rect.size];
    
    // 调用Effect的prepareToDraw方法
    [self.effect prepareToDraw];
    // 使用指定数量的顶点，绘制三角形
    glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
}

#pragma mark - Private
- (void)_adjustProjectionMatrixIfNeeded:(CGSize)size {
    if (MIN(size.width, size.height) <= DBL_EPSILON) {
        return;
    }
    float aspect = size.width / size.height;
    self.effect.transform.projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(120), aspect, 0.001, 100);
}

- (void)_adjustModelviewMatrix {
    GLKMatrix4 mat4 = GLKMatrix4Identity;
    
    NSTimeInterval t = self.timeSinceLastResume;
    float x = (float)cos(t) * 0.3f;
    float y = (float)sin(t) * 0.3f;
    mat4 = GLKMatrix4Translate(mat4, x, y, -1);
    
    x = (float)cos(t - M_PI_2) * -0.3f;
    y = (float)sin(t - M_PI_2) * -0.3f;
    mat4 = GLKMatrix4Rotate(mat4, GLKMathDegreesToRadians(15), x, y, 0);
    
    self.effect.transform.modelviewMatrix = mat4;
}

- (void)_updateTexture {
    NSString *file;
    if (TextureTypeCat == self.textureType) {
        file = [[NSBundle mainBundle] pathForResource:@"cat_512" ofType:@"png"];
    } else {
        file = [[NSBundle mainBundle] pathForResource:@"white_tile_400" ofType:@"jpg"];
    }
    NSDictionary<NSString *, NSNumber *> *options = @{
        GLKTextureLoaderOriginBottomLeft: @YES,
    };
    GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithContentsOfFile:file options:options error:NULL];
    
    self.effect.texture2d0.name = textureInfo.name;
    self.effect.texture2d0.target = textureInfo.target;
}

- (void)_updateLight {
    self.textField.text = [self pickerView:(UIPickerView *)self.textField.inputView titleForRow:self.lightType forComponent:0];
    [(UIPickerView *)self.textField.inputView selectRow:self.lightType inComponent:0 animated:NO];
    
    // 设置光源之前，重置modelviewMatrix，避免影响光源位置
    self.effect.transform.modelviewMatrix = GLKMatrix4Identity;
    
    // 因平行光不会受到衰减因子的影响，因此，在点光源照射下，会比在平行光照射下，暗一些
    self.effect.light0.linearAttenuation = 0.2;
    if (LightTypeDirectional == self.lightType) {
        self.effect.light0.position = GLKVector4Make(0, 0, 1, 0);
    } else if (LightTypePoint == self.lightType) {
        self.effect.light0.position = GLKVector4Make(0, 0, 1, 1);
        self.effect.light0.spotCutoff = 180;
    } else if (LightTypeSpotlight == self.lightType) {
        self.effect.light0.position = GLKVector4Make(0, 0, 1, 1);
        self.effect.light0.spotCutoff = 15;
        self.effect.light0.spotExponent = 50;
    }
}

@end
