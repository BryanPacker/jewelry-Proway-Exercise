# Jewelry App

Aplicação Vue.js para exibição de joias com infraestrutura automatizada na AWS usando Terraform e CI/CD com GitHub Actions.

## 📋 Pré-requisitos

- **Node.js** 18+
- **Docker**
- **Terraform** 1.5.0+
- **AWS CLI** configurado com suas credenciais
- **Git**

### Configurar AWS CLI

```bash
aws configure
# Insira suas credenciais AWS quando solicitado
```

---

## 🚀 Início Rápido

### Desenvolvimento Local

```bash
# Instalar dependências
npm install

# Executar em modo desenvolvimento
npm run dev
```
Acesse: **http://localhost:5173**

### Docker Local

```bash
# Usando Makefile
make docker-run

# Ou manualmente
docker build -t jewelry-app .
docker run -p 8080:80 jewelry-app
```
Acesse: **http://localhost:8080**

---

## 🌐 Deploy na AWS

### Deploy Automatizado (Recomendado)

```bash
# Provisiona infraestrutura + faz deploy da aplicação
make aws-deploy
```

**O que acontece:**
1. Terraform inicializa
2. Valida configuração
3. Cria plano de infraestrutura
4. Aplica mudanças na AWS
5. Faz build e deploy da app

### Destroy (Remover Infraestrutura)

```bash
# Remove toda a infraestrutura da AWS
make aws-destroy
```

### Deploy Manual (Passo a Passo)

```bash
# 1. Inicializar Terraform
make init

# 3. Aplicar infraestrutura
make apply
```

---

## 🛠️ Comandos Makefile

```bash
make build        # Build da aplicação
make docker-run   # Rodar app em Docker localmente
make init         # Inicializar Terraform
make apply        # Aplicar Terraform
make aws-deploy   # Deploy completo (init + apply + deploy)
make aws-destroy  # Destruir infraestrutura AWS
```

---

## 📁 Estrutura do Projeto

```
.
├── .github/
│   └── workflows/           # GitHub Actions workflows
│       ├── security-checks.yml
│       ├── cd.yml          # Deploy automático
│       └── destroy.yml     # Destroy manual
├── src/                     # Código Vue.js
│   ├── components/
│   ├── pages/
│   └── main.js
├── terraform/               # Infraestrutura como Código
│   ├── main.tf             # Configuração principal
│   ├── providers.tf        # Configurações AWS
│   ├── variables.tf        # Variáveis
│   ├── outputs.tf          # Outputs
│   ├── terraform.tfstate   # Estado (gerado)
│   └── modules/            # Módulos reutilizáveis
│       ├── ec2/
│       └── remote_backend/
├── Dockerfile              # Container da aplicação
├── Makefile                # Comandos automatizados
├── package.json
├── vite.config.js
└── README.md
```

---

## ☁️ Infraestrutura AWS Provisionada

O Terraform provisiona automaticamente:

- **Subnet** - Sub-rede para recursos
- **Security Group** - Regras de firewall
- **EC2 Linux** - Máquina virtual com Docker
- **IP Público** - Acesso externo à aplicação

A aplicação roda em container Docker na porta **8080** da VM.

---

## 🔄 CI/CD com GitHub Actions

### Fluxo Automático

```
Push para main
    ↓
🔒 Security Checks (CI)
    ├─ Checkov (IaC scanning)
    ├─ Trivy (Vulnerabilities)
    ├─ Semgrep (Code analysis)
    └─ Gitleaks (Secrets detection)
    ↓ (se passar ✅)
🚀 Deploy (CD)
    ├─ Terraform init
    ├─ Terraform validate
    ├─ Terraform plan
    └─ Terraform apply
    ↓
✅ App live na AWS
```

### Destroy Manual

1. Ir para **Actions** tab
2. Clicar em **Destroy Infrastructure**
3. Clicar em **Run workflow**
4. Confirmar com `destroy`

---

## 📖 Como Usar

### Desenvolvimento

```bash
# 1. Clone o repositório
git clone https://github.com/BryanPacker/jewelry-Proway-Exercise.git
cd jewelry-app

make aws-deploy
```

### Deploy na AWS

```bash
# 1. Faça suas mudanças
git add .
git commit -m "Sua mensagem"

# 2. Envie para main
git push origin main

# 3. GitHub Actions roda automaticamente
# - Checks de segurança
# - Deploy na AWS (se checks passarem)

# 4. Acompanhe em Actions tab
```

### Parar Aplicação

```bash
# Remove toda a infraestrutura
make aws-destroy

# Ou via GitHub Actions
# Actions → Destroy Infrastructure → Run workflow
```

---


## 📝 Notas

- ✅ Projeto com um único ambiente (conforme requisitos de curso)
- ✅ Estado Terraform armazenado localmente em `terraform.tfstate`
- ✅ Módulos Terraform reutilizáveis em `terraform/modules/`
- ✅ Código Vue.js original sem alterações
- ✅ GitHub Actions rodando automaticamente em cada push

---

## 🎯 Fluxo Completo (Resumido)

**Primeiro Deploy:**
```bash
aws configure
make aws-deploy
# ~5-10 minutos para provisionar tudo
```

**Atualizar App:**
```bash
# Edite código
git add .
git commit -m "Update"
git push origin main
# GitHub Actions faz tudo automaticamente
```

**Remover Tudo:**
```bash
make aws-destroy
# ~2-5 minutos
```

---

## 📞 Dúvidas?

Verifique:
1. Logs do GitHub Actions (Actions tab)
2. AWS Console para verificar recursos
3. Terraform state para debug: `terraform state show`

Happy deploying! 🚀
