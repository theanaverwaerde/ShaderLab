Shader "TheoVerwaerde/Fresnel"
{
    Properties
    {
        
        _FresnelColor ("Fresnel Color", Color) = (0,1,0,1)
        _FresnelPower ("Fresnel Power", Float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float4 normal : NORMAL;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
                float4 world_pos : TEXCOORD2;
                float3 view_dir : TEXCOORD3;
            };

            fixed4 _FresnelColor;
            float _FresnelPower;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = v.normal.xyz;
                
                o.world_pos = mul(unity_ObjectToWorld, v.vertex);
                o.view_dir = normalize(UnityWorldSpaceViewDir(o.world_pos));
                
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float fresnel = 1 - dot(i.normal, i.view_dir);
                fresnel = pow(fresnel, _FresnelPower);
                return _FresnelColor * fresnel;
            }
            ENDCG
        }
    }
}
