//
//  SettingsViewController.m
//  GLKit-05-Lighting
//
//  Created by Daniate on 2020/2/1.
//  Copyright © 2020 Daniate. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()
@property (nonatomic, weak) IBOutlet UISegmentedControl *segTexture;

@property (nonatomic, weak) IBOutlet UISwitch *switchLightEnable;

@property (nonatomic, weak) IBOutlet UISegmentedControl *segLightType;

@property (nonatomic, weak) IBOutlet UILabel *labelLightPos;
@property (nonatomic, weak) IBOutlet UISlider *sliderLightPosX;
@property (nonatomic, weak) IBOutlet UISlider *sliderLightPosY;
@property (nonatomic, weak) IBOutlet UISlider *sliderLightPosZ;

@property (nonatomic, weak) IBOutlet UILabel *labelLightAmbientColor;
@property (nonatomic, weak) IBOutlet UISlider *sliderLightAmbientColorR;
@property (nonatomic, weak) IBOutlet UISlider *sliderLightAmbientColorG;
@property (nonatomic, weak) IBOutlet UISlider *sliderLightAmbientColorB;

@property (nonatomic, weak) IBOutlet UILabel *labelLightDiffuseColor;
@property (nonatomic, weak) IBOutlet UISlider *sliderLightDiffuseColorR;
@property (nonatomic, weak) IBOutlet UISlider *sliderLightDiffuseColorG;
@property (nonatomic, weak) IBOutlet UISlider *sliderLightDiffuseColorB;

@property (nonatomic, weak) IBOutlet UILabel *labelLightSpecularColor;
@property (nonatomic, weak) IBOutlet UISlider *sliderLightSpecularColorR;
@property (nonatomic, weak) IBOutlet UISlider *sliderLightSpecularColorG;
@property (nonatomic, weak) IBOutlet UISlider *sliderLightSpecularColorB;

@property (nonatomic, weak) IBOutlet UILabel *labelLightSpotDirection;
@property (nonatomic, weak) IBOutlet UISlider *sliderSpotDirectionX;
@property (nonatomic, weak) IBOutlet UISlider *sliderSpotDirectionY;
@property (nonatomic, weak) IBOutlet UISlider *sliderSpotDirectionZ;

@property (nonatomic, weak) IBOutlet UILabel *labelLightSpotExponent;
@property (nonatomic, weak) IBOutlet UISlider *sliderSpotExponent;

@property (nonatomic, weak) IBOutlet UILabel *labelLightSpotCutoff;
@property (nonatomic, weak) IBOutlet UISlider *sliderSpotCutoff;

@property (nonatomic, weak) IBOutlet UILabel *labelLightConstantAttenuation;
@property (nonatomic, weak) IBOutlet UISlider *sliderConstantAttenuation;

@property (nonatomic, weak) IBOutlet UILabel *labelLightLinearAttenuation;
@property (nonatomic, weak) IBOutlet UISlider *sliderLinearAttenuation;

@property (nonatomic, weak) IBOutlet UILabel *labelLightQuadraticAttenuation;
@property (nonatomic, weak) IBOutlet UISlider *sliderQuadraticAttenuation;

@property (nonatomic, weak) IBOutlet UILabel *labelMaterialAmbientColor;
@property (nonatomic, weak) IBOutlet UISlider *sliderMaterialAmbientColorR;
@property (nonatomic, weak) IBOutlet UISlider *sliderMaterialAmbientColorG;
@property (nonatomic, weak) IBOutlet UISlider *sliderMaterialAmbientColorB;

@property (nonatomic, weak) IBOutlet UILabel *labelMaterialDiffuseColor;
@property (nonatomic, weak) IBOutlet UISlider *sliderMaterialDiffuseColorR;
@property (nonatomic, weak) IBOutlet UISlider *sliderMaterialDiffuseColorG;
@property (nonatomic, weak) IBOutlet UISlider *sliderMaterialDiffuseColorB;

@property (nonatomic, weak) IBOutlet UILabel *labelMaterialSpecularColor;
@property (nonatomic, weak) IBOutlet UISlider *sliderMaterialSpecularColorR;
@property (nonatomic, weak) IBOutlet UISlider *sliderMaterialSpecularColorG;
@property (nonatomic, weak) IBOutlet UISlider *sliderMaterialSpecularColorB;

