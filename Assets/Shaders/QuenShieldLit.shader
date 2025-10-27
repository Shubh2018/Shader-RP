Shader "Custom/QuenShieldLit"
{
    Properties
    {
        [HDR] _FresnelColor("Fresnel Color", Color) = (1, 1, 1, 1)
        _FresnelPower("Fresnel Power", Range(1, 20)) = 1
    }
    
    SubShader
    {
        Tags {
            "RenderType"="Transparent"
            "Queue"="Transparent"
        }
        
        LOD 200
        Blend OneMinusSrcAlpha SrcAlpha
        ZWrite On
        
        CGPROGRAM
        
        #pragma surface surf Standard fullforwardshadows alpha:auto
        
        #pragma target 3.0

        float _FresnelPower;
        float4 _FresnelColor;

        struct Input
        {
            float2 uv_MainTex;
            float3 worldNormal;
            float3 viewDir;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            o.Emission = _FresnelColor * pow(1 - dot(normalize(IN.worldNormal), normalize(IN.viewDir)), _FresnelPower);
            o.Alpha = dot(normalize(IN.worldNormal), normalize(IN.viewDir));
        }
        ENDCG
    }
    FallBack "Diffuse"
}
