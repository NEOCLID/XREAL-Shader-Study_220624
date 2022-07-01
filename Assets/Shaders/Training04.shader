Shader "Unlit/NewUnlitShader"
{
	Properties {
		_AmbientColor("Ambient Color", color) = (1, 1, 1, 1)
		_LightWidth("Light Width", Range(0, 255)) = 1
		_LightStep("Light Step", Range(0, 255)) = 1
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

			half4 _AmbientColor;
			float _LightWidth, _LightStep;

			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct VertexOutput
			{
				float4 vertex : SV_POSITION;
				float3 color  : COLOR;
				float3 normal : NORMAL;
			};

			VertexOutput vert(VertexInput v)
			{
				VertexOutput o;
				o.vertex = TransformObjectToHClip(v.vertex.xyz);
				o.normal=TransformObjectToWorldNormal(v.normal);
				return o;
			}

			half4 frag(VertexOutput i) : SV_Target
			{
				half4 color=half4(1,1,1,1);
				//color.rgb*=i.color;

				float3 light = _MainLightPosition.xyz;
				float3 lightcolor = _MainLightColor.rgb;

				float NdotL=saturate(dot(i.normal,light));

				float3 toonlight = ceil((NdotL)*_LightWidth)/_LightStep;

				float3 combine=NdotL>0?toonlight:_AmbientColor;

				color.rgb *= combine * lightcolor;

				return color;
			}
			ENDHLSL
		}
	}
}