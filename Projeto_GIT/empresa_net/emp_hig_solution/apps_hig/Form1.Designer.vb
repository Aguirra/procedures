<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()>
Partial Class SistemasIntegrados
    Inherits System.Windows.Forms.Form

    'Descartar substituições de formulário para limpar a lista de componentes.
    <System.Diagnostics.DebuggerNonUserCode()>
    Protected Overrides Sub Dispose(ByVal disposing As Boolean)
        Try
            If disposing AndAlso components IsNot Nothing Then
                components.Dispose()
            End If
        Finally
            MyBase.Dispose(disposing)
        End Try
    End Sub

    'Exigido pelo Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'OBSERVAÇÃO: o procedimento a seguir é exigido pelo Windows Form Designer
    'Pode ser modificado usando o Windows Form Designer.  
    'Não o modifique usando o editor de códigos.
    <System.Diagnostics.DebuggerStepThrough()>
    Private Sub InitializeComponent()
        Me.MenuStrip1 = New System.Windows.Forms.MenuStrip()
        Me.TESTEToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.TESTE1ToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.TESTE2ToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.MenuStrip1.SuspendLayout()
        Me.SuspendLayout()
        '
        'MenuStrip1
        '
        Me.MenuStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.TESTEToolStripMenuItem})
        Me.MenuStrip1.Location = New System.Drawing.Point(0, 0)
        Me.MenuStrip1.Name = "MenuStrip1"
        Me.MenuStrip1.Size = New System.Drawing.Size(800, 24)
        Me.MenuStrip1.TabIndex = 0
        Me.MenuStrip1.Text = "MenuStrip1"
        '
        'TESTEToolStripMenuItem
        '
        Me.TESTEToolStripMenuItem.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem() {Me.TESTE1ToolStripMenuItem, Me.TESTE2ToolStripMenuItem})
        Me.TESTEToolStripMenuItem.Name = "TESTEToolStripMenuItem"
        Me.TESTEToolStripMenuItem.Size = New System.Drawing.Size(51, 20)
        Me.TESTEToolStripMenuItem.Text = "TESTE"
        '
        'TESTE1ToolStripMenuItem
        '
        Me.TESTE1ToolStripMenuItem.Name = "TESTE1ToolStripMenuItem"
        Me.TESTE1ToolStripMenuItem.Size = New System.Drawing.Size(180, 22)
        Me.TESTE1ToolStripMenuItem.Text = "TESTE 1"
        '
        'TESTE2ToolStripMenuItem
        '
        Me.TESTE2ToolStripMenuItem.Name = "TESTE2ToolStripMenuItem"
        Me.TESTE2ToolStripMenuItem.Size = New System.Drawing.Size(180, 22)
        Me.TESTE2ToolStripMenuItem.Text = "TESTE 2"
        '
        'SistemasIntegrados
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(800, 450)
        Me.Controls.Add(Me.MenuStrip1)
        Me.MainMenuStrip = Me.MenuStrip1
        Me.Name = "SistemasIntegrados"
        Me.Text = "Form1"
        Me.MenuStrip1.ResumeLayout(False)
        Me.MenuStrip1.PerformLayout()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub

    Friend WithEvents MenuStrip1 As MenuStrip
    Friend WithEvents TESTEToolStripMenuItem As ToolStripMenuItem
    Friend WithEvents TESTE1ToolStripMenuItem As ToolStripMenuItem
    Friend WithEvents TESTE2ToolStripMenuItem As ToolStripMenuItem
End Class
