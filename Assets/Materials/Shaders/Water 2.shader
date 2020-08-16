// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Water2"
{
	Properties
	{
		_Shallow("Shallow", Color) = (0.05098037,0.7254902,0.7039081,0.8392157)
		_VertexWiggle("Vertex Wiggle", Range( 0 , 5)) = 0.5
		_VertexWigglep2("Vertex Wiggle p2", Range( 0.05 , 0.55)) = 0.08
		_Deep("Deep", Color) = (0.000578499,0.01675553,0.1226415,0)
		_WaterNormal("Water Normal", 2D) = "bump" {}
		_TextureSample0("Texture Sample 0", 2D) = "bump" {}
		[Header(Refraction)]
		_ChromaticAberration("Chromatic Aberration", Range( 0 , 0.3)) = 0.1
		_Distortion("Distortion", Float) = 0
		_Opacity("Opacity", Color) = (0,0,0,0)
		_WaterFalloff("WaterFalloff", Float) = 0
		_Depth("Depth", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Back
		GrabPass{ }
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityStandardUtils.cginc"
		#include "UnityCG.cginc"
		#pragma target 3.0
		#pragma multi_compile _ALPHAPREMULTIPLY_ON
		#pragma surface surf Standard alpha:fade keepalpha finalcolor:RefractionF exclude_path:deferred vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
			float4 screenPos;
			float3 worldPos;
		};

		uniform float _VertexWiggle;
		uniform float _VertexWigglep2;
		uniform sampler2D _TextureSample0;
		uniform sampler2D _WaterNormal;
		uniform sampler2D _GrabTexture;
		uniform float _Distortion;
		uniform float4 _Deep;
		uniform float4 _Shallow;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _Depth;
		uniform float _WaterFalloff;
		uniform float4 _Opacity;
		uniform float _ChromaticAberration;


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


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float mulTime51 = _Time.y * _VertexWiggle;
			float2 panner52 = ( mulTime51 * float2( 0.09,0.52 ) + float2( 0,0 ));
			float2 uv_TexCoord53 = v.texcoord.xy + panner52;
			float simplePerlin2D54 = snoise( uv_TexCoord53 );
			float VertWoogle57 = ( simplePerlin2D54 * _VertexWigglep2 );
			float3 temp_cast_0 = (VertWoogle57).xxx;
			v.vertex.xyz += temp_cast_0;
		}

		inline float4 Refraction( Input i, SurfaceOutputStandard o, float indexOfRefraction, float chomaticAberration ) {
			float3 worldNormal = o.Normal;
			float4 screenPos = i.screenPos;
			#if UNITY_UV_STARTS_AT_TOP
				float scale = -1.0;
			#else
				float scale = 1.0;
			#endif
			float halfPosW = screenPos.w * 0.5;
			screenPos.y = ( screenPos.y - halfPosW ) * _ProjectionParams.x * scale + halfPosW;
			#if SHADER_API_D3D9 || SHADER_API_D3D11
				screenPos.w += 0.00000000001;
			#endif
			float2 projScreenPos = ( screenPos / screenPos.w ).xy;
			float3 worldViewDir = normalize( UnityWorldSpaceViewDir( i.worldPos ) );
			float3 refractionOffset = ( ( ( ( indexOfRefraction - 1.0 ) * mul( UNITY_MATRIX_V, float4( worldNormal, 0.0 ) ) ) * ( 1.0 / ( screenPos.z + 1.0 ) ) ) * ( 1.0 - dot( worldNormal, worldViewDir ) ) );
			float2 cameraRefraction = float2( refractionOffset.x, -( refractionOffset.y * _ProjectionParams.x ) );
			float4 redAlpha = tex2D( _GrabTexture, ( projScreenPos + cameraRefraction ) );
			float green = tex2D( _GrabTexture, ( projScreenPos + ( cameraRefraction * ( 1.0 - chomaticAberration ) ) ) ).g;
			float blue = tex2D( _GrabTexture, ( projScreenPos + ( cameraRefraction * ( 1.0 + chomaticAberration ) ) ) ).b;
			return float4( redAlpha.r, green, blue, redAlpha.a );
		}

		void RefractionF( Input i, SurfaceOutputStandard o, inout half4 color )
		{
			#ifdef UNITY_PASS_FORWARDBASE
			float mulTime12 = _Time.y * 0.3057651;
			float2 panner13 = ( mulTime12 * float2( 0,0.1 ) + float2( 0,0 ));
			float2 uv_TexCoord14 = i.uv_texcoord + panner13;
			float simplePerlin2D15 = snoise( uv_TexCoord14 );
			float Refracto18 = ( simplePerlin2D15 * 0.01 );
			color.rgb = color.rgb + Refraction( i, o, Refracto18, _ChromaticAberration ) * ( 1 - color.a );
			color.a = 1;
			#endif
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Normal = float3(0,0,1);
			float2 uv_TexCoord20 = i.uv_texcoord * float2( 0.07,1.67 ) + float2( 0.2,0.1 );
			float2 panner21 = ( 1.0 * _Time.y * float2( 0.01,0.04 ) + uv_TexCoord20);
			float2 panner22 = ( 1.0 * _Time.y * float2( 0.04,0.01 ) + uv_TexCoord20);
			float3 Ribbles29 = BlendNormals( UnpackScaleNormal( tex2D( _TextureSample0, panner21 ), 0.3 ) , UnpackScaleNormal( tex2D( _WaterNormal, panner22 ), 0.004 ) );
			o.Normal = Ribbles29;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float2 appendResult33 = (float2(ase_screenPosNorm.x , ase_screenPosNorm.y));
			float4 screenColor38 = tex2D( _GrabTexture, ( float3( ( appendResult33 / ase_screenPosNorm.w ) ,  0.0 ) + ( _Distortion * Ribbles29 ) ).xy );
			float eyeDepth3 = LinearEyeDepth(UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture,UNITY_PROJ_COORD( ase_screenPos ))));
			float4 lerpResult8 = lerp( _Deep , _Shallow , saturate( pow( ( abs( ( eyeDepth3 - ase_screenPos.w ) ) + _Depth ) , _WaterFalloff ) ));
			float4 MainSegment10 = lerpResult8;
			float4 lerpResult43 = lerp( screenColor38 , MainSegment10 , _Opacity);
			float4 DistortionS40 = lerpResult43;
			float4 blendOpSrc61 = unity_FogColor;
			float4 blendOpDest61 = DistortionS40;
			o.Albedo = ( saturate( 	max( blendOpSrc61, blendOpDest61 ) )).rgb;
			o.Alpha = 1;
			o.Normal = o.Normal + 0.00001 * i.screenPos * i.worldPos;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16700
