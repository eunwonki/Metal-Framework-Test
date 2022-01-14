import MetalKit

enum SceneTypes{
    case Sandbox
}

class SceneManager{
    
    private static var _currentScene: SceneNode!
    
    public static func Initialize(_ sceneType: SceneTypes){
        SetScene(sceneType)
    }
    
    public static func SetScene(_ sceneType: SceneTypes){
        switch sceneType {
        case .Sandbox:
            _currentScene = SandboxScene(name: "Sandbox")
        }
    }
    
    public static func TickScene(renderCommandEncoder: MTLRenderCommandEncoder, deltaTime: Float){
        GameTime.UpdateTime(deltaTime)
        
        _currentScene.updateCameras()
        
        _currentScene.update()
        
        _currentScene.render(renderCommandEncoder: renderCommandEncoder)
        
    }
    
    
}
