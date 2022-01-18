import UIKit

let node = Node(name: "1")
node.setPosition(float3(1, 2, 3))
node.setRotation(float3(0.4,
                        0.7,
                        0.5))
node.setScale(float3(2, 3, 4))
print(node.modelMatrix)

let node2 = Node(name: "2")
node2.setLocalTransform(node.modelMatrix)

print(node2.getPosition())
print(node2.getRotation())
print(node2.getScale())
