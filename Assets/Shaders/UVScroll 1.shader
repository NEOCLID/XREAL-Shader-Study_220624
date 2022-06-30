Shader "UVScroll2"
{
	Properties {
		_TintColor("Test Color", color) = (1, 1, 1, 1)
		_Intensity("Range Sample", Range(0, 1)) = 0.5
		_MainTex("Main Texture", 2D) = "white" {}
		[NoScaleOffset] _Flowmap("Flowmap", 2D) = "white" {}
		_FlowTime("Flow Time", Range(0,2))=1
		_FlowIntensity("Flow Intensity", Range(0,2))=1
	}

	SubShader
	{
		Tags
		{
			"RenderPipeline"="UniversalPipeline"
			"RenderType"="Opaque"
			"Queue"="Geometry"
		}

		Pass
		{
			Name "Universal Forward"
			Tags {"LightMode" = "UniversalForward"}
			HLSLPROGRAM

			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x
			#pragma vertex vert
			#pragma fragment frag
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

			half4 _TintColor;
			float _Intensity;
			float4 _MainTex_ST;
			Texture2D _MainTex;
			sampler2D _Flowmap;
			SamplerState sampler_MainTex;

			float _FlowTime, _FlowIntensity;

			struct VertexInput
			{
				float4 vertex : POSITION;
			};

			struct VertexOutput
			{
				float4 vertex : SV_POSITION;
				float3 color: COLOR;
			};

			VertexOutput vert(VertexInput v)
			{
				VertexOutput o;
				o.vertex = TransformObjectToHClip(v.vertex.xyz);
				o.color=TransformObjectToWorld(v.vertex.xyz);

				return o;

			}

			half4 frag(VertexOutput i) : SV_Target
			{
				float color=half4(1,1,1,1);
				color*=i.color;
				return color;
			}
			ENDHLSL
		}
	}
}