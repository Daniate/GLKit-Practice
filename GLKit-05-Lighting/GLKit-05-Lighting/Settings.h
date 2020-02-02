//
//  Settings.h
//  GLKit-05-Lighting
//
//  Created by Daniate on 2020/2/1.
//  Copyright © 2020 Daniate. All rights reserved.
//

#import <Foundation/Foundation.h>

@import GLKit;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, LightType) {
    LightTypeDirectional,
    LightTypePoint,
    LightTypeSpotlight,
};

typedef NS_ENUM(NSUInteger, TextureType) {
    TextureTypeCat,
    TextureTypeTile,
};

@interface Settings : NSObject

@property (nonatomic, assign) TextureType textureType;

@property (nonatomic, strong) GLKEffectPropertyLight    *defaultLight;
@property (nonatomic, strong) GLKEffectPropertyMaterial *defaultMaterial;
@property (nonatomic, assign) GLboolean                  defaultColorMaterialEnabled;
@property (nonatomic, assign) GLboolean                  defaultLightModelTwoSided;
@property (nonatomic, assign) GLKLightingType            defaultLightingType;
@property (nonatomic, assign) GLKVector4                 defaultLightModelAmbientColor;

@property (nonatomic, assign, readonly) LightType lightType;

@property (nonatomic, strong) GLKEffectPropertyLight    *light;
@property (nonatomic, strong) GLKEffectPropertyMaterial *material;
@property (nonatomic, assign) GLboolean                  colorMaterialEnabled;
@property (nonatomic, assign) GLboolean                  lightModelTwoSided;
@property (nonatomic, assign) GLKLightingType            lightingType;
@property (nonatomic, assign) GLKVector4                 lightModelAmbientColor;

- (void)determineLightType;
- (void)saveDefaultValues:(GLKBaseEffect *)effect;
- (void)restoreDefaultValues;
@end

NS_ASSUME_NONNULL_END