@property (nonatomic, weak) IBOutlet UILabel *labelMaterialEmissiveColor;
@property (nonatomic, weak) IBOutlet UISlider *sliderMaterialEmissiveColorR;
@property (nonatomic, weak) IBOutlet UISlider *sliderMaterialEmissiveColorG;
@property (nonatomic, weak) IBOutlet UISlider *sliderMaterialEmissiveColorB;

@property (nonatomic, weak) IBOutlet UILabel *labelMaterialShininess;
@property (nonatomic, weak) IBOutlet UISlider *sliderShininess;

@property (nonatomic, weak) IBOutlet UISwitch *switchColorMaterialEnabled;

@property (nonatomic, weak) IBOutlet UISwitch *switchLightModelTwoSided;

@property (nonatomic, weak) IBOutlet UISegmentedControl *segLightingType;

@property (nonatomic, weak) IBOutlet UILabel *labelLightModelAmbientColor;
@property (nonatomic, weak) IBOutlet UISlider *sliderLightModelAmbientColorR;
@property (nonatomic, weak) IBOutlet UISlider *sliderLightModelAmbientColorG;
@property (nonatomic, weak) IBOutlet UISlider *sliderLightModelAmbientColorB;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateControlsValues];
    
    [self updateStates];
}

- (void)toggleEnable {
    BOOL enabled = (LightTypeSpotlight == self.settings.lightType);
    
    self.sliderSpotDirectionX.enabled = enabled;
    self.sliderSpotDirectionY.enabled = enabled;
    self.sliderSpotDirectionZ.enabled = enabled;
    
    self.sliderSpotExponent.enabled = enabled;
    
    self.sliderSpotCutoff.enabled = enabled;
}

- (void)updateControlsValues {
    [self.segTexture setSelectedSegmentIndex:self.settings.textureType];

    [self.switchLightEnable setOn:self.settings.light.enabled];
    
    [self.segLightType setSelectedSegmentIndex:self.settings.lightType];
    
    [self.sliderLightPosX setValue:self.settings.light.position.x];
    [self.sliderLightPosY setValue:self.settings.light.position.y];
    [self.sliderLightPosZ setValue:self.settings.light.position.z];
    
    [self.sliderLightAmbientColorR setValue:self.settings.light.ambientColor.r];
    [self.sliderLightAmbientColorG setValue:self.settings.light.ambientColor.g];
    [self.sliderLightAmbientColorB setValue:self.settings.light.ambientColor.b];
    
    [self.sliderLightDiffuseColorR setValue:self.settings.light.diffuseColor.r];
    [self.sliderLightDiffuseColorG setValue:self.settings.light.diffuseColor.g];
    [self.sliderLightDiffuseColorB setValue:self.settings.light.diffuseColor.b];
    
    [self.sliderLightSpecularColorR setValue:self.settings.light.specularColor.r];
    [self.sliderLightSpecularColorG setValue:self.settings.light.specularColor.g];
    [self.sliderLightSpecularColorB setValue:self.settings.light.specularColor.b];
    
    [self.sliderSpotDirectionX setValue:self.settings.light.spotDirection.x];
    [self.sliderSpotDirectionY setValue:self.settings.light.spotDirection.y];
    [self.sliderSpotDirectionZ setValue:self.settings.light.spotDirection.z];
    
    [self.sliderSpotExponent setValue:self.settings.light.spotExponent];
    [self.sliderSpotCutoff setValue:self.settings.light.spotCutoff];
    [self.sliderConstantAttenuation setValue:self.settings.light.constantAttenuation];
    [self.sliderLinearAttenuation setValue:self.settings.light.linearAttenuation];
    [self.sliderQuadraticAttenuation setValue:self.settings.light.quadraticAttenuation];
    
    [self.sliderMaterialAmbientColorR setValue:self.settings.material.ambientColor.r];
    [self.sliderMaterialAmbientColorG setValue:self.settings.material.ambientColor.g];
    [self.sliderMaterialAmbientColorB setValue:self.settings.material.ambientColor.b];
    
    [self.sliderMaterialDiffuseColorR setValue:self.settings.material.diffuseColor.r];
    [self.sliderMaterialDiffuseColorG setValue:self.settings.material.diffuseColor.g];
    [self.sliderMaterialDiffuseColorB setValue:self.settings.material.diffuseColor.b];
    
    [self.sliderMaterialSpecularColorR setValue:self.settings.material.specularColor.r];
    [self.sliderMaterialSpecularColorG setValue:self.settings.material.specularColor.g];
    [self.sliderMaterialSpecularColorB setValue:self.settings.material.specularColor.b];
    
    [self.sliderMaterialEmissiveColorR setValue:self.settings.material.emissiveColor.r];
    [self.sliderMaterialEmissiveColorG setValue:self.settings.material.emissiveColor.g];
    [self.sliderMaterialEmissiveColorB setValue:self.settings.material.emissiveColor.b];
    
    [self.sliderShininess setValue:self.settings.material.shininess];
    [self.switchColorMaterialEnabled setOn:self.settings.colorMaterialEnabled];
    [self.switchLightModelTwoSided setOn:self.settings.lightModelTwoSided];
    [self.segLightingType setSelectedSegmentIndex:self.settings.lightingType];
    
    [self.sliderLightModelAmbientColorR setValue:self.settings.lightModelAmbientColor.r];
    [self.sliderLightModelAmbientColorG setValue:self.settings.lightModelAmbientColor.g];
    [self.sliderLightModelAmbientColorB setValue:self.settings.lightModelAmbientColor.b];
}

