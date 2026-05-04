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

    procedure Categorias;
    procedure TipoPessoa;
    procedure StatusClientes;
    procedure StatusUsuario;
    procedure Fornecedor;
    procedure Clientes;
    procedure Produtos;
    procedure Usuarios;
    procedure AcaoAcesso;
    procedure UsuariosAcaoAcesso;
    procedure StatusAcaoAcesso;
    procedure Vendas;
    procedure VendasItens;

  public
    constructor Create(aConexao: TFDConnection);
  end;

implementation

uses uCadUsuario, cCadUsuario;

{ TAtualizacaoTabelaMSSQL }

{$REGION 'CONSTRUCTOR'}

constructor TAtualizacaoTabelaMSSQL.Create(aConexao: TFDConnection);
begin
  FdConexao := aConexao;

  // TABELAS DE DOMÍNIO (Não possuem FKs para outras tabelas primárias)
  Categorias;
  TipoPessoa;
  StatusClientes;
  StatusUsuario;
  Fornecedor;
  AcaoAcesso;

  // TABELAS PRINCIPAIS E RELACIONAMENTOS (Possuem FKs)
  Clientes;
  Produtos;
  Usuarios;

  StatusAcaoAcesso;
  UsuariosAcaoAcesso;

  Vendas;
  VendasItens;
end;

{$ENDREGION}

{$REGION 'TABELAEXISTE & COLUNAEXISTE'}

function TAtualizacaoTabelaMSSQL.TabelaExiste(Nome: String): Boolean;
var Q: TFDQuery;
begin
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := FdConexao;
    Q.SQL.Text := 'SELECT OBJECT_ID(:NOME)';
    Q.ParamByName('NOME').AsString := Nome;
    Q.Open;
    Result := not Q.Fields[0].IsNull;
  finally
    Q.Free;
  end;
end;

function TAtualizacaoTabelaMSSQL.ColunaExiste(Tabela, Coluna: String): Boolean;
var Q: TFDQuery;
begin
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := FdConexao;
    Q.SQL.Text :=
      'SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS '+
      'WHERE TABLE_NAME = :T AND COLUMN_NAME = :C';
    Q.ParamByName('T').AsString := Tabela;
    Q.ParamByName('C').AsString := Coluna;
    Q.Open;
    Result := not Q.IsEmpty;
  finally
    Q.Free;
  end;
end;

{$ENDREGION}

{$REGION 'CRIAÇÃO TABELAS'}

procedure TAtualizacaoTabelaMSSQL.Fornecedor;
begin
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
end;

procedure TAtualizacaoTabelaMSSQL.Categorias;
var Q: TFDQuery;
begin
  if not TabelaExiste('categorias') then
  begin
    FdConexao.ExecSQL(
      'CREATE TABLE categorias ('+
      ' categoriasId INT IDENTITY PRIMARY KEY, '+
      ' descricao VARCHAR(30) NULL )'
    );
  end;

  Q := TFDQuery.Create(nil);
  try
    Q.Connection := FdConexao;
    Q.SQL.Text := 'SELECT 1 FROM categorias WHERE descricao = :desc';
    Q.ParamByName('desc').AsString := 'Serviços';
    Q.Open;

    if Q.IsEmpty then
    begin
      FdConexao.ExecSQL(
        'INSERT INTO categorias (descricao) VALUES (:desc)',
        ['Serviços']
      );
    end;
  finally
    Q.Free;
  end;
end;

procedure TAtualizacaoTabelaMSSQL.StatusClientes;
begin
  if not TabelaExiste('statusClientes') then
  begin
    FdConexao.ExecSQL(
      'CREATE TABLE statusClientes ('+
      ' statusId INT IDENTITY PRIMARY KEY, '+
      ' descricao VARCHAR(20) NOT NULL)'
    );
  end;

  FdConexao.ExecSQL('IF NOT EXISTS (SELECT 1 FROM statusClientes WHERE descricao = ''Ativo'') INSERT INTO statusClientes (descricao) VALUES (''Ativo'')');
  FdConexao.ExecSQL('IF NOT EXISTS (SELECT 1 FROM statusClientes WHERE descricao = ''Bloqueado'') INSERT INTO statusClientes (descricao) VALUES (''Bloqueado'')');
  FdConexao.ExecSQL('IF NOT EXISTS (SELECT 1 FROM statusClientes WHERE descricao = ''Atenção'') INSERT INTO statusClientes (descricao) VALUES (''Atenção'')');
  FdConexao.ExecSQL('IF NOT EXISTS (SELECT 1 FROM statusClientes WHERE descricao = ''Prospecto'') INSERT INTO statusClientes (descricao) VALUES (''Prospecto'')');
  FdConexao.ExecSQL('IF NOT EXISTS (SELECT 1 FROM statusClientes WHERE descricao = ''Inativo'') INSERT INTO statusClientes (descricao) VALUES (''Inativo'')');
