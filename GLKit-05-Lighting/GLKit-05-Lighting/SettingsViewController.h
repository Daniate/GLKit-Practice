//
//  SettingsViewController.h
//  GLKit-05-Lighting
//
//  Created by Daniate on 2020/2/1.
//  Copyright © 2020 Daniate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Settings.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SettingsUpdatedDelegate;

@interface SettingsViewController : UITableViewController
@property (nonatomic, weak) id<SettingsUpdatedDelegate> delegate;
@property (nonatomic, strong) Settings *settings;
@end

@protocol SettingsUpdatedDelegate <NSObject>

- (void)settingsUpdated:(Settings *)settings viewController:(SettingsViewController *)settingsVC;

@end

NS_ASSUME_NONNULL_END
