//
//  ZAColorInversion.metal
//  ZAGraphics
//
//  Created by phucnh7 on 4/22/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

#include <metal_stdlib>


//fragment half4 inversion_fragment(ImageVertexOut v [[stage_in]],
//                                sampler sample [[sampler(0)]],
//                                texture2d<float> texture [[texture(0)]]) {
//    
//    float4 color = texture.sample(sample, v.textCoords);
//    
//    return half4(1 - color.x, 1 - color.y, 1 - color.z, 1);
//}
