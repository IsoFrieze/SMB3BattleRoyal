echo f | xcopy /y "SMAS.smc" "patched.smc"
asar patch.asm patched.smc
pause