Shader "TheoVerwaerde/PostProcess/ImageEffectShaderJitter"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _Amplitude("Amplitude", float) = 1
        _Frequence("Frequence", float) = 1
        _Direction("Direction", Vector) = (0,1,0,0)
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
            float _Amplitude;
            float _Frequence;
            float2 _Direction;

            fixed4 frag(v2f i) : SV_Target
            {
                float move = _Amplitude * sin(_Time * _Frequence);
                fixed4 col = tex2D(_MainTex, i.uv + (length(_Direction) == 0 ? 0 : normalize(_Direction)*move));
                return col;
            }
            ENDCG
        }
    }
}
