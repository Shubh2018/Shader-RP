Shader "Custom/RimShader"
{
    Properties
    {
        _MainColor("Color", Color) = (1, 1, 1, 1)
        _RimColor("Rim Color", Color) = (0, 0.5, 0.5, 0)
        _RimPower("Rim Power", Range(0.5, 8)) = 3

        _MainTex("Main Texure", 2D) = "white" {}
        _StripeWidth("Stripe Width", Range(0, 1)) = 1
    }

    SubShader
    {
        CGPROGRAM

        #pragma surface surf Lambert

        struct Input{
            float3 viewDir;
            float3 worldPos;
            float2 uv_MainTex;
        };

        float4 _Color;
        float4 _RimColor;
        float _RimPower;

        sampler2D _MainTex;
        float _StripeWidth;

        void surf(Input IN, inout SurfaceOutput o)
        {
            o.Albedo = tex2D(_MainTex, IN.uv_MainTex);

            half rim = 1 - saturate(dot(normalize(IN.viewDir), o.Normal));
            o.Emission = frac(IN.worldPos.y * 10 * _StripeWidth) > 0.4 ? float3(0, 1, 0) * rim: float3(1, 0, 0) * rim;
        }

        ENDCG
    }

    FallBack "Diffuse"
}
