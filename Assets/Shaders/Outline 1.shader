Shader "Custom/Outline 1"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _OutlineColor("Outline Color", Color) = (0,0,0,1)
        _Outline("Outline Width", Range(0.002, 0.1)) = 0.005
    }
    SubShader
    {
        Pass
        {
          CGPROGRAM
          #pragma surface surf Lambert vertex:vert

          #pragma target 3.0

          sampler2D _MainTex;

          struct Input
          {
              float2 uv_MainTex;
          };

          fixed4 _Color;

          void surf(Input IN, inout SurfaceOutput o)
          {
              o.Albedo = tex2D(_MainTex, IN.uv_MainTex) * _Color;
          }
          ENDCG
        }
    }
    FallBack "Diffuse"
}
