// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/InstancingShader" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MetaPosition1 ("meta position 1", Vector) = (0.0, 0.0, 0.0, 0.0)
		_MetaPosition2 ("meta position 2", Vector) = (0.0, 0.0, 0.0, 0.0)
		_MetaPosition3 ("meta position 3", Vector) = (0.0, 0.0, 0.0, 0.0)
		_MetaPosition4 ("meta position 4", Vector) = (0.0, 0.0, 0.0, 0.0)
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_instancing
            #include "UnityCG.cginc"

			float4 _MetaPosition1;
			float4 _MetaPosition2;
			float4 _MetaPosition3;
			float4 _MetaPosition4;

            struct appdata
            {
                float4 vertex : POSITION;
				float4 normal : NORMAL;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
				float4 color : COLOR;
				float4 posit : TEXCOORD0;
				float4 ratio : TEXCOORD1;
                UNITY_VERTEX_INPUT_INSTANCE_ID // necessary only if you want to access instanced properties in fragment Shader.
            };

            UNITY_INSTANCING_CBUFFER_START(MyProperties)
                UNITY_DEFINE_INSTANCED_PROP(float4, _Color)
            UNITY_INSTANCING_CBUFFER_END
           
            v2f vert(appdata v)
            {
                v2f o;

                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_TRANSFER_INSTANCE_ID(v, o); // necessary only if you want to access instanced properties in the fragment Shader.


				float4 objpos = mul(unity_ObjectToWorld, float4(0.0, 0.0, 0.0, 1.0));
				float4 retpos = v.vertex;

				o.posit = objpos + retpos;

				float scale = 0.0;
				float scale1 = smoothstep(1.0, 0.0, length(objpos.xyz - _MetaPosition1.xyz) * 0.25); 
				float scale2 = smoothstep(1.0, 0.0, length(objpos.xyz - _MetaPosition2.xyz) * 0.25); 
				float scale3 = smoothstep(1.0, 0.0, length(objpos.xyz - _MetaPosition3.xyz) * 0.25); 
				float scale4 = smoothstep(1.0, 0.0, length(objpos.xyz - _MetaPosition4.xyz) * 0.25); 
				
				scale += scale1;
				scale += scale2;
				scale += scale3;
				scale += scale4;
				

				o.ratio.x = scale1;
				o.ratio.y = scale2;
				o.ratio.z = scale3;
				o.ratio.w = scale4;

				if(scale > 0.5) scale = min(scale, 1.0);
				else scale = 0.0;

				//scale = 1.0;
				float4x4 matscl = {
					scale, 0.0, 0.0, 0.0,
					0.0, scale, 0.0, 0.0,
					0.0, 0.0, scale, 0.0,
					0.0, 0.0, 0.0, 1.0,
				};
                o.vertex = UnityObjectToClipPos(mul(matscl, retpos));
                return o;
            }
           
            fixed4 frag(v2f i) : SV_Target
            {
				float3 norm = float3(0.0, 0.0, 0.0); 
				norm += i.ratio.x * normalize(i.posit.xyz - _MetaPosition1.xyz);
				norm += i.ratio.y * normalize(i.posit.xyz - _MetaPosition2.xyz);
				norm += i.ratio.z * normalize(i.posit.xyz - _MetaPosition3.xyz);
				norm += i.ratio.w * normalize(i.posit.xyz - _MetaPosition4.xyz);
				norm = normalize(norm);
				float brightness = dot(norm, float3(1.0, 1.0, 1.0)) * 0.5 + 0.5;
				float3 retcol = float3(brightness, brightness, brightness);
				return float4(retcol, 1.0);
                //UNITY_SETUP_INSTANCE_ID(i); // necessary only if any instanced properties are going to be accessed in the fragment Shader.
                //return UNITY_ACCESS_INSTANCED_PROP(_Color);
				//return i.color;
            }
            ENDCG
        }
	}
	FallBack "Diffuse"
}
