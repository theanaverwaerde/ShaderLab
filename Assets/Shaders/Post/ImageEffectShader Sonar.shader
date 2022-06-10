Shader "TheoVerwaerde/PostProcess/ImageEffectShaderSonar"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _Color("Color", Color) = (1, 0, 0, 1)
        _Lenght("Lenght", Range(0,1)) = 1
        _Width("Width", Range(0,1)) = .5
        _Speed("Speed", Range(0,10)) = .5
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;
            sampler2D _CameraDepthTexture;
            float4 _Color;
            float _Lenght;
            float _Width;
            float _Speed;

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 base = tex2D(_MainTex, i.uv);
                
                float depth = tex2D(_CameraDepthTexture, i.uv).r;
                float depth01 = Linear01Depth(depth);

                float pos = (_Time * _Speed) % _Lenght;

                float sonar = smoothstep(pos-_Width, pos, depth01);
                float sonarCut = step(pos, depth01);

                float sonarFinal = sonar-sonarCut;
                
                return lerp(base,_Color,sonarFinal);
            }
            ENDCG
        }
    }
}
