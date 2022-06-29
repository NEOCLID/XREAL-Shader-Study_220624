// Shader ����. ���̴��� ������ �̸��� ���⼭ �����մϴ�.
Shader "2ndDayTest"
{
   

    Properties
    {
    // Properties Block : ���̴����� ����� ������ �����ϰ� �̸� material inspector�� �����ŵ�ϴ�
        _TintColor("Test Color", color) = (1,1,1,1)
        _Intensity("Range Sample", Range(0,1))=0.5
        _MainTex("RGB(A)", 2D)="white"{}
    }  

    SubShader
    {  
        Tags
        {
        //Render type�� Render Queue�� ���⼭ �����մϴ�.
        "RenderPipeline"="UniversalPipeline"
            "RenderType"="Opaque"          
            "Queue"="Geometry"
        }

        Pass
        {  		
            Name "Universal Forward"
                Tags { "LightMode" = "UniversalForward" }

            HLSLPROGRAM

            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x
            #pragma vertex vert
            #pragma fragment frag

            //cg shader�� .cginc�� hlsl shader�� .hlsl�� include�ϰ� �˴ϴ�.
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"        	
  
            //vertex buffer���� �о�� ������ �����մϴ�. 	
            struct VertexInput
            {
                float4 vertex : POSITION;
                float2 uv     : TEXCOORD0;
            };

            //�����⸦ ���� ���ؽ� ���̴����� �ȼ� ���̴��� ������ ������ �����մϴ�.
            struct VertexOutput
            {
                float4 vertex  	: SV_POSITION;
                float2 uv       : TEXCOORD0;

            };
            half4 _TintColor;
            float _Intensity;

            sampler2D _MainTex;
            float4 _MainTex_ST;

            //���ؽ� ���̴�
            VertexOutput vert(VertexInput v)
            {

                VertexOutput o;      
                o.vertex = TransformObjectToHClip(v.vertex.xyz);
                o.uv=v.uv;

                return o;
            }

            //�ȼ� ���̴�
            half4 frag(VertexOutput i) : SV_Target
            {   
                float2 uv = i.uv.xy * _MainTex_ST.xy + _MainTex_ST.zw; 
                float4 color = tex2D(_MainTex, uv) * _TintColor * _Intensity;

                return color;
            }

            ENDHLSL  
        }
    }
}