Shader "Unlit/ToonShader-Unlit"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color("Albedo", Color) = (1, 1, 1, 1)
        
        _OutlineWidth("Outline Width", Range(0.01, 2)) = 1
        _OutlineColor("Outline Color", Color) = (0, 0, 0, 1)
        
        _LevelCount("Level Count", Float) = 2
        _Attenuation("Attenuation", Range(0, 2)) = 0.5
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
            #include "UnityLightingCommon.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
                float3 lightDir : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            float4 _Color;
            float _LevelCount;
            float _Attenuation;

            half3 LightingRamp(half3 normal, half3 lightDir, half atten)
            {
                half NdotL = max(0, dot(normal, lightDir));
                half3 ramp = floor(NdotL * _LevelCount) / _LevelCount;

                half3 c;
                c.rgb = _LightColor0.rgb * max(0.1, (ramp * atten));
                return c;
            }

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.lightDir = normalize(_WorldSpaceLightPos0.xyz);
                return o;
            }

            half4 frag (v2f i) : SV_Target
            {
                half4 col = half4(tex2D(_MainTex, i.uv) * _Color * LightingRamp(i.normal, i.lightDir, _Attenuation), 1);
                return col;
            }
            ENDCG
        }

        Pass
        {
            Cull Front
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
            };

            float _OutlineWidth;
            half4 _OutlineColor;

            v2f vert (appdata v)
            {
                v2f o;
                o.normal = UnityObjectToWorldNormal(v.normal);

                v.vertex.xyz += o.normal * _OutlineWidth;
                
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            half4 frag (v2f i) : SV_Target
            {
                half4 col = _OutlineColor;
                return col;
            }
            ENDCG
        }
    }
}
