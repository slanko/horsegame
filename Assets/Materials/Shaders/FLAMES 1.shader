// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "FLAMES 1"
{
	Properties
	{
		_Noise1Speed("Noise 1 Speed", Float) = -1.5
		_Noise1Scale("Noise 1 Scale", Float) = 1.22
		_Noise2Speed("Noise 2 Speed", Float) = -1
		_Noise2Scale("Noise 2 Scale", Float) = 0.54
		_Base("Base", 2D) = "white" {}
		_BaseColour("Base Colour", Color) = (0.6415094,0.1968431,0.1785333,1)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 4.6
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
			float3 appendResult4 = (float3(0.0 , _Noise1Speed , 0.0));
			float2 panner5 = ( 0.15 * _Time.y * appendResult4.xy + ( _Noise1Scale * v.texcoord.xy ));
			float3 appendResult11 = (float3(0.0 , _Noise2Speed , 0.0));
			float2 panner12 = ( 0.64 * _Time.y * appendResult11.xy + ( v.texcoord.xy * _Noise2Scale ));
			float4 ase_vertex4Pos = v.vertex;
			float4 temp_output_23_0 = ( ( tex2Dlod( _Base, float4( panner5, 0, 0.0) ).r * tex2Dlod( _Base, float4( panner12, 0, 0.0) ).r ) * _BaseColour * ( ase_vertex4Pos + float4( 0.75,1.68,-2.82,0 ) ) );
			float mulTime42 = _Time.y * 0.172;
			float2 temp_cast_4 = (mulTime42).xx;
			float2 panner41 = ( 0.82 * _Time.y * float2( -0.53,-0.27 ) + temp_cast_4);
			float2 uv_TexCoord39 = v.texcoord.xy * float3(0,5,2).xy + panner41;
			float simplePerlin3D38 = snoise( float3( uv_TexCoord39 ,  0.0 ) );
			float3 desaturateInitialColor36 = ( temp_output_23_0 * simplePerlin3D38 ).rgb;
			float desaturateDot36 = dot( desaturateInitialColor36, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar36 = lerp( desaturateInitialColor36, desaturateDot36.xxx, 0.0 );
			v.vertex.xyz += desaturateVar36;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 appendResult4 = (float3(0.0 , _Noise1Speed , 0.0));
			float2 panner5 = ( 0.15 * _Time.y * appendResult4.xy + ( _Noise1Scale * i.uv_texcoord ));
			float3 appendResult11 = (float3(0.0 , _Noise2Speed , 0.0));
			float2 panner12 = ( 0.64 * _Time.y * appendResult11.xy + ( i.uv_texcoord * _Noise2Scale ));
			float4 ase_vertex4Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float4 temp_output_23_0 = ( ( tex2D( _Base, panner5 ).r * tex2D( _Base, panner12 ).r ) * _BaseColour * ( ase_vertex4Pos + float4( 0.75,1.68,-2.82,0 ) ) );
			o.Smoothness = temp_output_23_0.r;
			o.Alpha = temp_output_23_0.r;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows exclude_path:deferred vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 4.6
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
2162;73;1399;397;2625.217;247.6215;3.884537;True;False
Node;AmplifyShaderEditor.TextureCoordinatesNode;7;-1280.32,163.9357;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;3;-1221.822,56.55859;Float;False;Property;_Noise1Scale;Noise 1 Scale;1;0;Create;True;0;0;False;0;1.22;-1.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2;-1223.383,-34.74588;Float;False;Property;_Noise1Speed;Noise 1 Speed;0;0;Create;True;0;0;False;0;-1.5;-1.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-1236.683,340.3685;Float;False;Property;_Noise2Scale;Noise 2 Scale;3;0;Create;True;0;0;False;0;0.54;-1.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-1250.014,501.5148;Float;False;Property;_Noise2Speed;Noise 2 Speed;2;0;Create;True;0;0;False;0;-1;-1.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;4;-973.8436,-80.35768;Float;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-985.6879,63.2572;Float;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;11;-1000.494,449.6849;Float;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-991.61,249.8086;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-844.9458,1054.501;Float;False;Constant;_Float5;Float 5;7;0;Create;True;0;0;False;0;0.172;0;0;0.27;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;20;-790.2538,138.7662;Float;True;Property;_Base;Base;4;0;Create;True;0;0;False;0;25a754d697792d644a21d3698c4860e8;None;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleTimeNode;42;-539.4767,1072.323;Float;True;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;12;-776.9283,349.0065;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;0.64;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;5;-772.4872,-7.809954;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;0.15;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;41;-282.1357,1075.093;Float;True;3;0;FLOAT2;0,0;False;2;FLOAT2;-0.53,-0.27;False;1;FLOAT;0.82;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;16;-501.5431,261.6532;Float;True;Property;_1;1;4;0;Create;True;0;0;False;0;25a754d697792d644a21d3698c4860e8;25a754d697792d644a21d3698c4860e8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PosVertexDataNode;33;-290.4427,558.4474;Float;True;1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;46;-549.8462,827.7582;Float;False;Constant;_Vector0;Vector 0;6;0;Create;True;0;0;False;0;0,5,2;2,0,2;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;17;-519.3096,-0.4070518;Float;True;Property;_TextureSample0;Texture Sample 0;5;0;Create;True;0;0;False;0;25a754d697792d644a21d3698c4860e8;25a754d697792d644a21d3698c4860e8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;24;-124.6149,295.8662;Float;False;Property;_BaseColour;Base Colour;5;0;Create;True;0;0;False;0;0.6415094,0.1968431,0.1785333,1;0.6509434,0.1013261,0.1013261,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;34;139.3649,445.7422;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0.75,1.68,-2.82,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;39;2.722456,764.302;Float;True;0;20;2;3;2;SAMPLER2D;;False;0;FLOAT2;2.29,4.04;False;1;FLOAT2;0.24,1.67;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-180.2603,167.3998;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;38;274.7309,647.1777;Float;True;Simplex3D;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;315.368,235.4118;Float;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT4;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;542.9224,444.1825;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DesaturateOpNode;36;724.8474,440.1353;Float;True;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1100.847,104.6813;Float;False;True;6;Float;ASEMaterialInspector;0;0;Standard;FLAMES 1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;ForwardOnly;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;35;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;3;1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;4;1;2;0
WireConnection;6;0;3;0
WireConnection;6;1;7;0
WireConnection;11;1;9;0
WireConnection;8;0;7;0
WireConnection;8;1;10;0
WireConnection;42;0;43;0
WireConnection;12;0;8;0
WireConnection;12;2;11;0
WireConnection;5;0;6;0
WireConnection;5;2;4;0
WireConnection;41;0;42;0
WireConnection;16;0;20;0
WireConnection;16;1;12;0
WireConnection;17;0;20;0
WireConnection;17;1;5;0
WireConnection;34;0;33;0
WireConnection;39;0;46;0
WireConnection;39;1;41;0
WireConnection;19;0;17;1
WireConnection;19;1;16;1
WireConnection;38;0;39;0
WireConnection;23;0;19;0
WireConnection;23;1;24;0
WireConnection;23;2;34;0
WireConnection;47;0;23;0
WireConnection;47;1;38;0
WireConnection;36;0;47;0
WireConnection;0;4;23;0
WireConnection;0;9;23;0
WireConnection;0;11;36;0
ASEEND*/
//CHKSM=52AB8696422C02130C65D3813325D99270613207