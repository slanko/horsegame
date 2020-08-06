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
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
			float3 worldNormal;
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


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float simplePerlin3D40 = snoise( float3( v.texcoord.xy ,  0.0 ) );
			float2 temp_cast_1 = (1.048588).xx;
			float mulTime47 = _Time.y * 3.09;
			float2 panner48 = ( mulTime47 * float2( 0.06,0.03 ) + float2( 0.09,0.18 ));
			float2 uv_TexCoord50 = v.texcoord.xy * temp_cast_1 + panner48;
			float simplePerlin3D51 = snoise( float3( uv_TexCoord50 ,  0.0 ) );
			float4 color23 = IsGammaSpace() ? float4(1.614676,0.7569249,0.2208756,0.3411765) : float4(2.869379,0.5333745,0.03998582,0.3411765);
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = UnityObjectToWorldNormal( v.normal );
			float fresnelNdotV18 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode18 = ( 0.0 + 1.18 * pow( 1.0 - fresnelNdotV18, 5.0 ) );
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float3 temp_cast_4 = (( ( 1.0 - fresnelNode18 ) * ase_lightColor.a )).xxx;
			float4 color21 = IsGammaSpace() ? float4(0.8950655,0.9339623,0.4890085,0.3058824) : float4(0.7776831,0.8562991,0.2040083,0.3058824);
			float simplePerlin3D38 = snoise( ( saturate( ( 1.0 - ( ( distance( color23.rgb , temp_cast_4 ) - 0.94 ) / max( 2.19 , 1E-05 ) ) ) ) * color21 ).rgb );
			float4 temp_cast_6 = (( ( simplePerlin3D40 + simplePerlin3D51 ) + simplePerlin3D38 )).xxxx;
			half4 color14 = IsGammaSpace() ? half4(0.3584906,0.03551086,0.03551086,0.3294118) : half4(0.1056116,0.002748518,0.002748518,0.3294118);
			float4 blendOpSrc24 = temp_cast_6;
			float4 blendOpDest24 = ( float4( 0,0,0,0 ) * color14 );
			float4 blendOpSrc26 = ( saturate( ( 1.0 - ( ( 1.0 - blendOpDest24) / blendOpSrc24) ) ));
			float4 blendOpDest26 = _Color5;
			float4 temp_output_26_0 = ( saturate( ( 1.0 - ( ( 1.0 - blendOpDest26) / blendOpSrc26) ) ));
			v.vertex.xyz += temp_output_26_0.rgb;
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float simplePerlin3D40 = snoise( float3( i.uv_texcoord ,  0.0 ) );
			float2 temp_cast_1 = (1.048588).xx;
			float mulTime47 = _Time.y * 3.09;
			float2 panner48 = ( mulTime47 * float2( 0.06,0.03 ) + float2( 0.09,0.18 ));
			float2 uv_TexCoord50 = i.uv_texcoord * temp_cast_1 + panner48;
			float simplePerlin3D51 = snoise( float3( uv_TexCoord50 ,  0.0 ) );
			float4 color23 = IsGammaSpace() ? float4(1.614676,0.7569249,0.2208756,0.3411765) : float4(2.869379,0.5333745,0.03998582,0.3411765);
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV18 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode18 = ( 0.0 + 1.18 * pow( 1.0 - fresnelNdotV18, 5.0 ) );
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float3 temp_cast_4 = (( ( 1.0 - fresnelNode18 ) * ase_lightColor.a )).xxx;
			float4 color21 = IsGammaSpace() ? float4(0.8950655,0.9339623,0.4890085,0.3058824) : float4(0.7776831,0.8562991,0.2040083,0.3058824);
			float simplePerlin3D38 = snoise( ( saturate( ( 1.0 - ( ( distance( color23.rgb , temp_cast_4 ) - 0.94 ) / max( 2.19 , 1E-05 ) ) ) ) * color21 ).rgb );
			float4 temp_cast_6 = (( ( simplePerlin3D40 + simplePerlin3D51 ) + simplePerlin3D38 )).xxxx;
			half4 color14 = IsGammaSpace() ? half4(0.3584906,0.03551086,0.03551086,0.3294118) : half4(0.1056116,0.002748518,0.002748518,0.3294118);
			float4 blendOpSrc24 = temp_cast_6;
			float4 blendOpDest24 = ( float4( 0,0,0,0 ) * color14 );
			float4 blendOpSrc26 = ( saturate( ( 1.0 - ( ( 1.0 - blendOpDest24) / blendOpSrc24) ) ));
			float4 blendOpDest26 = _Color5;
			float4 temp_output_26_0 = ( saturate( ( 1.0 - ( ( 1.0 - blendOpDest26) / blendOpSrc26) ) ));
			o.Emission = temp_output_26_0.rgb;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Lambert keepalpha fullforwardshadows exclude_path:deferred vertex:vertexDataFunc 

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
				vertexDataFunc( v, customInputData );
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
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
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
2175;73;1214;426;719.4999;890.8947;3.209268;True;False
Node;AmplifyShaderEditor.CommentaryNode;54;-402.8126,-2305.587;Float;False;2079.321;1415.039;Error woogle;13;43;46;44;47;48;41;45;49;50;42;40;51;52;EROR;1,0,0.4745098,1;0;0
Node;AmplifyShaderEditor.FresnelNode;18;-583.0355,-834.0517;Float;False;Standard;TangentNormal;ViewDir;True;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1.18;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;46;391.2117,-2138.185;Float;True;Constant;_Float0;Float 0;1;0;Create;True;0;0;False;0;3.09;0;3;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;34;-286.8302,-595.3024;Float;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.OneMinusNode;19;-218.6316,-819.4928;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;47;684.0609,-1948.356;Float;True;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;48;909.1174,-1888.648;Float;True;3;0;FLOAT2;0.09,0.18;False;2;FLOAT2;0.06,0.03;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;23;8.063354,-406.8457;Float;False;Constant;_Color4;Color 4;0;1;[HDR];Create;True;0;0;False;0;1.614676,0.7569249,0.2208756,0.3411765;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;39.37904,-669.3863;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;49;870.9547,-2255.587;Float;True;Constant;_Float1;Float 1;1;0;Create;True;0;0;False;0;1.048588;0;1;1.09;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;22;330.7613,-566.7327;Float;True;Color Mask;-1;;4;eec747d987850564c95bde0e5a6d1867;0;4;1;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0.94;False;5;FLOAT;2.19;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;21;288.0823,-226.9449;Float;False;Constant;_Color3;Color 3;0;0;Create;True;0;0;False;0;0.8950655,0.9339623,0.4890085,0.3058824;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;50;1220.851,-1972.168;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;42;485.8351,-1447.536;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NoiseGeneratorNode;40;756.5107,-1322.182;Float;True;Simplex3D;1;0;FLOAT3;0.54,0.84,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;625.1166,-271.4754;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;51;1443.509,-1680.758;Float;True;Simplex3D;1;0;FLOAT3;0.54,0.84,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;38;921.7676,-284.4801;Float;True;Simplex3D;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;14;728.0281,207.7724;Half;False;Constant;_Color1;Color 1;0;0;Create;True;0;0;False;0;0.3584906,0.03551086,0.03551086,0.3294118;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;52;1277.061,-1143.548;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;1086.244,11.75953;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;39;1366.344,-439.0424;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;24;1527.357,-194.5734;Float;False;ColorBurn;True;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;25;1320.456,341.5602;Float;False;Property;_Color5;Color 5;0;0;Create;True;0;0;False;0;0.9427508,1,0,0.4666667;0,0.7921572,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;45;167.7313,-1358.596;Float;True;3;0;FLOAT2;0.05,-2.3;False;2;FLOAT2;1.3,0.1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BlendOpsNode;26;1993.159,135.6148;Float;True;ColorBurn;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-352.8126,-1605.512;Float;True;Constant;_FAST;FAST;1;0;Create;True;0;0;False;0;7.9;0;3;14;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;41;74.2832,-1717.308;Float;True;Constant;_EUUUGH;EUUUGH;1;0;Create;True;0;0;False;0;2.62;0;0.4;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;44;-48.53543,-1418.322;Float;True;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;9;2634.883,2.918589;Float;False;True;2;Float;ASEMaterialInspector;0;0;Lambert;EROR;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;2.16;1,0,0.64433,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;19;0;18;0
WireConnection;47;0;46;0
WireConnection;48;1;47;0
WireConnection;35;0;19;0
WireConnection;35;1;34;2
WireConnection;22;1;35;0
WireConnection;22;3;23;0
WireConnection;50;0;49;0
WireConnection;50;1;48;0
WireConnection;42;0;41;0
WireConnection;42;1;45;0
WireConnection;40;0;42;0
WireConnection;20;0;22;0
WireConnection;20;1;21;0
WireConnection;51;0;50;0
WireConnection;38;0;20;0
WireConnection;52;0;40;0
WireConnection;52;1;51;0
WireConnection;27;1;14;0
WireConnection;39;0;52;0
WireConnection;39;1;38;0
WireConnection;24;0;39;0
WireConnection;24;1;27;0
WireConnection;45;1;44;0
WireConnection;26;0;24;0
WireConnection;26;1;25;0
WireConnection;44;0;43;0
WireConnection;9;2;26;0
WireConnection;9;11;26;0
WireConnection;9;14;26;0
ASEEND*/
//CHKSM=F0B59CF7DBB9E7EAEECC85C4FE527A62A2D5358B