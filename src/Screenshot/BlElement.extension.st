Extension { #name : #BlElement }

{ #category : #'*Screenshot' }
BlElement >> gtProfile [
	| profile |
	profile := Dictionary new.
	(self respondsTo: #text)
		ifTrue: [ profile at: #text put: self text ]
		ifFalse: [ | childProfiles |
			childProfiles := OrderedCollection new.
			self children
				do: [ :child | 
					| childProfile |
					childProfile := child profile.
					childProfile isEmpty
						ifFalse:
							[ childProfiles add: childProfile ] ].
			childProfiles isEmpty
				ifFalse:
					[ profile at: #children put: childProfiles ] ].
	profile isEmpty
		ifFalse:
			[ profile at: #className put: self class name ].
	^ profile u
]
