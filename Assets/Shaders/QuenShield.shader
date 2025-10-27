Shader "Unlit/QuenShield"
{
    Properties
    {
        [HDR] _FresnelColor("Fresnel Color", Color) = (1, 1, 1, 1)
        _FresnelPower("Fresnel Power", Range(1, 20)) = 1
        
        _Freq("Frequency", Range(0, 1)) = 0.5
        _Amp("Amplitude", Range(0.01, 0.1)) = 0.05
        _Speed("Speed", Range(0, 100)) = 10
        
        _Tess("Tesselation", Range(2, 400)) = 20
        _MinDist("Minimum Distance", Float) = 1
        _MaxDist("Maximum Distance", Float) = 10
        _Phong("Phong Value", Range(0, 1)) = 0.5
    }
    
    SubShader
    {
        Tags {
            "RenderType"="Transparent"
            "Queue"="Transparent"
        }
        
        LOD 100
        
        Blend SrcAlpha OneMinusSrcAlpha

        Zwrite On
        Cull Back
        
        Pass
        {
            CGPROGRAM
            #if !defined(TESSELLATION_CGINC_INCLUDED)
            #define  TESSELLATION_CGINC_INCLUDED
            #endif
            #pragma target 5.0
            
            #pragma vertex vert
            #pragma fragment frag
            #pragma hull hullprogram

            #pragma tessphong _Phong

            #include "UnityCG.cginc"
            #include "Tessellation.cginc"

            float _FresnelPower;
            float4 _FresnelColor;

            float _Speed;
            float _Freq;
            float _Amp;
            
            float _Tess;
            float _MinDist;
            float _MaxDist;

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord: TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
                float3 viewDir : TEXCOORD1;
                float4 worldPos : TEXCOORD2;
            };

            struct TessellationFactors
            {
                float edge[3] : SV_TessFactor;
                float inside : SV_InsideTessFactor;
            };

            [UNITY_domain("tri")]
            [UNITY_outputcontrolpoints(3)]
            [UNITY_outputtopology("triangle_cw")]
            [UNITY_partitioning("integer")]
            [UNITY_patchconstantfunc("PatchConstant")]
            v2f hullprogram(InputPatch<v2f, 3> patch, uint id : SV_OutputControlPointID)
            {
                return patch[id];
            }

            TessellationFactors PatchConstant(InputPatch<v2f, 3> patch)
            {
                TessellationFactors f;
                f.edge[0] = 1;
                f.edge[1] = 1;
                f.edge[2] = 1;
                f.inside = 1;
                return f;
            }

            [UNITY_domain("tri")]
            void domainProgram(TessellationFactors factors, OutputPatch<v2f, 3> patch, float3 barycentricCoordinates : SV_DomainLocation)
            {
                v2f data;

                #define INTERPOLATE(fieldName) data.fieldName = patch[0].fieldName * barycentricCoordinates.x + patch[1].fieldName * barycentricCoordinates.y + patch[2].fieldName * barycentricCoordinates.z

                INTERPOLATE(vertex);
                INTERPOLATE(normal);
            }
            
            v2f vert (appdata v)
            {
                v2f o;

                //Fresnel
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.viewDir = normalize(UnityWorldSpaceViewDir(o.worldPos));

                //VertexDisplacement
                float t = _Speed * _Time;
                float height = _Amp * sin(v.vertex.y * t + _Freq );
                v.vertex += normalize(float4(o.normal, 1)) * height;

                o.vertex = UnityObjectToClipPos(v.vertex);
                
                return o;
            }

            half4 frag (v2f i) : SV_Target
            {
                //return half4(1, 1, 1, 1);
                half4 color = _FresnelColor * pow(1 - dot(i.viewDir, i.normal), _FresnelPower * saturate((sin(_Time.y) + 1.5) * 0.5));
                return color;
            }
            ENDCG
        }
    }
}
