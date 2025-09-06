Shader "Custom/Waves"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        
        _Tint ("Color Tint", Color) = (1, 1, 1, 1)
        _Freq ("Frequency", Range(0, 5)) = 3
        _Speed ("Speed", Range(0, 100)) = 10
        _Amp ("Amplitude", Range(0, 1)) = 0.5
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Opaque"
        }
        LOD 200

        CGPROGRAM
        #pragma surface surf Lambert vertex:vert
        #pragma target 3.0

        sampler2D _MainTex;

        float4 _tine;
        float _Freq;
        float _Speed;
        float _Amp;

        struct Input
        {
            float2 uv_MainTex;
            float3 vertColor;
        };

        struct appdata
        {
            float4 vertex : POSITION;
            float3 normal : NORMAL;
            float2 texcoord : TEXCOORD0;
            float2 texcoord1 : TEXCOORD1;
            float2 texcoord2 : TEXCOORD2;
        };

        void vert(inout appdata v, out Input o)
        {
            UNITY_INITIALIZE_OUTPUT(Input, o);
            float t = _Time * _Speed;
            float waveHeight = (sin(t + v.vertex.x * _Freq) + cos(t + v.vertex.z * _Freq)) * _Amp;
            v.vertex.y += waveHeight;
            v.normal = normalize(float3(v.normal.x + waveHeight, v.normal.y, v.normal.z + waveHeight));
            o.vertColor = saturate(waveHeight + 2);
        }

        void surf(Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
            o.Albedo = c * IN.vertColor.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}