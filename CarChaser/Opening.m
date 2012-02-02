//
//  Opening.m
//  CarChaser
//
//

#import "Opening.h"
#import "Resources.h"
#import "GameCenter.h"
#import "HelloWorldLayer.h"


@implementation OpeningLayer
+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	
	OpeningLayer *layer = [OpeningLayer node];
	
	[scene addChild: layer];
	
	return scene;
}

-(id) init
{
	if( (self=[super init])) {
		
        //縦向きにする
        [[CCDirector sharedDirector] setDeviceOrientation:CCDeviceOrientationPortrait];
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        self.isAccelerometerEnabled = YES;
            
		// Title Logo
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"CarChaser" fontName:@"Marker Felt" fontSize:68];
		label.position =  ccp( size.width/2 , size.height-72 );
        [label setOpacity:0x7f];
        [label setColor:ccc3(255,192,128)];
		[self addChild: label z:20];
        
        Resources *Rsrc = [Resources getResource];
        
        //create road image
        {
            roadSpr = [CCSpriteBatchNode batchNodeWithFile:@"CarChaserSprite.png"];
            [roadSpr setContentSize:CGSizeMake(roadSpr.contentSize.width,roadSpr.contentSize.height*2)];
            {
                //道路は縦3枚分の画像を並べる
                for(int i=0; i<3; i++)
                {
                    CCSprite *roadSpr1 = [CCSprite spriteWithFile:@"CarChaserSprite.png" rect:[Rsrc getRoadImageRect]];
                    CGPoint pos = roadSpr1.position;
                    pos.x = 0;
                    pos.y = i*([Rsrc getRoadImageRect].size.height-1);
                    roadSpr1.position = pos;
                    [roadSpr addChild:roadSpr1 z:1 tag:[Rsrc getRoadId:i]];
                }
            }
            
            [self addChild:roadSpr z:1 tag:[Rsrc getRoadId:0]];
            
            CGPoint pos = roadSpr.position;
            pos.x = size.width/2;
            pos.y = 0;
            roadSpr.position = pos;
        }
        
        //create touch_mode button
        {
            CCLabelTTF *label = [CCLabelTTF labelWithString:@"touch mode" fontName:@"Marker Felt" fontSize:36];
            CCMenuItem *menuItem = [CCMenuItemLabel itemWithLabel:label target:self selector:@selector(startButtonTapped:)];
            menuItem.position = ccp( size.width/2 , size.height/2-32 );
            CCMenu *menu = [CCMenu menuWithItems:menuItem, nil];
            menu.position = CGPointZero;
            [self addChild:menu z:20];
        }
        //create tilt_mode button
        {
            CCLabelTTF *label = [CCLabelTTF labelWithString:@"tilt mode" fontName:@"Marker Felt" fontSize:36];
            CCMenuItem *menuItem = [CCMenuItemLabel itemWithLabel:label target:self selector:@selector(tiltButtonTapped:)];
            menuItem.position = ccp( size.width/2 , size.height/2-96 );
            CCMenu *menu = [CCMenu menuWithItems:menuItem, nil];
            menu.position = CGPointZero;
            [self addChild:menu z:20];
        }
        
		// High Speed
        if(Rsrc.highspeed>0)
        {
            NSString *str = [NSString stringWithFormat:@"High Speed:%0.0fkm/h", Rsrc.highspeed*10.0];
            CCLabelTTF *label = [CCLabelTTF labelWithString:str fontName:@"Marker Felt" fontSize:20];
            [label setColor:ccc3(255,255,192)];
            CCMenuItem *menuItem = [CCMenuItemLabel itemWithLabel:label target:self selector:@selector(resetScoreButtonTapped:)];
            menuItem.position = ccp( 84 , size.height-16 );
            CCMenu *menu = [CCMenu menuWithItems:menuItem, nil];
            menu.position = CGPointZero;
            [self addChild:menu z:20];
        }
        
		// High Score
        if(Rsrc.highscore>0)
        {
            NSString *str = [NSString stringWithFormat:@"High Score:%d", Rsrc.highscore];
            CCLabelTTF *label = [CCLabelTTF labelWithString:str fontName:@"Marker Felt" fontSize:20];
            [label setColor:ccc3(255,255,192)];
            CCMenuItem *menuItem = [CCMenuItemLabel itemWithLabel:label target:self selector:@selector(resetScoreButtonTapped:)];
            menuItem.position = ccp( size.width-84 , size.height-16 );
            CCMenu *menu = [CCMenu menuWithItems:menuItem, nil];
            menu.position = CGPointZero;
            [self addChild:menu z:20];
        }
        
        [self scheduleUpdate];
    }
    
    return self;
}

