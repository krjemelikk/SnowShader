Shader "Custom/InteractiveSnow/Snow"
{
    Properties
    {
        _Color("Color", Color) = (1,1,1,1)
        _MainTex("Albedo (RGB)", 2D) = "white" {}
        _Glossiness("Smoothness", Range(0,1)) = 0.5
        _Metallic("Metallic", Range(0,1)) = 0.0
        _MetallicGlossMap("Metallic", 2D) = "white" {}

        _HeightMap("Height Map", 2D) = "white" {}
        _NormalMap("Normal", 2D) = "white" {}
        _NormalMapAmount("Normal Map Amount", float) = 1
        _HeightAmount("Height Amount", float) = 0.5
        _TessellationAmount("Tessellation Amount", Range(1,32)) = 8
        _BottomColor("Bottom Color", Color) = (.8,.8,1,1)

    }
        SubShader
        {
            Tags { "RenderType" = "Opaque" }
            LOD 200

            CGPROGRAM
            // Physically based Standard lighting model, and enable shadows on all light types
            #pragma surface surf Standard fullforwardshadows vertex:vert addshadow tessellate:tess nolightmap

            float _TessellationAmount;
            float tess()
            {
                return _TessellationAmount;
            }

            #pragma target 4.6

            sampler2D _MainTex;
            sampler2D _HeightMap;
            sampler2D _NormalMap;
            sampler2D _MetallicGlossMap;

            struct Input
            {
                float2 uv_MainTex;
                float2 uv_NormalMap;
                float2 uv_MetallicGlossMap;
            };

            half _Glossiness;
            half _Metallic;
            fixed4 _Color;
            fixed4 _BottomColor;
            float _HeightAmount;
            float _NormalMapAmount;

            // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
            // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
            // #pragma instancing_options assumeuniformscaling
            UNITY_INSTANCING_BUFFER_START(Props)
                // put more per-instance properties here
            UNITY_INSTANCING_BUFFER_END(Props)


            void vert(inout appdata_full v)
            {
                float offset = tex2Dlod(_HeightMap, float4(v.texcoord.xy, 0, 0)).r * _HeightAmount;
                v.vertex.y += offset;
            }
            void surf(Input IN, inout SurfaceOutputStandard o)
            {
                float height = tex2D(_HeightMap, IN.uv_MainTex).r;
                fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * lerp(_BottomColor, _Color, height) * _NormalMapAmount;

                o.Albedo = c.rgb;
                o.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_NormalMap));

                fixed4 metal = tex2D(_MetallicGlossMap, IN.uv_MainTex);
                o.Metallic = metal.r;

                o.Smoothness = metal.a * _Glossiness;
                o.Alpha = c.a;
            }
            ENDCG
        }
            FallBack "Diffuse"
}
