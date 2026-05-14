# Sistema de Vendas - Delphi

## Objetivo

Sistema de gerenciamento de vendas desenvolvido em Delphi com interface desktop. O sistema gerencia cadastros de clientes, fornecedores, produtos, categorias e controla operações de vendas, estoque e gera relatórios detalhados sobre as transações realizadas.

## Tecnologias Utilizadas

- **Linguagem:** Pascal (Delphi)
- **IDE:** Embarcadero Delphi 10.2
- **Banco de Dados:** Microsoft SQL Server (MS SQL)
- **Componentes:** FireDAC, Fortes Report Community Edition
- **Interface:** VCL (Visual Component Library)

## Como Executar

### Pré-requisitos

- Microsoft SQL Server configurado e acessível
- Arquivo de configuração `config.ini` com as credenciais de acesso ao banco de dados

### Passos

1. Edite o arquivo `config.ini` com as informações do seu banco de dados (SQL)
2. Salve e Abra o Executavel `Vendas.exe`
3. Ao Abrir o Sistema, Terá um usuario e uma senha padrão para o primeiro acesso, Usuario: ADMIN | Senha: 123

### Autenticação

O sistema possui um módulo de login obrigatório:
- Insira suas credenciais de usuário
- O sistema validará as permissões de acesso no banco de dados
- Opção de alterar senha disponível após o login

O sistema gera relatórios em formato customizado através do Fortes Report:

- **Relatório de Clientes:** Lista completa com dados cadastrais
- **Relatório de Produtos:** Informações de produtos com grupos e categorias
- **Relatório de Vendas:** Transações por período com valores e quantidades
- **Relatório de Estoque:** Quantidade e valor médio por categoria
- **Relatório de Ficha de Cliente:** Dados detalhados de clientes específicos

### Padrão de Arquivos

Os dados são armazenados em banco de dados MS SQL Server nas seguintes tabelas principais:

- **tbClientes:** Cadastro de clientes
- **tbProdutos:** Cadastro de produtos
- **tbCategorias:** Categorias de produtos
- **tbFornecedores:** Cadastro de fornecedores
- **tbVendas:** Registro de operações de vendas
- **tbUsuarios:** Usuários do sistema com controle de acesso
- **tbAcoes:** Log de ações realizadas no sistema

## Funcionalidades

### Cadastros
- ✅ Gestão de Clientes
- ✅ Gestão de Produtos
- ✅ Gestão de Categorias
- ✅ Gestão de Fornecedores
- ✅ Gestão de Usuários com controle de acesso
- ✅ Gestão de Status de Funções

### Operações
- ✅ Registro de Vendas com cálculo automático
- ✅ Controle de Estoque em tempo real
- ✅ Alteração e consulta de dados cadastrais
- ✅ Exclusão de registros com valida��ões

### Consultas
- ✅ Busca de Categorias
- ✅ Busca de Produtos
- ✅ Busca de Clientes

### Relatórios
- ✅ Relatório de Clientes
- ✅ Relatório de Produtos com Grupos e Categorias
- ✅ Relatório de Vendas por Data
- ✅ Relatório de Ficha de Cliente
- ✅ Relatório de Categorias
- ✅ Relatório de Produtos
- ✅ Relatório de Vendas por Produto

### Segurança
- ✅ Sistema de Login e Autenticação
- ✅ Controle de Acesso por Usuário
- ✅ Alteração de Senha
- ✅ Criptografia de dados sensíveis
- ✅ Log de ações do sistema

### Interface
- ✅ Navegação intuitiva com abas (PageControl)
- ✅ Controle automático de botões (Novo, Alterar, Apagar, Gravar, Cancelar)
- ✅ Suporte a diferentes resoluções de tela
- ✅ Tema escuro "Cyan Night"

---

**Versão:** 1.0  
**Desenvolvedor:** viniciente  
