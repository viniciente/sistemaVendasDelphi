unit uCadCategorias;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.Mask, Vcl.ComCtrls, Vcl.DBCtrls,
  Vcl.ExtCtrls, cCadCategoria, uDtmnConexao, uEnum, Vcl.Buttons, UTelaHeranca;

type
  TfrmCadCategorias = class(TfrmTelaHeranca)
    edtCategoriasId: TEdit;
    lblCodigo: TLabel;
    edtDescricao: TEdit;
    lblNome: TLabel;
    FDQuery1categoriasId: TFDAutoIncField;
    FDQuery1descricao: TStringField;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure dsListagemStateChange(Sender: TObject);
private
    { Private declarations }
    oCategoria:TCategoria;
    function Apagar:Boolean; override;
    function Gravar(EstadoDoCadastro: TEstadoDoCadastro):Boolean; override;
    { Public declarations }
  end;

var
  frmCadCategorias: TfrmCadCategorias;

implementation

{$R *.dfm}

{$REGION 'Override'}

function TfrmCadCategorias.Apagar: Boolean;
begin
  //pega o id da categoria e retorna true ou false, lembrando o sistema de atualizar a tela
  Result:=oCategoria.Apagar(FDQuery1.FieldByName('categoriasId').AsInteger);
end;

function TfrmCadCategorias.Gravar(EstadoDoCadastro: TEstadoDoCadastro): Boolean;
begin
  Result := False;
  if not Assigned(oCategoria) then Exit;

  try
    // Se for inserção, o ID deve ser 0 para o SQL gerar o automático
    if EstadoDoCadastro = ecInserir then
      oCategoria.Codigo := 0
    else
      oCategoria.Codigo := StrToIntDef(edtCategoriasId.Text, 0);

    oCategoria.Descricao := edtDescricao.Text;

    // Executa a ação baseada no estado
    case EstadoDoCadastro of
      ecInserir: Result := oCategoria.Inserir;
      ecAlterar: Result := oCategoria.Atualizar;
    end;

    // Se gravou com sucesso, atualizamos a consulta da listagem
    if Result then
    begin
      FDQuery1.Refresh;
      // O Refresh faz a nova categoria aparecer no Grid imediatamente
    end;

  except
    //caso de erro mostra uma mensagem dizendo que n deu certo
    MessageDlg('Não foi possível salvar as alterações.' + #13#13 +
              'Verifique sua conexão ou se os dados estão corretos.', mtError, [mbOK], 0);
  end;
end;
{$ENDREGION}

{$REGION'BTNS'}

procedure TfrmCadCategorias.btnAlterarClick(Sender: TObject);
begin
  //verificação de segurança, caso o oCategoria n tenha sido criado no formCreate, ele encerra para não dar erro maior
  if not Assigned(oCategoria) then Exit;

  //busca dados so id selecionado
  if oCategoria.Selecionar(FDQuery1 .FieldByName('categoriasId').AsInteger) then begin
    //se achou preenche os campos designados
    edtCategoriasId.Text := IntToStr(oCategoria.Codigo);
    edtDescricao.Text := oCategoria.descricao;
  end
  else begin
    //se não achou, "cancela" a ação
    btnCancelar.Click;
    Abort
  end;

  inherited;
end;

procedure TfrmCadCategorias.btnNovoClick(Sender: TObject);
begin
  inherited;

  //define que o estado atual é de inserção
  EstadoDoCadastro := ecInserir;

  //garante que mude para a pagina "Manutenção"
  pgcPrincipal.ActivePageIndex := 1;

  //limpa os campos designados
  edtCategoriasId.Clear;
  edtDescricao.Clear;

  //verifica se o edt recebeu o o foco
  if edtDescricao.CanFocus then
    edtDescricao.SetFocus;
end;

{$ENDREGION}

procedure TfrmCadCategorias.dsListagemStateChange(Sender: TObject);
begin
  inherited;
  ControlarBotoes;
end;

procedure TfrmCadCategorias.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // Cancela qualquer edição pendente no componente de listagem
  if FDQuery1.Active then
    FDQuery1.Cancel;

  inherited; // Chama o fechamento que esta na tela herança

  if Assigned(oCategoria) then
    FreeAndNil(oCategoria);
end;

procedure TfrmCadCategorias.FormCreate(Sender: TObject);
begin
  //criar objeto primeiro
  oCategoria  := TCategoria .Create(dtmConexao.FDConexao);
  // depois o pai
  inherited;
  FDQuery1.Connection:=dtmConexao.FDConexao;
  IndiceAtual:='categoriasId';
end;

end.
