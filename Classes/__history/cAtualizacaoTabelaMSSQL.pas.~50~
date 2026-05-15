unit cAtualizacaoTabelaMSSQL;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UTelaHeranca, Data.DB, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.Mask, Vcl.ComCtrls,
  Vcl.DBCtrls, cAtualizacaoBancoDeDados, cAcaoAcesso;

type
  TAtualizacaoTabelaMSSQL = class
  private
    FdConexao: TFDConnection;

    function TabelaExiste(Nome: String): Boolean;
    function ColunaExiste(Tabela, Coluna: String): Boolean;

    procedure CriarTabelas;
    procedure InserirDadosPadrao;
    procedure AtualizarEstrutura;

  public
    constructor Create(aConexao: TFDConnection);

    procedure Executar;
  end;

implementation

uses uCadUsuario, cCadUsuario;

{ TAtualizacaoTabelaMSSQL }

{$REGION 'CONSTRUCTOR'}

constructor TAtualizacaoTabelaMSSQL.Create(
  aConexao: TFDConnection
);
begin
  FdConexao := aConexao;
end;

procedure TAtualizacaoTabelaMSSQL.Executar;
begin
  CriarTabelas;

  AtualizarEstrutura;

  InserirDadosPadrao;
end;

{$ENDREGION}

function TAtualizacaoTabelaMSSQL.TabelaExiste(Nome: String): Boolean; var Q: TFDQuery;
begin
Q := TFDQuery.Create(nil);
try
Q.Connection := FdConexao; Q.SQL.Text := 'SELECT OBJECT_ID(:NOME)'; Q.ParamByName('NOME').AsString := Nome; Q.Open; Result := not Q.Fields[0].IsNull; finally Q.Free; end; end; function TAtualizacaoTabelaMSSQL.ColunaExiste(Tabela, Coluna: String): Boolean; var Q: TFDQuery; begin Q := TFDQuery.Create(nil); try Q.Connection := FdConexao; Q.SQL.Text := 'SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS '+ 'WHERE TABLE_NAME = :T AND COLUMN_NAME = :C'; Q.ParamByName('T').AsString := Tabela; Q.ParamByName('C').AsString := Coluna; Q.Open; Result := not Q.IsEmpty; finally Q.Free; end; end;

