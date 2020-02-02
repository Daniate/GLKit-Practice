//
//  ViewController.m
//  GLKit-05-Lighting
//
//  Created by Daniate on 2020/1/28.
//  Copyright © 2020 Daniate. All rights reserved.
//

#import "ViewController.h"
#import "SettingsViewController.h"

typedef struct Vertex {
    GLKVector3 position;
    GLKVector4 color;
    GLKVector2 texCoord;
    GLKVector3 normal;
} Vertex;

@interface ViewController () <SettingsUpdatedDelegate> {
    GLuint _vbo;
    Vertex _vertices[4];
}

@property (nonatomic, strong) GLKBaseEffect *effect;

@property (nonatomic, strong) Settings *settings;

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
    self.settings = [Settings new];
    
    GLKView *glView = (GLKView *)self.view;
    
    // 创建Context，并将其设置为当前的Context
    EAGLContext *glCtx = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:glCtx];
    glView.context = glCtx;
    
    NSString *file = [[NSBundle mainBundle] pathForResource:@"cat_512" ofType:@"png"];
    NSDictionary<NSString *, NSNumber *> *options = @{
        GLKTextureLoaderOriginBottomLeft: @YES,
    };
    GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithContentsOfFile:file options:options error:NULL];
    
    // 创建Effect，并对其进行配置
    self.effect = [[GLKBaseEffect alloc] init];
    
    // 保存默认值
    [self.settings saveDefaultValues:self.effect];
    [self.settings restoreDefaultValues];
    [self.settings determineLightType];
    
    self.effect.texture2d0.enabled = GL_TRUE;
    self.effect.texture2d0.name = textureInfo.name;
    self.effect.texture2d0.target = textureInfo.target;
    // GLKTextureEnvModeReplace 用纹理替换掉颜色，开启光照时，不要使用该值，否则，光照会失效
    // GLKTextureEnvModeModulate 纹理上的颜色乘上原来的颜色
//    self.effect.texture2d0.envMode = GLKTextureEnvModeReplace;
    
    self.effect.lightingType = GLKLightingTypePerPixel;
    
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([@"segue_id_settings" isEqualToString:segue.identifier]) {
        NSLog(@"segue.destinationViewController: %@", segue.destinationViewController);
        UINavigationController *nav = (UINavigationController *)segue.destinationViewController;
        SettingsViewController *destVC = (SettingsViewController *)nav.viewControllers.firstObject;
        destVC.delegate = self;
        destVC.settings = self.settings;
    }
}

#pragma mark - GLKViewDelegate
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    // 使用清除色对颜色缓冲区进行清除，背景颜色将会变为清除色
    glClear(GL_COLOR_BUFFER_BIT);
    
    [self _adjustProjectionMatrixIfNeeded:rect.size];
    
//    float c = sin(self.timeSinceLastResume) * 0.5 + 0.5;
//    NSLog(@"c: %f", c);
//    self.effect.light0.specularColor = GLKVector4Make(c, c, c, 1.0f);
//    self.effect.material.diffuseColor = GLKVector4Make(c, c, c, 1.0f);
    
    // 调用Effect的prepareToDraw方法
    [self.effect prepareToDraw];
    // 使用指定数量的顶点，绘制三角形
    glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
}

#pragma mark - SettingsUpdatedDelegate
- (void)settingsUpdated:(Settings *)settings viewController:(SettingsViewController *)settingsVC {
    NSString *file;
    if (TextureTypeCat == settings.textureType) {
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
    
    self.effect.light0.enabled = settings.light.enabled;
    
    self.effect.light0.position = settings.light.position;
    self.effect.light0.ambientColor = settings.light.ambientColor;
    self.effect.light0.diffuseColor = settings.light.diffuseColor;
    self.effect.light0.specularColor = settings.light.specularColor;
    self.effect.light0.spotDirection = settings.light.spotDirection;
    self.effect.light0.spotExponent = settings.light.spotExponent;
    self.effect.light0.spotCutoff = settings.light.spotCutoff;
    self.effect.light0.constantAttenuation = settings.light.constantAttenuation;
    self.effect.light0.linearAttenuation = settings.light.linearAttenuation;
    self.effect.light0.quadraticAttenuation = settings.light.quadraticAttenuation;
    
    self.effect.material.ambientColor = settings.material.ambientColor;
    self.effect.material.diffuseColor = settings.material.diffuseColor;
    self.effect.material.specularColor = settings.material.specularColor;
    self.effect.material.emissiveColor = settings.material.emissiveColor;
    self.effect.material.shininess = settings.material.shininess;
    
    self.effect.colorMaterialEnabled = settings.colorMaterialEnabled;
    self.effect.lightModelTwoSided = settings.lightModelTwoSided;
    self.effect.lightingType = settings.lightingType;
    self.effect.lightModelAmbientColor = settings.lightModelAmbientColor;
}

#pragma mark - Private
- (void)_adjustProjectionMatrixIfNeeded:(CGSize)size {
    if (MIN(size.width, size.height) <= DBL_EPSILON) {
        return;
    }
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
}

@end
