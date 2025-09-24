/**
 * Script de teste para a integração ThingSpeak-Firebase
 */

const axios = require("axios");

// Configurações de teste
const FIREBASE_FUNCTION_URL = "http://127.0.0.1:5001/demo-healthcare-project/us-central1/receiveThingSpeakData";
const GET_DATA_URL = "http://127.0.0.1:5001/demo-healthcare-project/us-central1/getPatientData";

// Dados de teste simulando o ThingSpeak
const testData = [
  {
    field1: "75",    // BPM normal
    field2: "98",    // O2 normal
    field3: "0",     // Sem queda
    api_key: "test_patient_001",
    created_at: new Date().toISOString(),
    entry_id: "1001"
  },
  {
    field1: "45",    // BPM crítico (baixo)
    field2: "92",    // O2 crítico (baixo)
    field3: "0",     // Sem queda
    api_key: "test_patient_002",
    created_at: new Date().toISOString(),
    entry_id: "1002"
  },
  {
    field1: "80",    // BPM normal
    field2: "97",    // O2 normal
    field3: "1",     // Queda detectada
    api_key: "test_patient_003",
    created_at: new Date().toISOString(),
    entry_id: "1003"
  }
];

async function testSendData() {
  console.log("🧪 Iniciando testes da integração ThingSpeak-Firebase...\n");

  for (let i = 0; i < testData.length; i++) {
    const data = testData[i];
    console.log(`📤 Teste ${i + 1}: Enviando dados para ${data.api_key}`);
    console.log(`   BPM: ${data.field1}, O2: ${data.field2}, Queda: ${data.field3}`);

    try {
      const response = await axios.post(FIREBASE_FUNCTION_URL, data, {
        headers: {
         "Content-Type": "application/json"
        }
      });

      console.log(`✅ Sucesso: ${response.data.message}`);
      console.log(`   Doc ID: ${response.data.docId}\n`);

    } catch (error) {
      console.log(
  `❌ Erro: ${(error.response && error.response.data && error.response.data.error) || error.message}\n`
);
    }

    // Aguardar um pouco entre os testes
    await new Promise(resolve => setTimeout(resolve, 1000));
  }
}

async function testGetData() {
  console.log("📊 Testando recuperação de dados...\n");

  const patientIds = ["test_patient_001", "test_patient_002", "test_patient_003"];

  for (const patientId of patientIds) {
    console.log(`📥 Buscando dados para ${patientId}`);

    try {
      const response = await axios.get(`${GET_DATA_URL}?patientId=${patientId}&limit=10`);
      const data = response.data;

      console.log(`✅ Encontrados ${data.totalRecords} registros`);
      console.log(`   Alertas não resolvidos: ${data.alerts.length}`);
      
      if (data.sensorData.length > 0) {
        const latest = data.sensorData[0];
        // eslint-disable-next-line max-len
        console.log(`   Último registro: BPM=${latest.sensors.bpm}, O2=${latest.sensors.o2}, Queda=${latest.sensors.fallAlert}`);
      }

      if (data.alerts && data.alerts.length > 0) {
        const alertas = data.alerts
          .flatMap(a => (a.alerts ? a.alerts.map(alert => alert.type) : [a.type]))
          .join(", ");
        console.log(`   Alertas: ${alertas}`);
      }

      console.log("");

    } catch (error) {
  const errMsg =
    (error && error.response && error.response.data && error.response.data.error) ||
    (error && error.message) ||
    String(error);
  console.log(`❌ Erro: ${errMsg}\n`);
}
  }
}

async function runTests() {
  try {
    await testSendData();
    await testGetData();
    console.log("🎉 Testes concluídos!");
  } catch (error) {
    console.error("💥 Erro geral nos testes:", error.message);
  }
}

// Executar testes se o script for chamado diretamente
if (require.main === module) {
  runTests();
}

module.exports = { testSendData, testGetData, runTests };
