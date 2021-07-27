Extension { #name : #RBCascadeNode }

{ #category : #'*SWFortranByPharo-Client' }
RBCascadeNode >> transpileUsing: transpiler [
	|msg block seq tmp|
	tmp := RBVariableNode new
		name: 'tmp';
		yourself.
	seq := RBSequenceNode new
		addNodes: (self messages collect: [:each |
			each copy receiver: tmp; yourself
		]);
		yourself.

	block := RBBlockNode new
		arguments: { tmp };
		body: seq;
		yourself.
	msg := RBMessageNode new
		receiver: block;
		selector: #value:;
		arguments: { self receiver copy };
		yourself.

	msg transpileUsing: transpiler.
	"
	self messages do: [ :each|
		each transpileUsing: transpiler.
	] separatedBy: [
		transpiler putLine.
	]
"
]
