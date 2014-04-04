if 0 < 0
{
	Run, "C:\Program Files (x86)\Vim\vim74\gvim"
}
else
{
	Run, "C:\Program Files (x86)\Vim\vim74\gvim" ""%1%""
}
WinWait, ahk_class Vim
WinActivate
WinMove A,, 1918, -480, 1080*2 + 4, 1898
