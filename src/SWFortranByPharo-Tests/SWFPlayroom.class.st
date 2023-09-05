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
		io out << 'Hello, world!'
	].
	mt := SWMTofF90 new.
	mt pool global haltAt: #<<.
	mt
		main: script;
		name: 'hoge';
		yourself.
	mt transpile.

	^ mt stream contents
	
]

{ #category : #tests }
SWFPlayroom class >> test4 [
	<sampleInstance>
	|script exp pool|
	script := [ :io |
		5 + 3
	].
	pool := SWPoolOfF90 new.
	exp := SWExpression new
		pool: pool global;
		node: script sourceNode;
		operands: { Object. SWIO };
		decode;
		yourself.
	^ exp
	
]
