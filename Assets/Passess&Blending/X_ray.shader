Shader "Custom/X_ray"
{
    Properties
    {
        _MainTex("Diffuse", 2D) = "white" {}
    }
    
    SubShader
    {
        Tags { "Queue" = "Geometry-1" }
        
        ColorMask 0
        ZWrite Off
        
        Stencil
        {
            Ref 1
            Comp Always
            Pass Replace
        }
        
        CGPROGRAM

        #pragma surface surf Lambert

        sampler2D _MainTex;
        
        struct Input
        {
            float2 uv_MainTex;    
        };
        
        void surf(Input IN, inout SurfaceOutput o)
        {
            float4 color = tex2D(_MainTex, IN.uv_MainTex);
            o.Albedo = color.rgb;
        }
        
        ENDCG
    }
    FallBack "Diffuse"
}
