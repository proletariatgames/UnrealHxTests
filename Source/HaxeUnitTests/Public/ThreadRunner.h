#pragma once
#include "Templates/Function.h"
#include "Async/AsyncWork.h"

class FThreadRunner : public FNonAbandonableTask {
  friend class FAutoDeleteAsyncTask<FThreadRunner>;
  private:
  FSimpleDelegate init;
  FSimpleDelegate loop;
  FSimpleDelegate end;
  int times;

  public:
  FThreadRunner(FSimpleDelegate inInit, FSimpleDelegate inLoop, FSimpleDelegate inEnd, int inTimes) : init(inInit), loop(inLoop), end(inEnd), times(inTimes)
  {
  }

  static void start(FSimpleDelegate inInit, FSimpleDelegate inLoop, FSimpleDelegate inEnd, int inTimes)
  {
    (new FAutoDeleteAsyncTask<FThreadRunner>(inInit, inLoop, inEnd, inTimes))->StartBackgroundTask();
  }

  protected:
  void DoWork()
  {
    this->init.Execute();
    for(int i = 0; i < this->times; i++)
    {
      this->loop.Execute();
    }
    this->end.Execute();
  }

	FORCEINLINE TStatId GetStatId() const
	{
		RETURN_QUICK_DECLARE_CYCLE_STAT(FMyTaskName, STATGROUP_ThreadPoolAsyncTasks);
	}
};