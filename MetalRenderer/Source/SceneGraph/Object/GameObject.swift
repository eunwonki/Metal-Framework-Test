import MetalKit

class GameObject: Node {
    private var _modelConstants = ModelConstants()
    private var _material = Material()
    private var _textureType: TextureTypes = TextureTypes.None
    private var _mesh: Mesh!
    
    init(name: String, meshType: MeshTypes) {
        super.init(name: name)
        _mesh = Entities.Meshes[meshType]
    }
    
    init(name: String, mesh: Mesh) {
        super.init(name: name)
        _mesh = mesh
    }
    
    override func update(){
        _modelConstants.modelMatrix = self.modelMatrix
        
        super.update()
    }
}

extension GameObject: Renderable{
    func doRender(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        renderCommandEncoder.setRenderPipelineState(Graphics.RenderPipelineStates[.Basic])
        renderCommandEncoder.setDepthStencilState(Graphics.DepthStencilStates[.Less])
        
        //Vertex Shader
        renderCommandEncoder.setVertexBytes(&_modelConstants, length: ModelConstants.stride, index: 2)
        
        //Fragment Shader
        renderCommandEncoder.setFragmentSamplerState(Graphics.SamplerStates[.Linear], index: 0)
        renderCommandEncoder.setFragmentBytes(&_material, length: Material.stride, index: 1)
        if(_material.useTexture) {
            renderCommandEncoder.setFragmentTexture(Entities.Textures[_textureType], index: 0)
        }
        
        _mesh.drawPrimitives(renderCommandEncoder)
    }
}

//Material Properties
extension GameObject {
    public func setMaterialColor(_ color: SIMD4<Float>){
        self._material.color = color
        self._material.useMaterialColor = true
        self._material.useTexture = false
    }
    
    public func setMaterialColor(_ r: Float,_ g: Float,_ b: Float,_ a: Float) {
        setMaterialColor(SIMD4<Float>(r,g,b,a))
    }
    
    public func setTexture(_ textureType: TextureTypes) {
        self._textureType = textureType
        self._material.useTexture = true
        self._material.useMaterialColor = false
    }
    
    // Is Lit
    public func setMaterialIsLit(_ isLit: Bool) { self._material.isLit = isLit }
    public func getMaterialIsLit()->Bool { return self._material.isLit }
    
    // Ambient
    public func setMaterialAmbient(_ ambient: SIMD3<Float>) { self._material.ambient = ambient }
    public func setMaterialAmbient(_ r: Float,_ g: Float,_ b: Float) { setMaterialAmbient(SIMD3<Float>(r,g,b)) }
    public func setMaterialAmbient(_ ambient: Float) { self._material.ambient = float3(ambient, ambient, ambient) }
    public func addMaterialAmbient(_ value: Float) { self._material.ambient += value }
    public func getMaterialAmbient()->SIMD3<Float> { return self._material.ambient }
    
    // Diffuse
    public func setMaterialDiffuse(_ diffuse: SIMD3<Float>) { self._material.diffuse = diffuse }
    public func setMaterialDiffuse(_ r: Float,_ g: Float,_ b: Float) { setMaterialDiffuse(SIMD3<Float>(r,g,b)) }
    public func setMaterialDiffuse(_ diffuse: Float) { self._material.diffuse = float3(diffuse, diffuse, diffuse) }
    public func addMaterialDiffuse(_ value: Float) { self._material.diffuse += value }
    public func getMaterialDiffuse()->SIMD3<Float> { return self._material.diffuse }
    
    // Specular
    public func setMaterialSpecular(_ specular: SIMD3<Float>) { self._material.specular = specular }
    public func setMaterialSpecular(_ r: Float,_ g: Float,_ b: Float) { setMaterialSpecular(SIMD3<Float>(r,g,b)) }
    public func setMaterialSpecular(_ specular: Float) { self._material.specular = float3(specular, specular, specular) }
    public func addMaterialSpecular(_ value: Float) { self._material.specular += value }
    public func getMaterialSpecular()->SIMD3<Float> { return self._material.specular }
    
    // Shininess
    public func setMaterialShininess(_ shininess: Float) { self._material.shininess = shininess }
    public func getShininess()->Float { return self._material.shininess }
}
