Class {
	#name : #SWFPlayroom,
	#superclass : #Object,
	#category : #'SWFortranByPharo-Tests'
}

{ #category : #tests }
SWFPlayroom class >> test1 [

	<script>
	| script returnType args argTypes |
	script := [ :arg1 |
	          SWType declareReturnAs: #double.
	          SWType declare: #arg1 as: #double.
	          arg1 sin ].
	args := script argumentNames.
	argTypes := Dictionary new.
	script sourceNode children last children do: [ :node |
		(node receiver name = #SWType) ifTrue: [
			(node selector = #declareReturnAs:) ifTrue: [
				returnType := node arguments first value.
			].
			(node selector = #declare:as:) ifTrue: [
				argTypes at: (node arguments first value) put: (node arguments second value).
			]
		].
	].
	self halt.
	^ script
]

{ #category : #tests }
SWFPlayroom class >> test2 [
	<sampleInstance>
	|script mt|
	script := [ :arg1 |
	          SWType declare: #return as: Float.
	          SWType declare: #arg1 as: Float.
	          arg1 * 2.0 ].
	mt := SWMTofF90 new
		script: script;
		name: 'hoge';
		yourself.
	mt transpileAsBindCFunc.

	^ mt stream contents
	
]

{ #category : #tests }
SWFPlayroom class >> test3 [
	<sampleInstance>
	|script mt|
	script := [ :io |
		io << 'Hello, world!'
	].
	mt := SWMTofF90 new
		main: script;
		name: 'hoge';
		yourself.
	mt transpile.

	^ mt stream contents
	
]

{ #category : #tests }
SWFPlayroom class >> test4 [
	<sampleInstance>
	|script mt|
	script := [ :io |
		io ln: 'Hello, world!';
			ln: 'Good-bye, heaven.'
	].
	mt := SWMTofF90 new
		main: script;
		name: 'hoge';
		yourself.
	mt transpile.

	^ mt stream contents
	
]

{ #category : #tests }
SWFPlayroom class >> test5 [
	<sampleInstance>
	|script pc|
	script := [ :io |
		io ln: 'Hello, world!';
			ln: 'Good-bye, heaven.'
	].
	pc := SWFProgramCaller new
		script: script;
		name: 'hoge';
		referenceMode: true;
		yourself.
	pc call.

	^ pc io getStdoutAsString
	
]

{ #category : #tests }
SWFPlayroom class >> test6 [
	<sampleInstance>
	|mt|
	mt := SWMTofF90 new
		main: SWTestP1;
		name: 'hoge';
		yourself.
	mt transpile.

	^ mt stream contents
	
]

{ #category : #tests }
SWFPlayroom class >> test7 [
	<sampleInstance>
	|mt|
	mt := SWMTofF90 new
		main: SWTestP2;
		name: 'hoge';
		yourself.
	mt transpile.

	^ mt stream contents
	
]

{ #category : #tests }
SWFPlayroom class >> test8 [
	<sampleInstance>
	|pc|
	pc := SWFProgramCaller new
		script: SWTestP2;
		name: 'hoge';
		referenceMode: false;
		yourself.
	pc call.
	^ pc io getStdoutAsString
	
]
