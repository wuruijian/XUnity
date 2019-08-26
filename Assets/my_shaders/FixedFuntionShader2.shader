Shader "jim/FixedFuntion2" {
	properties{
		_Color("Main Color",Color) = (1,1,1,1)
		_Ambient("Ambient",Color)=(0.3,0.3,0.3,0.3)//环境光
		_Specular("Specular",Color)=(1,1,1,1)//高光
		_Shiniess("Shininess",range(0,8)) = 4//高光范围
		_Emission("Emission",Color)=(1,1,1,1)//自发光
		_MainTex("MainTex",2d) = "white"{}
		_SecTex("SecTex",2d) = "white"{}
		_Constant("ConstantColor",Color) = (1,1,1,0.5)
	}
	SubShader {
		Tags { "Queue"="Transparent" "RenderType" = "Transparent"}
		pass{
			Blend SrcAlpha OneMinusSrcAlpha
			//color(1,1,1,1)
			//color[_Color]
			material{
				diffuse[_Color]
				ambient[_Ambient]
				specular[_Specular]
				shininess[_Shiniess]
				emission[_Emission]
			}
			lighting on//把光照开起来，不然diffuse不起作用
			separatespecular on //开了这个，高光才起作用

			settexture[_MainTex]{
				combine texture * primary double//primary是代表之前处理的值,double是将亮度放大2倍，因为相乘之后值变小，所以适当当大点
			}
			settexture[_SecTex]{
				constantColor[_Constant]//控制透明度的系数
				combine texture * previous double,texture*constant//previous是代表之前处理的值(_MainTex+高光处理),后面的texture取透明通道
			}
		}
	}
}
