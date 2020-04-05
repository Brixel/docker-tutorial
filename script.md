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

Het `docker run` command controleert automatisch of je deze image al hebt. Omdat je bent ingelogged met bij de Docker Hub registry (`docker login`) gaat je docker daemon ook bij deze registry kijken of de image bestaat. Als dat niet zo is, zal docker deze pullen.

## Websites runnen in docker
Het vorige voorbeeld was een vrij simpel voorbeeld, waarbij de container ook gestopt is na de execution. Veel applicaties zijn echter "forever running", zijn dus constant actief aan het luisteren naar input. Dit kan in de vorm van messages op een queue zijn, maar heel vaak is het ook een HTTP-request. In het volgende voorbeeld gaan we een simpele nginx container starten.

Snippet:

```
docker pull nginx/nginx
docker run -it -d -p 80:80 nginx
docker ps
```

Output:
```
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS
      NAMES
9018f6cec0cc        nginx               "nginx -g 'daemon of…"   3 seconds ago       Up 2 seconds        0.0.0.0:80->80/tcp   goofy_lovelace
```
Formatted output:

CONTAINER ID | IMAGE | COMMAND | CREATED | STATUS | PORTS | NAMES
---------|----------|---------|---------|----------|---------|---------
 9018f6cec0cc | nginx | "nginx -g 'daemon of…" | 3 seconds ago | up 2 seconds | 0.0.0.0:80->80/tcp | goofy_lovelace


Wat zien we hier?
- Container ID: de door docker gegeneerde Id van de container. Deze is uniek
- Image: de gebruikte image
- Command: Het uitgevoerde command dat in de Dockerfile staat
- Created: Wanneer de image gecreeërd (voor de eerste keer gestart) is
- Status: de huidige status van de container. Kan ook aangeven dat de container aan het restarten is. In dat geval is er meestal iets mis met de container.
- Ports: Als de container open poorten nodig heeft om te luisteren naar requests. De `-p 80:80` in de input geeft aan hoe de portmapping moet gebeuren. Formaat: `host:container`
- Names: Als je wilt kan je je container een beschrijvende naam geven. Als je dat niet doet, zal de docker daemon een eigen naam genereren, zoals in dit geval 'goofy_lovelace'

Neem nu een browser, en surf naar `http://localhost:80` (de 80 moet zelfs niet, je browser gaat _by default_ naar poort 80 in het geval van HTTP). Je zal hier de standaard nginx webpagina zien.

## Data en docker
Een van de grootste voordelen van docker is het feit dat je container volledig geisoleerd van je host omgeving draait. Het gevolg is dan ook, dat wanneer je je container stopt, alle data weg is uit deze container. In sommige gevallen niet erg, maar voor websites met dynamische content is dit toch een issue. Typisch gebruik je in dat soort gevallen een database, maar soms is dat _overkill_. Ook maakt deze manier van werken het gebruik van configuratiefiles een stuk moeilijker.
Om dat toch allemaal makkelijker te maken, kan je volume mapping doen.

We nemen het nginx voorbeeld er even bij. Nginx heeft z'n content meestal in een bepaalde map staan. In het geval van deze image is dat: `/usr/share/nginx/html`. Wat we dus willen doen, is de inhoud van deze folder wijzigen naar iets waar we wel aan kunnen.
```
docker run -d -p 80:80 -v ${PWD}\nginx-folder-data\:/usr/share/nginx/html nginx
```

- ${PWD} is een Powershell shorthand voor de current working directory
- nginx-folder-data is de folder waar dat de index.html zit die we willen sharen met onze container

Als we dan opnieuw op `http://localhost` kijken, zien we dat onze html gebruikt wordt.