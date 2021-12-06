Class {
	#name : #SWProjectOfFortran,
	#superclass : #SWProjectOld,
	#instVars : [
		'objs',
		'exeName'
	],
	#category : #'SWFortranByPharo-Client-Client'
}

{ #category : #execution }
SWProjectOfFortran >> compileAllAsFortran [

	self
		flag: #ToRewrite;
		objs: (self sources collect: [ :arg1 | 
					 | tmp1 tmp2 tmp4 |
					 tmp1 := String streamContents: [ :arg2 | 
							         arg2
								         << 'obj/';
								         << (arg1 at: #program) class name;
								         << '/';
								         << (arg1 at: #hash);
								         << '.o' ].
					 tmp2 := client post: tmp1 with: { 
							         ('action' -> 'compile').
							         ('type' -> self type).
							         ('sources' -> { (arg1 at: #Location) }) }.
					 self assert: [ tmp2 at: #success ].
					 tmp4 := Dictionary newFrom: arg1.
					 tmp4
						 at: #source put: (arg1 at: #Location);
						 at: #Location put: (tmp2 at: #Location);
						 yourself ])
]

{ #category : #accessing }
SWProjectOfFortran >> exeName [

	self flag: #ToRewrite.
	^ exeName
		  ifNil: [ 
			  exeName := String streamContents: [ :arg1 | 
				             | tmp1 |
				             arg1
					             << 'exe/';
					             << (self programs isNotEmpty
							              ifTrue: [ 
								              tmp1 := self programs at: 1.
								              (tmp1 respondsTo: #programName)
									              ifTrue: [ tmp1 programName ]
									              ifFalse: [ (self programs at: 1) class name ] ]
							              ifFalse: [ 'a' ]);
					             << '.out' ] ]
		  ifNotNil: [ exeName ]
]

{ #category : #accessing }
SWProjectOfFortran >> exeName: arg1 [

	exeName := arg1
]

{ #category : #running }
SWProjectOfFortran >> go [

	| tmp1 tmp2 tmp4 tmp6 |
	tmp1 := self pool get: self moduleName.
	tmp4 := SWSourceOld new.
	tmp4
		type: #mak;
		moduleName: self moduleName.
	tmp6 := SWTranspilerOfMake new.
	tmp6
		pool: self pool;
		source: tmp1;
		transpile.
	tmp4
		contents: tmp6 contents;
		putOn: self client.
	tmp2 := tmp4 yourself.
	^ self client
		  exec: 'make'
		  with: { ('-f' , tmp2 filename) } , self args
]

{ #category : #initialization }
SWProjectOfFortran >> initialize [

	super initialize.
	self type: #f90
]

{ #category : #execution }
SWProjectOfFortran >> linkAllAsFortran [

	| tmp1 |
	tmp1 := self client post: self exeName with: { 
			        ('action' -> 'link').
			        ('type' -> self type).
			        ('sources'
			         ->
			         (self objs collect: [ :arg1 | 
				          (arg1 at: #Location) asString ])) }.
	self
		assert: [ tmp1 at: #success ];
		exeName: (tmp1 at: #Location) asString
]

{ #category : #accessing }
SWProjectOfFortran >> objs [

	^ objs
]

{ #category : #accessing }
SWProjectOfFortran >> objs: arg1 [

	objs := arg1
]

{ #category : #execution }
SWProjectOfFortran >> putAll [

	self sources do: [ :arg1 | 
		arg1
			client: self client;
			put ]
]

{ #category : #execution }
SWProjectOfFortran >> run [

	| tmp1 tmp2 |
	tmp1 := self sources first type.
	tmp1 = #f90 ifTrue: [ 
		tmp2 := self client post: self exeName with: { 
				        ('action' -> 'execute').
				        ('arguments' -> {  }) }.
		(tmp2 at: #success) ifFalse: [ Error signal ].
		^ tmp2 ].
	tmp1 = #rb ifTrue: [ 
		^ self client exec: 'ruby' with: { 
				  '-I'.
				  './pharo-local/iceberg/garlic-flavor/FortranByPharo/script'.
				  '-I'.
				  './'.
				  self sources first filename } ].
	self error: 'NO IMPLEMENTATION'
]

{ #category : #accessing }
SWProjectOfFortran >> sources [

	^ sources
]

{ #category : #accessing }
SWProjectOfFortran >> sources: arg1 [

	sources := arg1
]