- (void)updateLabelsTexts {
    [self.labelLightPos setText:[NSString stringWithFormat:@"位置(%.2f, %.2f, %.2f)", self.settings.light.position.x, self.settings.light.position.y, self.settings.light.position.z]];
    [self.labelLightAmbientColor setText:[NSString stringWithFormat:@"环境色(%.2f, %.2f, %.2f)", self.settings.light.ambientColor.r, self.settings.light.ambientColor.g, self.settings.light.ambientColor.b]];
    [self.labelLightDiffuseColor setText:[NSString stringWithFormat:@"漫反射色(%.2f, %.2f, %.2f)", self.settings.light.diffuseColor.r, self.settings.light.diffuseColor.g, self.settings.light.diffuseColor.b]];
    [self.labelLightSpecularColor setText:[NSString stringWithFormat:@"高光色(%.2f, %.2f, %.2f)", self.settings.light.specularColor.r, self.settings.light.specularColor.g, self.settings.light.specularColor.b]];
    [self.labelLightSpotDirection setText:[NSString stringWithFormat:@"聚光照射方向(%.2f, %.2f, %.2f)", self.settings.light.spotDirection.x, self.settings.light.spotDirection.y, self.settings.light.spotDirection.z]];
    [self.labelLightSpotExponent setText:[NSString stringWithFormat:@"聚光边界模糊(%.2f)", self.settings.light.spotExponent]];
    [self.labelLightSpotCutoff setText:[NSString stringWithFormat:@"聚光角度大小(%.2f)", self.settings.light.spotCutoff]];
    [self.labelLightConstantAttenuation setText:[NSString stringWithFormat:@"光线衰减常数因子(%.2f)", self.settings.light.constantAttenuation]];
    [self.labelLightLinearAttenuation setText:[NSString stringWithFormat:@"光线衰减线性因子(%.2f)", self.settings.light.linearAttenuation]];
    [self.labelLightQuadraticAttenuation setText:[NSString stringWithFormat:@"光线衰减二次因子(%.2f)", self.settings.light.quadraticAttenuation]];
    [self.labelMaterialAmbientColor setText:[NSString stringWithFormat:@"环境色(%.2f, %.2f, %.2f)", self.settings.material.ambientColor.r, self.settings.material.ambientColor.g, self.settings.material.ambientColor.b]];
    [self.labelMaterialDiffuseColor setText:[NSString stringWithFormat:@"漫反射色(%.2f, %.2f, %.2f)", self.settings.material.diffuseColor.r, self.settings.material.diffuseColor.g, self.settings.material.diffuseColor.b]];
    [self.labelMaterialSpecularColor setText:[NSString stringWithFormat:@"高光色(%.2f, %.2f, %.2f)", self.settings.material.specularColor.r, self.settings.material.specularColor.g, self.settings.material.specularColor.b]];
    [self.labelMaterialEmissiveColor setText:[NSString stringWithFormat:@"自发光色(%.2f, %.2f, %.2f)", self.settings.material.emissiveColor.r, self.settings.material.emissiveColor.g, self.settings.material.emissiveColor.b]];
    [self.labelMaterialShininess setText:[NSString stringWithFormat:@"高光度(%.2f)", self.settings.material.shininess]];
    [self.labelLightModelAmbientColor setText:[NSString stringWithFormat:@"光源模型环境色(%.2f, %.2f, %.2f)", self.settings.lightModelAmbientColor.r, self.settings.lightModelAmbientColor.g, self.settings.lightModelAmbientColor.b]];
}

