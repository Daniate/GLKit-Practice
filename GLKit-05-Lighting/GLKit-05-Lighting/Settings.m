//
//  Settings.m
//  GLKit-05-Lighting
//
//  Created by Daniate on 2020/2/1.
//  Copyright © 2020 Daniate. All rights reserved.
//

#import "Settings.h"

@implementation Settings
- (instancetype)init {
    if (self = [super init]) {
        _defaultLight = [GLKEffectPropertyLight new];
        _defaultMaterial = [GLKEffectPropertyMaterial new];
        
        _light = [GLKEffectPropertyLight new];
        _material = [GLKEffectPropertyMaterial new];
        
        [self determineLightType];
    }
    return self;
}

- (void)determineLightType {
    _lightType = [self _determineLightType:self.light];
}

- (void)saveDefaultValues:(GLKBaseEffect *)effect {
    self.defaultLight.enabled = effect.light0.enabled;
    self.defaultLight.position = effect.light0.position;
    self.defaultLight.ambientColor = effect.light0.ambientColor;
    self.defaultLight.diffuseColor = effect.light0.diffuseColor;
    self.defaultLight.specularColor = effect.light0.specularColor;
    self.defaultLight.spotDirection = effect.light0.spotDirection;
    self.defaultLight.spotExponent = effect.light0.spotExponent;// 用于控制光锥内光束的聚集程度，值越大，越向中心聚集
    self.defaultLight.spotCutoff = effect.light0.spotCutoff;
    self.defaultLight.constantAttenuation = effect.light0.constantAttenuation;
    self.defaultLight.linearAttenuation = effect.light0.linearAttenuation;
    self.defaultLight.quadraticAttenuation = effect.light0.quadraticAttenuation;
    self.defaultLight.transform = effect.light0.transform;
    
    NSLog(@"Default Light:");
    NSLog(@"    enabled                   : %@", GL_TRUE == self.defaultLight.enabled ? @"GL_TRUE" : @"GL_FALSE");
    NSLog(@"    position                  : %@", NSStringFromGLKVector4(self.defaultLight.position));
    NSLog(@"    ambientColor              : %@", NSStringFromGLKVector4(self.defaultLight.ambientColor));
    NSLog(@"    diffuseColor              : %@", NSStringFromGLKVector4(self.defaultLight.diffuseColor));
    NSLog(@"    specularColor             : %@", NSStringFromGLKVector4(self.defaultLight.specularColor));
    NSLog(@"    spotDirection             : %@", NSStringFromGLKVector3(self.defaultLight.spotDirection));
    NSLog(@"    spotExponent              : %f", self.defaultLight.spotExponent);
    NSLog(@"    spotCutoff                : %f degrees", self.defaultLight.spotCutoff);
    NSLog(@"    constantAttenuation       : %f", self.defaultLight.constantAttenuation);
    NSLog(@"    linearAttenuation         : %f", self.defaultLight.linearAttenuation);
    NSLog(@"    quadraticAttenuation      : %f", self.defaultLight.quadraticAttenuation);
    NSLog(@"    transform.modelviewMatrix : %@", NSStringFromGLKMatrix4(self.defaultLight.transform.modelviewMatrix));
    NSLog(@"    transform.projectionMatrix: %@", NSStringFromGLKMatrix4(self.defaultLight.transform.projectionMatrix));
    
    self.defaultMaterial.ambientColor = effect.material.ambientColor;
    self.defaultMaterial.diffuseColor = effect.material.diffuseColor;
    self.defaultMaterial.specularColor = effect.material.specularColor;
    self.defaultMaterial.emissiveColor = effect.material.emissiveColor;
    self.defaultMaterial.shininess = effect.material.shininess;// 控制材料反光程度，越大反光程度越强烈
    
    NSLog(@"Default Material:");
    NSLog(@"    ambientColor              : %@", NSStringFromGLKVector4(self.defaultMaterial.ambientColor));
    NSLog(@"    diffuseColor              : %@", NSStringFromGLKVector4(self.defaultMaterial.diffuseColor));
    NSLog(@"    specularColor             : %@", NSStringFromGLKVector4(self.defaultMaterial.specularColor));
    NSLog(@"    emissiveColor             : %@", NSStringFromGLKVector4(self.defaultMaterial.emissiveColor));
    NSLog(@"    shininess                 : %f", self.defaultMaterial.shininess);
    
    self.defaultColorMaterialEnabled = effect.colorMaterialEnabled;
    self.defaultLightModelTwoSided = effect.lightModelTwoSided;
    self.defaultLightingType = effect.lightingType;
    self.defaultLightModelAmbientColor = effect.lightModelAmbientColor;// 用于控制光锥底部边界外侧的环境光
    
    NSLog(@"Default Others:");
    NSLog(@"    colorMaterialEnabled      : %@", GL_TRUE == self.defaultColorMaterialEnabled ? @"GL_TRUE" : @"GL_FALSE");
    NSLog(@"    lightModelTwoSided        : %@", GL_TRUE == self.defaultLightModelTwoSided ? @"GL_TRUE" : @"GL_FALSE");
    NSLog(@"    lightingType              : %@", GLKLightingTypePerPixel == self.defaultLightingType ? @"GLKLightingTypePerPixel" : @"GLKLightingTypePerVertex");
    NSLog(@"    lightModelAmbientColor    : %@", NSStringFromGLKVector4(self.defaultLightModelAmbientColor));
}

