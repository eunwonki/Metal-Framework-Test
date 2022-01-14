import simd

class Sun: LightObject {
    init() {
        super.init(name: "Sun", meshType: .Sphere)
        self.setMaterialColor(SIMD4<Float>(0.5, 0.5, 0, 1.0))
        self.setScale(0.3)
    }
}
