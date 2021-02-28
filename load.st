(IceRepository registry
    anySatisfy: [ :repo | repo location = '..' asFileReference])
        ifFalse: [
            | repo |
            repo := IceRepositoryCreator new
                location: '..' asFileReference;
                createRepository.
            repo register.
            repo workingCopy packages do: [ :p | p load ]
        ]
