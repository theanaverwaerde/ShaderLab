Shader "TheoVerwaerde/PBR_Tesselation"
 {
	Properties {
		
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        [NoScaleOffset][Normal] _Normal ("Normal map", 2D) = "white" {}
        _NormalScale ("Normal scale", Float) = 1
		[NoScaleOffset] _HeightMap ("Height map", 2D) = "white" {}
		_HeightScale ("Height Scale", Float) = 1
        [NoScaleOffset] _Metallic ("Metallic map", 2D) = "black" {}
        
        [NoScaleOffset] _Roughness ("Roughness map", 2D) = "white" {}
        _RoughnessSlider ("Roughness scale", Range (0, 1)) = 1      
		  
		_Tess ("Tessellation", Range(1,64)) = 4
		_MinMax ("Min / Max Distance Tesselation", Vector) = (5,10,0,0)
	}
 	
	SubShader {
		Tags { "RenderType"="Opaque" }
				
		CGPROGRAM
		#pragma surface surf Standard addshadow fullforwardshadows nolightmap vertex:vert tessellate:tessDistance
        #include "Tessellation.cginc"

        #pragma target 3.0
		
        struct appdata {
            float4 vertex : POSITION;
            float4 tangent : TANGENT;
            float3 normal : NORMAL;
            float2 texcoord : TEXCOORD0;
        };

		struct Input {
			float2 uv_MainTex;
		};
		
		sampler2D _MainTex;
		sampler2D _HeightMap;
        sampler2D _Normal;
        sampler2D _Metallic;
        sampler2D _Roughness;
		
        fixed4 _Color;
        float _NormalScale;
		half _HeightScale;
        float _RoughnessSlider;
		
		float _Tess;
		float2 _MinMax;

		float4 tessDistance (appdata v0, appdata v1, appdata v2) {
            return UnityDistanceBasedTess(v0.vertex, v1.vertex, v2.vertex, _MinMax.x, _MinMax.y, _Tess);
        }
		
	    void vert (inout appdata v)
		{
			float height = tex2Dlod(_HeightMap, float4(v.texcoord.xy, 0, 0)).r;
	    	
			v.vertex.xyz += height * v.normal.xyz * _HeightScale;
	    }

		void surf (Input IN, inout SurfaceOutputStandard o)
		{
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Alpha = c.a;
            
            o.Normal = UnpackNormalWithScale (tex2D (_Normal, IN.uv_MainTex),_NormalScale);
            
            fixed4 metallic = tex2D (_Metallic, IN.uv_MainTex);
            fixed4 roughness = tex2D (_Roughness, IN.uv_MainTex);

            o.Metallic = metallic.r;
            o.Smoothness = 1-roughness.r * _RoughnessSlider;
		}
		ENDCG
	}
	FallBack "Diffuse"
}