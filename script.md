# Script

## Wat is docker?
### Virtualisatie en isolatie
In eerste instantie een light-weight virtualizatieplatform, dat door middel van containers werkende applicatie beheert. De focus ligt hierbij wel op één applicatie per container. Dit heeft als voordeel dat de image alleen maar de dependencies van die ene applicatie erin zitten. 

### Crossplatform
Docker is beschikbaar voor Linux, Mac en Windows.
Omdat Docker een virtualizatieplatform is, moet het ergens in gehost worden. In Linux kan dit rechstreeks, maar bij Mac en Windows moet dit vaak nog via een virtualizatielaag, een zogenaamde hypervisor.
Je kan echter wel Linux en Windows images gebruiken, maar deze containers moeten uiteraard wel in de juiste Docker omgeving runnen. In de meeste gevallen zal je werken met Linux containers, omdat deze vaak een veel kleinere _footprint_ hebben dan Windows containers.


## Hands-on terminal magic
Om docker te gebruiken zal je toch af en toe de terminal in moeten duiken, maar vaak blijft het gebruik redelijk beperkt.
Om te kijken of je docker installatie succesvol is, is er  een image die kan runnen. Om deze te downloaden, zal je echter nog een account moeten maken op een registry. De bekendste is Docker Hub, maar je kan ook je eigen registry op zetten om je eigen images te hosten. Het voordeel van deze _private_ registries is dat je typisch alleen jezelf access kan geven aan deze images. Docker Hub is een publieke, en alles wat hier op geupload wordt kan worden gedownload worden. Overigens spreekt men bij docker niet over downloaden, maar over _pullen_.
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
Het vorige voorbeeld was een vrij simpel voorbeeld, waarbij de container ook gestopt is na de execution. Veel applicaties zijn echter "forever running", zijn dus constant actief aan het luisteren naar input. Vaak is deze input in de vorm van een HTTP-request, maar ook messages op een queue kunnen als input dienen. In het volgende voorbeeld gaan we een simpele nginx container starten.

Snippet:

```bash
docker pull nginx/nginx
docker run -it -d -p 80:80 nginx
docker ps
```

Output:
```bash
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
```bash
docker run -d -p 80:80 -v ${PWD}\examples\volumes\nginx-folder-data\:/usr/share/nginx/html nginx
```

- `${PWD}` is een Powershell shorthand voor de current working directory
- `nginx-folder-data` is de folder waar dat de index.html zit die we willen sharen met onze container

Als we dan opnieuw op `http://localhost` kijken, zien we dat onze html gebruikt wordt.

## Dependency management
In de meeste gevallen is er al een docker image voor jouw situatie. Het is dan ook maar een kwestie van goed te zoeken en de benodigde Google skills boven te halen.
Echter, in sommige gevallen ga je toch je eigen docker image moeten maken.
In ons geval gaan wij het volgende doen:
Het script dat ik nu aan het volgen ben is geschreven in markdown, een manier om tekst te stylen in een leesbare plain text manier. Markdown files worden geconverteerd naar HTML, zodat het vlot kan gerenderd worden in een browser. Er bestaan talloze markdown renderers, in allerlei verschillende talen. Maar dat zijn dus ook allemaal dependencies. En wat kunnen we met dependencies doen? Inderdaad: Dockerizen.
### Basic Dockerfile
Hoe genereer je nu een docker image? Aan de hand van een Dockerfile. Dockerfiles zijn in feite niets meer dan een textuele beschrijving van hoe je docker image eruit gaat zien.
#### Syntax
- `FROM`: geeft aan van welke base image je code start
- `COPY`: zorgt voor het kopieren van content van je host naar je container
- `RUN`: voert commando's in de container uit. Veel gebruikt om dependencies te installeren

Ale je eenmaal een Dockerfile in elkaar hebt gepuzzeld, kan je hier een image van maken:
```bash
docker build -t pythonmarkdown .
```
#### Syntax
- `-t pythonmarkdown`: maakt een docker image met als tag 'pythonmarkdown' aan. Voorbeelden: `-t pythonmarkdown:latest`, `-t pythonmarkdown:1.1`, `-t pythonmarkdown:alpine-1.1`
- `.` geeft de locatie van de context aan die je naar de container wilt sturen. De `COPY` _source_ wijst naar de root in de context aan 

### Multi stage Dockerfiles

De simpele Dockerfile die we nu hebben genereert dus nu een HTML file. Echter zit deze nu in de `output` folder in de docker container. In principe zouden wie hier via een paar omwegen wel aankunnen (volume mapping, aan de docker container zelf attachen, ...), maar in dit geval willen we toch dat die HTML in een website komt te staan. Wat je dan kan doen is in je bestaande Dockerfile ook nog eens de nginx configuratie zetten, maar dan heb je dus nog een extra dependency in je container. Extra dependencies betekent ook een grotere container.
Je kan dus in dit geval beter een multi-stage Dockerfile creeeren: eerst je "build" fase, gevolgd door de effectieve "run" fase.
Concreet komt het er op neer dat je meerdere `FROM` statements gebruikt, met als gevolg dat je eerst een grotere "build" image kan gebruiken, gevolgd door een veel lichtere "run" image. In het voorbeeld zie je dat ik in m'n build fase een `node` image gebruik. Deze heb ik nodig om m'n HTML te genereren. De `nginx:alpine` image is echter een heel lichtgewicht image, en dat is ook de image die uiteindelijk zal runnen en gepullen worden. Veel interessanter dan die `node` image.