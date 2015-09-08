typedef enum GameState {
    GameStateUninitialized,
    GameStatePlaying,
    GameStatePaused,
    GameStateWon,
    GameStateLost
} GameState;

@interface GameScene : CCScene

@property (nonatomic, assign) GameState gameState;

@end
