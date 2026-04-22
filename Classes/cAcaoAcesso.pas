unit cAcaoAcesso;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UTelaHeranca, Data.DB, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.Mask, Vcl.ComCtrls,
  Vcl.DBCtrls, Vcl.Buttons;

type
  TAcaoAcesso = class
  private
    FdConexao:TFDConnection;
    F_acaoAcessoId:Integer;
    F_descricao:string;
    F_chave:string;
    F_statusId:Integer;

    class procedure PreencherAcoes(aForm:TForm; aConexao:TFDConnection); static;
    class procedure VerificarUsuarioAcao(aUsuarioId: Integer;
  aAcaoAcessoId: Integer; aStatusId: Integer; aConexao: TFDConnection); static;

  public
    constructor Create (aConexao:TFDConnection);
    destructor Destroy; override;
    function Inserir:Boolean;
    function Atualizar:Boolean;
    function Apagar:Boolean;
    function Selecionar(id:Integer): Boolean;
    function ChaveExiste(aChave:String; aId:Integer=0):Boolean;
    class procedure CriarAcoes(aNomeForm: TFormClass; aConexao:TFDConnection); static;
    class procedure PreencherUsuariosVsAcoes(aConexao:TFDConnection); static;

  published
    property codigo    :Integer read F_acaoAcessoId write F_acaoAcessoId;
    property descricao :String  read F_descricao    write F_descricao;
    property chave     :string  read F_chave        write F_chave;
    property statusId  :Integer read F_statusId     write F_statusId;
  end;

implementation

{ TAcaoAcesso }

{$REGION'Constructor Destructor'}
constructor TAcaoAcesso.Create(aConexao: TFDConnection);
begin
  FdConexao:=aConexao;
end;

destructor TAcaoAcesso.Destroy;
begin

  inherited;
end;
{$ENDREGION}


 {$REGION'Fun  o Apagar, Atualizar, Inserir, Selecionar'}
function TAcaoAcesso.Apagar: Boolean;
var Qry: TFDQuery;
begin
  Result := False;
  // Se os campos aparecerem vazios no ShowMessage, a dele  o vai falhar
  if MessageDlg('Apagar o Registro: ' + #13 + #13 +
                'Codigo: ' + F_acaoAcessoId.ToString + #13 +
                'Nome: ' + F_descricao, mtConfirmation, [mbYes, mbNo], 0) = mrNo then
    Exit;

  try
    Qry := TFDQuery.Create(nil);
    Qry.Connection := FdConexao;
    Qry.SQL.Add('DELETE FROM acaoAcesso WHERE acaoAcessoId = :id');
    Qry.ParamByName('id').AsInteger := F_acaoAcessoId;

    FdConexao.StartTransaction;
    try
      Qry.ExecSQL;
      FdConexao.Commit; //grava definitvamente
      Result := True;
    except
      FdConexao.Rollback; //em caso de erro desfaz a tentativa
      Result := False;
    end;
  finally
    FreeAndNil(Qry);
  end;
end;

function TAcaoAcesso.Atualizar: Boolean;
var Qry:TFDQuery;
begin
  try
    Result:=True;
    Qry:=TFDQuery.Create(nil);
    Qry.Connection:=FdConexao;
    Qry.SQL.Clear;
    Qry.SQL.Add('UPDATE acaoAcesso '+
                '   SET descricao =:descricao '+
                '       ,chave    =:chave '+
                ' WHERE acaoAcessoId=:acaoAcessoId ');
    Qry.ParamByName('acaoAcessoId').AsInteger :=Self.F_acaoAcessoId;
    Qry.ParamByName('descricao').AsString     :=Self.F_descricao;
    Qry.ParamByName('chave').AsString         :=Self.F_chave;

    try
      FdConexao.StartTransaction;
      Qry.ExecSQL;
      FdConexao.Commit;
    except
      FdConexao.Rollback;
      Result:=False
    end;
  finally
    if Assigned(Qry) then
       FreeAndNil(Qry);
  end;
end;

function TAcaoAcesso.Inserir: Boolean;
var Qry:TFDQuery;
begin
  try
    Result:=True;
    Qry:=TFDQuery.Create(nil);
    Qry.Connection:=FdConexao;
    Qry.SQL.Clear;
    Qry.SQL.Add('INSERT INTO acaoAcesso (descricao, '+
                '                        chave ) '+
                ' VALUES                 (:descricao, '+
                '                        :chave ) ' );
    Qry.ParamByName('descricao').AsString     :=Self.F_descricao;
    Qry.ParamByName('chave').AsString         :=Self.F_chave;

    try
      FdConexao.StartTransaction;
      Qry.ExecSQL;
      FdConexao.Commit;
    except
      FdConexao.Rollback;
      Result:=False
    end;
  finally
    if Assigned(Qry) then
       FreeAndNil(Qry);
  end;
