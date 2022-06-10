Shader "TheoVerwaerde/Tesselation"
 {
	Properties {
		_Tess ("Tessellation", Range(1,64)) = 4
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		[NoScaleOffset] _HeightMap ("Height map", 2D) = "white" {}
		_Amount ("Amount", Range(0,2)) = 1
		_MinMax ("Min / Max", Vector) = (5,10,0,0)
	}
 	
	SubShader {
		Tags { "RenderType"="Opaque" }
				
		CGPROGRAM
		#pragma surface surf BlinnPhong addshadow fullforwardshadows nolightmap vertex:vert tessellate:tessDistance
        #include "Tessellation.cginc"

		
        struct appdata {
            float4 vertex : POSITION;
            float4 tangent : TANGENT;
            float3 normal : NORMAL;
            float2 texcoord : TEXCOORD0;
        };

		struct Input {
			float2 uv_MainTex;
		};
		
		float _Tess;
		sampler2D _MainTex;
		sampler2D _HeightMap;
		half _Amount;
		float2 _MinMax;

		float4 tessDistance (appdata v0, appdata v1, appdata v2) {
            return UnityDistanceBasedTess(v0.vertex, v1.vertex, v2.vertex, _MinMax.x, _MinMax.y, _Tess);
        }
		
	    void vert (inout appdata v)
		{
			float height = tex2Dlod(_HeightMap, float4(v.texcoord.xy, 0, 0)).r;
	    	
			v.vertex.xyz += height * v.normal.xyz * _Amount;
	    }

		void surf (Input IN, inout SurfaceOutput o)
		{
			o.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb;
		}
		ENDCG
	}
	FallBack "Diffuse"
}