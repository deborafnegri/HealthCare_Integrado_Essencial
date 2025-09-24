// Importa os módulos necessários do Firebase.
const functions = require("firebase-functions");
const admin = require("firebase-admin");

// Inicializa o Firebase Admin.
admin.initializeApp();
const db = admin.firestore();

// Define a região para evitar problemas de localização.
const regionalFunctions = functions.region("southamerica-east1");

// Cria e exporta a nossa função HTTP.
exports.updatePatientData = regionalFunctions.https.onRequest(async (req, res ) => {
  // 1. Validação do método.
  if (req.method !== "POST") {
    console.log("Requisição ignorada por não ser POST.");
    return res.status(405).send("Método não permitido. Use POST.");
  }

  const data = req.body;
  console.log("Dados recebidos:", JSON.stringify(data));

  // ===================================================================
  //  AQUI ESTÁ A CORREÇÃO PRINCIPAL!
  //  Garantimos que o channelId seja convertido para uma String.
  // ===================================================================
  const channelId = data.channel_id ? data.channel_id.toString() : null;
  
  const bpm = data.field1;
  const temperatura = data.field2;

  if (!channelId) {
    console.error("Erro: 'channel_id' não foi encontrado na requisição.");
    return res.status(400).send("Erro: 'channel_id' é obrigatório.");
  }

  try {
    // 5. Busca o paciente na coleção 'pacientes' usando a String.
    const pacientesRef = db.collection("pacientes");
    const querySnapshot = await pacientesRef.where("channelId", "==", channelId).limit(1).get();

    if (querySnapshot.empty) {
      // Se a busca falhar, este log vai aparecer.
      console.log(`Nenhum paciente encontrado com o channelId (String): "${channelId}"`);
      return res.status(404).send("Paciente não encontrado. Verifique se o Channel ID está correto e salvo como texto no Firestore.");
    }

    // 7. Se encontrou, atualiza os dados.
    const pacienteDoc = querySnapshot.docs[0];
    console.log(`Paciente encontrado: ${pacienteDoc.id}. Atualizando dados...`);

    const dadosParaAtualizar = {};
    // Convertendo para String para manter a consistência com seu app Flutter.
    if (bpm !== undefined) dadosParaAtualizar.bpm = bpm.toString();
    if (temperatura !== undefined) dadosParaAtualizar.temperatura = temperatura.toString();

    await pacienteDoc.ref.update(dadosParaAtualizar);

    console.log("Dados do paciente atualizados com sucesso!");
    return res.status(200).send("Dados atualizados com sucesso.");

  } catch (error) {
    console.error("Erro crítico ao processar a requisição:", error);
    return res.status(500).send("Erro interno do servidor.");
  }
});