- (void)restoreDefaultValues {
    self.textureType = TextureTypeCat;
    
    self.light.enabled = self.defaultLight.enabled;
    self.light.position = self.defaultLight.position;
    self.light.ambientColor = self.defaultLight.ambientColor;
    self.light.diffuseColor = self.defaultLight.diffuseColor;
    self.light.specularColor = self.defaultLight.specularColor;
    self.light.spotDirection = self.defaultLight.spotDirection;
    self.light.spotExponent = self.defaultLight.spotExponent;// 用于控制光锥内光束的聚集程度，值越大，越向中心聚集
    self.light.spotCutoff = self.defaultLight.spotCutoff;
    self.light.constantAttenuation = self.defaultLight.constantAttenuation;
    self.light.linearAttenuation = self.defaultLight.linearAttenuation;
    self.light.quadraticAttenuation = self.defaultLight.quadraticAttenuation;
    self.light.transform = self.defaultLight.transform;
    
    NSLog(@"Current Light:");
    NSLog(@"    enabled                   : %@", GL_TRUE == self.light.enabled ? @"GL_TRUE" : @"GL_FALSE");
    NSLog(@"    position                  : %@", NSStringFromGLKVector4(self.light.position));
    NSLog(@"    ambientColor              : %@", NSStringFromGLKVector4(self.light.ambientColor));
    NSLog(@"    diffuseColor              : %@", NSStringFromGLKVector4(self.light.diffuseColor));
    NSLog(@"    specularColor             : %@", NSStringFromGLKVector4(self.light.specularColor));
    NSLog(@"    spotDirection             : %@", NSStringFromGLKVector3(self.light.spotDirection));
    NSLog(@"    spotExponent              : %f", self.light.spotExponent);
    NSLog(@"    spotCutoff                : %f degrees", self.light.spotCutoff);
    NSLog(@"    constantAttenuation       : %f", self.light.constantAttenuation);
    NSLog(@"    linearAttenuation         : %f", self.light.linearAttenuation);
    NSLog(@"    quadraticAttenuation      : %f", self.light.quadraticAttenuation);
    NSLog(@"    transform.modelviewMatrix : %@", NSStringFromGLKMatrix4(self.light.transform.modelviewMatrix));
    NSLog(@"    transform.projectionMatrix: %@", NSStringFromGLKMatrix4(self.light.transform.projectionMatrix));
    
    self.material.ambientColor = self.defaultMaterial.ambientColor;
    self.material.diffuseColor = self.defaultMaterial.diffuseColor;
    self.material.specularColor = self.defaultMaterial.specularColor;
    self.material.emissiveColor = self.defaultMaterial.emissiveColor;
    self.material.shininess = self.defaultMaterial.shininess;// 控制材料反光程度，越大反光程度越强烈
    
    NSLog(@"Current Material:");
    NSLog(@"    ambientColor              : %@", NSStringFromGLKVector4(self.material.ambientColor));
    NSLog(@"    diffuseColor              : %@", NSStringFromGLKVector4(self.material.diffuseColor));
    NSLog(@"    specularColor             : %@", NSStringFromGLKVector4(self.material.specularColor));
    NSLog(@"    emissiveColor             : %@", NSStringFromGLKVector4(self.material.emissiveColor));
    NSLog(@"    shininess                 : %f", self.material.shininess);
    
    self.colorMaterialEnabled = self.defaultColorMaterialEnabled;
    self.lightModelTwoSided = self.defaultLightModelTwoSided;
    self.lightingType = self.defaultLightingType;
    self.lightModelAmbientColor = self.defaultLightModelAmbientColor;// 用于控制光锥底部边界外侧的环境光
    
    NSLog(@"Current Others:");
    NSLog(@"    colorMaterialEnabled      : %@", GL_TRUE == self.colorMaterialEnabled ? @"GL_TRUE" : @"GL_FALSE");
    NSLog(@"    lightModelTwoSided        : %@", GL_TRUE == self.lightModelTwoSided ? @"GL_TRUE" : @"GL_FALSE");
    NSLog(@"    lightingType              : %@", GLKLightingTypePerPixel == self.lightingType ? @"GLKLightingTypePerPixel" : @"GLKLightingTypePerVertex");
    NSLog(@"    lightModelAmbientColor    : %@", NSStringFromGLKVector4(self.lightModelAmbientColor));
}

#pragma mark - Private
- (LightType)_determineLightType:(GLKEffectPropertyLight *)light {
    NSLog(@"light.position: %@", NSStringFromGLKVector4(light.position));
    if (0.0f == light.position.w) {
        return LightTypeDirectional;
    }
    if (180.0f == light.spotCutoff) {
        return LightTypePoint;
    }
    return LightTypeSpotlight;
}
@end
