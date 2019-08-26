// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "jim/XRayShader"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_RayColor("RayColor", COLOR) = (0,0,1,0)
		_Alpha("Alpha",float) = 0.5
	}
		SubShader
	{
		Pass
	{
		Tags{ "RenderType" = "Transparent" "Queue" = "Transparent" }
		Blend One OneMinusSrcAlpha
		Cull Back
		ZTest Greater
		ZWrite Off

		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		// make fog work
		#pragma multi_compile_fog

		#include "UnityCG.cginc"
		#include "Lighting.cginc"

	struct appdata
	{
		float4 vertex : POSITION;
		float2 uv : TEXCOORD0;
		float4 normal : NORMAL;
	};

	struct v2f
	{
		UNITY_FOG_COORDS(0)
			float4 vertex : SV_POSITION;
		float2 uv : TEXCOORD1;
		float4 diff : TEXCOORD2;
	};

	v2f vert(appdata v)
	{
		v2f o;
		o.vertex = UnityObjectToClipPos(v.vertex);
		o.uv = v.uv;

		float3 worldNormal = normalize(mul(unity_ObjectToWorld, float4(v.normal.xyz,0)).xyz) * -1; //将法线转换到世界空间， * -1 是为了有外轮廓的效果，因此将法线翻转
		float3 viewDirection = normalize(_WorldSpaceCameraPos); //将视野也转到相同的世界空间
		o.diff = max(0, dot(viewDirection, worldNormal)); //计算视野和法线的夹角 将垂直的部分不填色

		return o;
	}

	uniform float4 _RayColor;
	uniform float _Alpha;

	fixed4 frag(v2f i) : SV_Target
	{
		_RayColor *= i.diff.x;
		_RayColor.a = _Alpha;
		return _RayColor;
	}
		ENDCG
	}

		Pass
	{
		Tags{ "RenderType" = "Opaque" }
		ZWrite On
		ZTest LEqual


		CGPROGRAM
#pragma vertex vert
#pragma fragment frag
		// make fog work
#pragma multi_compile_fog

#include "UnityCG.cginc"

	struct appdata
	{
		float4 vertex : POSITION;
		float2 uv : TEXCOORD0;
	};

	struct v2f
	{
		float2 uv : TEXCOORD0;
		UNITY_FOG_COORDS(1)
			float4 vertex : SV_POSITION;
	};

	sampler2D _MainTex;
	float4 _MainTex_ST;

	v2f vert(appdata v)
	{
		v2f o;
		o.vertex = UnityObjectToClipPos(v.vertex);
		o.uv = TRANSFORM_TEX(v.uv, _MainTex);
		UNITY_TRANSFER_FOG(o,o.vertex);
		return o;
	}

	fixed4 frag(v2f i) : SV_Target
	{
		// sample the texture
		fixed4 col = tex2D(_MainTex, i.uv);
	// apply fog
	UNITY_APPLY_FOG(i.fogCoord, col);
	return col;
	}
		ENDCG
	}

	}
}