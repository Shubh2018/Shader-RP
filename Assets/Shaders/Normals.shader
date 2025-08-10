Shader "Custom/Normals"
{
    Properties
    {
        _ColorA("Color A", Color) = (1, 1, 1, 1)
        _ColorB("Color B", Color) = (1, 1, 1, 1)
        _ColorStart ("Color Start", Range(0, 1)) = 0
        _ColorEnd ("Color End", Range(0, 1)) = 0
    }
    SubShader
    {
        Cull Off

        Tags {
            "RenderType"="Transparent"
            "Queue"="Transparent"
        }

        Pass
        {
            ZWrite Off
            ZTest LEqual
            Blend One One // Additive 
            //Blend DstColor Zero //Muliplicative

            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #define TAU 6.283185307179586

            float4 _ColorA;
            float4 _ColorB;

            float _ColorStart;
            float _ColorEnd;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normals : NORMAL;
            };

            struct v2f
            {
                float3 normals : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD1;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normals = UnityObjectToWorldNormal(v.normals);
                o.uv = v.uv;
                return o;
            }

            float InverseLerp(float a, float b, float v)
            {
                return (v-a)/(b-a);
            }

            float4 frag (v2f i) : SV_Target
            {
                float xOffset = cos(i.uv.x * TAU * 8) * 0.01;
                float t = cos((i.uv.y + xOffset - _Time.y * 0.2) * TAU * 5) * 0.5 + 0.5;

                t *= 1 - i.uv.y;

                float topBottomRemover = (abs(i.normals.y) < 0.999);
                float waves = t * topBottomRemover;

                float4 gradient = lerp(_ColorA, _ColorB, i.uv.y);

                return gradient * waves;
            }

            ENDCG
        }
    }
}
