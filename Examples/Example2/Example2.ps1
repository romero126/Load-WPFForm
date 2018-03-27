
. .\Load-WPFForm.ps1
cd Examples\Example2
$window = Load-WPFForm .\Window.xaml -InvokeScripts

$window.ShowDialog()