procedure TAtualizacaoTabelaMSSQL.CriarTabelas;
begin

  // =========================================================
  // CATEGORIAS
  // =========================================================
  if not TabelaExiste('categorias') then
  begin
    FdConexao.ExecSQL(
      'CREATE TABLE categorias ('+
      ' categoriasId INT IDENTITY PRIMARY KEY, '+
      ' descricao VARCHAR(30) NULL )'
    );
  end;

  // =========================================================
  // TIPO PESSOA
  // =========================================================
  if not TabelaExiste('tipoPessoa') then
  begin
    FdConexao.ExecSQL(
      'CREATE TABLE tipoPessoa ('+
      ' pessoaId INT IDENTITY PRIMARY KEY, '+
      ' descricao VARCHAR(15) NOT NULL )'
    );
  end;

  // =========================================================
  // STATUS CLIENTES
  // =========================================================
  if not TabelaExiste('statusClientes') then
  begin
    FdConexao.ExecSQL(
      'CREATE TABLE statusClientes ('+
      ' statusId INT IDENTITY PRIMARY KEY, '+
      ' descricao VARCHAR(20) NOT NULL )'
    );
  end;

  // =========================================================
  // STATUS USUARIO
  // =========================================================
  if not TabelaExiste('statusUsuario') then
  begin
    FdConexao.ExecSQL(
      'CREATE TABLE statusUsuario ('+
      ' statusId INT IDENTITY PRIMARY KEY, '+
      ' descricao VARCHAR(50) NOT NULL )'
    );
  end;

  // =========================================================
  // FORNECEDOR
  // =========================================================
  if not TabelaExiste('fornecedor') then
  begin
    FdConexao.ExecSQL(
      'CREATE TABLE fornecedor ('+
      ' fornecedorId INT IDENTITY PRIMARY KEY, '+
      ' nomeFantasia VARCHAR(100) NOT NULL, '+
      ' razaoSocial VARCHAR(100) NULL, '+
      ' cnpj VARCHAR(20) NULL, '+
      ' telefone VARCHAR(20) NULL, '+
      ' email VARCHAR(100) NULL )'
    );
  end;

  // =========================================================
  // ACAO ACESSO
  // =========================================================
  if not TabelaExiste('acaoAcesso') then
  begin
    FdConexao.ExecSQL(
      'CREATE TABLE acaoAcesso ('+
      ' acaoAcessoId INT IDENTITY PRIMARY KEY, '+
      ' descricao VARCHAR(100), '+
      ' chave VARCHAR(60) UNIQUE )'
    );
  end;

  // =========================================================
  // CLIENTES
  // =========================================================
  if not TabelaExiste('clientes') then
  begin
    FdConexao.ExecSQL(
      'CREATE TABLE clientes ('+
      ' clienteId INT IDENTITY PRIMARY KEY, '+
      ' nome VARCHAR(60), '+
      ' endereco VARCHAR(60), '+
      ' numero VARCHAR(20), '+
      ' cidade VARCHAR(50), '+
      ' bairro VARCHAR(40), '+
      ' estado VARCHAR(2), '+
      ' cep VARCHAR(10), '+
      ' telefone VARCHAR(14), '+
      ' email VARCHAR(100), '+
      ' dataNascimento DATETIME, '+
      ' cpf_cnpj VARCHAR(20), '+
      ' pessoaId INT, '+
      ' statusId INT, '+
      ' FOREIGN KEY (pessoaId) REFERENCES tipoPessoa(pessoaId), '+
      ' FOREIGN KEY (statusId) REFERENCES statusClientes(statusId) )'
    );
  end;

  // =========================================================
  // PRODUTOS
  // =========================================================
  if not TabelaExiste('produtos') then
  begin
    FdConexao.ExecSQL(
      'CREATE TABLE produtos ('+
      ' produtoId INT IDENTITY PRIMARY KEY, '+
      ' nome VARCHAR(60), '+
      ' descricao VARCHAR(255), '+
      ' valor DECIMAL(18,5), '+
      ' quantidade DECIMAL(18,5), '+
      ' categoriasId INT, '+
      ' fornecedorId INT, '+
      ' foto VARBINARY(MAX), '+
      ' FOREIGN KEY (categoriasId) REFERENCES categorias(categoriasId), '+
      ' FOREIGN KEY (fornecedorId) REFERENCES fornecedor(fornecedorId) )'
    );
  end;

  // =========================================================
  // USUARIOS
  // =========================================================
  if not TabelaExiste('usuarios') then
  begin
    FdConexao.ExecSQL(
      'CREATE TABLE usuarios ('+
      ' usuarioId INT IDENTITY PRIMARY KEY, '+
      ' nome VARCHAR(50) NOT NULL, '+
      ' senha VARCHAR(255) NOT NULL, '+
      ' foto VARBINARY(MAX) NULL, '+
      ' statusId INT NULL, '+
      ' FOREIGN KEY (statusId) REFERENCES statusUsuario(statusId) )'
    );
  end;

  // =========================================================
  // STATUS ACAO ACESSO
  // =========================================================
  if not TabelaExiste('statusAcaoAcesso') then
  begin
    FdConexao.ExecSQL(
      'CREATE TABLE statusAcaoAcesso ('+
      ' statusId INT NOT NULL, '+
      ' acaoAcessoId INT NOT NULL, '+
      ' ativo BIT NOT NULL DEFAULT 1, '+
      ' CONSTRAINT PK_statusAcaoAcesso '+
      ' PRIMARY KEY (statusId, acaoAcessoId), '+
      ' CONSTRAINT FK_statusAcaoAcesso_status '+
      ' FOREIGN KEY (statusId) REFERENCES statusUsuario(statusId), '+
      ' CONSTRAINT FK_statusAcaoAcesso_acao '+
      ' FOREIGN KEY (acaoAcessoId) REFERENCES acaoAcesso(acaoAcessoId) )'
    );
  end;

  // =========================================================
  // USUARIOS ACAO ACESSO
  // =========================================================
  if not TabelaExiste('usuariosAcaoAcesso') then
  begin
    FdConexao.ExecSQL(
      'CREATE TABLE usuariosAcaoAcesso ('+
      ' usuarioId INT NOT NULL, '+
      ' acaoAcessoId INT NOT NULL, '+
      ' ativo BIT NOT NULL DEFAULT 1, '+
      ' PRIMARY KEY (usuarioId, acaoAcessoId), '+
      ' CONSTRAINT FK_UsuarioAcaoAcessoUsuario '+
      ' FOREIGN KEY (usuarioId) REFERENCES usuarios(usuarioId), '+
      ' CONSTRAINT FK_UsuarioAcaoAcessoAcaoAcesso '+
      ' FOREIGN KEY (acaoAcessoId) REFERENCES acaoAcesso(acaoAcessoId) )'
    );
  end;

  // =========================================================
  // VENDAS
  // =========================================================
  if not TabelaExiste('vendas') then
  begin
    FdConexao.ExecSQL(
      'CREATE TABLE vendas ('+
      ' vendaId INT IDENTITY PRIMARY KEY, '+
      ' clienteId INT NOT NULL, '+
      ' usuarioId INT NULL, '+
      ' dataVenda DATETIME NULL DEFAULT GETDATE(), '+
      ' totalVenda DECIMAL(18,5) NULL, '+
      ' FOREIGN KEY (clienteId) REFERENCES clientes(clienteId), '+
      ' FOREIGN KEY (usuarioId) REFERENCES usuarios(usuarioId) )'
    );
  end;

  // =========================================================
  // VENDAS ITENS
  // =========================================================
  if not TabelaExiste('vendasItens') then
  begin
    FdConexao.ExecSQL(
      'CREATE TABLE vendasItens ('+
      ' vendaId INT NOT NULL, '+
      ' produtoId INT NOT NULL, '+
      ' valorUnitario DECIMAL(18,5) NULL, '+
      ' quantidade DECIMAL(18,5) NULL, '+
      ' totalProduto DECIMAL(18,5) NULL, '+
      ' PRIMARY KEY (vendaId, produtoId), '+
      ' FOREIGN KEY (vendaId) REFERENCES vendas(vendaId), '+
      ' FOREIGN KEY (produtoId) REFERENCES produtos(produtoId) )'
    );
  end;

