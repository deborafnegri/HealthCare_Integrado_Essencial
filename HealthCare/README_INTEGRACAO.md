# Integração ThingSpeak com Firebase - Projeto HealthCare

## Visão Geral

Esta integração permite que os dados coletados pelas pulseiras de monitoramento (BPM, saturação de O2 e alertas de queda) sejam automaticamente sincronizados do ThingSpeak para o aplicativo Firebase, proporcionando monitoramento em tempo real dos pacientes.

## Arquitetura da Solução

### Fluxo de Dados

1. **Pulseira** → Envia dados para o **ThingSpeak**
2. **ThingSpeak** → Aciona **React** quando novos dados chegam
3. **React** → Dispara **ThingHTTP** para enviar dados ao **Firebase**
4. **Firebase Functions** → Processa e armazena dados no **Firestore**
5. **Aplicativo Flutter** → Consome dados do **Firestore**

### Componentes Implementados

#### Firebase Functions

**Localização:** `meu-app-da-pulseira/funcao/index.js`

**Funções Disponíveis:**

1. **receiveThingSpeakData** - Recebe dados do ThingSpeak
   - Endpoint: `/receiveThingSpeakData`
   - Método: POST
   - Processa dados de BPM, O2 e alerta de queda
   - Detecta automaticamente condições críticas
   - Armazena dados no Firestore

2. **getPatientData** - Recupera dados de um paciente
   - Endpoint: `/getPatientData`
   - Método: GET
   - Parâmetros: `patientId`, `limit` (opcional)
   - Retorna dados dos sensores e alertas não resolvidos

3. **helloWorld** - Função de teste
   - Endpoint: `/helloWorld`
   - Método: GET
   - Verifica se o serviço está funcionando

## Estrutura dos Dados

### Dados Recebidos do ThingSpeak

```
field1: BPM (batimentos por minuto)
field2: O2 (saturação de oxigênio em %)
field3: Alerta de queda (0 = sem queda, 1 = queda detectada)
api_key: Identificador do paciente
created_at: Timestamp do ThingSpeak
entry_id: ID da entrada no ThingSpeak
```

### Estrutura no Firestore

```
patients/
  └── [patientId]/
      ├── sensorData/
      │   └── [documentId]
      │       ├── timestamp: string (ISO)
      │       ├── entryId: string
      │       ├── apiKey: string
      │       ├── sensors:
      │       │   ├── bpm: number
      │       │   ├── o2: number
      │       │   └── fallAlert: boolean
      │       ├── receivedAt: string (ISO)
      │       └── source: "thingspeak"
      └── alerts/
          └── [documentId]
              ├── alerts: Array<{type, value, message}>
              ├── timestamp: string (ISO)
              ├── resolved: boolean
              └── sensorDataRef: Object
```

## Alertas Automáticos

O sistema detecta automaticamente as seguintes condições críticas:

- **BPM Crítico**: < 60 ou > 100 bpm
- **O2 Baixo**: < 95%
- **Queda Detectada**: field3 = 1

Quando detectados, os alertas são armazenados na coleção `alerts` do paciente.

## Configuração do ThingSpeak

### 1. Configurar ThingHTTP

1. Acesse ThingSpeak → Apps → ThingHTTP → New ThingHTTP
2. Configure:
   - **Name**: Firebase Integration
   - **URL**: `https://us-central1-[SEU-PROJECT-ID].cloudfunctions.net/receiveThingSpeakData`
   - **Method**: POST
   - **Content Type**: `application/x-www-form-urlencoded`
   - **Body**: 
     ```
     field1=%%channel_[CHANNEL_ID]_field_1%%&field2=%%channel_[CHANNEL_ID]_field_2%%&field3=%%channel_[CHANNEL_ID]_field_3%%&api_key=%%channel_write_api_key%%&created_at=%%datetime%%&entry_id=%%entry_id%%
     ```

### 2. Configurar React

1. Acesse ThingSpeak → Apps → React → New React
2. Configure:
   - **Condition Type**: On Data Insertion
   - **Test Frequency**: On Data Insertion
   - **Action**: ThingHTTP
   - **ThingHTTP**: Firebase Integration
   - **Options**: Run action each time condition is met

## Deploy e Configuração

### 1. Deploy das Firebase Functions

```bash
cd meu-app-da-pulseira
firebase deploy --only functions
```

### 2. Configurar Variáveis de Ambiente (se necessário)

```bash
firebase functions:config:set thingspeak.api_key="SUA_API_KEY"
```

### 3. Testar a Integração

Execute os testes locais:

```bash
cd funcao
node test_firebase_integration.js
```

## Testes Realizados

Os testes verificaram:

✅ Recepção de dados normais (BPM: 75, O2: 98, Queda: 0)
✅ Detecção de BPM crítico (BPM: 45)
✅ Detecção de O2 baixo (O2: 92)
✅ Detecção de queda (Queda: 1)
✅ Armazenamento correto no Firestore
✅ Geração automática de alertas
✅ Recuperação de dados por paciente

## Monitoramento e Logs

### Logs do Firebase Functions

```bash
firebase functions:log
```

### Logs em Tempo Real

```bash
firebase functions:log --only receiveThingSpeakData
```

## Segurança

- As funções utilizam CORS para permitir requisições do ThingSpeak
- Validação de dados de entrada
- Logs detalhados para auditoria
- Estrutura de dados isolada por paciente

## Próximos Passos

1. **Integração com o App Flutter**: Modificar o aplicativo para consumir dados do Firestore
2. **Interface de Alertas**: Implementar notificações push para alertas críticos
3. **Dashboard**: Criar interface para visualização dos dados em tempo real
4. **Configuração de Pacientes**: Implementar sistema para associar API keys com pacientes específicos
5. **Backup e Recuperação**: Configurar backup automático dos dados

## Suporte e Manutenção

### Problemas Comuns

1. **Dados não chegam ao Firebase**
   - Verificar configuração do ThingHTTP
   - Confirmar URL do Firebase Functions
   - Verificar logs do Firebase

2. **Alertas não são gerados**
   - Verificar limites críticos no código
   - Confirmar se os dados estão sendo processados
   - Verificar coleção de alertas no Firestore

3. **Erro 500 nas funções**
   - Verificar logs do Firebase Functions
   - Confirmar configuração do Firestore
   - Verificar permissões do projeto

### Contato

Para suporte técnico, consulte os logs do Firebase Functions e a documentação do ThingSpeak.

## Arquivos Importantes

- `funcao/index.js` - Código das Firebase Functions
- `firebase.json` - Configuração do projeto Firebase
- `thingspeak_config_guide.md` - Guia detalhado de configuração do ThingSpeak
- `test_firebase_integration.js` - Testes automatizados
- `test_simple.js` - Teste básico de funcionamento

