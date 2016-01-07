#include "HaxeGlue.h"
extern "C" void check_hx_init();

class FHaxeGlue : public IModuleInterface
{
public:
  virtual void StartupModule() override;
  virtual void ShutdownModule() override;

  virtual bool IsGameModule() const override
  {
    return true;
  }
};

IMPLEMENT_MODULE( FHaxeGlue, HaxeGlue )

void FHaxeGlue::StartupModule()
{
  check_hx_init();
}
 
void FHaxeGlue::ShutdownModule()
{
}
