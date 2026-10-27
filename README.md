# Crédito para Empreendedores — Landing Page (Flutter Web)

Página única, responsiva (mobile-first), para captar contatos interessados em
crédito e levá-los ao atendimento pelo WhatsApp **+55 89 98112-0109**.

- Sem banco de dados: os dados do formulário só montam a mensagem do WhatsApp.
- Sem logomarcas de banco; paleta vermelha/branca apenas inspirada.
- Sem cookies de rastreamento, chaves de API ou segredos no código.

---

## 1. Estrutura de pastas

```
lib/
  main.dart                      ponto de entrada
  app.dart                       MaterialApp, rotas (/ e /privacidade), idioma pt-BR
  config/app_config.dart         número do WhatsApp, nome do site, dados do Aviso de Privacidade
  theme/                         cores (app_colors) e tema/tipografia (app_theme)
  core/
    breakpoints.dart             larguras de celular, tablet e desktop
    phone_input_formatter.dart   máscara (89) 99999-9999
    validators.dart              validação dos campos
  models/                        opções dos campos, dados do formulário, seções do menu
  services/
    link_service.dart            abertura de links (url_launcher) — substituível nos testes
    whatsapp_service.dart        monta a mensagem e o link wa.me (codificado para URL)
  pages/
    home_page.dart               tela principal: junta as seções, rolagem do menu, botão flutuante
    privacy_page.dart            Aviso de Privacidade (LGPD)
  widgets/
    header/                      cabeçalho + menu lateral no celular
    hero/                        banner principal com a foto da equipe
    benefits/                    cartões de benefícios
    audience/                    "Você trabalha por conta própria?"
    lead_form/                   formulário de interesse (seção mais importante)
    how_it_works/                "Como funciona?" (3 etapas)
    faq/                         perguntas frequentes (expande/recolhe)
    final_cta/                   chamada final em vermelho
    footer/                      rodapé
    marquee/                     faixa animada com tipos de negócio
    motion/                      efeitos: inclinação 3D, revelação ao rolar, flutuação, pulso
    common/                      botões (com profundidade 3D), botão flutuante do WhatsApp, títulos, grade, diálogo de ajuda
assets/
  images/                        fotos sem fundo, otimizadas em WebP (~160 KB no total)
  fonts/                         Plus Jakarta Sans (licença OFL), só caracteres latinos
web/                             index.html (tela de carregamento, SEO), manifest e ícones
test/                            testes de máscara, validação, mensagem e fluxos da página
fotos_sem_fundo/                 fotos em PNG, alta resolução, para outros usos (fica fora do repositório público)
.github/workflows/deploy.yml     compila, testa e publica no GitHub Pages a cada envio
```

## 2. Pré-requisitos

- Flutter **3.24 ou mais recente** (canal stable) — https://docs.flutter.dev/get-started/install
- Google Chrome (para rodar e testar localmente)

Confira com:

```bash
flutter --version
flutter doctor
```

> Se a pasta não tiver os arquivos de plataforma que o seu Flutter espera,
> rode `flutter create . --platforms web` dentro do projeto. Isso **não**
> sobrescreve os arquivos de `lib/` nem o `web/index.html`.

## 3. Instalar as dependências

```bash
cd microcredito_empreendedores
flutter pub get
```

## 4. Executar localmente

No computador:

```bash
flutter run -d chrome
```

No celular (mesma rede Wi-Fi do computador):

```bash
flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8080
```

Depois abra `http://IP-DO-COMPUTADOR:8080` no navegador do celular.

## 5. Testes e verificação

```bash
flutter analyze
flutter test
```

Os testes cobrem: máscara e validação do telefone, DDDs, municípios e
atividades, montagem e codificação da mensagem, envio vazio, falta de
consentimento, campos "outros", abertura do WhatsApp, orientação quando o
WhatsApp não abre, Aviso de Privacidade, menu do celular e rolagem até o
formulário. Os testes de tela também falham se algum elemento "estourar" o
layout em desktop (1280 px) ou celular (390 px).

## 6. Gerar a versão de produção

```bash
flutter build web --release --no-web-resources-cdn
```

- `--no-web-resources-cdn` empacota o motor gráfico junto com o site, sem
  buscar arquivos em CDN do Google (melhor para privacidade/LGPD).
