# Script

## Wat is docker?
### Virtualisatie en isolatie
In eerste instantie een light-weight virtualizatie platform, dat vanuit images werkende applicatie beheert. De focus ligt hierbij wel op één applicatie per container. Dit heeft als voordeel dat de image alleen maar de dependencies van die ene applicatie erin zitten. 

### Cross platform
Docker is beschikbaar voor Linux, Mac en Windows.
Omdat Docker een virtualizatieplatform is, moet het ergens in gehost worden. In Linux kan dit rechstreeks, maar bij Mac en Windows moet dit vaak nog via een virtualizatielaag, een zogenaamde hypervisor.
Je kan echter wel Linux en Windows images gebruiken, maar deze containers moeten uiteraard wel in de juiste Docker omgeving runnen. In de meeste gevallen zal je werken met Linux containers, omdat deze vaak een veel kleinere _footprint_ hebben dan Windows containers.


## Hands-on terminal magic
Om docker te gebruiken zal je toch af en toe de terminal in moeten duiken, maar vaak blijft het gebruik redelijk beperkt.
Om te kijken of je docker installatie succesvol is, is er  een image die kan runnen. Om deze te downloaden, zal je echter nog een account moeten maken op een registry. De bekendste is Docker Hub, maar je kan ook je eigen registry op zetten voor je eigen images op te zetten. Het voordeel van deze _private_ registries is dat je typisch alleen jezelf access kan geven aan deze images. Docker Hub is een publieke, en alles wat hier op geupload wordt kan worden gedownload worden. Overigens spreekt men bij docker niet over downloaden, maar over _pullen_.
Software ontwikkelaars die nu een belletje horen rinkelen en aan Git, het versiebeheersysteem denken: er zijn nog andere overeenkomsten. Maar daar kom ik nog opo terug.
Laten we beginnen met de typische hello-world image te runnen.

Snippet:

`$ docker run hello-world`

Output:
```
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
1b930d010525: Pull complete
Digest: sha256:f9dfddf63636d84ef479d645ab5885156ae030f611a56f3a7ac7f2fdd86d7e4e
Status: Downloaded newer image for hello-world:latest
```

