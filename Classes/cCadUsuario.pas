unit cCadUsuario;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UTelaHeranca, Data.DB, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.Mask, Vcl.ComCtrls,
  Vcl.DBCtrls, uFuncaoCriptografia;

type
  TUsuario = class
  private
    FdConexao:TFDConnection;
    F_usuarioId:Integer;
    F_nome:string;
    F_senha:string;
    F_Foto: TBitmap;
    F_statusId:Integer;
    function getSenha: string;
    procedure setSenha(const Value: string);

  public
    constructor Create(aConexao:TFDConnection);
    destructor Destroy; override;
    function Inserir:Boolean;
    function Atualizar:Boolean;
    function Apagar:Boolean;
    function Selecionar(id:Integer):Boolean;
    function Logar(aUsuario, aSenha: String): Boolean;
    function UsuarioExiste(aUsuario: String): Boolean;
    function AlterarSenha: Boolean;
  published
    property codigo    :Integer read F_usuarioId    write F_usuarioId;
    property nome      :string  read F_nome         write F_nome;
    property senha     :string  read getSenha       write setSenha;
    property foto      :TBitmap read F_Foto;
    property status    :Integer read F_statusId     write F_statusId;
  end;
implementation

{$REGION 'Constructor Destructor'}
constructor TUsuario.Create(aConexao:TFDConnection);
begin
  FdConexao:=aConexao;
  F_Foto := TBitmap.Create;
end;

destructor TUsuario.Destroy;
begin
  F_Foto.Free;
  inherited;
end;

{$ENDREGION}

{$REGION 'CRUD'}
function TUsuario.Apagar: Boolean;
var Qry: TFDQuery;
begin
  Result := False;
  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := FdConexao;
    FdConexao.StartTransaction;

    try
      //Apaga os registros de ACESSO/AÇÃO do usuário
      Qry.SQL.Text := 'DELETE FROM usuariosAcaoAcesso WHERE usuarioId = :id';
      Qry.ParamByName('id').AsInteger := F_usuarioId;
      Qry.ExecSQL;

      //Apaga o usuário propriamente dito
      Qry.SQL.Text := 'DELETE FROM usuarios WHERE usuarioId = :id';
      Qry.ParamByName('id').AsInteger := F_usuarioId;
      Qry.ExecSQL;

      FdConexao.Commit;
      Result := True;
    except
      on E: Exception do
      begin
        FdConexao.Rollback;
        ShowMessage('Erro ao apagar usuário: ' + E.Message);
      end;
    end;
  finally
    Qry.Free;
  end;
end;

function TUsuario.Atualizar: Boolean;
var
  Qry: TFDQuery;
  ms: TMemoryStream;
begin
  Result := True; // Assume sucesso por padrão
  Qry := TFDQuery.Create(nil);
  ms := TMemoryStream.Create;
  try
    Qry.Connection := FdConexao;

    // Montagem da instrução SQL de atualização.
    // O uso de SQL.Add ajuda a organizar a leitura do comando.
    Qry.SQL.Add('UPDATE usuarios ');
    Qry.SQL.Add('   SET nome    = :nome, ');
    Qry.SQL.Add('       senha   = :senha, ');
    Qry.SQL.Add('       foto    = :foto,  ' );
    Qry.SQL.Add('       statusId = :statusId' );
    Qry.SQL.Add(' WHERE usuarioId = :usuarioId'); // CRÍTICO: Filtra apenas o usuário atual

    // Mapeamento dos parâmetros.
    // O usuarioId é usado no WHERE para localizar o registro correto no SQL Server.
    Qry.ParamByName('usuarioId').AsInteger := Self.F_usuarioId;
    Qry.ParamByName('nome').AsString        := Self.F_nome;
    Qry.ParamByName('senha').AsString       := Self.F_senha;
    Qry.ParamByName('statusId').AsInteger   := Self.F_statusId;

    // --- MANIPULAÇÃO DE IMAGEM (BLOB) ---
