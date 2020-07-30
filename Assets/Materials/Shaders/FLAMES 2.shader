// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "FLAMES 2"
{
	Properties
	{
		_Noise1Speed("Noise 1 Speed", Float) = -1.5
		_Noise1Scale("Noise 1 Scale", Float) = 1.22
		_Noise2Speed("Noise 2 Speed", Float) = -1
		_Noise2Scale("Noise 2 Scale", Float) = 0.54
		_Base("Base", 2D) = "white" {}
		_BaseColour("Base Colour", Color) = (0,0.9716981,0.9422502,1)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform sampler2D _Base;
		uniform float _Noise1Speed;
		uniform float _Noise1Scale;
		uniform float _Noise2Speed;
		uniform float _Noise2Scale;
		uniform float4 _BaseColour;


		float3 mod3D289( float3 x ) { return x - floor( x / 289.0 ) * 289.0; }

		float4 mod3D289( float4 x ) { return x - floor( x / 289.0 ) * 289.0; }

		float4 permute( float4 x ) { return mod3D289( ( x * 34.0 + 1.0 ) * x ); }

		float4 taylorInvSqrt( float4 r ) { return 1.79284291400159 - r * 0.85373472095314; }

		float snoise( float3 v )
		{
			const float2 C = float2( 1.0 / 6.0, 1.0 / 3.0 );
			float3 i = floor( v + dot( v, C.yyy ) );
			float3 x0 = v - i + dot( i, C.xxx );
			float3 g = step( x0.yzx, x0.xyz );
			float3 l = 1.0 - g;
			float3 i1 = min( g.xyz, l.zxy );
			float3 i2 = max( g.xyz, l.zxy );
			float3 x1 = x0 - i1 + C.xxx;
			float3 x2 = x0 - i2 + C.yyy;
			float3 x3 = x0 - 0.5;
			i = mod3D289( i);
			float4 p = permute( permute( permute( i.z + float4( 0.0, i1.z, i2.z, 1.0 ) ) + i.y + float4( 0.0, i1.y, i2.y, 1.0 ) ) + i.x + float4( 0.0, i1.x, i2.x, 1.0 ) );
			float4 j = p - 49.0 * floor( p / 49.0 );  // mod(p,7*7)
			float4 x_ = floor( j / 7.0 );
			float4 y_ = floor( j - 7.0 * x_ );  // mod(j,N)
			float4 x = ( x_ * 2.0 + 0.5 ) / 7.0 - 1.0;
			float4 y = ( y_ * 2.0 + 0.5 ) / 7.0 - 1.0;
			float4 h = 1.0 - abs( x ) - abs( y );
			float4 b0 = float4( x.xy, y.xy );
			float4 b1 = float4( x.zw, y.zw );
			float4 s0 = floor( b0 ) * 2.0 + 1.0;
			float4 s1 = floor( b1 ) * 2.0 + 1.0;
			float4 sh = -step( h, 0.0 );
			float4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
			float4 a1 = b1.xzyw + s1.xzyw * sh.zzww;
			float3 g0 = float3( a0.xy, h.x );
			float3 g1 = float3( a0.zw, h.y );
			float3 g2 = float3( a1.xy, h.z );
			float3 g3 = float3( a1.zw, h.w );
			float4 norm = taylorInvSqrt( float4( dot( g0, g0 ), dot( g1, g1 ), dot( g2, g2 ), dot( g3, g3 ) ) );
			g0 *= norm.x;
			g1 *= norm.y;
			g2 *= norm.z;
			g3 *= norm.w;
			float4 m = max( 0.6 - float4( dot( x0, x0 ), dot( x1, x1 ), dot( x2, x2 ), dot( x3, x3 ) ), 0.0 );
			m = m* m;
			m = m* m;
			float4 px = float4( dot( x0, g0 ), dot( x1, g1 ), dot( x2, g2 ), dot( x3, g3 ) );
			return 42.0 * dot( m, px);
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 appendResult6 = (float3(0.0 , _Noise1Speed , 0.0));
			float2 panner14 = ( 0.15 * _Time.y * appendResult6.xy + ( _Noise1Scale * v.texcoord.xy ));
			float3 appendResult8 = (float3(0.0 , _Noise2Speed , 0.0));
			float2 panner13 = ( 0.64 * _Time.y * appendResult8.xy + ( v.texcoord.xy * _Noise2Scale ));
			float4 ase_vertex4Pos = v.vertex;
			float4 temp_output_25_0 = ( ( tex2Dlod( _Base, float4( panner14, 0, 0.0) ).r * tex2Dlod( _Base, float4( panner13, 0, 0.0) ).r ) * _BaseColour * ( ase_vertex4Pos + float4( 0.75,1.68,-2.82,0 ) ) );
			float mulTime12 = _Time.y * 0.172;
			float2 temp_cast_4 = (mulTime12).xx;
			float2 panner15 = ( 0.82 * _Time.y * float2( -0.53,-0.27 ) + temp_cast_4);
			float2 uv_TexCoord22 = v.texcoord.xy * float3(0,5,2).xy + panner15;
			float simplePerlin3D24 = snoise( float3( uv_TexCoord22 ,  0.0 ) );
			float3 desaturateInitialColor27 = ( temp_output_25_0 * simplePerlin3D24 ).rgb;
			float desaturateDot27 = dot( desaturateInitialColor27, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar27 = lerp( desaturateInitialColor27, desaturateDot27.xxx, 0.0 );
			v.vertex.xyz += desaturateVar27;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 appendResult6 = (float3(0.0 , _Noise1Speed , 0.0));
			float2 panner14 = ( 0.15 * _Time.y * appendResult6.xy + ( _Noise1Scale * i.uv_texcoord ));
			float3 appendResult8 = (float3(0.0 , _Noise2Speed , 0.0));
			float2 panner13 = ( 0.64 * _Time.y * appendResult8.xy + ( i.uv_texcoord * _Noise2Scale ));
			float4 ase_vertex4Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float4 temp_output_25_0 = ( ( tex2D( _Base, panner14 ).r * tex2D( _Base, panner13 ).r ) * _BaseColour * ( ase_vertex4Pos + float4( 0.75,1.68,-2.82,0 ) ) );
			float mulTime12 = _Time.y * 0.172;
			float2 temp_cast_4 = (mulTime12).xx;
			float2 panner15 = ( 0.82 * _Time.y * float2( -0.53,-0.27 ) + temp_cast_4);
			float2 uv_TexCoord22 = i.uv_texcoord * float3(0,5,2).xy + panner15;
			float simplePerlin3D24 = snoise( float3( uv_TexCoord22 ,  0.0 ) );
			float3 desaturateInitialColor27 = ( temp_output_25_0 * simplePerlin3D24 ).rgb;
			float desaturateDot27 = dot( desaturateInitialColor27, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar27 = lerp( desaturateInitialColor27, desaturateDot27.xxx, 0.0 );
			o.Emission = desaturateVar27;
			o.Smoothness = temp_output_25_0.r;
			o.Alpha = temp_output_25_0.r;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16700
2162;73;1399;397;3204.486;91.76997;2.83108;True;False
Node;AmplifyShaderEditor.TextureCoordinatesNode;1;-2606.166,-102.497;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;2;-2547.668,-209.8741;Float;False;Property;_Noise1Scale;Noise 1 Scale;1;0;Create;True;0;0;False;0;1.22;0.69;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-2549.229,-301.1786;Float;False;Property;_Noise1Speed;Noise 1 Speed;0;0;Create;True;0;0;False;0;-1.5;-1.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-2562.529,73.93578;Float;False;Property;_Noise2Scale;Noise 2 Scale;3;0;Create;True;0;0;False;0;0.54;0.54;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-2575.86,235.0821;Float;False;Property;_Noise2Speed;Noise 2 Speed;2;0;Create;True;0;0;False;0;-1;-1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;6;-2299.689,-346.7904;Float;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-2311.533,-203.1755;Float;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;8;-2326.34,183.2522;Float;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-2317.456,-16.62412;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-2170.791,788.0682;Float;False;Constant;_Float5;Float 5;7;0;Create;True;0;0;False;0;0.172;0;0;0.27;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;13;-2102.774,82.57378;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;0.64;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;14;-2098.333,-274.2427;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;0.15;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;12;-1865.322,805.8903;Float;True;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;11;-2116.099,-127.6665;Float;True;Property;_Base;Base;4;0;Create;True;0;0;False;0;25a754d697792d644a21d3698c4860e8;25a754d697792d644a21d3698c4860e8;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.PosVertexDataNode;17;-1616.288,292.0147;Float;True;1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;15;-1607.981,808.6603;Float;True;3;0;FLOAT2;0,0;False;2;FLOAT2;-0.53,-0.27;False;1;FLOAT;0.82;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;16;-1827.388,-4.779519;Float;True;Property;_1;1;4;0;Create;True;0;0;False;0;25a754d697792d644a21d3698c4860e8;25a754d697792d644a21d3698c4860e8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;18;-1875.692,561.3254;Float;False;Constant;_Vector0;Vector 0;6;0;Create;True;0;0;False;0;0,5,2;2,0,2;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;19;-1845.155,-266.8398;Float;True;Property;_TextureSample0;Texture Sample 0;5;0;Create;True;0;0;False;0;25a754d697792d644a21d3698c4860e8;25a754d697792d644a21d3698c4860e8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;22;-1323.123,497.8693;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;2.29,4.04;False;1;FLOAT2;0.24,1.67;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-1506.106,-99.03292;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;21;-1186.48,179.3095;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0.75,1.68,-2.82,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ColorNode;20;-1450.46,29.43349;Float;False;Property;_BaseColour;Base Colour;5;0;Create;True;0;0;False;0;0,0.9716981,0.9422502,1;0.7372549,0.2548039,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-1010.477,-31.02091;Float;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT4;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;24;-1051.114,380.745;Float;True;Simplex3D;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-782.9227,177.7498;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DesaturateOpNode;27;-600.9978,173.7026;Float;True;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;FLAMES 2;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;6;1;3;0
WireConnection;7;0;2;0
WireConnection;7;1;1;0
WireConnection;8;1;5;0
WireConnection;9;0;1;0
WireConnection;9;1;4;0
WireConnection;13;0;9;0
WireConnection;13;2;8;0
WireConnection;14;0;7;0
WireConnection;14;2;6;0
WireConnection;12;0;10;0
WireConnection;15;0;12;0
WireConnection;16;0;11;0
WireConnection;16;1;13;0
WireConnection;19;0;11;0
WireConnection;19;1;14;0
WireConnection;22;0;18;0
WireConnection;22;1;15;0
WireConnection;23;0;19;1
WireConnection;23;1;16;1
WireConnection;21;0;17;0
WireConnection;25;0;23;0
WireConnection;25;1;20;0
WireConnection;25;2;21;0
WireConnection;24;0;22;0
WireConnection;26;0;25;0
WireConnection;26;1;24;0
WireConnection;27;0;26;0
WireConnection;0;2;27;0
WireConnection;0;4;25;0
WireConnection;0;9;25;0
WireConnection;0;11;27;0
ASEEND*/
//CHKSM=DE205830B6ED65267EA320874DB96710CE67E543