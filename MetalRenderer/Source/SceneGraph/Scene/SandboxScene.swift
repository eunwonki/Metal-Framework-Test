import MetalKit

func / (left: float3, right: Float) -> float3 {
    return float3(left.x / right, left.y / right, left.z / right)
}

func + (left: float3, right: float3) -> float3 {
    return float3(left.x + right.x, left.y + right.y, left.z + right.z)
}

class SandboxScene: SceneNode {
    var debugCamera = DebugCamera()
    var cruiser = Cruiser()
    var scene: GameObject!
    var sun = Sun()
    var pivot = float3()
    
    override func buildScene() {
        debugCamera.setPosition(0, 0, 1)
        addCamera(debugCamera)
        
        sun.setPosition(float3(0, 3, 0))
        sun.setMaterialIsLit(false)
        sun.setLightBrightness(0.3)
        sun.setMaterialColor(1, 1, 1, 1)
        sun.setLightColor(1, 1, 1)
        addLight(sun)
        
        #if os(macOS)
        cruiser.setMaterialAmbient(0.01)
        cruiser.setRotationX(0.5)
        cruiser.setMaterialShininess(10)
        cruiser.setMaterialSpecular(5)
        addChild(cruiser)
        #endif
        
        #if os(iOS)
        let sceneMesh = ModelMesh(modelName: "scene")
        scene = GameObject(name: "scene", mesh: sceneMesh)
        scene.setMaterialColor(float4(1, 0, 0, 1))
        scene.setMaterialAmbient(0.01)
        scene.setMaterialShininess(10)
        scene.setMaterialSpecular(5)
        addChild(scene)
        
        pivot = (sceneMesh.boundingBox.maxBounds
            + sceneMesh.boundingBox.minBounds) / 2
        
        debugCamera.lookAt(pos: pivot)
        #endif
    }
    
    #if os(macOS)
    override func doUpdate() {
        if Mouse.IsMouseButtonPressed(button: .left) {
            cruiser.rotateX(Mouse.GetDY() * GameTime.DeltaTime)
            cruiser.rotateY(Mouse.GetDX() * GameTime.DeltaTime)
        }

        cruiser.setMaterialShininess(cruiser.getShininess() + Mouse.GetDWheel())
    }
    #endif
    
    #if os(iOS)
    override func doUpdate() {
        // TODO: Rotation By Pivot 좀 더 정교하게 구현.
        if Gesture.isDragging {
            let xdiff = Float(Gesture.currentDragDiff.height * 0.1) * GameTime.DeltaTime
            let ydiff = -Float(Gesture.currentDragDiff.width * 0.1) * GameTime.DeltaTime
            
            scene.rotateAround(pivot, xdiff, ydiff, 0)
        }
    }
    #endif
}
