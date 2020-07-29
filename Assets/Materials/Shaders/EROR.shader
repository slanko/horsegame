// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "EROR"
{
	Properties
	{
		_Color5("Color 5", Color) = (0.9427508,1,0,0.4666667)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform float4 _Color5;


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


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float2 temp_cast_0 = (4.0).xx;
			float mulTime44 = _Time.y * 7.9;
			float2 panner45 = ( mulTime44 * float2( 0.01,-0.25 ) + float2( 0.05,-2.3 ));
			float2 uv_TexCoord42 = i.uv_texcoord * temp_cast_0 + panner45;
			float simplePerlin3D40 = snoise( float3( uv_TexCoord42 ,  0.0 ) );
			float2 temp_cast_2 = (1.73).xx;
			float mulTime47 = _Time.y * 3.09;
			float2 panner48 = ( mulTime47 * float2( -0.6,-0.2 ) + float2( -1.1,-0.25 ));
			float2 uv_TexCoord50 = i.uv_texcoord * temp_cast_2 + panner48;
			float simplePerlin3D51 = snoise( float3( uv_TexCoord50 ,  0.0 ) );
			float4 color23 = IsGammaSpace() ? float4(1.614676,0.7569249,0.2208756,0.3411765) : float4(2.869379,0.5333745,0.03998582,0.3411765);
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV18 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode18 = ( 0.63 + 1.18 * pow( 1.0 - fresnelNdotV18, 0.89 ) );
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float3 temp_cast_5 = (( ( 1.0 - fresnelNode18 ) * ase_lightColor.a )).xxx;
			float4 color21 = IsGammaSpace() ? float4(0.8950655,0.9339623,0.4890085,0.3058824) : float4(0.7776831,0.8562991,0.2040083,0.3058824);
			float simplePerlin2D38 = snoise( ( saturate( ( 1.0 - ( ( distance( color23.rgb , temp_cast_5 ) - 2.0 ) / max( 2.11 , 1E-05 ) ) ) ) * color21 ).rg );
			float4 temp_cast_7 = (( ( simplePerlin3D40 + simplePerlin3D51 ) + simplePerlin2D38 )).xxxx;
			float4 color17 = IsGammaSpace() ? float4(1.892181,1.563108,0,0.4352941) : float4(4.06741,2.671627,0,0.4352941);
			float fresnelNdotV10 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode10 = ( 1.23 + 5.33 * pow( 1.0 - fresnelNdotV10, 9.32 ) );
			float3 temp_cast_9 = (( ( 1.0 - fresnelNode10 ) * ase_lightColor.a )).xxx;
			half4 color14 = IsGammaSpace() ? half4(0.3584906,0.03551086,0.03551086,0.3294118) : half4(0.1056116,0.002748518,0.002748518,0.3294118);
			float4 blendOpSrc24 = temp_cast_7;
			float4 blendOpDest24 = ( saturate( ( 1.0 - ( ( distance( color17.rgb , temp_cast_9 ) - 1.73 ) / max( -0.6 , 1E-05 ) ) ) ) * color14 );
			float4 blendOpSrc26 = ( saturate( 	max( blendOpSrc24, blendOpDest24 ) ));
			float4 blendOpDest26 = _Color5;
			c.rgb = ( saturate( ( 1.0 - ( ( 1.0 - blendOpDest26) / blendOpSrc26) ) )).rgb;
			c.a = 1;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows exclude_path:deferred 

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
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float3 worldNormal : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
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
				surfIN.worldNormal = IN.worldNormal;
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
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
2162;73;1399;523;463.8671;472.5179;2.561447;True;False
Node;AmplifyShaderEditor.CommentaryNode;54;-402.8126,-2305.587;Float;False;2079.321;1415.039;Error woogle;13;43;46;44;47;48;41;45;49;50;42;40;51;52;EROR;1,0,0.4745098,1;0;0
Node;AmplifyShaderEditor.FresnelNode;18;-423.4616,-727.6691;Float;False;Standard;TangentNormal;ViewDir;True;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0.63;False;2;FLOAT;1.18;False;3;FLOAT;0.89;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-352.8126,-1605.512;Float;True;Constant;_FAST;FAST;1;0;Create;True;0;0;False;0;7.9;0;3;14;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;46;391.2117,-2138.185;Float;True;Constant;_Float0;Float 0;1;0;Create;True;0;0;False;0;3.09;0;3;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;47;684.0609,-1948.356;Float;True;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;44;-48.53543,-1418.322;Float;True;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;19;-59.05776,-713.1102;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;34;-127.2564,-488.9198;Float;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.ColorNode;23;167.6372,-300.4631;Float;False;Constant;_Color4;Color 4;0;1;[HDR];Create;True;0;0;False;0;1.614676,0.7569249,0.2208756,0.3411765;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;48;909.1174,-1888.648;Float;True;3;0;FLOAT2;-1.1,-0.25;False;2;FLOAT2;-0.6,-0.2;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;41;-141.0224,-1917.866;Float;True;Constant;_EUUUGH;EUUUGH;1;0;Create;True;0;0;False;0;4;0;0.4;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;45;167.7313,-1355.977;Float;True;3;0;FLOAT2;0.05,-2.3;False;2;FLOAT2;0.01,-0.25;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FresnelNode;10;-723.9131,-202.3336;Float;False;Standard;WorldNormal;ViewDir;True;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;1.23;False;2;FLOAT;5.33;False;3;FLOAT;9.32;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;49;965.3354,-2255.587;Float;True;Constant;_Float1;Float 1;1;0;Create;True;0;0;False;0;1.73;0;2.79;2.79;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;198.9529,-563.0037;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;50;1220.851,-1972.168;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;42;479.4652,-1439.496;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;15;-401.0408,-196.1563;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;36;-443.6958,59.35733;Float;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.ColorNode;21;450.1147,-199.2328;Float;False;Constant;_Color3;Color 3;0;0;Create;True;0;0;False;0;0.8950655,0.9339623,0.4890085,0.3058824;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;22;490.3351,-460.3501;Float;True;Color Mask;-1;;4;eec747d987850564c95bde0e5a6d1867;0;4;1;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;2;False;5;FLOAT;2.11;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;51;1443.509,-1680.758;Float;True;Simplex3D;1;0;FLOAT3;0.54,0.84,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;-120.8395,-184.0339;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;17;-117.1895,68.60684;Float;False;Constant;_Color2;Color 2;0;1;[HDR];Create;True;0;0;False;0;1.892181,1.563108,0,0.4352941;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NoiseGeneratorNode;40;753.5613,-1322.182;Float;True;Simplex3D;1;0;FLOAT3;0.54,0.84,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;784.6905,-165.0928;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;52;1277.061,-1143.548;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;14;459.4663,316.1401;Half;False;Constant;_Color1;Color 1;0;0;Create;True;0;0;False;0;0.3584906,0.03551086,0.03551086,0.3294118;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NoiseGeneratorNode;38;965.2877,-158.7553;Float;True;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;16;178.8106,-88.39312;Float;True;Color Mask;-1;;5;eec747d987850564c95bde0e5a6d1867;0;4;1;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;1.73;False;5;FLOAT;-0.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;817.6821,120.1273;Float;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;39;1366.344,-439.0424;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;25;1071.721,341.5602;Float;False;Property;_Color5;Color 5;0;0;Create;True;0;0;False;0;0.9427508,1,0,0.4666667;0,0.7921572,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendOpsNode;24;1527.357,-194.5734;Float;False;Lighten;True;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;26;1877.692,149.8859;Float;True;ColorBurn;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;9;2204.571,5.405939;Float;False;True;2;Float;ASEMaterialInspector;0;0;CustomLighting;EROR;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexScale;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;47;0;46;0
WireConnection;44;0;43;0
WireConnection;19;0;18;0
WireConnection;48;1;47;0
WireConnection;45;1;44;0
WireConnection;35;0;19;0
WireConnection;35;1;34;2
WireConnection;50;0;49;0
WireConnection;50;1;48;0
WireConnection;42;0;41;0
WireConnection;42;1;45;0
WireConnection;15;0;10;0
WireConnection;22;1;35;0
WireConnection;22;3;23;0
WireConnection;51;0;50;0
WireConnection;37;0;15;0
WireConnection;37;1;36;2
WireConnection;40;0;42;0
WireConnection;20;0;22;0
WireConnection;20;1;21;0
WireConnection;52;0;40;0
WireConnection;52;1;51;0
WireConnection;38;0;20;0
WireConnection;16;1;37;0
WireConnection;16;3;17;0
WireConnection;27;0;16;0
WireConnection;27;1;14;0
WireConnection;39;0;52;0
WireConnection;39;1;38;0
WireConnection;24;0;39;0
WireConnection;24;1;27;0
WireConnection;26;0;24;0
WireConnection;26;1;25;0
WireConnection;9;13;26;0
ASEEND*/
//CHKSM=548FCC5DAAB9A81D8D331B54E101333B0A822EDB