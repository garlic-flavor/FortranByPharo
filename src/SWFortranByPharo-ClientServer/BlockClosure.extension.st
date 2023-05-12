Extension { #name : #BlockClosure }

{ #category : #'*SWFortranByPharo-ClientServer' }
BlockClosure >> | rightBlock [
	^ [ :std |
		|pipe|
		pipe := std newPipe.
		[
			self value: (std sub
				in: std in;
				out: pipe writeStream;
				yourself).
			std semaphore signal.
		] fork.
		[
			rightBlock value: (std sub
				in: pipe readStream;
				out: std out;
				yourself).
			std semaphore signal.
		] fork
	]
]
