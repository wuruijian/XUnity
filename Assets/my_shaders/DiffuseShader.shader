// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "jim/DiffuseShader"
{
	SubShader
	{

		Pass
		{
			tags {"LightMode"="ForwardBase"}
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			struct v2f{
				float4 pos : POSITION; 
				float4 color : COLOR;
			};
			
			v2f vert (appdata_base v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);

				float3 norl =  normalize(v.normal);
				float3 lightNorl = normalize(_WorldSpaceLightPos0).xyz;

				lightNorl = mul(float4(lightNorl,0),unity_WorldToObject).xyz;
				lightNorl = normalize(lightNorl);

				float dotValue = saturate( dot(norl,lightNorl));

				o.color =  _LightColor0*dotValue;
				return o;
			}
			
			fixed4 frag (v2f i) : COLOR
			{
				return i.color+UNITY_LIGHTMODEL_AMBIENT;
			}
			ENDCG
		}
	}
}
