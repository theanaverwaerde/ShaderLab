Shader "TheoVerwaerde/PBR_Fresnel"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        [NoScaleOffset][Normal] _Normal ("Normal map", 2D) = "white" {}
        _NormalScale ("Normal scale", Float) = 1
        [NoScaleOffset] _Metallic ("Metallic map", 2D) = "black" {}
        
        [NoScaleOffset] _Roughness ("Roughness map", 2D) = "white" {}
        _RoughnessSlider ("Roughness scale", Range (0, 1)) = 1     

        _FresnelColor ("Fresnel Color", Color) = (0,1,0,1)
        _FresnelPower ("Fresnel Power", Float) = 1  
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows

        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _Normal;
        sampler2D _Metallic;
        sampler2D _Roughness;

        struct Input
        {
            float3 worldPos;
            float3 worldNormal; INTERNAL_DATA 
            float2 uv_MainTex;
        };
        
        fixed4 _Color;
        float _NormalScale;
        float _RoughnessSlider;

        fixed4 _FresnelColor;
        float _FresnelPower;
        
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

            
            float3 view_dir = normalize(UnityWorldSpaceViewDir(IN.worldPos));
            
            float fresnel = 1 - dot(WorldNormalVector (IN, o.Normal), view_dir);
            fresnel = pow(fresnel, _FresnelPower);
            o.Emission = _FresnelColor * fresnel; 
        }
        ENDCG
    }
    FallBack "Diffuse"
}
