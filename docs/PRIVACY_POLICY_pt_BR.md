# Política de privacidade — Platrare

**Data de entrada em vigor:** 12 de abril de 2026

Platrare é um aplicativo de finanças pessoais com arquitetura local-first. Esta política descreve os dados acessados pelo app, como são utilizados e seus direitos.

---

## 1. Quem somos

Platrare é publicada por um desenvolvedor individual. As informações de contato estão disponíveis na App Store ou Google Play e em **Configurações → Sobre → Copiar detalhes de suporte** no app.

---

## 2. Dados armazenados no seu dispositivo

Todos os dados criados no Platrare permanecem **exclusivamente no seu dispositivo**. Não operamos nenhum servidor que receba ou armazene suas informações financeiras.

**O que é armazenado localmente:**

| Categoria | Detalhes |
|---|---|
| Livro financeiro | Contas, saldos, limites de cheque especial, histórico de transações, transações planejadas e categorias |
| Anexos | Fotos de recibos e documentos que você escolhe adicionar às transações |
| Preferências | Moeda base, moeda secundária, tema, idioma, configuração de visibilidade de saldo |
| Segurança | Status do bloqueio do app; hash criptográfico unidirecional do seu PIN (o PIN bruto nunca é armazenado) |
| Cache de câmbio | Dados públicos de taxas de câmbio baixados de uma API de terceiros e armazenados localmente |

---

## 3. Dados enviados pela Internet

### 3.1 Taxas de câmbio

O app busca periodicamente dados de taxas de câmbio da **API Frankfurter** (api.frankfurter.dev / api.frankfurter.app), que publica dados do **Banco Central Europeu (BCE)**. Essas requisições não contêm **nenhuma informação pessoal** — apenas uma chamada HTTP anônima padrão. Suas contas, saldos e transações nunca são transmitidos. Os dados são armazenados em cache por até **6 horas**.

### 3.2 Sem análises nem publicidade

Platrare **não contém nenhum SDK de análise, serviço de relatório de falhas ou rede publicitária**. Nenhum dado de uso, identificador de dispositivo ou telemetria comportamental é coletado.

---

## 4. Permissões do dispositivo

| Permissão | Finalidade | Quando solicitada |
|---|---|---|
| Câmera | Capturar fotos de recibos | Somente ao tocar em "Tirar foto" |
| Biblioteca de fotos | Selecionar imagens para anexar | Somente ao tocar em "Escolher da galeria" |
| Arquivos | Anexar PDFs e documentos | Somente ao tocar em "Procurar arquivos" |
| Biometria / Face ID | Desbloquear o app | Somente quando a tela de bloqueio é exibida |
| Rede | Buscar taxas de câmbio | Automaticamente; nenhum dado pessoal é enviado |

O app não solicita acesso a localização, contatos, microfone, calendário ou qualquer outra permissão não listada acima.

---

## 5. Bloqueio do app e biometria

Ao ativar **Bloquear app ao abrir**:

- O app usa o framework biométrico seguro do SO (iOS LocalAuthentication / Android BiometricPrompt). Seus dados biométricos são processados inteiramente no enclave seguro do SO — o app nunca os acessa, armazena ou transmite.
- Se você criar um PIN, apenas um **hash criptográfico unidirecional** desse PIN é armazenado no dispositivo. O PIN bruto nunca é gravado no armazenamento.

---

## 6. Backups

**Exportar** cria um arquivo `.zip` (sem criptografia) ou `.platrare` (criptografado com AES-256 e senha). Você escolhe onde armazená-lo. **Nunca recebemos seu backup.**

**O backup automático diário** salva um arquivo apenas no armazenamento privado do dispositivo. Não faz upload automático para nenhum serviço em nuvem. Você pode compartilhá-lo manualmente em **Configurações → Backup automático → Salvar na nuvem**.

**Importar** substitui todos os dados do dispositivo pelo conteúdo do backup. Importe apenas de fontes confiáveis.

---

## 7. Crianças

Platrare não é destinada a crianças menores de 13 anos. Não coletamos informações de crianças intencionalmente.

---

## 8. Retenção e exclusão de dados

Os dados permanecem no seu dispositivo até você excluí-los no app, usar **Configurações → Limpar dados**, importar um backup substituto ou desinstalar o app. Como não temos nenhuma cópia dos seus dados em nossos servidores, não há nada a excluir do nosso lado.

---

## 9. Seus direitos

- **Acesso e portabilidade** — Todos os dados são visíveis no app. Use **Exportar backup** para uma cópia portátil.
- **Correção** — Edite qualquer registro a qualquer momento.
- **Exclusão** — Use as funções de exclusão no app, **Limpar dados** ou desinstale.

**Usuários do EEE/Reino Unido:** O RGPD e o UK GDPR podem conceder direitos adicionais, incluindo o direito de reclamar junto à sua autoridade supervisora local.

**Residentes na Califórnia:** A CCPA/CPRA pode se aplicar. Como não vendemos nem compartilhamos dados pessoais, os direitos de exclusão geralmente não se aplicam.

---

## 10. Segurança

- Dados em banco de dados **isolado no app**, inacessível a outros apps.
- Backups protegidos com **criptografia AES-256** opcional.
- PINs armazenados apenas como **hash criptográfico unidirecional**.
- Tráfego de rede exclusivamente via **HTTPS**.

---

## 11. Alterações

Podemos atualizar esta política quando os recursos evoluírem. A **data de entrada em vigor** refletirá a última revisão. O uso continuado constitui aceitação das alterações.

---

## 12. Contato

Use o contato na App Store ou Google Play, ou **Configurações → Sobre → Copiar detalhes de suporte** no app.
