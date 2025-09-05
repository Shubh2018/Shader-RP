Shader "Unlit/ColorVS"
{
    Properties
    {

    }
    
    SubShader
    {
        Tags { "RenderType"="Opaque" }

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
                float4 vertex : SV_POSITION;
                float4 color : COLOR;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.color = float4(v.vertex.x, 0, 0, 1);
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                float4 col = i.color;
                return col;
            }
            ENDCG
        }
    }
}
