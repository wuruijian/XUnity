// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

//time:   2016-3-26
//author: Jim
//tips:   透明度控制


//语法
//Blend Off     不混合
//Blend SrcFactor DstFactor  SrcFactor是源系数，DstFactor是目标系数
//最终颜色 = （Shader计算出的点颜色值 * 源系数）+（点累积颜色 * 目标系数）
//
//属性（往SrcFactor，DstFactor 上填的值）
//one                          1
//zero                         0
//SrcColor                   源的RGB值，例如（0.5,0.4,1）
//SrcAlpha                   源的A值, 例如0.6
//DstColor                   混合目标的RGB值例如（0.5，0.4,1）
//DstAlpha                   混合目标的A值例如0.6
//OneMinusSrcColor          (1,1,1) - SrcColor
//OneMinusSrcAlpha          1- SrcAlpha
//OneMinusDstColor          (1,1,1) - DstColor
//OneMinusDstAlpha          1- DstAlpha
//
//运算法则示例：
//（注：r,g,b,a,x,y,z取值范围为[0,1]）
//
//（r,g,b） * a = (r*a , g*a , b*a)
//（r,g,b） * (x,y,z) = (r*x , g*y , b*z)
//（r,g,b） + (x,y,z) = (r+x , g+y , b+z)
//（r,g,b） - (x,y,z)  = (r-x , g-y , b-z)



Shader "jim/AlphaShader" {
	properties {
		_MainTex ("Main Tex",2D) = "white"{}
		_MainColor ("Main Color",Color) = (1,1,1,1)
		_Alpha ("Alpha",Range(0,1)) = 0.5
	}
	SubShader {
		Tags{
			"RenderType" = "Transparent"
			"Queue" = "Transparent"
		}
//		Blend Zero One //仅显示背景的RGB部分，无Alpha透明通道处理。

//		Blend One Zero //仅显示贴图的RGB部分，无Alpha透明通道处理。 A通道为0即本应该透明的地方也渲染出来了。

//		Blend One One //贴图和背景叠加，无Alpha透明通道处理。仅仅是颜色rgb数值的叠加更趋近于白色即（1，1，1）了。

//		Blend SrcAlpha zero //仅仅显示贴图，贴图含Alpha透明通道处理。但是贴图中的透明部分，即下图黑色部分没有颜色来显示，因为源颜色乘以alpha值0，为0；而混合目标的颜色乘以zero 0，也是0。所以透明部分显示的颜色为（0，0，0）
		
		Blend SrcAlpha OneMinusSrcAlpha
//		最终颜色 = 源颜色 * 源透明值 + 目标颜色*（1 - 源透明值）
//		最常用的透明混合方式。贴图alpha值高的部分，显示得实，而混合的背景很淡。而alpha值高的部分，贴图显示得淡，而背景现实得实。
//		举例：
//		（1）假设贴图有一个不透明红色点【风宇冲】Unity3D教程宝典之Shader篇：第十三讲 <wbr>Alpha混合， Color（1，0，0，1），该点背景色为不透明蓝色 【风宇冲】Unity3D教程宝典之Shader篇：第十三讲 <wbr>Alpha混合Color（0，0，1，1）
//		最终颜色 =  （1，0，0）* 1+（0，0，1）*（1-1） = （1，0，0）【风宇冲】Unity3D教程宝典之Shader篇：第十三讲 <wbr>Alpha混合
//		结论一：贴图alpha值为1时，仅显示贴图，不显示背景
//
//		（2）假设贴图有一个透明红色点【风宇冲】Unity3D教程宝典之Shader篇：第十三讲 <wbr>Alpha混合， Color（1，0，0，0），该点背景色为透明，但B通道值为1，即Color（0，0，1，0）
//		最终颜色 =  （1，0，0）* 0+（0，0，1）*（1-0） = （0，0，1）【风宇冲】Unity3D教程宝典之Shader篇：第十三讲 <wbr>Alpha混合
//		结论二：贴图alpha值为0时，仅显示混合目标即背景，不显示贴图
//		但是目标alpha值为0，即其实这个点的背景是透明的，而我们却把它显示出来了，这就不对了。
//		经验：带A通道的贴图中，空的地方不只A值为0，RGB值也要为0，不然容易出错。
//
//		（3）假设贴图有一个半透明红色点【风宇冲】Unity3D教程宝典之Shader篇：第十三讲 <wbr>Alpha混合， Color（1，0，0，0.8），该点背景色为不透明蓝色【风宇冲】Unity3D教程宝典之Shader篇：第十三讲 <wbr>Alpha混合 Color（0，0，1，1）
//		最终颜色 =  （1，0，0）* 0.8+（0，0，1）*（1-0.8） = （0.8，0，0.2）【风宇冲】Unity3D教程宝典之Shader篇：第十三讲 <wbr>Alpha混合
//		而假如0.8变为0.2时，
//		最终颜色 =  （1，0，0）* 0.2+（0，0，1）*（1-0.2） = （0.2，0，0.8）【风宇冲】Unity3D教程宝典之Shader篇：第十三讲 <wbr>Alpha混合
//		结论：贴图alpha值越大，颜色越偏向贴图；alpha值越小，颜色越偏向混合目标
		
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
			float _Alpha;
			
			
			v2f vert(appdata_t v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos (v.pos);
				o.texcoord = v.texcoord;
				o.color = v.color;
				return o;
			}
			
			float4 frag(v2f i) : Color
			{
				float4 col = tex2D(_MainTex,i.texcoord);
				col *= _MainColor;
				col.a *= _Alpha;
				return col;
			}

		ENDCG
		}
	}
	
	FallBack "Diffuse"
	
	
}