0;73;1439;365;-906.8152;707.8918;1.406956;True;False
Node;AmplifyShaderEditor.ScreenPosInputsNode;2;-1778.13,-1162.083;Float;True;1;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;20;-1635.008,-423.4244;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.07,1.67;False;1;FLOAT2;0.2,0.1;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenDepthNode;3;-1413.13,-1163.083;Float;False;0;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-1283.628,-180.8155;Float;False;Constant;_Float2;Float 2;4;0;Create;True;0;0;False;0;0.004;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-1289.401,-419.4474;Float;False;Constant;_Float3;Float 3;4;0;Create;True;0;0;False;0;0.3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;4;-1163.53,-1090.083;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;21;-1322.824,-560.0296;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.01,0.04;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;22;-1322.151,-330.4418;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.04,0.01;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-1283.628,-180.8155;Float;False;Constant;_Float2;Float 2;4;0;Create;True;0;0;False;0;0.004;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;23;-1066.321,-350.7489;Float;True;Property;_WaterNormal;Water Normal;4;0;Create;True;0;0;False;0;905aecd5a3fbd064491c14d4f0634f80;905aecd5a3fbd064491c14d4f0634f80;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;27;-1069.764,-591.0966;Float;True;Property;_TextureSample0;Texture Sample 0;5;0;Create;True;0;0;False;0;905aecd5a3fbd064491c14d4f0634f80;905aecd5a3fbd064491c14d4f0634f80;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;45;-959.9383,-1194.838;Float;False;Property;_Depth;Depth;11;0;Create;True;0;0;False;0;0;-7.49;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;5;-920.1785,-1084.66;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;46;-751.3263,-1196.175;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendNormalsNode;26;-700.7953,-410.3247;Float;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;46;-751.3263,-1196.175;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;48;-797.051,-863.8994;Float;False;Property;_WaterFalloff;WaterFalloff;10;0;Create;True;0;0;False;0;0;-0.45;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;29;-450.4885,-414.6902;Float;False;Ribbles;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;31;10.95361,-602.4705;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;47;-601.4198,-1078.463;Float;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-255.816,185.5213;Float;True;Constant;_Float0;Float 0;0;0;Create;True;0;0;False;0;0.3057651;0;0;14;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;50;-338.0846,809.5568;Float;True;Property;_VertexWiggle;Vertex Wiggle;1;0;Create;True;0;0;False;0;0.5;0.65;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;7;-766.0359,-1626.358;Float;False;Property;_Shallow;Shallow;0;0;Create;True;0;0;False;0;0.05098037,0.7254902,0.7039081,0.8392157;0.5444998,0.8679245,0.7874382,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;30;237.5763,-287.6637;Float;False;29;Ribbles;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;35;277.399,-383.5243;Float;False;Property;_Distortion;Distortion;8;0;Create;True;0;0;False;0;0;-0.03;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;33;310.5397,-616.6765;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;6;-832.3876,-1415.577;Float;False;Property;_Deep;Deep;3;0;Create;True;0;0;False;0;0.000578499,0.01675553,0.1226415,0;0.3893735,0.6312593,0.6603774,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;49;-470.2738,-1203.347;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;484.29,-334.241;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;8;-334.7827,-1404.987;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;34;518.3989,-569.5245;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;12;79.39497,259.101;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;51;8.98621,880.7645;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;37;698.3683,-488.1851;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;10;-109.6003,-1406.056;Float;True;MainSegment;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PannerNode;52;228.7065,830.4636;Float;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0.09,0.52;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;13;320.463,196.9403;Float;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0.1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;53;491.4724,794.7236;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;14;583.2288,146.5967;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;9;756.7985,-800.3891;Float;False;10;MainSegment;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScreenColorNode;38;870.0152,-431.0239;Float;False;Global;_GrabScreen0;Grab Screen 0;7;0;Create;True;0;0;False;0;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;44;710.754,-677.9586;Float;False;Property;_Opacity;Opacity;9;0;Create;True;0;0;False;0;0,0,0,0;0.4133143,0.6792453,0.6213821,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;43;1084.44,-575.2451;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0.8196079,0.7738198,0.6941177,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;16;856.3458,115.2628;Float;False;Constant;_Float1;Float 1;0;0;Create;True;0;0;False;0;0.01;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;55;755.1018,692.2311;Float;False;Property;_VertexWigglep2;Vertex Wiggle p2;2;0;Create;True;0;0;False;0;0.08;0.25;0.05;0.55;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;54;841.6871,850.1592;Float;True;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;15;802.9858,311.514;Float;True;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;1064.655,145.4095;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;56;1105.728,670.1948;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;40;1264.645,-426.8905;Float;False;DistortionS;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;18;1264.668,171.918;Float;False;Refracto;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;57;1305.742,715.3071;Float;False;VertWoogle;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;41;1721.038,-447.2241;Float;False;40;DistortionS;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FogAndAmbientColorsNode;60;1636.675,-554.4268;Float;False;unity_FogColor;0;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;59;2021.594,-309.277;Float;False;29;Ribbles;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;58;2021.392,-41.33307;Float;False;57;VertWoogle;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;19;2032.159,-171.7654;Float;False;18;Refracto;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;61;2007.644,-534.6921;Float;False;Lighten;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2249.199,-382.6442;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Water2;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;ForwardOnly;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;6;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.107;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;3;0;2;0
WireConnection;4;0;3;0
WireConnection;4;1;2;4
WireConnection;21;0;20;0
WireConnection;22;0;20;0
WireConnection;23;1;22;0
WireConnection;23;5;25;0
WireConnection;27;1;21;0
WireConnection;27;5;28;0
WireConnection;5;0;4;0
WireConnection;46;0;5;0
WireConnection;46;1;45;0
WireConnection;26;0;27;0
WireConnection;26;1;23;0
WireConnection;29;0;26;0
WireConnection;47;0;46;0
WireConnection;47;1;48;0
WireConnection;33;0;31;1
WireConnection;33;1;31;2
WireConnection;49;0;47;0
WireConnection;36;0;35;0
WireConnection;36;1;30;0
WireConnection;8;0;6;0
WireConnection;8;1;7;0
WireConnection;8;2;49;0
WireConnection;34;0;33;0
WireConnection;34;1;31;4
WireConnection;12;0;11;0
WireConnection;51;0;50;0
WireConnection;37;0;34;0
WireConnection;37;1;36;0
WireConnection;10;0;8;0
WireConnection;52;1;51;0
WireConnection;13;1;12;0
WireConnection;53;1;52;0
WireConnection;38;0;37;0
WireConnection;43;0;38;0
WireConnection;43;1;9;0
WireConnection;43;2;44;0
WireConnection;54;0;53;0
WireConnection;15;0;14;0
WireConnection;17;0;15;0
WireConnection;17;1;16;0
WireConnection;56;0;54;0
WireConnection;56;1;55;0
WireConnection;40;0;43;0
WireConnection;18;0;17;0
WireConnection;57;0;56;0
WireConnection;61;0;60;0
WireConnection;61;1;41;0
WireConnection;0;0;61;0
WireConnection;0;1;59;0
WireConnection;0;8;19;0
WireConnection;0;11;58;0
ASEEND*/
//CHKSM=BCE4AC043251E84B9429AEA16B83C7CC8A309894