end;

procedure TAtualizacaoTabelaMSSQL.TipoPessoa;
begin
  if not TabelaExiste('tipoPessoa') then
  begin
    FdConexao.ExecSQL(
      'CREATE TABLE tipoPessoa ('+
      ' pessoaId INT IDENTITY PRIMARY KEY, '+
      ' descricao VARCHAR(15) NOT NULL )'
    );
  end;

  FdConexao.ExecSQL('IF NOT EXISTS (SELECT 1 FROM tipoPessoa WHERE descricao = ''Física'') INSERT INTO tipoPessoa (descricao) VALUES (''Física'')');
  FdConexao.ExecSQL('IF NOT EXISTS (SELECT 1 FROM tipoPessoa WHERE descricao = ''Jurídica'') INSERT INTO tipoPessoa (descricao) VALUES (''Jurídica'')');
end;

procedure TAtualizacaoTabelaMSSQL.StatusUsuario;
var Q: TFDQuery;
begin
  if not TabelaExiste('statusUsuario') then
  begin
    FdConexao.ExecSQL(
      'CREATE TABLE statusUsuario ('+
      ' statusId INT IDENTITY PRIMARY KEY, '+
      ' descricao VARCHAR(50) NOT NULL)'
    );
  end;

  Q := TFDQuery.Create(nil);
  try
    Q.Connection := FdConexao;
    Q.SQL.Text := 'SELECT 1 FROM statusUsuario WHERE descricao = :desc';
    Q.ParamByName('desc').AsString := 'ADMIN';
    Q.Open;

    if Q.IsEmpty then
    begin
      FdConexao.ExecSQL('INSERT INTO statusUsuario (descricao) VALUES (:desc)', ['ADMIN']);
    end;
  finally
    Q.Free;
  end;
end;

procedure TAtualizacaoTabelaMSSQL.AcaoAcesso;
begin
  if not TabelaExiste('acaoAcesso') then
  begin
    FdConexao.ExecSQL(
      'CREATE TABLE acaoAcesso ('+
      ' acaoAcessoId INT IDENTITY PRIMARY KEY, '+
      ' descricao VARCHAR(100), '+
      ' chave VARCHAR(60) UNIQUE)'
    );
  end;
end;

procedure TAtualizacaoTabelaMSSQL.Clientes;
begin
  if not TabelaExiste('clientes') then
  begin
    FdConexao.ExecSQL(
      'CREATE TABLE clientes ('+
      ' clienteId INT IDENTITY PRIMARY KEY, '+
      ' nome VARCHAR(60), '+
      ' endereco VARCHAR(60), '+
      ' numero VARCHAR(20), '+    // ADDED
      ' cidade VARCHAR(50), '+
      ' bairro VARCHAR(40), '+
      ' estado VARCHAR(2), '+
      ' cep VARCHAR(10), '+
      ' telefone VARCHAR(14), '+
      ' email VARCHAR(100), '+
      ' dataNascimento DATETIME, '+
      ' cpf_cnpj VARCHAR(20), '+  // ADDED
      ' pessoaId INT, '+          // ADDED
      ' statusId INT, '+
      ' FOREIGN KEY (pessoaId) REFERENCES tipoPessoa(pessoaId), '+ // FK ADDED
      ' FOREIGN KEY (statusId) REFERENCES statusClientes(statusId) )'
    );
  end
  else
  begin
    // Tratamento caso a tabela exista mas falte algo (pode jogar na sua classe cAtualizacaoCamposMSSQL futuramente)
    if not ColunaExiste('clientes', 'cpf_cnpj') then
      FdConexao.ExecSQL('ALTER TABLE clientes ADD cpf_cnpj VARCHAR(20)');
    if not ColunaExiste('clientes', 'numero') then
      FdConexao.ExecSQL('ALTER TABLE clientes ADD numero VARCHAR(20)');
  end;
end;

procedure TAtualizacaoTabelaMSSQL.Produtos;
begin
  if not TabelaExiste('produtos') then
  begin
    FdConexao.ExecSQL(
      'CREATE TABLE produtos ('+
      ' produtoId INT IDENTITY PRIMARY KEY, '+
      ' nome VARCHAR(60), '+
      ' descricao VARCHAR(255), '+
      ' valor DECIMAL(18,5), '+
      ' quantidade DECIMAL(18,5), '+ // CORRIGIDO PARA DECIMAL
      ' categoriasId INT, '+
      ' fornecedorId INT, '+
      ' foto VARBINARY(MAX), '+
      ' FOREIGN KEY (categoriasId) REFERENCES categorias(categoriasId), '+
      ' FOREIGN KEY (fornecedorId) REFERENCES fornecedor(fornecedorId))'
    );
  end;
