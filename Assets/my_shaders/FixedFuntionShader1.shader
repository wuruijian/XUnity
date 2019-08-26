Shader "jim/FixedFuntion1" {
	properties{
		_Color("Main Color",Color) = (1,1,1,1)
		_Ambient("Ambient",Color)=(0.3,0.3,0.3,0.3)//环境光
		_Specular("Specular",Color)=(1,1,1,1)//高光
		_Shiniess("Shininess",range(0,8)) = 4//高光范围
		_Emission("Emission",Color)=(1,1,1,1)//自发光
	}
	SubShader {

		pass{
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
		}
	}
}