- (IBAction)onValueChangedSeg:(UISegmentedControl *)sender {
    if (self.segTexture == sender) {
        self.settings.textureType = sender.selectedSegmentIndex;
    } else if (self.segLightType == sender) {
        float x = self.settings.light.position.x;
        float y = self.settings.light.position.y;
        float z = self.settings.light.position.z;
        if (LightTypeDirectional == sender.selectedSegmentIndex) {
            self.settings.light.position = GLKVector4Make(x, y, z, 0);
            
            self.sliderSpotCutoff.maximumValue = 180.0f;
        } else {
            self.settings.light.position = GLKVector4Make(x, y, z, 1);
            if (LightTypePoint == sender.selectedSegmentIndex) {
                self.settings.light.spotCutoff = 180.0;
                
                self.sliderSpotCutoff.maximumValue = 180.0f;
            } else {
                self.settings.light.spotCutoff = 20.0;
                
                self.sliderSpotCutoff.maximumValue = 120.0f;
            }
        }
        [self.sliderSpotCutoff setValue:self.settings.light.spotCutoff];
    } else if (self.segLightingType == sender) {
        self.settings.lightingType = (GLint)sender.selectedSegmentIndex;
    }
    
    [self updateStates];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(settingsUpdated:viewController:)]) {
        [self.delegate settingsUpdated:self.settings viewController:self];
    }
}

- (IBAction)onValueChangedSwitch:(UISwitch *)sender {
    if (self.switchLightEnable == sender) {
        self.settings.light.enabled = sender.on;
    } else if (self.switchColorMaterialEnabled == sender) {
        self.settings.colorMaterialEnabled = sender.on;
    } else if (self.switchLightModelTwoSided == sender) {
        self.settings.lightModelTwoSided = sender.on;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(settingsUpdated:viewController:)]) {
        [self.delegate settingsUpdated:self.settings viewController:self];
    }
}

- (IBAction)dismiss:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)reset {
    [self.settings restoreDefaultValues];
    
    [self updateControlsValues];
    
    [self updateStates];
}

- (void)updateStates {
    [self.settings determineLightType];
    [self updateLabelsTexts];
    [self toggleEnable];
}

