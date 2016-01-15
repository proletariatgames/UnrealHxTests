#include "HaxeGlue.h"

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
}
 
void FHaxeGlue::ShutdownModule()
{
}
