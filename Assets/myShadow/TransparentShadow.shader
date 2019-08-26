﻿// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unlit/TransparentShadow"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Color("Main Color",color) = (1,1,1,1)
		_Cutoff("Base Alpha cutoff",range(0,0.9)) = 0.2
	}
	SubShader
	{
		Tags { "Queue"="Transparent" }
		LOD 100
		Lighting Off
		Zwrite Off
		Cull Off
		Blend SrcAlpha OneMinusSrcAlpha

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 color : COLOR;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _Cutoff;
			float4 _Color;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.color = v.color;
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);

				if(col.a < _Cutoff){
					clip(col.a - _Cutoff);
				}else{
					col.rgb = col.rgb * float3(0,0,0);
					col.rgb = col.rgb + _Color;
					col.a = _Color.a;
				}
				return col;
			}
			ENDCG
		}
	}
}
