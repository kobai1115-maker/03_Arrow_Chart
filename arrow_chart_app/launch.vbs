Set fso = CreateObject("Scripting.FileSystemObject")
Set WshShell = CreateObject("WScript.Shell")

' VBScript自体の場所をカレントディレクトリに設定
WshShell.CurrentDirectory = fso.GetParentFolderName(WScript.ScriptFullName)

' 画面を表示せずにバッチファイルを実行
WshShell.Run chr(34) & "run_app.bat" & Chr(34), 0

Set WshShell = Nothing
Set fso = Nothing
