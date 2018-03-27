
Add-Type -AssemblyName PresentationFramework
function Load-WPFForm() {
	<#
	.SYNOPSIS
	Method to allow quickly loading a WPF Application XAML file as a Window.


	.DESCRIPTION
	Loads a WPF Window from its respective XAML Counterpart. Returns a [System.Windows.Window] object

	.EXAMPLE
		$window = Load-WPF -File .\FileName.xaml
		$window.ShowDialog();

		Description
		-----------
		Loads windows elements for graphical user interface.
	#>
	param(
		[Parameter(Mandatory = $true)]
		[string[]]$File,
		[Parameter(Mandatory = $false)]
		[switch]$InvokeScripts = $false
	)


	if (-not (Test-Path $File)) {
		write-host "ERROR File Path not correct $file"
		return
	}

	$xaml = [XML](get-content $File)
	
	#Remove ScriptBlocks from the XML File
	$xamlScripts = new-Object System.Collections.ArrayList;
	$node = $xaml.GetElementsbyTagName("SCRIPT")[0]
	while ($node -ne $null) {
		if ($InvokeScripts) {	
			if ($node.ParentNode.Name -eq $Node.ParentNode.LocalName) {
				$node.ParentNode.SetAttribute('x:Name', "A" + [GUID]::NewGuid().ToString().Replace("-", ""));
			}
		
			[void]$xamlScripts.Add((
				New-Object PSObject -Property @{
					Name = $node.ParentNode.Name
					ScriptBlock = $node.InnerText
				}
			))
		}
		[void]$node.ParentNode.RemoveChild($node)
		$Elements = $xaml.GetElementsbyTagName("SCRIPT")
		if ($Elements) {
			$node = $Elements[0]
		}
	}
	
	# Create an object for the XML content
	$xamlReader = New-Object System.Xml.XmlNodeReader $xaml
	# Load the content so we can start to work with it

	#Execute embedded scripts
	$Self = [Windows.Markup.XamlReader]::Load($xamlReader)
	if ($InvokeScripts) {
		foreach ($node in $xamlScripts) {
			try {
				$window = $self
				$this = $self.FindName($node.Name);
				. ([ScriptBlock]::Create($node.ScriptBlock)).Invoke();
			} catch {}
		}
	}
	return $Self
}