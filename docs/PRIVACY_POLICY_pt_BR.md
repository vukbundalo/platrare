# Política de privacidade — Platrare

**Data de entrada em vigor:** 4 de setembro de 2026

Platrare é um aplicativo de finanças pessoais com arquitetura local-first. Esta política descreve os dados acessados pelo app, como são utilizados e seus direitos.

---

## 1. Quem somos

Platrare é publicada por um desenvolvedor individual, que é o controlador dos dados para os fins do RGPD. Você pode entrar em contato com o desenvolvedor pelo e-mail **[support email]**, pela página do app na App Store ou Google Play, ou em **Configurações → Sobre → Falar com o suporte** no app.

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
| Lembretes | Se você ativar lembretes para transações planejadas, a data de vencimento, a descrição e o valor de cada transação planejada futura são entregues ao agendador de notificações locais do sistema operacional para que ele possa exibir o lembrete mesmo com o app fechado. Eles nunca saem do dispositivo. |
| Snapshot do widget da tela inicial (iOS) | Um pequeno resumo pré-calculado (saldos projetados para os próximos dias e os rótulos exibidos pelo widget) armazenado no contêiner compartilhado privado do app para que o widget possa ser renderizado sem abrir o app. Quando o bloqueio do app está ativado, os valores nesse snapshot são mascarados, a menos que você escolha o contrário em Configurações. |

---

## 3. Dados enviados pela Internet

### 3.1 Taxas de câmbio

O app busca periodicamente dados de taxas de câmbio da **API Frankfurter** (api.frankfurter.dev / api.frankfurter.app), que publica dados do **Banco Central Europeu (BCE)**. Essas requisições não contêm **nenhuma informação pessoal** — apenas uma chamada HTTP anônima padrão. Suas contas, saldos e transações nunca são transmitidos. Os dados são armazenados em cache por até **6 horas**.

### 3.2 Sem análises nem publicidade

Platrare **não contém nenhum SDK de análise, serviço de relatório de falhas ou rede publicitária**. Nenhum dado de uso, identificador de dispositivo ou telemetria comportamental é coletado. Lembretes, widgets da tela inicial e atalhos funcionam totalmente offline.

---

## 4. Permissões do dispositivo

| Permissão | Finalidade | Quando solicitada |
|---|---|---|
| Câmera | Capturar fotos de recibos | Somente ao tocar em "Tirar foto" |
| Biblioteca de fotos | Selecionar imagens para anexar | Somente ao tocar em "Escolher da galeria" |
| Arquivos | Anexar PDFs e documentos | Somente ao tocar em "Procurar arquivos" |
| Biometria / Face ID | Desbloquear o app | Somente quando a tela de bloqueio é exibida |
| Notificações | Lembrar você pouco antes do vencimento de uma transação planejada | Somente quando você ativa lembretes em Configurações |
| Executar na inicialização (Android) | Reagendar seus lembretes após a reinicialização do dispositivo | Automaticamente, somente se os lembretes estiverem ativados |
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

Somente as exportações `.platrare` criptografadas com senha incluem o hash do PIN de bloqueio do app; exportações não criptografadas e backups automáticos diários nunca o incluem. Ao restaurar um backup sem PIN, o PIN já definido no dispositivo é mantido.

**Backups do dispositivo pelo sistema operacional.** O recurso de backup do próprio celular (Backup do iCloud no iOS, Google Auto Backup no Android) pode copiar o livro financeiro do app, os backups automáticos diários e as preferências para sua conta Apple ou Google como parte do backup do dispositivo, sob os termos da Apple ou do Google. No Android, os anexos de recibos são excluídos disso para respeitar o limite de backup do sistema. Você controla os backups do dispositivo nas configurações do sistema operacional; o desenvolvedor nunca os recebe.

---

## 7. Widgets, atalhos e Siri (iOS)

- **Widgets da tela inicial** exibem saldos projetados a partir do snapshot descrito na seção 2. O snapshot fica no contêiner compartilhado privado do app no seu dispositivo e nunca é enviado para a internet. Quando o bloqueio do app está ativado, os valores são mascarados por padrão.
- **Ações rápidas e App Shortcuts** (toque longo no ícone do app, o app Atalhos ou a Siri) apenas abrem o app em uma tela escolhida, por exemplo "Adicionar transação". O reconhecimento de voz da Siri é realizado pelo iOS sob os termos de privacidade da Apple; o app recebe apenas o comando resolvido e nunca envia seu livro financeiro à Apple.

---

## 8. Crianças

Platrare não é destinada a crianças menores de 13 anos. Não coletamos informações de crianças intencionalmente.

---

## 9. Retenção e exclusão de dados

Os dados permanecem no seu dispositivo até você excluí-los no app, usar **Configurações → Limpar dados**, importar um backup substituto ou desinstalar o app. Como não temos nenhuma cópia dos seus dados em nossos servidores, não há nada a excluir do nosso lado.

---

## 10. Seus direitos

- **Acesso e portabilidade** — Todos os dados são visíveis no app. Use **Exportar backup** para uma cópia portátil.
- **Correção** — Edite qualquer registro a qualquer momento.
- **Exclusão** — Use as funções de exclusão no app, **Limpar dados** ou desinstale.

**Usuários do EEE/Reino Unido:** O RGPD e o UK GDPR podem conceder direitos adicionais, incluindo o direito de reclamar junto à sua autoridade supervisora local.

**Residentes na Califórnia:** A CCPA/CPRA pode se aplicar. Como não vendemos nem compartilhamos dados pessoais, os direitos de exclusão geralmente não se aplicam.

---

## 11. Segurança

- Dados em banco de dados **isolado no app**, inacessível a outros apps.
- Backups protegidos com **criptografia AES-256** opcional.
- PINs armazenados apenas como **hash criptográfico unidirecional**.
- Tráfego de rede exclusivamente via **HTTPS**.

---

## 12. Alterações

Podemos atualizar esta política quando os recursos evoluírem. A **data de entrada em vigor** refletirá a última revisão. O uso continuado constitui aceitação das alterações.

---

## 13. Contato

Para questões ou solicitações relacionadas à privacidade, envie um e-mail para **[support email]**, use o contato na App Store ou Google Play, ou toque em **Configurações → Sobre → Falar com o suporte** no app.
