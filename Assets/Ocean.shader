Shader "Custom/Ocean"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _FoamTex("Texture", 2D) = "white" {}
         
        _Freq("Frequency", Range(0, 1)) = 0.5
        _Amp("Amplitude", Range(0, 1)) = 0.5
        _Speed("Speed", Range(0, 100)) = 10
        
        _MainUVScrollSpeed ("Main Texture Scroll Speed", Vector) = (0, 0, 0)
        _FoamUVScrollSpeed ("Foam Texture Scroll Speed", Vector) = (0, 0, 0)
    }
    SubShader
    {
        CGPROGRAM

        #pragma surface surf Lambert vertex:vert
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _FoamTex;

        float3 _MainUVScrollSpeed;
        float3 _FoamUVScrollSpeed;
        
        struct Input
        {
            float2 uv_MainTex;
            float2 uv_FoamTex;
            float3 vertColor;
        };

        float _Freq;
        float _Amp;
        float _Speed;

        void vert(inout appdata_base v, out Input o)
        {
            UNITY_INITIALIZE_OUTPUT(Input, o);
            float t = _Speed * _Time;
            float height = sin(v.vertex.x * _Freq + t) * _Amp;
            v.vertex.y += height;
            v.normal = normalize(float3(v.normal.x + height, v.normal.y, v.normal.z));
            o.vertColor = saturate(height + 2);
        }

        void surf (Input IN, inout SurfaceOutput o)
        {
            float2 newMainUV = IN.uv_MainTex + (_MainUVScrollSpeed * _Time);
            float2 newFoamUV = IN.uv_FoamTex + (_FoamUVScrollSpeed * _Time);
            float4 mainTex = tex2D (_MainTex, newMainUV);
            float4 foamTex = tex2D (_FoamTex, newFoamUV);
            o.Albedo = saturate((mainTex.rgb + foamTex.rgb) / 2);
        }
        
        ENDCG
    }
    FallBack "Diffuse"
}
