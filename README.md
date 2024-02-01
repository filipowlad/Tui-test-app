Application is devided on several blocks to split logic and code visibility.
Blocks:
1. API – contains API protocols and models used by them
2. Helpers – contains helpfull extensions
3. Components – contains standalone views and stylers that can be reused in different places
4. Features – contains standalone features that can be reused + tests for them
5. Facade – contains providers protocols that defines application's capabilities
6. App itself – contains implementations of frotocols from other blocks + coordination between features