// --- MANIPULAÇÃO DE IMAGEM (BLOB) ---
    if (Self.F_foto <> nil) and (not Self.F_foto.Empty) then
    begin
      Self.F_foto.SaveToStream(ms);
      ms.Position := 0;
      Qry.ParamByName('foto').LoadFromStream(ms, ftBlob);
    end
    else
    begin
      // SE NÃO TIVER FOTO, PRECISA DECLARAR COMO NULL
      // Sem isso, o FireDAC dá erro de "Field not found"
      Qry.ParamByName('foto').DataType := ftBlob;
      Qry.ParamByName('foto').Value    := Null;
    end;

    // --- PROCESSO DE GRAVAÇÃO COM TRANSAÇÃO ---
    try
      FdConexao.StartTransaction;
      Qry.ExecSQL;      // Executa a alteração no banco
      FdConexao.Commit;  // Confirma as alterações
    except
      on E: Exception do
      begin
        // Em caso de falha (ex: erro de Foreign Key "FK_status"), desfaz tudo
        FdConexao.Rollback;
        ShowMessage('Erro técnico ao atualizar: ' + E.Message);
        Result := False;
      end;
    end;
  finally
    // Limpeza de memória
    ms.Free;
    FreeAndNil(Qry);
  end;
end;

function TUsuario.Inserir: Boolean;
var
  Qry: TFDQuery;
  ms: TMemoryStream;
begin
  Result := False;

  // Criação dinâmica da Query e do Stream para manipular a foto em memória
  Qry := TFDQuery.Create(nil);
  ms := TMemoryStream.Create;
  try
    Qry.Connection := FdConexao;
    // SQL parametrizada para evitar SQL Injection e facilitar o envio de BLOBs (fotos)
    Qry.SQL.Text := 'INSERT INTO usuarios (nome, senha, foto, statusId) ' +
                    'VALUES (:nome, :senha, :foto, :statusId)';

    // Preenchimento dos parâmetros com os dados das propriedades da classe
    Qry.ParamByName('nome').AsString  := Self.F_nome;
    Qry.ParamByName('senha').AsString := Self.F_senha;

    // IMPORTANTE: Este valor deve existir na tabela statusUsuario (1, 2 ou 3)
    Qry.ParamByName('statusId').AsInteger := Self.F_statusId;

    // --- TRATAMENTO DA FOTO ---
    // Se houver uma imagem carregada no objeto F_foto, converte para Stream e envia como Blob
    if (F_foto <> nil) and (not F_foto.Empty) then
    begin
      F_foto.SaveToStream(ms);
      ms.Position := 0;
      Qry.ParamByName('foto').LoadFromStream(ms, ftBlob);
    end
    else
    begin
      // Se não houver foto, define o parâmetro como Nulo para o SQL Server
      Qry.ParamByName('foto').DataType := ftBlob;
      Qry.ParamByName('foto').Value    := Null;
    end;

    // --- CONTROLE DE TRANSAÇÃO ---
    try
      FdConexao.StartTransaction; // Inicia a operação atômica
      Qry.ExecSQL;                // Tenta executar o comando no banco
      FdConexao.Commit;           // Confirma a gravação permanentemente
      Result := True;
    except
      on E: Exception do
      begin
        FdConexao.Rollback;       // Em caso de erro (ex: FK Violada), desfaz qualquer alteração
        ShowMessage('Erro: ' + E.Message);
      end;
    end;
  finally
    // Libera os objetos da memória para evitar vazamentos (Memory Leaks)
    ms.Free;
    Qry.Free;
  end;
end;

function TUsuario.Selecionar(Id: Integer): Boolean;
var
  Qry: TFDQuery;
  ms: TMemoryStream;
begin
  Result := False;
  ms := nil; // Inicializa como nil
  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := FdConexao;
    Qry.SQL.Text := 'SELECT usuarioId, nome, senha, foto, statusId FROM usuarios WHERE usuarioId = :usuarioId';
    Qry.ParamByName('usuarioId').AsInteger := Id;

    try
      Qry.Open;

      if not Qry.IsEmpty then
      begin
        Self.F_usuarioId := Qry.FieldByName('usuarioId').AsInteger;
        Self.F_nome      := Qry.FieldByName('nome').AsString;
        Self.F_senha     := Qry.FieldByName('senha').AsString;
        Self.F_statusId  := Qry.FieldByName('statusId').AsInteger;

        if not Qry.FieldByName('foto').IsNull then
        begin
          ms := TMemoryStream.Create;
          try
            // Extrai o BLOB do banco para o Stream
            TBlobField(Qry.FieldByName('foto')).SaveToStream(ms);
            ms.Position := 0;
            // Carrega o Stream para o seu TBitmap
            Self.F_Foto.LoadFromStream(ms);
          finally
            ms.Free;
          end;
        end
        else
          Self.F_Foto.SetSize(0, 0);

        Result := True;
      end;

    except
      on E: Exception do
      begin
        ShowMessage('Erro técnico ao selecionar: ' + E.Message);
        Result := False;
      end;
    end;
  finally
    FreeAndNil(Qry);
  end;