- Se o site ficar em uma subpasta (ex.: `seudominio.com/credito/`),
  acrescente `--base-href /credito/`.

Os arquivos finais ficam em **`build/web/`** — é essa pasta que vai para a
hospedagem.

## 7. Publicar

**Publicação atual (automática):** o site está no GitHub Pages, em
https://jeffersonsousa-maker.github.io/credito-empreendedores/

A cada envio para a branch `main`, o GitHub roda o arquivo
`.github/workflows/deploy.yml`: instala o Flutter, analisa o código, roda os
testes, gera a versão de produção e publica. Se algum teste falhar, o site
continua no ar com a versão anterior. Acompanhe em **Actions** no repositório.

Para usar um domínio próprio no GitHub Pages: em **Settings > Pages > Custom
domain**, informe o domínio, cadastre no registro do domínio os DNS que o
GitHub indicar, marque **Enforce HTTPS** e troque `--base-href` no workflow
para `/`. Atualize também `og:url`, `og:image` e `canonical` em
`web/index.html`.

Cada publicação também atualiza o download **Site pronto para hospedar**
(em **Releases** no repositório): um `site-pronto.zip` já compilado, com o
endereço base na raiz do domínio, para enviar a outra hospedagem sem
precisar instalar o Flutter.

**Outras hospedagens:**

Qualquer hospedagem de arquivos estáticos serve. Opções:

**Netlify (mais simples):** entre em https://app.netlify.com/drop e arraste a
pasta `build/web`. O HTTPS já vem ativo.

**Firebase Hosting:**

```bash
npm install -g firebase-tools
firebase login
firebase init hosting      # pasta pública: build/web | single-page app: Sim
firebase deploy
```

**Hostinger, Locaweb, cPanel e similares:** envie o conteúdo de `build/web`
para `public_html` pelo gerenciador de arquivos ou FTP. Ative o SSL gratuito
no painel. Sugestão de `.htaccess` para cache e HTTPS:

```apache
RewriteEngine On
RewriteCond %{HTTPS} off
RewriteRule ^ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]

<IfModule mod_headers.c>
  <FilesMatch "\.(js|wasm|webp|png|ttf|otf|json)$">
    Header set Cache-Control "public, max-age=604800"
  </FilesMatch>
  <FilesMatch "(index\.html|flutter_service_worker\.js|flutter_bootstrap\.js|version\.json)$">
    Header set Cache-Control "no-cache"
  </FilesMatch>
</IfModule>
```

**GitHub Pages:** gere com `--base-href /NOME-DO-REPOSITORIO/` e publique a
pasta `build/web`.

### Domínio e HTTPS

1. Compre/registre o domínio (ex.: no Registro.br para `.com.br`).
2. Na hospedagem, adicione o domínio personalizado e copie os registros DNS
   indicados (geralmente `A` para o domínio e `CNAME` para `www`).
3. No painel do domínio, cadastre esses registros. A propagação leva de
   minutos a algumas horas.
4. Ative o certificado SSL (Netlify e Firebase fazem sozinhos; no cPanel use
   "SSL/TLS" ou "Let's Encrypt").
5. Abra `https://seudominio.com.br` e confira o cadeado no navegador.

Depois de ter o domínio, troque em `web/index.html` a linha `og:image` por um
endereço completo (ex.: `https://seudominio.com.br/icons/Icon-512.png`) para a
prévia do link aparecer bem no WhatsApp.

## 8. Roteiro de teste manual (celular e computador)

Faça em pelo menos um Android (Chrome), um iPhone (Safari) e um computador:

- [ ] A página abre rápido e a tela de carregamento some sozinha.
- [ ] Menu: cada item rola até a seção certa (no celular, pelo ícone ☰).
- [ ] "Quero saber mais" leva ao formulário.
- [ ] Telefone: a máscara (89) 99999-9999 aparece enquanto digita; número
      incompleto, DDD inválido ou fixo mostram erro.
- [ ] Município: só as 5 opções; "Outros municípios do Piauí" abre o campo
      do nome, que é obrigatório.
- [ ] Atividade: "Outro tipo de atividade" abre o campo de especificação.
- [ ] Sem marcar a autorização, o envio é bloqueado com mensagem clara.
- [ ] Com tudo certo, o WhatsApp abre com a mensagem contendo telefone,
      município e atividade — e só envia quando você toca em Enviar.
