program pPrincipal;

uses
  System.StartUpCopy,
  FMX.Forms,
  uPrincipal in 'uPrincipal.pas' {frm_Principal},
  uClientes in 'uClientes.pas' {frmClientes},
  uProdutos in 'uProdutos.pas' {frmProdutos};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tfrm_Principal, frm_Principal);
  Application.CreateForm(TfrmClientes, frmClientes);
  Application.CreateForm(TfrmProdutos, frmProdutos);
  Application.Run;
end.
