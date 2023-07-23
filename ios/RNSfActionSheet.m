#import "RNSfActionSheet.h"
#import "UISFSymbolImageView.h"

#import <React/RCTBridge.h>
#import <React/RCTConvert.h>
#import <React/RCTLog.h>
#import <React/RCTUIManager.h>
#import <React/RCTUtils.h>

@implementation RNSfActionSheet

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_EXPORT_MODULE()

@synthesize bridge = _bridge;

/*
 * The `anchor` option takes a view to set as the anchor for the share
 * popup to point to, on iPads running iOS 8. If it is not passed, it
 * defaults to centering the share popup on screen without any arrows.
 */
- (CGRect)sourceRectInView:(UIView *)sourceView anchorViewTag:(NSNumber *)anchorViewTag
{
    if (anchorViewTag) {
        UIView *anchorView = [self.bridge.uiManager viewForReactTag:anchorViewTag];
        return [anchorView convertRect:anchorView.bounds toView:sourceView];
    } else {
        return (CGRect){sourceView.center, {1, 1}};
    }
}

RCT_EXPORT_METHOD(showActionSheetWithOptions:(NSDictionary *)options callback:(RCTResponseSenderBlock)callback)
{
    if (RCTRunningInAppExtension()) {
        RCTLogError(@"Unable to show action sheet from app extension");
        return;
    }
    
    NSString *title = [RCTConvert NSString:options[@"title"]];
    NSString *message = [RCTConvert NSString:options[@"message"]];
    NSArray<NSDictionary *> *buttons = [RCTConvert NSDictionaryArray:options[@"options"]];
    NSInteger destructiveButtonIndex = options[@"destructiveButtonIndex"] ? [RCTConvert NSInteger:options[@"destructiveButtonIndex"]] : -1;
    NSInteger cancelButtonIndex = options[@"cancelButtonIndex"] ? [RCTConvert NSInteger:options[@"cancelButtonIndex"]] : -1;
    
    UIViewController *controller = RCTPresentedViewController();
    
    if (controller == nil) {
        RCTLogError(@"Tried to display action sheet but there is no application window. options: %@", options);
        return;
    }
    
    /*
     * The `anchor` option takes a view to set as the anchor for the share
     * popup to point to, on iPads running iOS 8. If it is not passed, it
     * defaults to centering the share popup on screen without any arrows.
     */
    NSNumber *anchorViewTag = [RCTConvert NSNumber:options[@"anchor"]];
    UIView *sourceView = controller.view;
    CGRect sourceRect = [self sourceRectInView:sourceView anchorViewTag:anchorViewTag];
    
    UIAlertController *alertController =
    [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    
    NSInteger index = 0;
    for (NSDictionary *option in buttons) {
        UIAlertActionStyle style = UIAlertActionStyleDefault;
        if (index == destructiveButtonIndex) {
            style = UIAlertActionStyleDestructive;
        } else if (index == cancelButtonIndex) {
            style = UIAlertActionStyleCancel;
        }
        
        NSInteger localIndex = index;
        UIAlertAction *action = [UIAlertAction actionWithTitle:[option valueForKey:@"title"] style:style handler:^(__unused UIAlertAction *action){
            callback(@[@(localIndex)]);
        }];
        
        if ([option objectForKey:@"icon"]) {
            NSDictionary<NSString *, id> *icon = [RCTConvert NSDictionary:[option valueForKey:@"icon"]];
            UIColor *color = [RCTConvert UIColor:icon[@"color"]];
            
//            UIImageSymbolConfiguration * configuration = [UIImageSymbolConfiguration configurationWithPointSize:30 weight:UIImageSymbolWeightBold scale:UIImageSymbolScaleLarge];
//            UIImage * image = [UIImage systemImageNamed:name withConfiguration:configuration];
            
            // Resize the image, since the default is too small.
            // TODO: There might be a better way to do this.
//            CGSize sacleSize = CGSizeMake(32, 28);
//            UIGraphicsBeginImageContextWithOptions(sacleSize, NO, 0.0);
//            [sfImage drawInRect:CGRectMake(0, 0, sacleSize.width, sacleSize.height)];
//            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//            UIGraphicsEndImageContext();
            
            UISFSymbolImageView *view = [[UISFSymbolImageView alloc] init];
            [view setMulticolor:icon[@"multicolor"]];
            [view setWeight:icon[@"weight"]];
            [view setScale:icon[@"scale"]];
            [view setSize:icon[@"size"]];
            [view setIconColor:color];
            [view setRestorationIdentifier:icon[@"resizeMode"]];
            [view setSystemName:icon[@"name"]];
            [view updateImage];
            
            [action setValue:view.image forKey:@"image"];
        }
        
        if ([option objectForKey:@"titleTextAlignment"]) {
            NSNumber *titleTextAlignment = [RCTConvert NSNumber:[option valueForKey:@"titleTextAlignment"]];
            [action setValue:titleTextAlignment forKey:@"titleTextAlignment"];
        }
        
        if ([option objectForKey:@"titleTextColor"]) {
            UIColor *titleTextColor = [RCTConvert UIColor:[option valueForKey:@"titleTextColor"]];
            [action setValue:titleTextColor forKey:@"titleTextColor"];
        }
        
        [alertController addAction: action];
        index++;
    }
    
    alertController.modalPresentationStyle = UIModalPresentationPopover;
    alertController.popoverPresentationController.sourceView = sourceView;
    alertController.popoverPresentationController.sourceRect = sourceRect;
    
    if (!anchorViewTag) {
        alertController.popoverPresentationController.permittedArrowDirections = 0;
    }
    
    [controller presentViewController:alertController animated:YES completion:nil];
    
    alertController.view.tintColor = [RCTConvert UIColor:options[@"tintColor"]];
}

@end
