# Script

## Wat is docker?
### Virtualisatie en isolatie
In eerste instantie een light-weight virtualizatie platform, dat vanuit images werkende applicatie beheert. De focus ligt hierbij wel op één applicatie per container. Dit heeft als voordeel dat de image alleen maar de dependencies van die ene applicatie erin zitten. 

### Cross platform
Docker is beschikbaar voor Linux, Mac en Windows.
Omdat Docker een virtualizatieplatform is, moet het ergens in gehost worden. In Linux kan dit rechstreeks, maar bij Mac en Windows moet dit vaak nog via een hypervisor.
Je kan echter wel Linux als Windows images gebruiken, maar deze containers moeten uiteraard wel in de juiste Docker omgeving runnen.


## Hands-on terminal magic
```
$ docker run hello-world
```
