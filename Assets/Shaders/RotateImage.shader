Shader "TheoVerwaerde/RotateImage"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Rotate ("Rotate", Range(0, 360)) = 0
        _RotatePoint ("Rotate Point", Vector) = (0.5, 0.5, 0.0)
        
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

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float2 _RotatePoint;
            float _Rotate;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float angle = _Time * _Rotate;
                float2 uv_rot_center_offset = i.uv - _RotatePoint;
                float2 uv_rot_center_offset_rotated = float2(
                    uv_rot_center_offset.x * cos(angle) - uv_rot_center_offset.y * sin(angle),
                    uv_rot_center_offset.x * sin(angle) + uv_rot_center_offset.y * cos(angle));
                float2 uv_rot = _RotatePoint + uv_rot_center_offset_rotated;

                float4 tex = tex2D(_MainTex, uv_rot);
                return tex;
            }
            ENDCG
        }
    }
}
