const functions = require('firebase-functions');
const admin = require('firebase-admin');

// Inicializa o Firebase Admin SDK
admin.initializeApp();

// Função auxiliar: verifica se quem chamou é admin
function assertAdmin(context) {
  if (!context.auth || context.auth.token.role !== 'admin') {
    throw new functions.https.HttpsError(
      'permission-denied',
      'Apenas administradores podem listar usuários.'
    );
  }
}

// ========================================
// FUNÇÃO: Listar usuários do Authentication
// ========================================
exports.listUsers = functions.https.onCall(async (data, context) => {
  // Verifica se quem chamou é admin
  assertAdmin(context);

  const pageSize = Math.min(Number(data?.pageSize || 50), 1000);
  const pageToken = data?.pageToken || undefined;

  try {
    // Lista usuários usando o Admin SDK
    const result = await admin.auth().listUsers(pageSize, pageToken);
    
    // Mapeia apenas os campos necessários
    const users = result.users.map(u => ({
      uid: u.uid,
      email: u.email,
      displayName: u.displayName || null,
      disabled: u.disabled || false,
      metadata: {
        creationTime: u.metadata?.creationTime || null,
        lastSignInTime: u.metadata?.lastSignInTime || null,
      },
      customClaims: u.customClaims || {},
      providerIds: (u.providerData || []).map(p => p.providerId),
    }));

    return {
      users,
      nextPageToken: result.pageToken || null,
    };
  } catch (e) {
    console.error('Erro ao listar usuários:', e);
    throw new functions.https.HttpsError('internal', e.message);
  }
});

// ========================================
// FUNÇÃO: Criar novo usuário
// ========================================
exports.createUser = functions.https.onCall(async (data, context) => {
  assertAdmin(context);

  const { email, password, displayName, role } = data;

  if (!email || !password) {
    throw new functions.https.HttpsError(
      'invalid-argument',
      'Email e senha são obrigatórios.'
    );
  }

  const validRoles = ['admin', 'user_premium', 'user_free'];
  const userRole = validRoles.includes(role) ? role : 'user_free';

  try {
    // Cria usuário no Authentication
    const userRecord = await admin.auth().createUser({
      email,
      password,
      displayName: displayName || null,
    });

    // Define a role (custom claim)
    await admin.auth().setCustomUserClaims(userRecord.uid, { role: userRole });

    // Cria documento no Firestore (opcional, mas recomendado)
    await admin.firestore().collection('users').doc(userRecord.uid).set({
      email,
      displayName: displayName || null,
      role: userRole,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    return {
      success: true,
      uid: userRecord.uid,
      message: 'Usuário criado com sucesso!',
    };
  } catch (e) {
    console.error('Erro ao criar usuário:', e);
    throw new functions.https.HttpsError('internal', e.message);
  }
});

// ========================================
// FUNÇÃO: Atualizar role do usuário
// ========================================
exports.setUserRole = functions.https.onCall(async (data, context) => {
  assertAdmin(context);

  const { uid, role } = data;

  if (!uid || !role) {
    throw new functions.https.HttpsError(
      'invalid-argument',
      'UID e role são obrigatórios.'
    );
  }

  const validRoles = ['admin', 'user_premium', 'user_free'];
  if (!validRoles.includes(role)) {
    throw new functions.https.HttpsError(
      'invalid-argument',
      'Role inválida. Use: admin, user_premium ou user_free'
    );
  }

  try {
    // Atualiza a custom claim
    await admin.auth().setCustomUserClaims(uid, { role });

    // Atualiza no Firestore também (se existir)
    await admin.firestore().collection('users').doc(uid).set({
      role,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    }, { merge: true });

    return {
      success: true,
      message: `Role "${role}" definida para o usuário ${uid}`,
    };
  } catch (e) {
    console.error('Erro ao definir role:', e);
    throw new functions.https.HttpsError('internal', e.message);
  }
});

// ========================================
// FUNÇÃO: Desativar/ativar usuário
// ========================================
exports.setUserDisabled = functions.https.onCall(async (data, context) => {
  assertAdmin(context);

  const { uid, disabled } = data;

  if (!uid || typeof disabled !== 'boolean') {
    throw new functions.https.HttpsError(
      'invalid-argument',
      'UID e disabled (boolean) são obrigatórios.'
    );
  }

  try {
    await admin.auth().updateUser(uid, { disabled });
    return {
      success: true,
      message: `Usuário ${disabled ? 'desativado' : 'ativado'} com sucesso!`,
    };
  } catch (e) {
    console.error('Erro ao atualizar usuário:', e);
    throw new functions.https.HttpsError('internal', e.message);
  }
});

// ========================================
// FUNÇÃO: Deletar usuário
// ========================================
exports.deleteUser = functions.https.onCall(async (data, context) => {
  assertAdmin(context);

  const { uid } = data;

  if (!uid) {
    throw new functions.https.HttpsError('invalid-argument', 'UID é obrigatório.');
  }

  try {
    // Deleta do Authentication
    await admin.auth().deleteUser(uid);

    // Deleta do Firestore (se existir)
    await admin.firestore().collection('users').doc(uid).delete();

    return {
      success: true,
      message: 'Usuário deletado com sucesso!',
    };
  } catch (e) {
    console.error('Erro ao deletar usuário:', e);
    throw new functions.https.HttpsError('internal', e.message);
  }
});