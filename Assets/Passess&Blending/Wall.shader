Shader "Custom/BasicBlend"
{
    Properties
    {
        _MainTex("MainTex", 2D) = "white" {}
        _DecalTex("Decal", 2D) = "white" {}
        [Toggle] _ShowDecal("Show Decal", Float) = 0
    }
    
    SubShader
    {
        Tags{"Queue"="Geometry"}
        
        Stencil
        {
            ref 1 // this value represents the reference value of this shader.
            Comp NotEqual // drawn if the ref is not equal to the value in stencil buffer
            Pass Keep // keep the current contents in the stencil buffer
        }
        
        CGPROGRAM
        #pragma surface surf Lambert

        struct Input
        {
            float2 uv_MainTex;
        };

        sampler2D _MainTex;
        sampler2D _DecalTex;
        float _ShowDecal;

        void surf(Input IN, inout SurfaceOutput o)
        {
            float4 tex = tex2D(_MainTex, IN.uv_MainTex);
            float4 decal = tex2D(_DecalTex, IN.uv_MainTex) * _ShowDecal;
            o.Albedo = decal.r > 0.9 ? decal.rgb : tex.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
