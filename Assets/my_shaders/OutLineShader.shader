// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

//time:   2016-3-27
//author: Jim
//tips:   物体描边


Shader "jim/OutLineShader" {
	properties {
		_Color ("Main Color", Color) = (.5,.5,.5,1)
		_MainTex ("Main Tex",2D) = "white"{}
		_LineColor ("Line Color",Color) = (1,1,1,1)
		_LineSize ("LineSize",range(0,0.2)) = 0.01
	}
	SubShader {
		Pass{
		// 先绘制这个纯色的顶点，然后在下一个pass绘制对象。
   		//这里不存在前后面，关闭裁剪前后面，也不需要深度缓存
		Tags{
			"LightMode" = "Always"
			"Queue" = "Transparent"
		}
		Blend SrcAlpha OneMinusSrcAlpha
		Cull Off // 关闭剔除，模型前后都会显示
   		ZWrite Off // 系统默认是开的，要关闭。关闭深度缓存，后渲染的物体会根据ZTest的结果将自己渲染输出写入
//   		ZTest Always  // 深度测试[一直显示]，被其他物体挡住后，此pass绘制的颜色会显示出来
		CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			struct appdata {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};
			struct v2f{
				float4 color : COLOR;
				float4 pos : SV_POSITION;
			};
			
			fixed4 _LineColor;
			sampler2D _MainTex;
			// 获取材质的纹理坐标
			float4 _MainTex_ST;
			float _LineSize;
			
			v2f vert(appdata v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos (v.vertex);
    			// UNITY_MATRIX_IT_MV为【模型坐标-世界坐标-摄像机坐标】【专门针对法线的变换】
    			// 法线乘以MV，将模型空间 转换 视图空间
    			float3 norm = mul((float3x3)UNITY_MATRIX_IT_MV,v.normal);
    			// 转换 视图空间 到 投影空间 【3D转2D】
    			float2 offset = TransformViewToProjection(norm.xy);
    			 // 得到的offset，模型被挤的非常大，然后乘以倍率
    			o.pos.xy += offset * _LineSize * o.pos.z;
				o.color = _LineColor;
				return o;
			}
			
			half4 frag(v2f i) : Color
			{
				return i.color;
			}

		ENDCG
		}
		
		Pass{
			ZWrite On
			ZTest LEqual
			Blend SrcAlpha OneMinusSrcAlpha
		CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			
			struct v2f{
				float4 pos : SV_POSITION;
				float2 uv	: TEXCOORD0;
			};
			
			sampler2D _MainTex;
			// 获取材质的纹理坐标
			float4 _MainTex_ST;
			float4 _Color;
			
			v2f vert(appdata_full v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos (v.vertex);
				 // 用于带材质的写法，获取纹理坐标
    			o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				return o;
			}
			
			float4 frag(v2f i) : Color
			{
				float4 col = tex2D(_MainTex,i.uv);
				return col * _Color;
			}

		ENDCG
		}
		////////////采用固定管线渲染///////////////
//		Pass {
//			Name "BASE"
//			ZWrite On
//			ZTest LEqual
//			Blend SrcAlpha OneMinusSrcAlpha
//			Material {
//				Diffuse [_Color]
//				Ambient [_Color]
//			}
//			Lighting On
//			SetTexture [_MainTex] {
//				ConstantColor [_Color]
//				Combine texture * constant
//			}
//			SetTexture [_MainTex] {
//				Combine previous * primary DOUBLE
//			}
//		}
	}
	Fallback "Diffuse"
}
