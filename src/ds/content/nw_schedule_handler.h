#pragma once

#include <ds/app/event_client.h>
#include <ds/ui/sprite/sprite_engine.h>
#include <ds/app/auto_update.h>
#include <Poco/DateTime.h>

namespace ds::model {

/**
* \class schneider::NWScheduleHandler
* \brief Check the event schedule and let the rest of the app know when there's a change to the current event
*/
class NWScheduleHandler : public ds::AutoUpdate {
public:
	NWScheduleHandler(ds::ui::SpriteEngine& eng);

	virtual void update(const ds::UpdateParams&);

protected:

	virtual void checkSchedule();
	virtual bool eventIsNow(ds::model::ContentModelRef& theEvent, Poco::DateTime& ldt);

	ds::EventClient							mEventClient;
	ds::ui::SpriteEngine&					mEngine;

};

} 