end;

procedure TAtualizacaoTabelaMSSQL.Usuarios;
var
  Q: TFDQuery;
  StatusId: Integer;
begin
  if not TabelaExiste('usuarios') then
  begin
    FdConexao.ExecSQL(
      'CREATE TABLE usuarios ('+
      ' usuarioId INT IDENTITY PRIMARY KEY, '+
      ' nome VARCHAR(50) NOT NULL, '+
      ' senha VARCHAR(255) NOT NULL, '+ // Aumentado para hash
      ' foto VARBINARY(MAX) NULL, '+
      ' statusId INT NULL, '+
      ' FOREIGN KEY (statusId) REFERENCES statusUsuario(statusId) )'
    );
  end;

  Q := TFDQuery.Create(nil);
  try
    Q.Connection := FdConexao;
    Q.SQL.Text := 'SELECT statusId FROM statusUsuario WHERE descricao = :desc';
    Q.ParamByName('desc').AsString := 'ADMIN';
    Q.Open;

    if not Q.IsEmpty then
      StatusId := Q.FieldByName('statusId').AsInteger
    else
      StatusId := 1;

    Q.Close;
    Q.SQL.Text := 'SELECT 1 FROM usuarios WHERE nome = :nome';
    Q.ParamByName('nome').AsString := 'ADMIN';
    Q.Open;

    if Q.IsEmpty then
    begin
      FdConexao.ExecSQL(
        'INSERT INTO usuarios (nome, senha, statusId) VALUES (:n, :s, :st)',
        ['ADMIN', '987', StatusId]
      );
    end;
  finally
    Q.Free;
  end;
end;

procedure TAtualizacaoTabelaMSSQL.StatusAcaoAcesso;
begin
  if not TabelaExiste('statusAcaoAcesso') then
  begin
    FdConexao.ExecSQL(
    ' CREATE TABLE statusAcaoAcesso (  '+
    ' statusId      INT  NOT NULL,       '+ // MUDADO DE usuarioId PARA statusId
    ' acaoAcessoId  INT  NOT NULL,         '+
    ' ativo         BIT  NOT NULL DEFAULT 1, '+
    ' CONSTRAINT PK_statusAcaoAcesso           '+
    ' PRIMARY KEY (statusId, acaoAcessoId),      '+
    ' CONSTRAINT FK_statusAcaoAcesso_status    '+
    ' FOREIGN KEY (statusId) REFERENCES statusUsuario(statusId), '+
    ' CONSTRAINT FK_statusAcaoAcesso_acao                        '+
    ' FOREIGN KEY (acaoAcessoId) REFERENCES acaoAcesso(acaoAcessoId) '+
    ' ); '
    );
  end;
end;

procedure TAtualizacaoTabelaMSSQL.UsuariosAcaoAcesso;
begin
  if not TabelaExiste('usuariosAcaoAcesso') then
  begin
    FdConexao.ExecSQL(
      'CREATE TABLE usuariosAcaoAcesso ('+
      ' usuarioId INT NOT NULL, '+
      ' acaoAcessoId INT NOT NULL, '+
      ' ativo BIT NOT NULL DEFAULT 1, '+
      ' PRIMARY KEY (usuarioId, acaoAcessoId), '+
      '   CONSTRAINT FK_UsuarioAcaoAcessoUsuario '+
      '   FOREIGN KEY (usuarioId) REFERENCES usuarios(usuarioId), '+
      '   CONSTRAINT FK_UsuarioAcaoAcessoAcaoAcesso '+
      '   FOREIGN KEY (acaoAcessoId) REFERENCES acaoAcesso(acaoAcessoId) '+
      ' ) '
    );
  end;
end;

procedure TAtualizacaoTabelaMSSQL.Vendas;
begin
  if not TabelaExiste('vendas') then
  begin
    FdConexao.ExecSQL(
      'CREATE TABLE vendas ('+
      ' vendaId INT IDENTITY PRIMARY KEY, '+
      ' clienteId INT NOT NULL, '+
      ' usuarioId INT NULL, '+    // Adicionado para suportar seu dashboard
      ' dataVenda DATETIME NULL DEFAULT GETDATE(), '+
      ' totalVenda DECIMAL(18,5) NULL, '+
      ' FOREIGN KEY (clienteId) REFERENCES clientes(clienteId), '+
      ' FOREIGN KEY (usuarioId) REFERENCES usuarios(usuarioId))'
    );
  end;
end;

procedure TAtualizacaoTabelaMSSQL.VendasItens;
begin
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
      ' FOREIGN KEY (produtoId) REFERENCES produtos(produtoId))'
    );
  end;
end;

{$ENDREGION}

end.
