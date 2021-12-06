Class {
	#name : #SWTranspilerTest,
	#superclass : #TestCase,
	#instVars : [
		'rbt'
	],
	#category : #'SWFortranByPharo-Client-Tests-Transpiler'
}

{ #category : #running }
SWTranspilerTest >> setUp [

	| tmp2 |
	super setUp.
	tmp2 := SWTranspilerOfRuby new.
	tmp2
		source: SWTestHelloWorld new;
		indentShifter:  -1.
	rbt := tmp2 yourself
]

{ #category : #accessing }
SWTranspilerTest >> source: arg1 [

	^ rbt newline join: arg1 , { '' }
]

{ #category : #tests }
SWTranspilerTest >> test: arg1 equals: arg2 [

	rbt transpileMethod: arg1.
	self assert: rbt contents equals: (self source: arg2)
]

{ #category : #test }
SWTranspilerTest >> testPutCodeWith [

	rbt
		putCode: '\
		put("%value%")
		return 100
	\'
		with: { ('%value%' -> 'Hello, world') }.
	self
		assert: rbt contents
		equals:
		(String crlf join: { 'put("Hello, world")'. 'return 100'.
		 '' })
]

{ #category : #test }
SWTranspilerTest >> testPutMessageCallWith [

	self test: #program equals: { 'puts(''Hello, World!'')' }.
	rbt reset.
	self test: #program2 equals: { 'a = 1 + 2'. 'puts(a)' }.
	rbt reset.
	self test: #program3 equals: { 'a = 1 + (2 * 3)'. 'puts(a)' }
]

{ #category : #tests }
SWTranspilerTest >> testSelectorNameOf [

	self
		assert: (SWTranspiler selectorNameOf: #print:) equals: 'print_';
		assert: (SWTranspiler selectorNameOf: #+) equals: 'opAdd_'
]

{ #category : #test }
SWTranspilerTest >> testTransformSelector [

	self
		assert: (rbt transformSelector: #print:)
		equals: 'rb_print_with:using:';
		assert: (rbt transformSelector: #+) equals: 'rb_opAdd_with:using:'
]