- [ ] Botão verde flutuante abre o WhatsApp e some enquanto o formulário
      está na tela (não cobre campos nem o botão de envio).
- [ ] Botões "Falar pelo WhatsApp" e "Falar com um atendente" funcionam.
- [ ] Aviso de Privacidade abre e o botão "Voltar para o site" funciona.
- [ ] Navegação por teclado (Tab/Enter/Espaço) alcança todos os campos e
      botões no computador.
- [ ] Bloqueador de pop-up ativo: aparece a janela de orientação com
      "Copiar mensagem".

## 9. Efeitos 3D e transições

| Efeito | Onde |
|---|---|
| Foto da equipe inclina em 3D com o mouse, em camadas (cartão, pessoas e selos se movem em profundidades diferentes) | `widgets/hero/hero_section.dart` + `motion/tilt_3d.dart` |
| Entrada do banner em sequência (texto, botões, foto) | `motion/reveal.dart` |
| Cartões de benefícios inclinam em 3D com reflexo de luz | `widgets/benefits/benefit_card.dart` |
| Seções surgem ao rolar (inclinadas, girando ou deslizando) | `motion/reveal.dart` |
| Botões com profundidade de "tecla": sobem no mouse e afundam no toque | `widgets/common/app_buttons.dart` (`Depth3D`) |
| Faixa vermelha com tipos de negócio passando | `widgets/marquee/business_marquee.dart` |
| Selos e círculos de luz flutuando | `motion/ambient.dart` (`FloatingBob`) |
| Pulso no botão flutuante do WhatsApp | `motion/ambient.dart` (`PulseRing`) |
| Transição com zoom ao abrir o Aviso de Privacidade | `theme/app_theme.dart` |

Todos os efeitos se desligam sozinhos quando o visitante ativa "reduzir
movimento" no celular ou no computador. Para desligar tudo, use
`MicrocreditoApp(enableMotion: false)` em `lib/main.dart` (os testes já fazem
isso; um teste separado roda a página com os efeitos ligados).

## 10. Onde alterar cada coisa

| O que | Arquivo |
|---|---|
| Número do WhatsApp, nome do site | `lib/config/app_config.dart` |
| Responsável e contato do Aviso de Privacidade | `lib/config/app_config.dart` |
| Texto do Aviso de Privacidade | `lib/pages/privacy_page.dart` |
| Municípios e atividades do formulário (e a área de atendimento) | `lib/models/form_options.dart` |
| Perguntas frequentes | `lib/widgets/faq/faq_section.dart` |
| Exemplos dos benefícios | `lib/widgets/benefits/benefits_section.dart` |
| Modelo da mensagem do WhatsApp | `lib/services/whatsapp_service.dart` |
| Cores | `lib/theme/app_colors.dart` |
| Fotos | `assets/images/` (mantenha os mesmos nomes de arquivo) |

## 11. Antes de publicar

- Preencha `privacyControllerName` em `lib/config/app_config.dart` com o nome
  da pessoa ou empresa responsável pelo atendimento e revise o Aviso de
  Privacidade (é um modelo inicial, não substitui orientação jurídica).
- Tenha a autorização por escrito de uso de imagem das pessoas que aparecem
  nas fotos.
- Confira se as respostas novas do FAQ (documentos, MEI/CNPJ e gratuidade do
  atendimento) correspondem à prática da equipe.
- As fotos tiveram o fundo removido e as logomarcas (camisetas, cordões,
  maquininha) e os dados de crachá apagados, conforme o briefing de não usar
  marcas de instituições financeiras.

## Privacidade e desempenho — resumo técnico

- Nenhum dado é gravado ou enviado a servidores pelo site; o formulário só
  gera o link `https://wa.me/5589981120109?text=...`.
- Sem cookies, pixels ou analytics. Se forem adicionados no futuro, atualize o
  Aviso de Privacidade e peça consentimento antes.
- Fonte e ícones vão empacotados no site (sem Google Fonts em tempo de
  execução). A fonte contém todos os caracteres usados nos textos.
- Fotos em WebP com transparência, pré-carregadas para o banner não "piscar".
