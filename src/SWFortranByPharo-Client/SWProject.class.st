Class {
	#name : #SWProject,
	#superclass : #Object,
	#instVars : [
		'client',
		'programs',
		'type',
		'sources',
		'objs',
		'exeName'
	],
	#category : #'SWFortranByPharo-Client-Client'
}

{ #category : #accessing }
SWProject >> client [

	^ client
]

{ #category : #accessing }
SWProject >> client: anObject [

	client := anObject
]

{ #category : #execution }
SWProject >> compileAllAsFortran [
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
SWProject >> dirName [
	self type = #f90 ifTrue: [ ^ 'src' ].
	self type = #rb ifTrue: [ ^ 'script' ].
	self error: 'NO IMPLEMENTAION.'.
]

{ #category : #accessing }
SWProject >> exeName [

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
SWProject >> exeName: anObject [

	exeName := anObject
]

{ #category : #running }
SWProject >> go [
	self type = #f90 ifTrue: [
		^ self
			putAll;
			compileAllAsFortran;
			linkAllAsFortran;
			run
	].

	self type = #rb ifTrue: [
		^ self
			putAll;
			run
	].

	self error: 'NO IMPLEMENTATION!'
]

{ #category : #running }
SWProject >> goDomestic [
	^ String streamContents: [ :s |
		self classes do: [ :aClass ||instance|
			instance := aClass new.
			instance view: s.
			instance program.
		]
	]
]

{ #category : #initialization }
SWProject >> initialize [
	super initialize.
	type := #f90.
]

{ #category : #execution }
SWProject >> linkAllAsFortran [
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
SWProject >> objs [

	^ objs
]

{ #category : #accessing }
SWProject >> objs: anObject [

	objs := anObject
]

{ #category : #accessing }
SWProject >> programs [

	^ programs
]

{ #category : #accessing }
SWProject >> programs: anObject [

	programs := anObject
]

{ #category : #execution }
SWProject >> putAll [
	self sources: (self programs collect: [ :aProgram ||contents hash filename res|
		contents := self transpile: aProgram.
		hash := (SHA256 hashMessage: contents) hex.
		filename := String streamContents: [ :s |
			s << self dirName; << '/';
				<< aProgram class name; << '/';
				<< hash; << '.'; << self type
		].
		res := client put: filename contents: contents.	
		self assert: [ res at: #success ].
		Dictionary new
			at: #Location put: (res at: #Location);
			at: #hash put: hash;
			at: #program put: aProgram;
			yourself.
	])
]

{ #category : #execution }
SWProject >> run [
	self type = #f90 ifTrue: [|res|
		res := self client post: self exeName with: {
			'action' -> 'execute'.	
			'arguments' -> {  }
		}.
		(res at: #success) ifFalse: [ Error signal ].
		^ res
	].

	self type = #rb ifTrue: [|res|
		res := self client post: 'ruby' with: {
			'action' -> 'execute'.
			'arguments' -> (self sources collect: [ :each | (each at: #Location) asString ])
		}.
		(res at: #success) ifFalse: [ Error signal ].
		^ res
	].

	self error: 'NO IMPLEMENTATION'
]

{ #category : #accessing }
SWProject >> sources [

	^ sources
]

{ #category : #accessing }
SWProject >> sources: anObject [

	sources := anObject
]

{ #category : #execution }
SWProject >> transpile: aSource [
	^ self transpilerClass new
		source: aSource;
		transpileProgram;
		contents
]

{ #category : #accessing }
SWProject >> transpilerClass [
	self type = #f90 ifTrue: [ ^ SWTranspilerOfFortran ].
	self type = #rb ifTrue: [ ^ SWTranspilerOfRuby ].
	self error: 'NO IMPLEMENTATION!'.
]

{ #category : #accessing }
SWProject >> type [

	^ type
]

{ #category : #accessing }
SWProject >> type: anObject [

	type := anObject
]
