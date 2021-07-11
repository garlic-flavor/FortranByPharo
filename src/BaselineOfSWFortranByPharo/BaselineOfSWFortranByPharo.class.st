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
		"Dependencies"
		self setUpDependencies: spec.

		"Packages"
		spec
			package: 'SWFortranByPharo-Base';
			package: 'SWFortranByPharo-Client' with: [ spec requires: #('SQLite3-Core' 'SWFortranByPharo-Base') ];
			package: 'SWFortranByPharo-Server' with: [ spec requires: #('OSSubprocess' 'SWFortranByPharo-Base' 'SWFortranByPharo-Client') ];
			package: 'SWFortranByPharo-Base-Test' with: [ spec requires: #('SWFortranByPharo-Base') ];
			package: 'SWFortranByPharo-Server-Test' with: [ spec requires: #('SWFortranByPharo-Server') ];
			package: 'SWFortranByPharo-Client-Test' with: [ spec requires: #('SWFortranByPharo-Client') ].
		
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
		baseline: 'SQLite3-Core'
			with: [ spec repository: 'https://github.com/pharo-rdbms/Pharo-SQLite3' ].
]
