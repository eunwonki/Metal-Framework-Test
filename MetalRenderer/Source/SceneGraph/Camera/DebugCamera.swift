import Foundation
import simd

class DebugCamera: Camera {

    // TODO: perspective projection matrix zoom 조금만 커져도 사라지는 문제 해결.
    override var projectionMatrix: matrix_float4x4 {
        return matrix_float4x4.perspective(degreesFov: 45.0,
                                           aspectRatio: Renderer.AspectRatio,
                                           near: 0.01, far: 100,
                                           zoom: self.zoom)
    }

    var zoom: Float = 1.0
    
    init() {
        super.init(name: "Debug", cameraType: .Debug)
    }

    #if os(macOS)
        override func doUpdate() {
            if Keyboard.IsKeyPressed(.leftArrow) {
                self.moveX(-GameTime.DeltaTime)
            }
        
            if Keyboard.IsKeyPressed(.rightArrow) {
                self.moveX(GameTime.DeltaTime)
            }
        
            if Keyboard.IsKeyPressed(.upArrow) {
                self.moveY(GameTime.DeltaTime)
            }
        
            if Keyboard.IsKeyPressed(.downArrow) {
                self.moveY(-GameTime.DeltaTime)
            }
        
            if Mouse.IsMouseButtonPressed(button: .right) {
                self.rotate(Mouse.GetDY() * GameTime.DeltaTime,
                            Mouse.GetDX() * GameTime.DeltaTime,
                            0)
            }
        
            if Mouse.IsMouseButtonPressed(button: .center) {
                self.moveX(-Mouse.GetDX() * GameTime.DeltaTime)
                self.moveY(Mouse.GetDY() * GameTime.DeltaTime)
            }
        
            self.moveZ(-Mouse.GetDWheel() * 0.1)
        }
    #endif
    
    #if os(iOS)
        override func doUpdate() {
            if Gesture.isZooming {
                // TODO: zoom 더 정교하게 구현할 것...
                zoom += Gesture.zoomDelta
            }
            
            if Gesture.isDragging {
                // orbit camera 구현.
            }
        }
    #endif
}
