Shader "Custom/Leaves"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM

        #pragma surface surf Lambert alpha:fade

        sampler2D _MainTex;

        struct Input
        {
             fixed2 uv_MainTex;    
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            float4 color = tex2D(_MainTex, IN.uv_MainTex).rgba;

            o.Albedo = color.rgb;
            o.Alpha = color.a;
        }

        ENDCG
    }
    FallBack "Diffuse"
}
