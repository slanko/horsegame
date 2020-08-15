// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Water2"
{
	Properties
	{
		_Float1("Float 1", Float) = 0.01
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#pragma target 3.0
		#pragma surface surf Standard alpha:fade keepalpha exclude_path:deferred vertex:vertexDataFunc 
		struct Input
		{
			float4 screenPos;
		};

		uniform float _Float1;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;


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
			float mulTime12 = _Time.y * 0.3057651;
			float2 panner13 = ( mulTime12 * float2( 0.03,0.3 ) + float2( 0,0 ));
			float2 uv_TexCoord14 = v.texcoord.xy + panner13;
			float simplePerlin2D15 = snoise( uv_TexCoord14 );
			float VertexWoogle18 = ( simplePerlin2D15 * _Float1 );
			float3 temp_cast_0 = (VertexWoogle18).xxx;
			v.vertex.xyz += temp_cast_0;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 color6 = IsGammaSpace() ? float4(0.000578499,0.01675553,0.1226415,0) : float4(4.477547E-05,0.001296868,0.01390275,0);
			float4 color7 = IsGammaSpace() ? float4(0.05098037,0.7254902,0.7039081,0.8392157) : float4(0.004024714,0.48515,0.453574,0.8392157);
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float eyeDepth3 = LinearEyeDepth(UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture,UNITY_PROJ_COORD( ase_screenPos ))));
			float4 lerpResult8 = lerp( color6 , color7 , abs( ( eyeDepth3 - ase_screenPos.w ) ));
			float4 MainSegment10 = lerpResult8;
			o.Albedo = MainSegment10.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16700
0;73;1439;365;6159.501;1486.187;8.180575;True;False
Node;AmplifyShaderEditor.RangedFloatNode;11;-642.0656,973.9473;Float;True;Constant;_Float0;Float 0;0;0;Create;True;0;0;False;0;0.3057651;0;0;14;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;2;-664.2578,-913.8654;Float;True;1;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;12;-306.8546,1047.527;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenDepthNode;3;-299.2578,-914.8654;Float;False;0;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;13;-65.78649,985.3663;Float;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0.03,0.3;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;4;-49.65792,-841.8654;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;14;196.9791,933.0228;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.AbsOpNode;5;207.1437,-843.1676;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;6;9.623333,-1160.783;Float;False;Constant;_Deep;Deep;0;0;Create;True;0;0;False;0;0.000578499,0.01675553,0.1226415,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;7;75.9749,-1371.564;Float;False;Constant;_Shallow;Shallow;0;0;Create;True;0;0;False;0;0.05098037,0.7254902,0.7039081,0.8392157;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;16;518.8538,840.7419;Float;False;Property;_Float1;Float 1;0;0;Create;True;0;0;False;0;0.01;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;15;416.7361,1099.94;Float;True;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;8;464.221,-1171.697;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;678.4053,931.8356;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;18;878.4189,960.3441;Float;False;VertexWoogle;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;10;726.2667,-1175.838;Float;True;MainSegment;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;9;1979.662,-390.8127;Float;False;10;MainSegment;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;19;1974.709,-115.8201;Float;False;18;VertexWoogle;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2249.199,-382.6442;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Water2;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;ForwardOnly;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;0;0;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;12;0;11;0
WireConnection;3;0;2;0
WireConnection;13;1;12;0
WireConnection;4;0;3;0
WireConnection;4;1;2;4
WireConnection;14;1;13;0
WireConnection;5;0;4;0
WireConnection;15;0;14;0
WireConnection;8;0;6;0
WireConnection;8;1;7;0
WireConnection;8;2;5;0
WireConnection;17;0;15;0
WireConnection;17;1;16;0
WireConnection;18;0;17;0
WireConnection;10;0;8;0
WireConnection;0;0;9;0
WireConnection;0;11;19;0
ASEEND*/
//CHKSM=9F666967E88074A7ADA4665E69B5064790D0AE83