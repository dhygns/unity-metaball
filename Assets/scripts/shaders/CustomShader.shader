// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tutorial/Textured Colored" {
    Properties {
        _Color ("Main Color", Color) = (1,1,1,0.5)
		_uTime ("custom values", Float) = 1.0
        //_MainTex ("Texture", 2D) = "white" { }
    }
    SubShader {
		//Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
		//ZWrite Off
		Blend SrcAlpha OneMinusSrcAlpha 

        Pass {

        CGPROGRAM
		
		#pragma vertex vert
        #pragma fragment frag

        #include "UnityCG.cginc"

        fixed4 _Color;
        sampler2D _MainTex;

        struct v2f {
            float4 pos : SV_POSITION;
            float2 uv : TEXCOORD0;
			float3 cam : TEXCOORD1;
			float3 po1 : TEXCOORD2;
			float3 po2 : TEXCOORD3;
			float3 po3 : TEXCOORD4;
        };

        v2f vert (appdata_base v)
        {
            v2f o;
            o.pos = UnityObjectToClipPos (v.vertex);
            o.uv = v.texcoord;//o.pos.xy;//TRANSFORM_TEX (v.texcoord, _MainTex);


			//camera, object setting at here.
			o.cam = float3(0.0, 0.0, 0.0);
			o.po1 = float3(sin(5.0), 0.0, 0.0);
			o.po2 = float3(0.0, 0.0, 0.0);
			o.po3 = float3(0.0, 0.0, 0.0);
            return o;
        }

        fixed4 frag (v2f i) : SV_Target
        {
            fixed4 texcol = fixed4(i.uv.x, i.uv.y, frac(_Time.y), 1.0);//tex2D (_MainTex, i.uv);
            return texcol;// * _Color;
        }
        ENDCG

        }
    }
}