- (IBAction)onValueChangedSlider:(UISlider *)sender {
    if (self.sliderLightPosX == sender) {
        float x = sender.value;
        float y = self.settings.light.position.y;
        float z = self.settings.light.position.z;
        float w = self.settings.light.position.w;
        self.settings.light.position = GLKVector4Make(x, y, z, w);
    } else if (self.sliderLightPosY == sender) {
        float x = self.settings.light.position.x;
        float y = sender.value;
        float z = self.settings.light.position.z;
        float w = self.settings.light.position.w;
        self.settings.light.position = GLKVector4Make(x, y, z, w);
    } else if (self.sliderLightPosZ == sender) {
        float x = self.settings.light.position.x;
        float y = self.settings.light.position.y;
        float z = sender.value;
        float w = self.settings.light.position.w;
        self.settings.light.position = GLKVector4Make(x, y, z, w);
    } else if (self.sliderLightAmbientColorR == sender) {
        float r = sender.value;
        float g = self.settings.light.ambientColor.g;
        float b = self.settings.light.ambientColor.b;
        self.settings.light.ambientColor = GLKVector4Make(r, g, b, 1.0f);
    } else if (self.sliderLightAmbientColorG == sender) {
        float r = self.settings.light.ambientColor.r;
        float g = sender.value;
        float b = self.settings.light.ambientColor.b;
        self.settings.light.ambientColor = GLKVector4Make(r, g, b, 1.0f);
    } else if (self.sliderLightAmbientColorB == sender) {
        float r = self.settings.light.ambientColor.r;
        float g = self.settings.light.ambientColor.g;
        float b = sender.value;
        self.settings.light.ambientColor = GLKVector4Make(r, g, b, 1.0f);
    } else if (self.sliderLightDiffuseColorR == sender) {
        float r = sender.value;
        float g = self.settings.light.diffuseColor.g;
        float b = self.settings.light.diffuseColor.b;
        self.settings.light.diffuseColor = GLKVector4Make(r, g, b, 1.0f);
    } else if (self.sliderLightDiffuseColorG == sender) {
        float r = self.settings.light.diffuseColor.r;
        float g = sender.value;
        float b = self.settings.light.diffuseColor.b;
        self.settings.light.diffuseColor = GLKVector4Make(r, g, b, 1.0f);
    } else if (self.sliderLightDiffuseColorB == sender) {
        float r = self.settings.light.diffuseColor.r;
        float g = self.settings.light.diffuseColor.g;
        float b = sender.value;
        self.settings.light.diffuseColor = GLKVector4Make(r, g, b, 1.0f);
    } else if (self.sliderLightSpecularColorR == sender) {
        float r = sender.value;
        float g = self.settings.light.specularColor.g;
        float b = self.settings.light.specularColor.b;
        self.settings.light.specularColor = GLKVector4Make(r, g, b, 1.0f);
    } else if (self.sliderLightSpecularColorG == sender) {
        float r = self.settings.light.specularColor.r;
        float g = sender.value;
        float b = self.settings.light.specularColor.b;
        self.settings.light.specularColor = GLKVector4Make(r, g, b, 1.0f);
    } else if (self.sliderLightSpecularColorB == sender) {
        float r = self.settings.light.specularColor.r;
        float g = self.settings.light.specularColor.g;
        float b = sender.value;
        self.settings.light.specularColor = GLKVector4Make(r, g, b, 1.0f);
    } else if (self.sliderSpotDirectionX == sender) {
        float x = sender.value;
        float y = self.settings.light.spotDirection.y;
        float z = self.settings.light.spotDirection.z;
        self.settings.light.spotDirection = GLKVector3Make(x, y, z);
    } else if (self.sliderSpotDirectionY == sender) {
        float x = self.settings.light.spotDirection.x;
        float y = sender.value;
        float z = self.settings.light.spotDirection.z;
        self.settings.light.spotDirection = GLKVector3Make(x, y, z);
    } else if (self.sliderSpotDirectionZ == sender) {
        float x = self.settings.light.spotDirection.x;
        float y = self.settings.light.spotDirection.y;
        float z = sender.value;
        self.settings.light.spotDirection = GLKVector3Make(x, y, z);
    } else if (self.sliderSpotExponent == sender) {
        self.settings.light.spotExponent = sender.value;
    } else if (self.sliderSpotCutoff == sender) {
        self.settings.light.spotCutoff = sender.value;
        [self.settings determineLightType];
    } else if (self.sliderConstantAttenuation == sender) {
        self.settings.light.constantAttenuation = sender.value;
    } else if (self.sliderLinearAttenuation == sender) {
        self.settings.light.linearAttenuation = sender.value;
    } else if (self.sliderQuadraticAttenuation == sender) {
        self.settings.light.quadraticAttenuation = sender.value;
    } else if (self.sliderMaterialAmbientColorR == sender) {
        float r = sender.value;
        float g = self.settings.material.ambientColor.g;
        float b = self.settings.material.ambientColor.b;
        self.settings.material.ambientColor = GLKVector4Make(r, g, b, 1.0f);
    } else if (self.sliderMaterialAmbientColorG == sender) {
        float r = self.settings.material.ambientColor.r;
        float g = sender.value;
        float b = self.settings.material.ambientColor.b;
        self.settings.material.ambientColor = GLKVector4Make(r, g, b, 1.0f);
    } else if (self.sliderMaterialAmbientColorB == sender) {
        float r = self.settings.material.ambientColor.r;
        float g = self.settings.material.ambientColor.g;
        float b = sender.value;
        self.settings.material.ambientColor = GLKVector4Make(r, g, b, 1.0f);
    } else if (self.sliderMaterialDiffuseColorR == sender) {
        float r = sender.value;
        float g = self.settings.material.diffuseColor.g;
        float b = self.settings.material.diffuseColor.b;
        self.settings.material.diffuseColor = GLKVector4Make(r, g, b, 1.0f);
    } else if (self.sliderMaterialDiffuseColorG == sender) {
        float r = self.settings.material.diffuseColor.r;
        float g = sender.value;
        float b = self.settings.material.diffuseColor.b;
        self.settings.material.diffuseColor = GLKVector4Make(r, g, b, 1.0f);
    } else if (self.sliderMaterialDiffuseColorB == sender) {
        float r = self.settings.material.diffuseColor.r;
        float g = self.settings.material.diffuseColor.g;
        float b = sender.value;
        self.settings.material.diffuseColor = GLKVector4Make(r, g, b, 1.0f);
    } else if (self.sliderMaterialSpecularColorR == sender) {
        float r = sender.value;
        float g = self.settings.material.specularColor.g;
        float b = self.settings.material.specularColor.b;
        self.settings.material.specularColor = GLKVector4Make(r, g, b, 1.0f);
    } else if (self.sliderMaterialSpecularColorG == sender) {
        float r = self.settings.material.specularColor.r;
        float g = sender.value;
        float b = self.settings.material.specularColor.b;
        self.settings.material.specularColor = GLKVector4Make(r, g, b, 1.0f);
    } else if (self.sliderMaterialSpecularColorB == sender) {
        float r = self.settings.material.specularColor.r;
        float g = self.settings.material.specularColor.g;
        float b = sender.value;
        self.settings.material.specularColor = GLKVector4Make(r, g, b, 1.0f);
    } else if (self.sliderMaterialEmissiveColorR == sender) {
        float r = sender.value;
        float g = self.settings.material.emissiveColor.g;
        float b = self.settings.material.emissiveColor.b;
        self.settings.material.emissiveColor = GLKVector4Make(r, g, b, 1.0f);
    } else if (self.sliderMaterialEmissiveColorG == sender) {
        float r = self.settings.material.emissiveColor.r;
        float g = sender.value;
        float b = self.settings.material.emissiveColor.b;
        self.settings.material.emissiveColor = GLKVector4Make(r, g, b, 1.0f);
    } else if (self.sliderMaterialEmissiveColorB == sender) {
        float r = self.settings.material.emissiveColor.r;
        float g = self.settings.material.emissiveColor.g;
        float b = sender.value;
        self.settings.material.emissiveColor = GLKVector4Make(r, g, b, 1.0f);
    } else if (self.sliderShininess == sender) {
        self.settings.material.shininess = sender.value;
    } else if (self.sliderLightModelAmbientColorR == sender) {
        float r = sender.value;
        float g = self.settings.lightModelAmbientColor.g;
        float b = self.settings.lightModelAmbientColor.b;
        self.settings.lightModelAmbientColor = GLKVector4Make(r, g, b, 1.0f);
    } else if (self.sliderLightModelAmbientColorG == sender) {
        float r = self.settings.lightModelAmbientColor.r;
        float g = sender.value;
        float b = self.settings.lightModelAmbientColor.b;
        self.settings.lightModelAmbientColor = GLKVector4Make(r, g, b, 1.0f);
    } else if (self.sliderLightModelAmbientColorB == sender) {
        float r = self.settings.lightModelAmbientColor.r;
        float g = self.settings.lightModelAmbientColor.g;
        float b = sender.value;
        self.settings.lightModelAmbientColor = GLKVector4Make(r, g, b, 1.0f);
    }
    
    [self updateStates];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(settingsUpdated:viewController:)]) {
        [self.delegate settingsUpdated:self.settings viewController:self];
    }
}

@end
