import MetalKit

class Node {
    private var _name: String = "Node"
    private var _id: String!
    
    private var _position: SIMD3<Float> = .init()
    private var _scale: SIMD3<Float> = .init(1, 1, 1)
    private var _rotation: SIMD3<Float> = .init()
    
    var parentModelMatrix = matrix_identity_float4x4
    
    var modelMatrix: matrix_float4x4 {
        var modelMatrix = matrix_identity_float4x4
        modelMatrix.translate(direction: self._position)
        modelMatrix.rotate(angle: self._rotation.x, axis: X_AXIS)
        modelMatrix.rotate(angle: self._rotation.y, axis: Y_AXIS)
        modelMatrix.rotate(angle: self._rotation.z, axis: Z_AXIS)
        modelMatrix.scale(axis: self._scale)
        return matrix_multiply(self.parentModelMatrix, modelMatrix)
    }
    
    var rotateMatrix: matrix_float4x4 {
        var r = self.modelMatrix
        r[0] = r[0] / self._scale.x
        r[1] = r[1] / self._scale.y
        r[2] = r[2] / self._scale.z
        r[3] = float4()
        return r
    }
    
    var children: [Node] = []
    
    init(name: String) {
        self._name = name
        self._id = UUID().uuidString
    }
    
    func addChild(_ child: Node) {
        self.children.append(child)
    }
    
    /// Override this function instead of the update function
    func doUpdate() {}
    
    func update() {
        self.doUpdate()
        for child in self.children {
            child.parentModelMatrix = self.modelMatrix
            child.update()
        }
    }
    
    func render(renderCommandEncoder: MTLRenderCommandEncoder) {
        renderCommandEncoder.pushDebugGroup("Rendering \(self._name)")
        if let renderable = self as? Renderable {
            renderable.doRender(renderCommandEncoder)
        }
        
        for child in self.children {
            child.render(renderCommandEncoder: renderCommandEncoder)
        }
        renderCommandEncoder.popDebugGroup()
    }
}

extension Node {
    // Naming
    func setName(_ name: String) { self._name = name }
    func getName()->String { return self._name }
    func getID()->String { return self._id }
    
    // Positioning and Movement
    func setPosition(_ position: SIMD3<Float>) { self._position = position }
    func setPosition(_ r: Float, _ g: Float, _ b: Float) { self.setPosition(SIMD3<Float>(r, g, b)) }
    func setPositionX(_ xPosition: Float) { self._position.x = xPosition }
    func setPositionY(_ yPosition: Float) { self._position.y = yPosition }
    func setPositionZ(_ zPosition: Float) { self._position.z = zPosition }
    func getPosition()->SIMD3<Float> { return self._position }
    func getPositionX()->Float { return self._position.x }
    func getPositionY()->Float { return self._position.y }
    func getPositionZ()->Float { return self._position.z }
    func move(_ x: Float, _ y: Float, _ z: Float) { self._position += SIMD3<Float>(x, y, z) }
    func moveX(_ delta: Float) { self._position.x += delta }
    func moveY(_ delta: Float) { self._position.y += delta }
    func moveZ(_ delta: Float) { self._position.z += delta }
    
    // Rotating
    func setRotation(_ rotation: SIMD3<Float>) { self._rotation = rotation }
    func setRotation(_ r: Float, _ g: Float, _ b: Float) { self.setRotation(SIMD3<Float>(r, g, b)) }
    func setRotationX(_ xRotation: Float) { self._rotation.x = xRotation }
    func setRotationY(_ yRotation: Float) { self._rotation.y = yRotation }
    func setRotationZ(_ zRotation: Float) { self._rotation.z = zRotation }
    func getRotation()->SIMD3<Float> { return self._rotation }
    func getRotationX()->Float { return self._rotation.x }
    func getRotationY()->Float { return self._rotation.y }
    func getRotationZ()->Float { return self._rotation.z }
    func rotate(_ x: Float, _ y: Float, _ z: Float) { self._rotation += SIMD3<Float>(x, y, z) }
    func rotateAround(_ pivot: float3,
                      _ x: Float,
                      _ y: Float,
                      _ z: Float)
    {
        // TODO: translation이 바뀌지 않으면서 작동하도록 개선.
        self._rotation = self._rotation + float3(x, y, z)
        
        let matrix =
            matrix_identity_float4x4.translateMatrix(direction: pivot)
                * self.rotateMatrix
                * matrix_identity_float4x4.translateMatrix(direction: -pivot)
        self.setLocalTransform(matrix)
    }

    func rotateX(_ delta: Float) { self._rotation.x += delta }
    func rotateY(_ delta: Float) { self._rotation.y += delta }
    func rotateZ(_ delta: Float) { self._rotation.z += delta }
    
    // Scaling
    func setScale(_ scale: SIMD3<Float>) { self._scale = scale }
    func setScale(_ r: Float, _ g: Float, _ b: Float) { self.setScale(SIMD3<Float>(r, g, b)) }
    func setScale(_ scale: Float) { self.setScale(SIMD3<Float>(scale, scale, scale)) }
    func setScaleX(_ scaleX: Float) { self._scale.x = scaleX }
    func setScaleY(_ scaleY: Float) { self._scale.y = scaleY }
    func setScaleZ(_ scaleZ: Float) { self._scale.z = scaleZ }
    func getScale()->SIMD3<Float> { return self._scale }
    func getScaleX()->Float { return self._scale.x }
    func getScaleY()->Float { return self._scale.y }
    func getScaleZ()->Float { return self._scale.z }
    func scaleX(_ delta: Float) { self._scale.x += delta }
    func scaleY(_ delta: Float) { self._scale.y += delta }
    func scaleZ(_ delta: Float) { self._scale.z += delta }
    
    func setLocalTransform(_ matrix: matrix_float4x4) {
        // https://math.stackexchange.com/questions/237369/given-this-transformation-matrix-how-do-i-decompose-it-into-translation-rotati/3554913
        self.setPosition(float3(matrix[3][0],
                                matrix[3][1],
                                matrix[3][2]))
        
        self._scale.x = sqrt(matrix[0][0] * matrix[0][0]
            + matrix[0][1] * matrix[0][1]
            + matrix[0][2] * matrix[0][2])
        self._scale.y = sqrt(matrix[1][0] * matrix[1][0]
            + matrix[1][1] * matrix[1][1]
            + matrix[1][2] * matrix[1][2])
        self._scale.z = sqrt(matrix[2][0] * matrix[2][0]
            + matrix[2][1] * matrix[2][1]
            + matrix[2][2] * matrix[2][2])
        
        // http://planning.cs.uiuc.edu/node103.html
        // 왜 음수로 하면 맞는지 모르겠음...
        let r = self.rotateMatrix
        self._rotation.z = -atan2(r[1][0], r[0][0])
        self._rotation.y = -atan2(-r[2][0], sqrt(r[2][1] * r[2][1] + r[2][2] * r[2][2]))
        self._rotation.x = -atan2(r[2][1], r[2][2])
    }
}