end;

procedure TAtualizacaoTabelaMSSQL.AtualizarEstrutura;
begin

  if not ColunaExiste('clientes', 'cpf_cnpj') then
  begin
    FdConexao.ExecSQL(
      'ALTER TABLE clientes ADD cpf_cnpj VARCHAR(20)'
    );
  end;

  if not ColunaExiste('clientes', 'numero') then
  begin
    FdConexao.ExecSQL(
      'ALTER TABLE clientes ADD numero VARCHAR(20)'
    );
  end;

end;

procedure TAtualizacaoTabelaMSSQL.InserirDadosPadrao;
begin

  // =========================================================
  // CATEGORIAS
  // =========================================================

  FdConexao.ExecSQL(
    'IF NOT EXISTS (SELECT 1 FROM categorias WHERE descricao = ''Serviços'') '+
    'INSERT INTO categorias (descricao) VALUES (''Serviços'')'
  );

  // =========================================================
  // TIPO PESSOA
  // =========================================================

  FdConexao.ExecSQL(
    'IF NOT EXISTS (SELECT 1 FROM tipoPessoa WHERE descricao = ''Física'') '+
    'INSERT INTO tipoPessoa (descricao) VALUES (''Física'')'
  );

  FdConexao.ExecSQL(
    'IF NOT EXISTS (SELECT 1 FROM tipoPessoa WHERE descricao = ''Jurídica'') '+
    'INSERT INTO tipoPessoa (descricao) VALUES (''Jurídica'')'
  );

  // =========================================================
  // STATUS CLIENTES
  // =========================================================

  FdConexao.ExecSQL(
    'IF NOT EXISTS (SELECT 1 FROM statusClientes WHERE descricao = ''Ativo'') '+
    'INSERT INTO statusClientes (descricao) VALUES (''Ativo'')'
  );

  FdConexao.ExecSQL(
    'IF NOT EXISTS (SELECT 1 FROM statusClientes WHERE descricao = ''Bloqueado'') '+
    'INSERT INTO statusClientes (descricao) VALUES (''Bloqueado'')'
  );

  FdConexao.ExecSQL(
    'IF NOT EXISTS (SELECT 1 FROM statusClientes WHERE descricao = ''Atenção'') '+
    'INSERT INTO statusClientes (descricao) VALUES (''Atenção'')'
  );

  FdConexao.ExecSQL(
    'IF NOT EXISTS (SELECT 1 FROM statusClientes WHERE descricao = ''Inativo'') '+
    'INSERT INTO statusClientes (descricao) VALUES (''Inativo'')'
  );

  FdConexao.ExecSQL(
    'IF NOT EXISTS (SELECT 1 FROM statusClientes WHERE descricao = ''Prospecto'') '+
    'INSERT INTO statusClientes (descricao) VALUES (''Prospecto'')'
  );

  // =========================================================
  // STATUS USUARIO
  // =========================================================

  FdConexao.ExecSQL(
    'IF NOT EXISTS (SELECT 1 FROM statusUsuario WHERE descricao = ''ADMIN'') '+
    'INSERT INTO statusUsuario (descricao) VALUES (''ADMIN'')'
  );

  // =========================================================
  // USUARIO ADMIN
  // =========================================================

  FdConexao.ExecSQL(
    'IF NOT EXISTS (SELECT 1 FROM usuarios WHERE nome = ''ADMIN'') '+
    'INSERT INTO usuarios (nome, senha, statusId) '+
    'VALUES ('+
    ' ''ADMIN'', '+
    ' ''987'', '+
    ' (SELECT TOP 1 statusId FROM statusUsuario WHERE descricao = ''ADMIN'') '+
    ')'
  );

end;

{$ENDREGION}

end.
