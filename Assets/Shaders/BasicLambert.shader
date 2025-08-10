Shader "Custom/BasicLambert"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _SpecColor("Spec Color", Color) = (1,1,1,1)
        _Spec("Specular", Range(0, 1)) = 0.5
        _Gloss("Gloss", Range(0, 1)) = 0.5
    }
    SubShader
    {
        CGPROGRAM

        #pragma surface surf BasicLambert

        half4 LightingBasicLambert(SurfaceOutput s, half3 lightDir, half atten)
        {
            half NdotL = dot(s.Normal, lightDir);

            half4 c;
            c.rgb = s.Albedo * _LightColor0.rgb * (NdotL * atten);
            c.a = s.Alpha;
            return c;
        }

        fixed4 _Color;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Albedo = _Color.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
