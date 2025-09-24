# Pesquisa sobre ThingSpeak e Firebase

## ThingSpeak

### ThingHTTP

O ThingHTTP permite a comunicação entre dispositivos, sites e serviços web. Ele pode ser acionado por outros aplicativos ThingSpeak, como TimeControl e React. Para criar uma requisição ThingHTTP, é necessário definir um nome, uma chave API (gerada automaticamente), a URL de destino, o método HTTP (GET, POST, PUT, DELETE) e a versão HTTP. É possível passar dados usando chaves de substituição (replacement keys) no corpo da requisição.

### React App

O React App do ThingSpeak permite acionar ações quando os dados do canal atendem a uma determinada condição. As condições podem ser baseadas em tipos numéricos (maior que, menor que, igual a), strings, status ou geolocalização. A frequência de teste pode ser 'Na Inserção de Dados' ou em intervalos de tempo fixos (10, 30, 60 minutos). A ação pode ser um 'MATLAB Analysis' ou 'ThingHTTP'.

### Estrutura de Dados

Os dados são enviados para o ThingSpeak em campos (`field1`, `field2`, etc.). Os dados de BPM, O2 e alerta de queda provavelmente serão mapeados para esses campos. A documentação de 'Write Data to Channel' mostra que é possível enviar dados via HTTP GET ou POST para `https://api.thingspeak.com/update.<format>`, onde `<format>` pode ser `json` ou `xml`. Os parâmetros incluem `api_key` e `field<X>` para os valores dos sensores.

## Firebase

O projeto existente já possui uma estrutura de funções Firebase (`HealthCare/meu-app-da-pulseira/funcao/index.js`). A função `onRequest` pode ser usada para criar um endpoint HTTP que receberá os dados do ThingSpeak. Será necessário configurar essa função para:

1.  Receber requisições POST do ThingSpeak.
2.  Extrair os dados de BPM, O2 e alerta de queda do corpo da requisição.
3.  Processar esses dados (ex: associar a um paciente).
4.  Armazenar os dados no Firebase Firestore ou Realtime Database.

## Próximos Passos

1.  Configurar um ThingHTTP no ThingSpeak para enviar os dados para uma Firebase Function.
2.  Desenvolver a Firebase Function para receber e processar esses dados.