end;

function TAcaoAcesso.Selecionar(id: Integer): Boolean;
var Qry: TFDQuery;
begin
  Result := False;
  try
    Qry := TFDQuery.Create(nil);
    Qry.Connection := FdConexao;
    Qry.SQL.Add('SELECT acaoAcessoId, descricao, chave FROM acaoAcesso WHERE acaoAcessoId = :id');
    Qry.ParamByName('id').AsInteger := id;
    Qry.Open;

    if not Qry.IsEmpty then
    begin
      Self.F_acaoAcessoId := Qry.FieldByName('acaoAcessoId').AsInteger;
      Self.F_descricao    := Qry.FieldByName('descricao').AsString;
      Self.F_chave        := Qry.FieldByName('chave').AsString;
      Result := True;
    end;
  finally
    FreeAndNil(Qry);
  end;
end;

{$ENDREGION}

class procedure TAcaoAcesso.PreencherAcoes(aForm: TForm; aConexao: TFDConnection);
var i:Integer;
    oAcaoAcesso:TAcaoAcesso;
begin
  try
    oAcaoAcesso:=TAcaoAcesso.Create(aConexao);
    oAcaoAcesso.descricao := aForm.Caption;
    //usa o nome como chave tecnica
    oAcaoAcesso.Chave := aForm.Name;
    //verifica se a tela esta cadastrada no banco
    if not oAcaoAcesso.ChaveExiste(oAcaoAcesso.Chave) then
       oAcaoAcesso.Inserir;

    //percorre a lista de todos os componentess que pertecem a esse formulario
    for I := 0 to aForm.ComponentCount -1 do
    begin
      //filtra somente os botões (bitbtn)
      if (aForm.Components[i] is TBitBtn) then
      begin
        if TBitBtn(aForm.Components[i]).Tag=99 then
        begin
          oAcaoAcesso.descricao := '    - BOT O '+ StringReplace(TBitBtn(aForm.Components[i]).Caption, '&','',[rfReplaceAll]);
          oAcaoAcesso.Chave     := aForm.Name+'_'+TBitBtn(aForm.Components[i]).Name;
          if not oAcaoAcesso.ChaveExiste(oAcaoAcesso.Chave) then
             oAcaoAcesso.Inserir;
        end;
      end;
    end;

  finally
    if Assigned(oAcaoAcesso) then
       FreeAndNil(oAcaoAcesso);
  end;
end;

class procedure TAcaoAcesso.CriarAcoes(aNomeForm: TFormClass; aConexao:TFDConnection);
var
  form: TForm;
begin
  try
    form := aNomeForm.Create(Application);
    PreencherAcoes(form,aConexao);
  finally
    if Assigned(form) then
       form.Release;
  end;
end;

function TAcaoAcesso.ChaveExiste(aChave: String; aId:Integer): Boolean;
var Qry:TFDQuery;
begin
  try
    Qry:=TFDQuery.Create(nil);
    Qry.Connection:=FdConexao;
    Qry.SQL.Clear;
    Qry.SQL.Add('SELECT COUNT(acaoAcesso) AS Qtde '+
                '  FROM acaoAcesso '+
                ' WHERE chave =:chave ');

    if aId > 0 then
    begin
      Qry.SQL.Add(' AND acaoAcessoId<>:AcaoAcessoId');
      Qry.ParamByName('acaoAcessoId').AsInteger :=aId;
    end;

    Qry.ParamByName('chave').AsString :=aChave;
    try
      Qry.Open;

      if Qry.FieldByName('Qtde').AsInteger>0 then
        result:= true
      else
        Result:=False;
    except
      Result:=False
    end;
  finally
    if Assigned(Qry) then
       FreeAndNil(Qry);
  end;
end;

class procedure TAcaoAcesso.VerificarUsuarioAcao(aUsuarioId: Integer;
  aAcaoAcessoId: Integer; aStatusId: Integer; aConexao: TFDConnection);
var
  Qry: TFDQuery;
  vAtivo: Boolean;
  vChave: string;
