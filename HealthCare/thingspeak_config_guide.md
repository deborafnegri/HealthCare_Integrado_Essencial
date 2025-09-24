# Guia de Configuração do ThingSpeak para Integração com Firebase

## Visão Geral

Este guia explica como configurar o ThingSpeak para enviar automaticamente os dados da pulseira (BPM, O2, alerta de queda) para o Firebase usando ThingHTTP e React.

## Estrutura dos Dados

A pulseira deve enviar os dados para o ThingSpeak nos seguintes campos:

- **Field 1**: BPM (batimentos por minuto)
- **Field 2**: O2 (saturação de oxigênio em %)
- **Field 3**: Alerta de queda (0 = sem queda, 1 = queda detectada)

## Configuração do ThingHTTP

### Passo 1: Criar um ThingHTTP

1. Acesse sua conta no ThingSpeak
2. Vá para **Apps** > **ThingHTTP**
3. Clique em **New ThingHTTP**
4. Configure os seguintes parâmetros:

#### Configurações Obrigatórias:

- **Name**: `Firebase Integration`
- **URL**: `https://us-central1-[SEU-PROJECT-ID].cloudfunctions.net/receiveThingSpeakData`
  - Substitua `[SEU-PROJECT-ID]` pelo ID do seu projeto Firebase
- **Method**: `POST`
- **Content Type**: `application/x-www-form-urlencoded`

#### Configurações do Body:

No campo **Body**, adicione:

```
field1=%%channel_[CHANNEL_ID]_field_1%%&field2=%%channel_[CHANNEL_ID]_field_2%%&field3=%%channel_[CHANNEL_ID]_field_3%%&api_key=%%channel_write_api_key%%&created_at=%%datetime%%&entry_id=%%entry_id%%
```

Substitua `[CHANNEL_ID]` pelo ID do seu canal ThingSpeak.

### Passo 2: Configurar o React

1. Vá para **Apps** > **React**
2. Clique em **New React**
3. Configure:

#### Configurações:

- **Condition Type**: `On Data Insertion`
- **Test Frequency**: `On Data Insertion`
- **Action**: `ThingHTTP`
- **ThingHTTP**: Selecione o ThingHTTP criado anteriormente (`Firebase Integration`)

#### Opções:

- Marque: **Run action each time condition is met**

## Exemplo de Configuração da Pulseira

A pulseira deve enviar dados para o ThingSpeak usando uma URL como:

```
https://api.thingspeak.com/update?api_key=[SUA_WRITE_API_KEY]&field1=[BPM]&field2=[O2]&field3=[FALL_ALERT]
```

Exemplo com dados:

```
https://api.thingspeak.com/update?api_key=ABCD1234EFGH5678&field1=75&field2=98&field3=0
```

## Estrutura dos Dados no Firebase

Os dados serão armazenados no Firestore na seguinte estrutura:

```
patients/
  └── [patientId]/
      ├── sensorData/
      │   └── [documentId]
      │       ├── timestamp: Date
      │       ├── entryId: string
      │       ├── apiKey: string
      │       ├── sensors:
      │       │   ├── bpm: number
      │       │   ├── o2: number
      │       │   └── fallAlert: boolean
      │       ├── receivedAt: Date
      │       └── source: "thingspeak"
      └── alerts/
          └── [documentId]
              ├── alerts: Array
              ├── timestamp: Date
              ├── resolved: boolean
              └── sensorDataRef: Object
```

## Alertas Automáticos

O sistema detecta automaticamente as seguintes condições críticas:

- **BPM Crítico**: < 60 ou > 100 bpm
- **O2 Baixo**: < 95%
- **Queda Detectada**: field3 = 1

## Testando a Integração

### 1. Teste Manual via POSTMAN

URL: `https://us-central1-[SEU-PROJECT-ID].cloudfunctions.net/receiveThingSpeakData`

Método: POST

Body (x-www-form-urlencoded):

```
field1=75
field2=98
field3=0
api_key=test_patient_001
```

### 2. Verificar Dados no Firebase

Use a função `getPatientData`:

URL: `https://us-central1-[SEU-PROJECT-ID].cloudfunctions.net/getPatientData?patientId=test_patient_001`

Método: GET

## Associação de Pacientes

Por padrão, o sistema usa a `api_key` como identificador do paciente. Para associar corretamente os dados:

1. Cada pulseira deve ter uma `api_key` única
2. A `api_key` deve corresponder ao ID do paciente no sistema
3. Ou implemente uma tabela de mapeamento no Firestore

## Solução de Problemas

### Dados não chegam ao Firebase:

1. Verifique se a URL do ThingHTTP está correta
2. Confirme se o React está configurado para "On Data Insertion"
3. Verifique os logs do Firebase Functions
4. Teste manualmente com POSTMAN

### Alertas não são gerados:

1. Verifique se os valores estão dentro dos limites críticos
2. Confirme se os dados estão sendo salvos corretamente
3. Verifique os logs da função `checkCriticalAlerts`

## Próximos Passos

1. Deploy das Firebase Functions
2. Configuração do ThingSpeak conforme este guia
3. Teste com dados reais da pulseira
4. Implementação da interface no aplicativo Flutter para visualizar os dados
