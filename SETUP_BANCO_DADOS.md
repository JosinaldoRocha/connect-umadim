# Setup do Banco de Dados - Conecta UMADIM

Este guia explica como configurar o **Supabase** (storage) e o **Firebase** (Firestore) para o app.

---

## Parte 1: Supabase Storage

### Passo 1: Criar novo projeto no Supabase

1. Acesse [supabase.com/dashboard](https://supabase.com/dashboard)
2. **New Project** → preencha nome, senha do banco e região
3. Aguarde a criação

### Passo 2: Executar o SQL de setup

1. No Supabase Dashboard: **SQL Editor** → **New query**
2. Copie todo o conteúdo do arquivo `supabase_setup.sql`
3. Cole no editor e clique em **Run**
4. Verifique se não há erros

### Passo 3: Atualizar credenciais no app

1. No Supabase: **Settings** → **API**
2. Copie **Project URL** e **anon public key**
3. Em `lib/app/core/supabase/supabase_init.dart`, substitua:
   - `COLE_SUA_URL_AQUI` → Project URL
   - `COLE_SUA_ANON_KEY_AQUI` → anon public key

### Se o SQL falhar: criar buckets manualmente

1. **Storage** → **New bucket**
2. Crie `user_profile_images` (marque **Public bucket**)
3. Crie `event_images` (marque **Public bucket**)
4. Em cada bucket: **Policies** → **New policy** → use template "Allow uploads" para `anon`

---

## Parte 2: Firebase Firestore

O app usa **Firebase** para dados (usuários, eventos, versículos, líderes). As coleções são criadas automaticamente quando o app insere o primeiro documento.

### Coleções necessárias

| Coleção | Uso |
|---------|-----|
| `users` | Usuários do app (cadastro completo) |
| `events` | Eventos da UMADIM |
| `verses` | Versículos bíblicos (exibidos na home) |
| `leaders` | Líderes autorizados a cadastrar (exceto membros) |

### Estrutura dos documentos

#### `users` (criada pelo app no cadastro)

```json
{
  "id": "uid-do-firebase-auth",
  "name": "Nome Completo",
  "email": "email@exemplo.com",
  "password": "",
  "umadimFunction": { "title": "Membro", "department": "Umadim" },
  "localFunction": { "title": "Membro", "department": "Umadim" },
  "birthDate": "timestamp ou null",
  "gender": "Masculino",
  "congregation": "Nome da congregação",
  "photoUrl": "url ou null",
  "phoneNumber": "null ou número",
  "createdAt": "timestamp"
}
```

#### `events` (criada pelo app)

```json
{
  "id": "uuid",
  "userId": "uid-do-criador",
  "title": "Título do evento",
  "type": "Congresso",
  "status": "Agendado",
  "imageUrl": "url ou null",
  "eventLocation": "Local",
  "eventDate": "timestamp ou null",
  "eventTime": "timestamp",
  "promotedBy": "Umadim",
  "description": "null ou texto",
  "theme": "null ou texto",
  "singer": "null ou texto",
  "minister": "null ou texto",
  "confirmedPresences": [],
  "createdAt": "timestamp"
}
```

**Tipos de evento:** Congresso, Retiro, Culto, Estudo bíblico, Cinema, Gincana, Social, Intercâmbio  
**Status:** Agendado, Em andamento, Finalizado, Cancelado, Adiado, Não agendado  
**Departamentos:** Juv. Templo central, Juv. Monte Sinai, etc.

#### `verses` (você precisa criar manualmente)

```json
{
  "text": "Texto do versículo",
  "reference": "João 3:16"
}
```

Adicione quantos versículos quiser para exibir na home.

#### `leaders` (obrigatório para líderes se cadastrarem)

Usuários com função diferente de "Membro" precisam existir em `leaders` antes de se cadastrar:

```json
{
  "id": "document-id",
  "name": "Nome do Líder",
  "email": "email@exemplo.com",
  "isRegistered": false
}
```

Após o cadastro, o app muda `isRegistered` para `true`.

### Regras do Firestore (segurança)

No Firebase Console: **Firestore** → **Rules** → use algo como:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
    match /events/{eventId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update, delete: if request.auth != null;
    }
    match /verses/{verseId} {
      allow read: if request.auth != null;
      allow write: if false;
    }
    match /leaders/{leaderId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
  }
}
```

### Dados iniciais

1. **verses**: Coleção `verses` com alguns versículos de exemplo
2. **leaders**: Se houver líderes, adicione documentos em `leaders` com `isRegistered: false`
3. **users e events**: São criados pelo app

---

## Resumo

1. **Supabase**: novo projeto → executa `supabase_setup.sql` → atualiza URL e key no app
2. **Firebase**: já configurado no app; coleções `users`, `events` e `leaders` são criadas pelo app
3. **Adicionar manualmente**: versículos em `verses` e líderes em `leaders` (se necessário)
