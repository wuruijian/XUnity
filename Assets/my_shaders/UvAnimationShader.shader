// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

//time:   2016-3-27
//author: Jim
//tips:   uv animation

Shader "jim/UvAnimation_Shader" {
	properties {
		_MainTex ("Main Tex",2D) = "white"{}
		_MainColor ("Main Color",Color) = (1,1,1,1)
		_SizeX ("sizeX",float) = 3
		_SizeY ("sizeY",float) = 1
		_Speed ("speed",float) = 100
	}
	SubShader {
		Tags{
			"RenderType" = "Transparent"
			"Queue" = "Transparent"
		}
		
		Blend SrcAlpha OneMinusSrcAlpha
		
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
			uniform sampler2D _MainTex_ST;
			
			fixed _SizeX;
			fixed _SizeY;
			fixed _Speed;
			
			float2 moveUV(float2 uv){
			 	// 当前播放总索引
				int index = _Time.x * _Speed;
				// 求列索引
				int col = fmod(index, _SizeX);
				// 求行索引
				int row = index / _SizeX;
				// 获取单元格UV
				float2 cellUV = float2(uv.x/_SizeX,uv.y/_SizeY);
				
				cellUV.x += col * (1/_SizeX);
				cellUV.y += row * (1/_SizeY);
				return cellUV;
			}
			
			
			v2f vert(appdata_t v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos (v.pos);
				o.texcoord = moveUV(v.texcoord.xy);
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
