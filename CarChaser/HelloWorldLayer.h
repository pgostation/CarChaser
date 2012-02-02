//
//  HelloWorldLayer.h
//  iCarChaser
//
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

//#define KEYS_NUM 4
#define ENEMY_NUM 4

#define BUTTON_NUM 4
#define LeftButton 0
#define RightButton 1
#define JumpButton 2
#define BlakeButton 3

#define analogLR 0
#define analogUD 1

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{
    // Analog Controller
    CCSprite *button[BUTTON_NUM];
    CCSprite *analog[2];
    CGPoint controlValue;
    BOOL controllEnable;
    CFMutableDictionaryRef touchesDic;
    
    BOOL reverseAccelometor;
    
    CCSprite *playerSpr;
    CCSprite *enemySpr[ENEMY_NUM];
    CCSpriteBatchNode *roadSpr;
    CGPoint playerVelocity;
    CGPoint enemyVelocity[ENEMY_NUM];
    CGPoint enemyHandle[ENEMY_NUM];
    //BOOL keys[KEYS_NUM];
    ccTime level;
    int bombAnimCount;
    CCLabelTTF *speedlabel;
    CCLabelTTF *scorelabel;
    CCLabelTTF *remainlabel;
    int remain;
    int score;
    int thisgame_highspeed;
    int local_score;
    int count;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

-(void) myGameLoop;
-(void) changeToOpening;

@end
