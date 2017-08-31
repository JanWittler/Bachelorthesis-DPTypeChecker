# DPTypeChecker
A type checker based on the paper [Differential Privacy by Typing in Security Protocols](http://sps.cs.uni-saarland.de/publications/dp_proto_long.pdf) by F. Eigner and M. Maffei.

Topic of the bachelor thesis of Jan Wittler.

Tested with Xcode 8.3.3 on macOS Sierra (10.12). Compatibility with other versions or operation systems cannot be guaranteed.

##  Abstract
Differential privacy is a security concept used to verify the confidentiality of arbitrary database queries. In particular, it can provide strong guarantees for distributing statistical information from a database without compromising sensitive user data. As of now differential privacy is one of the most promising approaches to user privacy, with many different mechanized proof techniques having been developed.

Since user data is often spread across multiple databases, it is required to model multiple, possibly malicious, parties when evaluating a query. To protect sensitive data and achieve differential privacy in such an adverse setting, many cryptographic protocols have been proposed. Proving differential privacy for such protocols is hard and out of scope for most of the mentioned mechanized proof techniques.

To enable an automated evaluation of the differential privacy property of arbitrary security protocols, Eigner and Maffei introduced a type system targeted for distributed differential privacy. This work presents an implementation of the mentioned type system which is able to reason about Dolev-Yao intruders and can model compromised parties. In addition to the implementation, the thesis covers a complete mapping of the original type system to an algorithmic variant. Furthermore, the work was tested against two realistic examples and was able to verify the given protocol and detect a potential malicious party, respectively.
