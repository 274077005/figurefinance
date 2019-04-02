#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>



@interface ApplePay : NSObject


+ (ApplePay*)shared;

- (void)toPay:(id)proc WithCount:(int)count;
-(void)check;


@property(nonatomic,copy)void(^submitBlock)(void);
@end