begin
  try
    Qry := TFDQuery.Create(nil);
    Qry.Connection := aConexao;

    // Busca a chave da a  o para decidir a restri  o pelo nome, n o pelo ID
    Qry.SQL.Text := 'SELECT chave FROM acaoAcesso WHERE acaoAcessoId = :aId';
    Qry.ParamByName('aId').AsInteger := aAcaoAcessoId;
    Qry.Open;
    vChave := Qry.FieldByName('chave').AsString;
    Qry.Close;

    // Verifica se a permiss o j  existe para n o duplicar
    Qry.SQL.Text := 'SELECT ativo FROM usuariosAcaoAcesso ' +
                   'WHERE usuarioId = :uId AND acaoAcessoId = :aId';
    Qry.ParamByName('uId').AsInteger := aUsuarioId;
    Qry.ParamByName('aId').AsInteger := aAcaoAcessoId;
    Qry.Open;

    if Qry.IsEmpty then
    begin
      vAtivo := True;

      // Restri  es autom ticas para Colaborador (statusId = 3)
      if aStatusId = 3 then
      begin
        // Bloqueia a tela inteira de Usu rio vs A  es
        if vChave = 'frmUsuarioVsAcoes' then
          vAtivo := False;

        // Bloqueia todos os bot es APAGAR de qualquer tela
        if Pos('_btnApagar', vChave) > 0 then
          vAtivo := False;

        if Pos('_btnAlterar', vChave) > 0 then
          vAtivo := False;
      end;

      if aStatusId = 2 then
      begin
        if Pos('_btnAlterar', vChave) > 0 then
          vAtivo := False;
      end;

      Qry.Close;
      Qry.SQL.Text := 'INSERT INTO usuariosAcaoAcesso ' +
                      '(usuarioId, acaoAcessoId, ativo) ' +
                      'VALUES (:uId, :aId, :ativo)';
      Qry.ParamByName('uId').AsInteger   := aUsuarioId;
      Qry.ParamByName('aId').AsInteger   := aAcaoAcessoId;
      Qry.ParamByName('ativo').AsBoolean := vAtivo;

      try
        aConexao.StartTransaction;
        Qry.ExecSQL;
        aConexao.Commit;
      except
        aConexao.Rollback;
      end;
    end
    else
    begin
      // Permiss o j  existe   atualiza somente se for uma altera  o de status
      // (ex: usu rio foi promovido de Colaborador para Gerente ou vice-versa)
      vAtivo := Qry.FieldByName('ativo').AsBoolean;
      Qry.Close;

      // Se virou Colaborador, for a o bloqueio das restri  es
      if aStatusId = 3 then
      begin
        if (vChave = 'frmUsuarioVsAcoes') or (Pos('_btnApagar', vChave) > 0) then
        begin
          Qry.SQL.Text := 'UPDATE usuariosAcaoAcesso SET ativo = 0 ' +
                         'WHERE usuarioId = :uId AND acaoAcessoId = :aId';
          Qry.ParamByName('uId').AsInteger := aUsuarioId;
          Qry.ParamByName('aId').AsInteger := aAcaoAcessoId;
          try
            aConexao.StartTransaction;
            Qry.ExecSQL;
            aConexao.Commit;
          except
            aConexao.Rollback;
          end;
        end;
      end;
    end;

  finally
    Qry.Free;
  end;
end;

class procedure TAcaoAcesso.PreencherUsuariosVsAcoes(aConexao:TFDConnection);
var Qry:TFDQuery;
    QryAcaoAcesso:TFDQuery;
begin
  try
    Qry:=TFDQuery.Create(nil);
    Qry.Connection:=aConexao;
    Qry.SQL.Clear;

    QryAcaoAcesso:=TFDQuery.Create(nil);
    QryAcaoAcesso.Connection:=aConexao;
    QryAcaoAcesso.SQL.Clear;

    Qry.SQL.Add('SELECT usuarioId, statusId FROM usuarios ');
    Qry.Open;

    QryAcaoAcesso.SQL.Add('SELECT acaoAcessoId FROM acaoAcesso ');
    QryAcaoAcesso.Open;

    while not Qry.Eof do  //usuarios
    begin
      QryAcaoAcesso.First;
      while not QryAcaoAcesso.Eof do
      begin
        VerificarUsuarioAcao(
          Qry.FieldByName('usuarioId').AsInteger,
          QryAcaoAcesso.FieldByName('acaoAcessoId').AsInteger,
          Qry.FieldByName('statusId').AsInteger,
          aConexao
        );
        QryAcaoAcesso.Next;
      end;
      Qry.Next;
    end;
  finally
    if Assigned(Qry) then
       FreeAndNil(Qry);
  end;
end;


end.


