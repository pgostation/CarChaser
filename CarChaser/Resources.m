//
//  Resources.m
//  CarChaser
//
//

#import "Resources.h"
#import <GameKit/GameKit.h>
#import "GameCenter.h"

static Resources *Rsrc;

#define mkrect(_x1,_x2,_x3,_x4) CGRectMake((CGFloat)(_x1),(CGFloat)(_x2),(CGFloat)(_x3),(CGFloat)(_x4))
//#define NSRectToCGRect(r) CGRectMake(r.origin.x, r.origin.y, r.size.width, r.size.height)

@implementation Resources

@synthesize highspeed=highspeed_, highscore=highscore_;
@synthesize control_mode=control_mode_;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        CGRect rects[] = {mkrect(0.f,289.f,62.f,62.f),
                          mkrect(0.f,256.f,32.f,32.f),
                          mkrect(32.f,256.f,32.f,32.f),
                          mkrect(64.f,256.f,32.f,32.f),
                          mkrect(96.f,256.f,32.f,32.f),
                          mkrect(128.f,256.f,32.f,32.f),
                          mkrect(160.f,256.f,32.f,32.f),
                          mkrect(192.f,256.f,32.f,32.f),
                          mkrect(224.f,256.f,32.f,32.f),
                          mkrect(256.f,256.f,32.f,32.f),
                          mkrect(288.f,256.f,32.f,32.f)};
        bombAnimFrame = [self animationFrameWithRects:@"CarChaserSprite.png" rects:rects framecount:sizeof(rects)/sizeof(rects[0])];
        
        
        //High Score
        {
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            
            if(defaults!=nil){
                self.highscore = (int)[defaults integerForKey:@"highScore"];
                self.highspeed = [defaults floatForKey:@"highSpeed"];
            }
            else{
                self.highscore = 0;
                self.highspeed = 0.0;
            }
        }
    }
    
    return self;
}

//-----------------------
//Util

+(Resources *) getResource
{
    if(Rsrc == nil){
        Rsrc = [[self alloc] init];
    }
    return Rsrc;
}


-(NSMutableArray *) animationFrameWithRects:(NSString*)filename rects:(CGRect *)rects framecount:(int)framecount
{
    NSMutableArray* frames = [[NSMutableArray arrayWithCapacity:framecount] retain];
    CCTexture2D* texture = [[CCTextureCache sharedTextureCache] addImage:filename];
    for (int i = 0; i < framecount; i++)
    {        
        CCSpriteFrame* frame = [CCSpriteFrame frameWithTexture:texture rect:rects[i]];
        
        [frames addObject:frame];
    }
    
    return frames;
}

-(void) syncHighScore
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];

    NSNumber *nsspd = [NSNumber numberWithFloat:highspeed_];
    NSNumber *nsscr = [NSNumber numberWithInt:highscore_];
    [defaults setObject:nsspd forKey:@"highSpeed"];
    [defaults setObject:nsscr forKey:@"highScore"];

    [defaults synchronize];
}

-(void) gameCenterSubmit:(int)score highspeed:(float)speed
{
    [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:^(NSError *error) {
        if (error == nil) {
            // 認証に成功した場合の処理コードをここに挿入する
            [[GameKitHelper sharedGameKitHelper] submitScore:(int)(speed*10) category:@"HighSpeed"];
            [[GameKitHelper sharedGameKitHelper] submitScore:(int)score category:@"HighScore"];
        } else {
            // アプリケーションはエラーパラメータを処理してプレーヤーにエラーを報告できる
            /*UIAlertView *alert =
            [[UIAlertView alloc]
             initWithTitle:[error localizedFailureReason]
             message:[error localizedDescription]
             delegate:nil
             cancelButtonTitle:@"OK"
             otherButtonTitles:nil
             ];
            [alert show];*/
        }
    }];

}


-(void) setAccelometer:(float)in_accellometer_y
{
    accellometer_y = in_accellometer_y;
}

-(float) getAccelometer
{
    return accellometer_y;
}

//-----------------------
//Get Image Rect

//num: 0-3
-(CGRect) getCarIconRect:(int)num
{
    return mkrect(1+64*num,289,62,62);
}

/*
//num: 0-9
-(CGRect) getBombIconRect:(int)num
{
    return mkrect(0+32*num,256,32,32);
}*/

//
-(CGRect) getRoadImageRect
{
    return mkrect(0,0,384,256);
}


//------------------------
//Get Sprite Id

-(int) getControllerId:(int)num
{
    return 60+num;
}

//num:0-2
-(int) getRoadId:(int)num
{
    return 1+num;
}

-(int) getMyCarId
{
    return 4;
}

//num:0-(ENEMY_NUM-1)
-(int) getEnemyCarId:(int)num
{
    return 5+num;
}


//------------------------
//Get Animation Frame

//Bomb
-(CCSpriteFrame*) getBombAnim:(int)num
{
    return [bombAnimFrame objectAtIndex:num];
}

@end
