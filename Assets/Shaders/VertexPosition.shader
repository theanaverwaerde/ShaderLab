Shader "TheoVerwaerde/VertexHeightMap"
 {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		[NoScaleOffset] _HeightMap ("Height map", 2D) = "white" {}
		_Amount ("Amount", Range(0,2)) = 1
	}
 	
	SubShader {
		Tags { "RenderType"="Opaque" }
				
		CGPROGRAM
		#pragma surface surf Lambert vertex:vert

		struct Input {
			float2 uv_MainTex;
		};
		
		sampler2D _MainTex;
		sampler2D _HeightMap;
		half _Amount;
		
	    void vert (inout appdata_full v)
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