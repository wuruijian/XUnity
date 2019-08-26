// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

//time:   2016-3-26
//author: Jim
//tips:   简单控制贴图颜色

Shader "jim/ColorShader" {
	properties {
		_MainTex ("Main Tex",2D) = "white"{}
		_MainColor ("Main Color",Color) = (1,1,1,1)
	}
	SubShader {
		Tags{
			"RenderType" = "Transparent"
			"Queue" = "Transparent"
		}
		
		Pass{
		CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			
			struct appdata_t{
				float4 color : COLOR;
				float4 pos  : POSITION;
				float2 texcoord	: TEXCOORD0;
			};
			
			struct v2f{
				float4 color : COLOR;
				float4 pos : SV_POSITION;
				float2 texcoord	: TEXCOORD0;
			};
			
			fixed4 _MainColor;
			uniform sampler2D _MainTex;
			// 获取地球材质的纹理坐标
			uniform float4 _MainTex_ST;
			
			v2f vert(appdata_t v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos (v.pos);
				 // 用于带材质的写法，获取纹理坐标
    			o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
				o.color = v.color;
				return o;
			}
			
			float4 frag(v2f i) : Color
			{
				float4 col = tex2D(_MainTex,i.texcoord);
				col *= _MainColor;
				return col;
			}

		ENDCG
		}
	}
	
	FallBack "Diffuse"
	
	
}
