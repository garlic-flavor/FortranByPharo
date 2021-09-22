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
			package: 'SWFortranByPharo-Base';
			package: 'SWFortranByPharo-Client' with: [ spec requires: #('ZincHTTPComponents' 'SWFortranByPharo-Base') ];
			package: 'SWFortranByPharo-Server' with: [ spec requires: #('OSSubprocess' 'ZincHTTPComponents' 'SWFortranByPharo-Base') ];
			package: 'SWFortranByPharo-Base-Tests' with: [ spec requires: #('SWFortranByPharo-Base') ];
			package: 'SWFortranByPharo-Server-Tests' with: [ spec requires: #('SWFortranByPharo-Server') ];
			package: 'SWFortranByPharo-Client-Tests' with: [ spec requires: #('SWFortranByPharo-Client') ].
		
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
		baseline: 'ZincHTTPComponents'
 			with: [ spec
					loads: #('Zinc-WebSocket-Core');
					repository: 'github://svenvc/zinc/repository' ]


]
