Shader "TheoVerwaerde/NegatifScene"
{
    Properties
    {
        
        _Normal ("Texture", 2D) = "white" {}
        _NegValue ("Negatif", Range(0,1)) = 1
        _Zoom ("Zoom", Float) = 1
        _NormalScale ("Normal", Range(0.001,0.01)) = 0.001
    }
    SubShader
    {
        Tags { "Queue" = "Transparent" }
        
        GrabPass
        {
            
        }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct v2f
            {
                float4 grabPos : TEXCOORD0;
                float2 uv : TEXCOORD1;
                float4 vertex : SV_POSITION;
            };
            
            sampler2D _GrabTexture;

            sampler2D _Normal;
            float4 _Normal_ST;
            float _NegValue;
            float _NormalScale;
            float _Zoom;
            

            v2f vert (appdata_base v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                
                o.uv = TRANSFORM_TEX(v.texcoord, _Normal);

                o.grabPos = ComputeGrabScreenPos(float4(o.vertex.xyz, o.vertex.w + _Zoom));
                
                return o; 
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float3 normal = UnpackNormalWithScale( tex2D(_Normal, i.uv),_NormalScale);
                
                half4 bgcolor = tex2Dproj(_GrabTexture, float4(i.grabPos.xyz+normal,i.grabPos.w));
                return lerp(bgcolor,_NegValue - bgcolor,_NegValue);
            }
            ENDCG
        }
    }
}
