Shader "Unlit/ColorVF"
{
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
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float4 color: COLOR;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                //o.color.r = v.vertex.x;
                //o.color.g = v.vertex.z;
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                float4 col;
                col.r = i.vertex.x/1000;
                col.g = i.vertex.y/1000;
                return col;
            }
            ENDCG
        }
    }
}
