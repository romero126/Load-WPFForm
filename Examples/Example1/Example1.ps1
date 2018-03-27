
. .\Load-WPFForm.ps1
cd Examples\Example1
$window = Load-WPFForm .\Window.xaml
$Window.FindName("btn1").Add_Click({
    [System.Windows.MessageBox]::Show('You Clicked me!')
})
$window.ShowDialog()