-(void) update:(ccTime)delta
{
    Resources *Rsrc = [Resources getResource];
    int times = delta/(0.99f/60);
    
    count+=times;
    
    //road scroll
    {
        CGPoint pos = roadSpr.position;
        pos.y-=2;
        
        int roadHeight = [roadSpr getChildByTag:[Rsrc getRoadId:0]].contentSize.height;
        if (pos.y < -roadHeight/2) {
            pos.y += roadHeight-1;
        } else if (pos.y > roadHeight/2) {
            pos.y -= roadHeight-1;
        }
        
        roadSpr.position = pos;
    }

    /*if(count>300){
        [self startButtonTapped:nil];
    }*/
}

-(void) startButtonTapped:(id)sender
{
    Resources *Rsrc = [Resources getResource];
    Rsrc.control_mode = TOUCH_MODE;
        
    CCTransitionRadialCCW *tran = [CCTransitionRadialCCW transitionWithDuration:1 scene:[HelloWorldLayer scene]];
    [[CCDirector sharedDirector] replaceScene:tran];
}

-(void) tiltButtonTapped:(id)sender
{
    Resources *Rsrc = [Resources getResource];
    Rsrc.control_mode = TILT_MODE;
    
    
    CCTransitionRadialCCW *tran = [CCTransitionRadialCCW transitionWithDuration:1 scene:[HelloWorldLayer scene]];
    [[CCDirector sharedDirector] replaceScene:tran];
}

- (void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    Resources *Rsrc = [Resources getResource];
    [Rsrc setAccelometer:acceleration.y];
}

-(void) resetScoreButtonTapped:(id)sender
{
    UIAlertView *alert =
    [[UIAlertView alloc]
     initWithTitle:@"Clear scores?"
     message:nil//@"Clear scores?"
     delegate:self
     cancelButtonTitle:@"Cancel"
     otherButtonTitles:@"OK", nil
     ];
    [alert show];
}

-(void)alertView:(UIAlertView*)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    Resources *Rsrc = [Resources getResource];

    switch (buttonIndex) {
        case 1:
            Rsrc.highscore = 0;
            Rsrc.highspeed = 0.0;
            [Rsrc syncHighScore];
            
            //画面を一瞬暗転する
            //CCScene *currentScene = [[CCDirector sharedDirector] runningScene];
            //CCTransitionFade *tran = [CCTransitionFade transitionWithDuration:0.1 scene:[BlackLayer sceneWithPushScene:currentScene]];

            CCTransitionFade *tran = [CCTransitionFade transitionWithDuration:0.1 scene:[BlackLayer sceneWithPushScene:[OpeningLayer scene]]];
            [[CCDirector sharedDirector] pushScene:tran];
            
            break;
    }
    
}

/*-(void) quitButtonTapped:(id)sender
{
    //[NSApp terminate:self];
    [[CCDirector sharedDirector] end]; //結局停止するだけだし意味ない
}*/

@end



@implementation BlackLayer
+(CCScene *) sceneWithPushScene:(CCScene *)pushedScene
{
	CCScene *scene = [CCScene node];
	
    [pushedScene retain];
    
	BlackLayer *layer = [BlackLayer node];
    layer->pushedScene = pushedScene;
	
	[scene addChild: layer];
	
	return scene;
}

-(id) init
{
	if( (self=[super init])) {
        self->times = 0;
        [self scheduleUpdate];
    }
    
    return self;
}

-(void)dealloc{
    
    [pushedScene release];
    [super dealloc];
}

-(void) update:(ccTime)delta
{
    times += delta;

    if(times>0.1){
        //popSceneでTransitionを使う
        CCTransitionFade *tran = [CCTransitionFade transitionWithDuration:0.1 scene:pushedScene];
        [[CCDirector sharedDirector] replaceScene:tran];
    }
}


@end