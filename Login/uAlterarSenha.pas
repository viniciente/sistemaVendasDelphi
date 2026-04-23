unit uAlterarSenha;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons;

type
  TfrmAlterarSenha = class(TForm)
    edtSenha: TEdit;
    btnAlterar: TBitBtn;
    btnFechar: TBitBtn;
    lblSenha: TLabel;
    edtNovaSenha: TEdit;
    edtRepetirNovaSenha: TEdit;
    lblUsuarioLogado: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormShow(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
  private
    procedure LimparEdits;
   // procedure btnAlterarClick(Sender: TObject);
    { Private declarations }
  public
   { Public declarations }
  end;

var
  frmAlterarSenha: TfrmAlterarSenha;

implementation

uses Unit2, cCadUsuario, uDtmnConexao;

{$R *.dfm}

procedure TfrmAlterarSenha.btnAlterarClick(Sender: TObject);
Var oUsuario:TUsuario;
begin
  //vompara op edtSenha com a senha salva, se estiver certa
  if (edtSenha.Text=oUsuarioLogado.senha) then begin
    // comprar a senha nova com a senha digitada novamente, se estiver certa
    if (edtNovaSenha.Text=edtRepetirNovaSenha.Text) then begin
      try
        //cria conexão
        oUsuario:=TUsuario.Create(dtmConexao.FDConexao);
        //id continua o mesmo
        oUsuario.codigo := oUsuarioLogado.codigo;
        //aletra a senha pela nova
        oUsuario.senha  := edtNovaSenha.Text;
        oUsuario.AlterarSenha;
        //altera a senha do usuarioLogado
        oUsuarioLogado.senha := edtNovaSenha.Text;
        //notifica que a senha foi alterada
        MessageDlg('Senha Alterada',MtInformation,[mbok],0);
        LimparEdits;
      finally
        FreeAndNil(oUsuario);
      end;
    end
    else begin
      //notifica que as senha digitadas estão incorretas
      MessageDlg('Senhas digitadas não coincidem,',mtinformation,[mbok],0);
      edtNovaSenha.SetFocus;
    end;

  end
  else begin
    MessageDlg('Senha Atual esta invalida',mtinformation,[mbok],0);
  end;
end;

procedure TfrmAlterarSenha.LimparEdits;
begin
  //limpa os campos
  edtSenha.Clear;
  edtNovaSenha.Clear;
  edtRepetirNovaSenha.Clear;
  lblUsuarioLogado.Caption:=oUsuarioLogado.nome;
end;

procedure TfrmAlterarSenha.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmAlterarSenha.FormShow(Sender: TObject);
begin
  LimparEdits;
end;

end.

