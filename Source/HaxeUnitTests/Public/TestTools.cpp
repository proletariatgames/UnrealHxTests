#include "TestTools.h"
#include "HaxeUnitTests.h"
#include "Modules/ModuleManager.h"
#if WITH_EDITOR
#include "ISessionFrontendModule.h"
#endif

void UTestTools::openAutomationFrontend() {
#if WITH_EDITOR
	ISessionFrontendModule& SessionFrontend = FModuleManager::LoadModuleChecked<ISessionFrontendModule>("SessionFrontend");
	SessionFrontend.InvokeSessionFrontend(FName("AutomationPanel"));
#endif
}