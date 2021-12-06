Class {
	#name : #SWTranspilerOfRuby,
	#superclass : #SWTranspiler,
	#category : #'SWFortranByPharo-Client-Transpiler'
}

{ #category : #'as yet unclassified' }
SWTranspilerOfRuby >> and_For: arg1 With: arg2 [

	self
		transpile: arg1;
		put: ' && ';
		preventNewline;
		transpile: (arg2 at: 1) body
]

{ #category : #'as yet unclassified' }
SWTranspilerOfRuby >> anySatisfy_For: arg1 With: arg2 [

	self
		transpile: arg1;
		put: '.find';
		putBlockWithoutProc: (arg2 at: 1)
]

{ #category : #converting }
SWTranspilerOfRuby >> asStringFor: arg1 With: arg2 [

	self
		pushMessageNest;
		put: 'SWString.new(';
		transpile: arg1;
		put: '.to_s)';
		popMessageNest
]

{ #category : #converting }
SWTranspilerOfRuby >> asSymbolFor: arg1 With: arg2 [

	self
		transpile: arg1;
		put: '.intern'
]

{ #category : #accessing }
SWTranspilerOfRuby >> at_For: arg1 With: arg2 [

	self
		transpile: arg1;
		put: '[';
		transpile: (arg2 at: 1);
		put: ']'
]

{ #category : #accessing }
SWTranspilerOfRuby >> at_ifAbsent_For: arg1 With: arg2 [

	self
		put: '(';
		transpile: arg1;
		put: '[';
		transpile: (arg2 at: 1);
		put: '] || ';
		preventNewline;
		transpile: (arg2 at: 2) body;
		put: ')'
]

{ #category : #accessing }
SWTranspilerOfRuby >> at_put_For: arg1 With: arg2 [

	self
		transpile: arg1;
		pushMessageNest;
		put: '[';
		transpile: (arg2 at: 1);
		put: '] = ';
		transpile: (arg2 at: 2);
		popMessageNest
]

{ #category : #'as yet unclassified' }
SWTranspilerOfRuby >> beginsWith_For: arg1 With: arg2 [

	self putMessage: arg1 send: 'start_with?' with: arg2
]

{ #category : #'as yet unclassified' }
SWTranspilerOfRuby >> collect_For: arg1 With: arg2 [

	self
		transpile: arg1;
		put: '.collect';
		putBlockWithoutProc: (arg2 at: 1)
]

{ #category : #'as yet unclassified' }
SWTranspilerOfRuby >> copyFor: arg1 With: arg2 [

	self
		transpile: arg1;
		put: '.clone'
]

{ #category : #copying }
SWTranspilerOfRuby >> copyReplaceAll_with_For: arg1 With: arg2 [

	self
		incMessageNest;
		pushMessageNest;
		transpile: arg1;
		put: '[';
		transpile: (arg2 at: 1);
		put: ']= ';
		transpile: (arg2 at: 2);
		popMessageNest;
		decMessageNest
]

{ #category : #'as yet unclassified' }
SWTranspilerOfRuby >> descriptionFor: arg1 With: arg2 [

	self
		pushMessageNest;
		putMessage: arg1 send: 'message' with: arg2;
		popMessageNest
]

{ #category : #'as yet unclassified' }
SWTranspilerOfRuby >> do_For: arg1 With: arg2 [

	self
		pushMessageNest;
		transpile: arg1;
		put: '.each';
		putBlockWithoutProc: (arg2 at: 1);
		popMessageNest
]

{ #category : #'as yet unclassified' }
SWTranspilerOfRuby >> ensure_For: arg1 With: arg2 [

	self
		pushMessageNest;
		putLine: 'begin';
		transpile: arg1 body;
		putLine: 'ensure';
		transpile: (arg2 at: 1) body;
		put: 'end';
		popMessageNest
]

{ #category : #'as yet unclassified' }
SWTranspilerOfRuby >> ifFalse_For: arg1 With: arg2 [

	self
		put: 'if not ';
		pushMessageNest;
		transpile: arg1;
		putLine;
		transpile: (arg2 at: 1) body;
		popMessageNest;
		put: 'end'
]

{ #category : #'as yet unclassified' }
SWTranspilerOfRuby >> ifNil_For: arg1 With: arg2 [

	self
		pushMessageNest;
		put: '(if ';
		transpile: arg1;
		putLine: '.nil?';
		transpile: (arg2 at: 1) body;
		putLine: 'else';
		incIndent;
		transpile: arg1;
		putLine;
		decIndent;
		put: 'end)';
		popMessageNest
]

{ #category : #'as yet unclassified' }
SWTranspilerOfRuby >> ifNotNil_For: arg1 With: arg2 [

	self
		pushMessageNest;
		put: '(not (';
		transpile: arg1;
		putLine: ').nil?) ? (';
		transpile: (arg2 at: 1) body;
		put: '): nil';
		popMessageNest
]

{ #category : #'as yet unclassified' }
SWTranspilerOfRuby >> ifNotNil_ifNil_For: arg1 With: arg2 [

	self
		pushMessageNest;
		put: 'if not (';
		transpile: arg1;
		putLine: ').nil?';
		transpile: (arg2 at: 1) body;
		putLine: 'else';
		transpile: (arg2 at: 2) body;
		put: 'end';
		popMessageNest
]

{ #category : #'as yet unclassified' }
SWTranspilerOfRuby >> ifTrue_For: arg1 With: arg2 [

	self
		pushMessageNest;
		put: 'if ';
		transpile: arg1;
		putLine;
		transpile: (arg2 at: 1) body;
		put: 'end'
]

{ #category : #'as yet unclassified' }
SWTranspilerOfRuby >> ifTrue_ifFalse_For: arg1 With: arg2 [

	self
		pushMessageNest;
		put: '(if ';
		transpile: arg1;
		putLine;
		transpile: (arg2 at: 1) body;
		putLine: 'else';
		transpile: (arg2 at: 2) body;
		put: 'end)';
		popMessageNest
]

{ #category : #initialization }
SWTranspilerOfRuby >> initialize [

	super initialize.
	self
		newline: String lf;
		type: #rb
]

{ #category : #'as yet unclassified' }
SWTranspilerOfRuby >> join_For: arg1 With: arg2 [

	self
		pushMessageNest;
		putMessage: (arg2 at: 1) send: 'join' with: { arg1 };
		popMessageNest
]

{ #category : #'as yet unclassified' }
SWTranspilerOfRuby >> on_do_For: arg1 With: arg2 [

	self
		pushMessageNest;
		putLine: 'begin';
		transpile: arg1 body;
		put: 'rescue => ';
		putLine: (0 < (arg2 at: 2) arguments size
				 ifTrue: [ (arg2 at: 2) argumentNames at: 1 ]
				 ifFalse: [ 'e' ]);
		transpile: (arg2 at: 2) body;
		put: 'end';
		popMessageNest
]

{ #category : #'as yet unclassified' }
SWTranspilerOfRuby >> opArrow_For: arg1 With: arg2 [

	self
		pushMessageNest;
		put: 'Association.new(';
		transpile: arg1;
		put: ', ';
		transpile: (arg2 at: 1);
		put: ')';
		popMessageNest
]

{ #category : #'as yet unclassified' }
SWTranspilerOfRuby >> opCamma_For: arg1 With: arg2 [

	self
		transpile: arg1;
		put: ' + ';
		transpile: (arg2 at: 1)
]

{ #category : #'as yet unclassified' }
SWTranspilerOfRuby >> opEqual_For: arg1 With: arg2 [

	self
		transpile: arg1;
		put: ' == ';
		transpile: (arg2 at: 1)
]

{ #category : #'as yet unclassified' }
SWTranspilerOfRuby >> opNotEqual_For: arg1 With: arg2 [

	self
		transpile: arg1;
		put: ' != ';
		transpile: (arg2 at: 1)
]

{ #category : #'as yet unclassified' }
SWTranspilerOfRuby >> perform_For: arg1 With: arg2 [

	self
		pushMessageNest;
		putMessage: arg1 send: 'send' with: arg2;
		popMessageNest
]

{ #category : #'code generation' }
SWTranspilerOfRuby >> putArgumentsOf: arg1 with: arg2 [

	0 < arg2 size ifTrue: [ 
		self
			put: '(';
			putArray: arg2;
			put: ')' ]
]

{ #category : #'as yet unclassified' }
SWTranspilerOfRuby >> putBlock: arg1 [

	self
		put: 'proc';
		putBlockWithoutProc: arg1
]

{ #category : #'as yet unclassified' }
SWTranspilerOfRuby >> putBlockWithoutProc: arg1 [

	self
		pushMessageNest;
		put: '{'.
	0 < arg1 arguments size ifTrue: [ 
		self put: '|'.
		arg1 argumentNames
			do: [ :arg2 | self put: arg2 asString ]
			separatedBy: [ self put: ', ' ].
		self put: '|' ].
	self
		putLine;
		transpile: arg1 body;
		put: '}';
		popMessageNest
]

{ #category : #'as yet unclassified' }
SWTranspilerOfRuby >> putClassDefinition: arg1 [

	self
		putComment: arg1 comment;
		put: 'class ';
		put: arg1 name.
	arg1 superclass = Object ifFalse: [ 
		self
			put: ' < ';
			put: arg1 superclass name ].
	self
		putLine;
		incIndent.
	arg1 classVariables do: [ :arg2 | 
		self
			put: '@@';
			put: arg2 name;
			putLine: ' = nil' ].
	arg1 instanceVariables do: [ :arg3 | 
		self
			put: '@';
			put: arg3 name;
			putLine: ' = nil' ].
	arg1 class methods
		select: [ :arg4 | (arg4 protocol beginsWith: 'code generation') not ]
		thenDo: [ :arg5 | self putMethod: arg5 ofClass: arg1 ].
	arg1 methods
		select: [ :arg6 | (arg6 protocol beginsWith: 'code generation') not ]
		thenDo: [ :arg7 | self putMethod: arg7 ofClass: arg1 ].
	self
		flag: #toImplement;
		decIndent;
		putLine: 'end'
]

{ #category : #'as yet unclassified' }
SWTranspilerOfRuby >> putClassname: arg1 [

	(#( #String ) anySatisfy: [ :arg2 | arg2 = arg1 ]) ifTrue: [ 
		self put: 'SW'.
		^ self put: arg1 ].
	^ super putClassname: arg1
]

{ #category : #'as yet unclassified' }
SWTranspilerOfRuby >> putComment: arg1 [

	arg1 ifNotNil: [ 
		arg1 linesDo: [ :arg2 | 
			self
				put: '# ';
				putLine: arg2 ] ]
]

{ #category : #'as yet unclassified' }
SWTranspilerOfRuby >> putFileHeaderOf: arg1 [

	self putLine: '#!/usr/bin/ruby'
]

{ #category : #'code generation' }
SWTranspilerOfRuby >> putFunctionCallOf: arg1 with: arg2 [

	self
		pushMessageNest;
		put: (arg1 asString first isLetter
				 ifTrue: [ arg1 ]
				 ifFalse: [ 
					 ' ' join: { 
								 ''.
								 arg1.
								 '' } ]);
		putArgumentsOf: arg1 with: arg2;
		popMessageNest
]

{ #category : #tests }
SWTranspilerOfRuby >> putMainProgram [

	self
		putCode: '\
		(%entryClass%.new).main_(ARGV)
	\'
		with: { ('%entryClass%' -> self source entryClass) }
]

{ #category : #'as yet unclassified' }
SWTranspilerOfRuby >> putMessage: arg1 send: arg2 with: arg3 [

	((arg1 respondsTo: #name) and: [ arg1 name = 'super' ]) ifTrue: [ 
		^ self putFunctionCallOf: 'super' with: arg3 ].
	^ super putMessage: arg1 send: arg2 with: arg3
]

{ #category : #'as yet unclassified' }
SWTranspilerOfRuby >> putMethod: arg1 ofClass: arg2 [

	| tmp1 |
	self
		putComment: arg1 comment;
		put: 'def ';
		put: (arg1 methodClass class = Metaclass
				 ifTrue: [ 'self.' ]
				 ifFalse: [ '' ]);
		put: (self class safeSelectorNameOf: arg1 selector);
		put: '(';
		put:
			(', ' join: (arg1 argumentNames collect: [ :arg3 | arg3 asString ]));
		putLine: ')';
		pushMessageNest.
	tmp1 := self safeSelectorNameOf: arg1.
	(arg2 respondsTo: tmp1)
		ifTrue: [ 
			self incIndent.
			arg2 perform: tmp1 with: self.
			self
				decIndent;
				putLine ]
		ifFalse: [ arg1 transpileUsing: self ].
	self
		putLine: 'end';
		popMessageNest
]

{ #category : #'as yet unclassified' }
SWTranspilerOfRuby >> putNil [

	self put: 'nil'
]

{ #category : #'code generation' }
SWTranspilerOfRuby >> putRequirements [

	| tmp1 |
	tmp1 := #rb_requirements.
	self source classes do: [ :arg1 | 
		(arg1 respondsTo: tmp1) ifTrue: [ 
			(arg1 perform: tmp1) do: [ :arg2 | 
				| tmp2 |
				arg2 isString
					ifTrue: [ 
						self
							put: 'require ''';
							put: arg2;
							putLine: '''' ]
					ifFalse: [ 
						| tmp4 |
						tmp4 := SWSourceOld new.
						tmp4
							classes: { arg2 };
							type: self type;
							client: self client;
							put.
						tmp2 := tmp4 yourself.
						self
							put: 'require ''';
							put: tmp2 filename;
							putLine: '''' ] ] ] ]
]

{ #category : #'as yet unclassified' }
SWTranspilerOfRuby >> putSymbol: arg1 [

	self
		put: ':';
		put: (self class safeSelectorNameOf: arg1)
]

{ #category : #'as yet unclassified' }
SWTranspilerOfRuby >> putTestRunner [

	self
		put: 'runner = ';
		put: self source firstClass asString;
		putLine: '.new'.
	(self source firstClass methods select: [ :arg1 | 
		 arg1 protocol beginsWith: 'test' ]) do: [ :arg2 | 
		self
			putLine: 'runner.setUp';
			put: 'runner.';
			putLine: arg2 selector asString;
			putLine: 'runner.tearDown' ]
]

{ #category : #'as yet unclassified' }
SWTranspilerOfRuby >> putVariable: arg1 [

	(#( #String #Dictionary ) anySatisfy: [ :arg2 | arg2 = arg1 name ]) 
		ifTrue: [ 
			self put: 'SW'.
			^ self put: arg1 name ].
	arg1 isInstanceVariable ifTrue: [ 
		self put: '@'.
		^ self put: arg1 name ].
	arg1 isClassVariable ifTrue: [ 
		self put: '@@'.
		^ self put: arg1 name ].
	^ super putVariable: arg1
]

{ #category : #'as yet unclassified' }
SWTranspilerOfRuby >> valueFor: arg1 With: arg2 [

	self
		transpile: arg1;
		put: '.call'
]

{ #category : #'as yet unclassified' }
SWTranspilerOfRuby >> value_For: arg1 With: arg2 [

	self
		transpile: arg1;
		put: '.';
		putFunctionCallOf: 'call' with: arg2
]

{ #category : #'as yet unclassified' }
SWTranspilerOfRuby >> yourselfFor: arg1 With: arg2 [

	self transpile: arg1
]
