const axios = require('axios');

async function testSimple() {
  console.log('🧪 Teste simples da função helloWorld...');
  
  try {
    const response = await axios.get('http://127.0.0.1:5001/demo-healthcare-project/us-central1/helloWorld');
    console.log('✅ Sucesso:', response.data);
  } catch (error) {
    console.log('❌ Erro:', error.message);
  }

  console.log('\n🧪 Teste simples de envio de dados...');
  
  try {
    const testData = {
      field1: '75',
      field2: '98', 
      field3: '0',
      api_key: 'test_patient_simple'
    };

    const response = await axios.post(
      'http://127.0.0.1:5001/demo-healthcare-project/us-central1/receiveThingSpeakData',
      new URLSearchParams(testData).toString(),
      {
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded'
        }
      }
    );

    console.log('✅ Sucesso:', response.data);
  } catch (error) {
    console.log('❌ Erro:', error.response?.data || error.message);
  }
}

testSimple();

