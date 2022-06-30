// Shader 시작. 셰이더의 폴더와 이름을 여기서 결정합니다.
Shader "Training03"
{

    Properties
    {
    // Properties Block : 셰이더에서 사용할 변수를 선언하고 이를 material inspector에 노출시킵니다
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
           //Render type과 Render Queue를 여기서 결정합니다.
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

            //cg shader는 .cginc를 hlsl shader는 .hlsl을 include하게 됩니다.
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"        	
            
            half4 _TintColor;
            float _Intensity;
            
            float4 _MainTex01_ST, _MainTex02_ST;
            Texture2D _MainTex01, _MainTex02, _MaskTex;
            SamplerState sampler_MainTex;

  
            //vertex buffer에서 읽어올 정보를 선언합니다. 	
            struct VertexInput
            {
                float4 vertex : POSITION;
                float2 uv     : TEXCOORD0;
                float2 uv2      : TEXCOORD1;

                float4 color    :   COLOR;
            };

            //보간기를 통해 버텍스 셰이더에서 픽셀 셰이더로 전달할 정보를 선언합니다.
            struct VertexOutput
            {
                float4 vertex  	: SV_POSITION;
                float2 uv       : TEXCOORD0;
                float2 uv2      : TEXCOORD1;

                float4 color    :   COLOR;
            };

            //버텍스 셰이더
            VertexOutput vert(VertexInput v)
            {

                VertexOutput o;      
                o.vertex = TransformObjectToHClip(v.vertex.xyz);
                o.uv=v.uv.xy*_MainTex01_ST.xy+_MainTex01_ST.zw;
                o.uv2=v.uv.xy*_MainTex02_ST.xy+_MainTex02_ST.zw;
                o.color=v.color;
                return o;
            }

            //픽셀 셰이더
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