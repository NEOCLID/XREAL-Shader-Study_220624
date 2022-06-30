// Shader ����. ���̴��� ������ �̸��� ���⼭ �����մϴ�.
Shader "Training03"
{

    Properties
    {
    // Properties Block : ���̴����� ����� ������ �����ϰ� �̸� material inspector�� �����ŵ�ϴ�
        _TintColor("Test Color", color) = (1,1,1,1)
        _Intensity("Range Sample", Range(0,1))=0.5
        _MainTex01("RGB(01)", 2D)="white"{}
        _MainTex02("RGB(02)", 2D)="white"{}

        _MaskTex("Mask Tex", 2D)="white"{}
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
            
            half4 _TintColor;
            float _Intensity;
            
            float4 _MainTex01_ST, _MainTex02_ST;
            Texture2D _MainTex01, _MainTex02, _MaskTex;
            SamplerState sampler_MainTex;

  
            //vertex buffer���� �о�� ������ �����մϴ�. 	
            struct VertexInput
            {
                float4 vertex : POSITION;
                float2 uv     : TEXCOORD0;
                float2 uv2      : TEXCOORD1;

                float4 color    :   COLOR;
            };

            //�����⸦ ���� ���ؽ� ���̴����� �ȼ� ���̴��� ������ ������ �����մϴ�.
            struct VertexOutput
            {
                float4 vertex  	: SV_POSITION;
                float2 uv       : TEXCOORD0;
                float2 uv2      : TEXCOORD1;

                float4 color    :   COLOR;
            };

            //���ؽ� ���̴�
            VertexOutput vert(VertexInput v)
            {

                VertexOutput o;      
                o.vertex = TransformObjectToHClip(v.vertex.xyz);
                o.uv=v.uv.xy*_MainTex01_ST.xy+_MainTex01_ST.zw;
                o.uv2=v.uv.xy*_MainTex02_ST.xy+_MainTex02_ST.zw;
                o.color=v.color;
                return o;
            }

            //�ȼ� ���̴�
            half4 frag(VertexOutput i) : SV_Target
            {   
                float4 color = i.uv.y > 0.5 ? pow(i.uv.x, 2.2) : i.uv.x;
                color += float4(1,0,0,0);

                //half4 tex01 = _MainTex01.Sample(sampler_MainTex, i.uv);
                //half4 tex02 = _MainTex02.Sample(sampler_MainTex, i.uv2);
                //half4 mask=_MaskTex.Sample(sampler_MainTex,i.uv);
                //half4 color = lerp(tex01, tex02, mask.r);
                //half4 color = lerp(tex01, tex02, i.color.r);
                //Why Problem..?

                return color;
            }

            ENDHLSL  
        }
    }
}