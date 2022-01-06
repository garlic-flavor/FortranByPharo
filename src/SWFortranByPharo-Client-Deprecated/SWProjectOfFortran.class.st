"
I represent a Project of fortran.
"
Class {
	#name : #SWProjectOfFortran,
	#superclass : #SWProjectOld,
	#instVars : [
		'objs',
		'exeName'
	],
	#category : #'SWFortranByPharo-Client-Deprecated-Client-Deprecated'
}

{ #category : #execution }
SWProjectOfFortran >> compileAllAsFortran [
	self flag: #ToRewrite.
	self objs: (self sources collect: [ :aSource ||objname res|
		objname := String streamContents: [ :s |
			s << 'obj/'; << (aSource at: #program) class name; << '/'; << (aSource at: #hash); << '.o'
		].
		res := client post: objname with: {
			'action' -> 'compile'.
			'type' -> self type.
			'sources' -> {aSource at: #Location}.
		}.
		self assert: [ res at: #success ].
		(Dictionary newFrom: aSource)
			at: #source put: (aSource at: #Location);
			at: #Location put: (res at: #Location);
			yourself.
	])
]

{ #category : #accessing }
SWProjectOfFortran >> exeName [
	self flag: #ToRewrite.
	^ exeName ifNil: [
		exeName := String streamContents: [ :s |
			
			s << 'exe/';
				<< (self programs isNotEmpty ifTrue: [|head|
					head := self programs at: 1.
					(head respondsTo: #programName) ifTrue: [
						head programName
					] ifFalse: [
						(self programs at: 1) class name
					]
				] ifFalse: [ 'a' ]);
				<< '.out'
		]
	]
]

{ #category : #accessing }
SWProjectOfFortran >> exeName: anObject [

	exeName := anObject
]

{ #category : #running }
SWProjectOfFortran >> go [
	|aSource make|
	aSource := self pool get: self moduleName.
	make := SWSourceOld new
		type: #mak;
		moduleName: self moduleName;
		contents: (SWTranspilerOfMake new
			pool: self pool;
			source: aSource;
			transpile;
			contents);
		putOn: self client;
		yourself.
	^ self client exec: 'make' with: ({'-f',  make filename }, self args).

]

{ #category : #initialization }
SWProjectOfFortran >> initialize [
	super initialize.
	self type: #f90.
]

{ #category : #execution }
SWProjectOfFortran >> linkAllAsFortran [
	|res|
	res := self client post: self exeName with: { 
		'action' -> 'link'.
		'type' -> self type.
		'sources' -> (self objs collect: [:each | (each at: #Location) asString ]).
	}.
	self assert: [ res at: #success ].
	self exeName: (res at: #Location) asString.

]

{ #category : #accessing }
SWProjectOfFortran >> objs [

	^ objs
]

{ #category : #accessing }
SWProjectOfFortran >> objs: anObject [

	objs := anObject
]

{ #category : #execution }
SWProjectOfFortran >> putAll [
	self sources do: [ :aSource |
		aSource
			client: self client;
			put.
	]
]

{ #category : #execution }
SWProjectOfFortran >> run [
	|type|
	type := self sources first type.
	type = #f90 ifTrue: [|res|
		res := self client post: self exeName with: {
			'action' -> 'execute'.	
			'arguments' -> {  }
		}.
		(res at: #success) ifFalse: [ Error signal ].
		^ res
	].

	type = #rb ifTrue: [
		^ self client exec: 'ruby' with: {
			'-I'.
			'./pharo-local/iceberg/garlic-flavor/FortranByPharo/script'.
			'-I'.
			'./'.
			self sources first filename
		}
	].

	self error: 'NO IMPLEMENTATION'
]

{ #category : #accessing }
SWProjectOfFortran >> sources [

	^ sources
]

{ #category : #accessing }
SWProjectOfFortran >> sources: anObject [

	sources := anObject
]
