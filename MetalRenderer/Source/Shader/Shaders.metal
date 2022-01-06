//
//  Shaders.metal
//  Point Cloud
//
//  Created by Robert-Hein Hooijmans on 21/12/16.
//  Copyright © 2016 Robert-Hein Hooijmans. All rights reserved.
//

#define POINT_SCALE 5.0
#define SIGHT_RANGE 150.0

#include <metal_stdlib>
using namespace metal;

struct VertexOut {
    float4 position[[position]];
    float3 normal;
    float3 eye;
    float pointSize[[point_size]];
};

struct RenderParams
{
    float4x4 mvpMatrix;
};

vertex VertexOut vert(const device float4* vertices [[buffer(0)]],
                      const device float4* normals [[buffer(1)]],
                      const device RenderParams &params [[buffer(2)]],
                      unsigned int vid [[vertex_id]]) {
    VertexOut out;
    
    out.position = params.mvpMatrix * vertices[vid];
    out.normal = normals[vid].xyz;
    out.eye = (params.mvpMatrix * vertices[vid]).xyz;
    out.pointSize = 3.0;
    
    return out;
}

fragment half4 frag(VertexOut vert [[stage_in]],
                    float2 pointCoord [[point_coord]]) {
    return half4(1);
}
