# Museli

Museli is currently a playground for implementing a binary 
serialization format for Perl/JSON style data structures 
(Int, Float, String, Array, Hash, Undef), it is not meant
to be for anything other then experimentation, learning 
and fun.

## Rationale

At my job we work a lot with [Sereal](https://metacpan.org/pod/Sereal) 
and one of the things on my backlog has been to look at 
updating/re-writing the JVM version. Currently it is in 
Java, I was thinking perhaps using Scala, maybe Clojure, 
we will see. 

But anyway, since I have never in my whole career had call 
to learn about binary encoding formats and bit-fiddling, I 
decided that before I embark the more ambitious Scala/Sereal 
project, it would be wise to familiarize myself with the 
problem domain of encoder/decoders in general and bit-fiddling
specifically, but do it in a language I am more comfortable 
with (Perl). 

## COPYRIGHT AND LICENSE

This software is copyright (c) 2015 by Stevan Little.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.