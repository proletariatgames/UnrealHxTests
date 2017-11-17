#include "HaxeProgramTest.h"
#include "HaxeInit.h"
#include "RequiredProgramMainCPPInclude.h"

IMPLEMENT_APPLICATION(HaxeProgramTest, "HaxeProgramTest");

INT32_MAIN_INT32_ARGC_TCHAR_ARGV()
{
  GEngineLoop.PreInit(ArgC, ArgV);
  check_hx_init();
  return 0;
}