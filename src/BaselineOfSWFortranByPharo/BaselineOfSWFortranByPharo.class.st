"
This describes dependencies of the SWFortranByPharo package.
This project is for Pharo 9.0 or above.
"
Class {
	#name : #BaselineOfSWFortranByPharo,
	#superclass : #BaselineOf,
	#category : #BaselineOfSWFortranByPharo
}

{ #category : #baselines }
BaselineOfSWFortranByPharo >> baseline: spec [
	<baseline>
	spec for: #pharo
	do: [ 
		spec blessing: #baseline.
		"Dependencies"
		self setUpDependencies: spec.

		"Packages"
		spec
			package: 'SWFortranByPharo-Analyzer';
			package: 'SWFortranByPharo-Transpiler' with: [ spec requires: #( 'SWFortranByPharo-Analyzer' ) ];
			package: 'SWFortranByPharo-ClientServer' with: [ spec requires: #('OSSubprocess'
				'SWFortranByPharo-Transpiler') ];
			
		"Tests"
			package: 'SWFortranByPharo-Tests' with: [ spec requires: #('SWFortranByPharo-ClientServer') ];
			package: 'SWFortranByPharo-ClientServer-Tests' with: [ spec requires: #('SWFortranByPharo-Tests') ];
			package: 'SWFortranByPharo-Analyzer-Tests' with: [ spec requires: #('SWFortranByPharo-Tests') ];
			package: 'SWFortranByPharo-Transpiler-Tests' with: [ spec requires: #('SWFortranByPharo-Tests') ].
		"Groups"
	]
]

{ #category : #accessing }
BaselineOfSWFortranByPharo >> projectClass [ 
	^ MetacelloCypressBaselineProject
]

{ #category : #initialization }
BaselineOfSWFortranByPharo >> setUpDependencies: spec [
	spec 
		baseline: 'OSSubprocess'
			with: [spec repository: 'github://pharo-contributions/OSSubprocess:master/repository'];
"
		baseline: 'ZincHTTPComponents'
 			with: [ spec repository: 'github://svenvc/zinc/repository' ];
		baseline: 'NeoUniversalBinaryJSON'
			with: [ spec repository: 'github://svenvc/NeoUniversalBinaryJSON'  ];
"
		baseline: 'MessagePack'
			with: [ spec repository: 'github://msgpack/msgpack-smalltalk/repository' ]
";
		package: 'Zinc-WebSocket-Core' with: [
			spec
				repository: 'github://svenvc/zinc' ].
"
]