end;

{$ENDREGION}

{$region 'LOGIN'}
function TUsuario.Logar(aUsuario: String; aSenha: String): Boolean;
var
  Qry: TFDQuery;
  ms: TMemoryStream;
begin
  Result := False;
  try
    Qry := TFDQuery.Create(nil);
    Qry.Connection := FdConexao;
    Qry.SQL.Add('SELECT usuarioId, nome, senha, foto, statusId');
    Qry.SQL.Add('  FROM usuarios');
    Qry.SQL.Add(' WHERE nome = :nome');
    Qry.SQL.Add('   AND senha = :Senha');
    Qry.ParamByName('nome').AsString  := aUsuario;
    Qry.ParamByName('senha').AsString := Criptografar(aSenha);
    try
      Qry.Open;
      if not Qry.IsEmpty then
      begin
        Result       := True;
        F_usuarioId  := Qry.FieldByName('usuarioId').AsInteger;
        F_nome       := Qry.FieldByName('nome').AsString;
        F_senha      := Qry.FieldByName('senha').AsString;
        F_statusId   := Qry.FieldByName('statusId').AsInteger;

        // Carrega a foto
        if not Qry.FieldByName('foto').IsNull then
        begin
          ms := TMemoryStream.Create;
          try
            TBlobField(Qry.FieldByName('foto')).SaveToStream(ms);
            ms.Position := 0;
            F_Foto.LoadFromStream(ms);
          finally
            ms.Free;
          end;
        end;
      end;
    except
      on E: Exception do
      begin
        ShowMessage('Erro técnico: ' + E.Message);
        Result := False;
      end;
    end;
  finally
    FreeAndNil(Qry);
  end;
end;
{$endregion}

{$REGION 'Usuario Exixte'}
function TUsuario.UsuarioExiste(aUsuario:String):Boolean;
var Qry:TFDQuery;
begin
  try
    Qry:=TFDQuery.Create(nil);
    Qry.Connection:=FdConexao;
    Qry.SQL.Clear;
    Qry.SQL.Add('SELECT COUNT(usuarioId) AS Qtde '+
                '  FROM usuarios '+
                ' WHERE nome =:nome ');
    Qry.ParamByName('nome').AsString :=aUsuario;
    Try
      Qry.Open;

      if Qry.FieldByName('Qtde').AsInteger>0 then
         result := true
      else
         result := false;

    except
        on E: Exception do
        begin
          ShowMessage('Erro técnico: ' + E.Message);
          Result := False;
        end;
    end;

  finally
    if Assigned(Qry) then
       FreeAndNil(Qry);
  end;
end;

{$ENDREGION}

{$REGION 'Get e SET'}
function TUsuario.getSenha: string;
begin
  Result := Descriptografar(Self.F_senha)
end;

procedure TUsuario.setSenha(const Value: string);
begin
  Self.F_senha := Criptografar(Value);
end;

{$ENDREGION}

{$region 'ALTERAR SENHA'}
function TUsuario.AlterarSenha: Boolean;
var Qry:TFDQuery;
begin
  try
    Result:=true;
    Qry:=TFDQuery.Create(nil);
    Qry.Connection:=FdConexao;
    Qry.SQL.Clear;
    Qry.SQL.Add('UPDATE usuarios '+
                '   SET senha =:senha '+
                ' WHERE usuarioId=:usuarioId ');
    Qry.ParamByName('usuarioId').AsInteger       :=Self.F_usuarioId;
    Qry.ParamByName('senha').AsString            :=Self.F_Senha;

    Try
      FdConexao.StartTransaction;
      Qry.ExecSQL;
      FdConexao.Commit;
    except
      on E: Exception do
      begin
        ShowMessage('Erro técnico: ' + E.Message);
        FdConexao.Rollback;
        Result := False;
      end;
    end;
  finally
    if Assigned(Qry) then
       FreeAndNil(Qry);
  end;
end;

{$endregion}

end.
